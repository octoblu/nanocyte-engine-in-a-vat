fs = require 'fs'
redis = require 'redis'
client = redis.createClient process.env.REDIS_PORT, process.env.REDIS_HOST, auth_pass: process.env.REDIS_PASSWORD

ConfigurationGenerator = require 'nanocyte-configuration-generator'
ConfigurationSaver = require 'nanocyte-configuration-saver-redis'

flow = require './flows/compose-race-condition.json'
configurationGenerator = new ConfigurationGenerator {}
configurationSaver = new ConfigurationSaver client

configurationGenerator.configure flowData: flow, userData: {}, (error, flowData) ->
  return console.error "config generator had an error!", error if error?
  configurationSaver.save flowId: 'compose-race-condition', instanceId: '1', flowData: flowData, (error, result)->
    return console.error "config saver had an error!", error if error?
    client.unref()
