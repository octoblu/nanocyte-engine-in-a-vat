EngineInAVat = require './nanocyte-engine-in-a-vat'

flow = require './flows/compose-race-condition.json'

console.log flow
engineInAVat = new EngineInAVat flowName: 'compose-race-condition', flowData: flow


engineInAVat.configure ->
  engineInAVat.messageRouter {}