EngineInAVat = require './nanocyte-engine-in-a-vat'
_ = require 'lodash'
flow = require './flows/compose-race-condition.json'

engineInAVat = new EngineInAVat flowName: 'compose-race-condition', flowData: flow


engineInAVat.configure (error, configuration)->
  engineInAVat.triggerByName name: 'High  Five', message: 1
  engineInAVat.triggerByName name: 'Both', message: 1
  router = engineInAVat.triggerByName name: 'Handshake', message: 1
