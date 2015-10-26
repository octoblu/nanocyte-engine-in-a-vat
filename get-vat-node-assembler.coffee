{Transform} = require 'stream'

NodeAssembler = require('@octoblu/nanocyte-engine-simple/src/models/node-assembler')
EngineOutputNode = require('@octoblu/nanocyte-engine-simple/src/models/engine-output-node')

getVatNodeAssembler = (outputStream) ->
  class VatNodeAssembler extends NodeAssembler
    constructor: ->
      super arguments
      @_assembleNodes = @assembleNodes
      @assembleNodes = @assembleVatNodes

    assembleVatNodes: =>
      nodes = @_assembleNodes.apply arguments
      nodes['engine-output'] = VatOutputNode

      nodes

  class VatOutputNode extends EngineOutputNode
    constructor: -> super EngineOutput: VatOutput


  class VatOutput extends Transform
    constructor: ->
      super objectMode: true
      @pipe outputStream

    _transform: (envelope, enc, next) =>
      @push envelope.message
      next()

  VatNodeAssembler

module.exports = getVatNodeAssembler
