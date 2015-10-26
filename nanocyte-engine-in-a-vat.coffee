fs = require 'fs'
redis = require 'redis'
debug = require('debug')('nanocyte-engine-in-a-vat')
Router = require '@octoblu/nanocyte-engine-simple'

ConfigurationGenerator = require 'nanocyte-configuration-generator'
ConfigurationSaver = require 'nanocyte-configuration-saver-redis'


class NanocyteEngineInAVat
  constructor: (options) ->
    {@flowName, @flowData} = options

    client = redis.createClient process.env.REDIS_PORT, process.env.REDIS_HOST, auth_pass: process.env.REDIS_PASSWORD
    client.unref()

    @configurationGenerator = new ConfigurationGenerator {}
    @configurationSaver = new ConfigurationSaver client

  configure: (callback=->) =>
    @configurationGenerator.configure flowData: @flowData, userData: {}, (error, configuration) =>
      return console.error "config generator had an error!", error if error?
      debug 'configured'
      @configurationSaver.save flowId: @flowName, instanceId: 'engine-in-a-vat', flowData: configuration, (error, result)=>
        return console.error "config saver had an error!", error if error?
        debug 'saved'
        callback()

  messageRouter: (nodeId, message, callback) =>
    debug "trying to message router"
    envelope =
      metadata:
        fromNodeId: nodeId
        flowId: @flowId
        instanceId: @instanceId
      message: message

    router = new Router @flowName, 'engine-in-a-vat'

    router.initialize =>
      debug "router initialized."
      router.message envelope      
      router.on 'data', (data) => debug "router said:", data

    router

module.exports = NanocyteEngineInAVat
