{Transform} = require 'stream'
_ = require 'lodash'

NodeAssembler = require('@octoblu/nanocyte-engine-simple/src/models/node-assembler')
EngineOutputNode = require('@octoblu/nanocyte-engine-simple/src/models/engine-output-node')

getVatNodeAssembler = (outputStream) ->
  class VatNodeAssembler extends NodeAssembler
    assembleNodes: =>
      _.mapValues super, getVatNode

  getVatNode = (EngineNode)->
    class VatNode extends EngineNode
      message: (envelope, enc, next)=>
        outputStream.write envelope
        super
        
  VatNodeAssembler

module.exports = getVatNodeAssembler
