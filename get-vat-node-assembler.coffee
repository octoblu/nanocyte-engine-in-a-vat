{Transform} = require 'stream'
_ = require 'lodash'

NodeAssembler = require('@octoblu/nanocyte-engine-simple/src/models/node-assembler')
EngineOutputNode = require('@octoblu/nanocyte-engine-simple/src/models/engine-output-node')

getVatNodeAssembler = (outputStream) ->
  class VatNodeAssembler extends NodeAssembler
    assembleNodes: =>
      nodes = _.mapValues super, getVatNode
      nodes['engine-output'] = nodes['nanocyte-component-pass-through']

      nodes

  getVatNode = (EngineNode, nanocyteType)->
    class VatNode extends EngineNode
      message: (envelope, enc, next) =>
        envelope.metadata.nanocyteType = nanocyteType
        outputStream.write envelope
        super

  VatNodeAssembler

module.exports = getVatNodeAssembler
