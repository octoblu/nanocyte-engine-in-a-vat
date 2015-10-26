EngineInAVat = require './nanocyte-engine-in-a-vat'
_ = require 'lodash'
flow = require './flows/compose-race-condition.json'

engineInAVat = new EngineInAVat flowName: 'compose-race-condition', flowData: flow


engineInAVat.configure (error, configuration)->
  router = engineInAVat.triggerByName {name: 'High  Five', message: 1}

  router.on 'data', (message) =>
    console.log message, '\n'

  router2 = engineInAVat.triggerByName {name: 'Handshake', message: 1}

  router2.on 'data', (message) =>
    console.log message, '\n'

  #
  # engineInAVat.triggerByName name: 'Handshake', message: 1
