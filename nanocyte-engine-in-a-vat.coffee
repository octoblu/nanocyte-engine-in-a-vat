fs = require 'fs'
_ = require 'lodash'
redis = require 'redis'
debug = require('debug')('nanocyte-engine-in-a-vat')
Router = require '@octoblu/nanocyte-engine-simple'

ConfigurationGenerator = require 'nanocyte-configuration-generator'
ConfigurationSaver = require 'nanocyte-configuration-saver-redis'

VatNodeAssembler = require './vat-node-assembler'
AddNodeInfoStream = require './add-node-info-stream'

class NanocyteEngineInAVat
  constructor: (options) ->
    {@flowName, @flowData} = options
    @instanceId = 'engine-in-a-vat'
    @triggers = @findTriggers()

    client = redis.createClient process.env.REDIS_PORT, process.env.REDIS_HOST, auth_pass: process.env.REDIS_PASSWORD
    client.unref()
    @configurationGenerator = new ConfigurationGenerator {}
    @configurationSaver = new ConfigurationSaver client

  configure: (callback=->) =>
    @configurationGenerator.configure flowData: @flowData, userData: {}, (error, configuration) =>
      return console.error "config generator had an error!", error if error?
      debug 'configured'
      @configuration = configuration

      @configurationSaver.save flowId: @flowName, instanceId: @instanceId, flowData: configuration, (error, result)=>
        return console.error "config saver had an error!", error if error?
        debug 'saved'
        callback(null, configuration)

  triggerByName: ({name, message}) =>
    trigger = @triggers[name]
    throw new Error "Can't find a trigger named '#{name}'" unless trigger?
    @messageRouter trigger.id, message

  messageRouter: (nodeId, message) =>
    nodeInfoStream = new AddNodeInfoStream flowData: @flowData, nanocyteConfig: @configuration
    envelope =
      metadata:
        fromNodeId: nodeId
        flowId: @flowName
        instanceId: @instanceId
      message: message

    @setupRouter (error, router)=>
      router.pipe nodeInfoStream
      router.message envelope

    nodeInfoStream

  setupRouter: (callback)=>
    router = new Router @flowName, 'engine-in-a-vat', NodeAssembler: VatNodeAssembler
    router.initialize =>
      debug "router initialized."
      callback null, router

  findTriggers: =>
    _.indexBy _.filter(@flowData.nodes, type: 'operation:trigger'), 'name'


module.exports = NanocyteEngineInAVat
