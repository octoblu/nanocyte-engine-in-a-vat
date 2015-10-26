{Transform} = require 'stream'

NodeAssembler = require('@octoblu/nanocyte-engine-simple/src/models/node-assembler')
EngineOutputNode = require('@octoblu/nanocyte-engine-simple/src/models/engine-output-node')

class VatNodeAssembler extends NodeAssembler
  constructor: ->
    super arguments
    @_assembleNodes = @assembleNodes
    @assembleNodes = @assembleVatNodes

  assembleVatNodes: =>
    nodes = @_assembleNodes.apply arguments
    nodes['engine-output'] = VatOutputNode

    nodes


class VatOutput extends Transform
  constructor: -> super objectMode: true
  _transform: ({config, data, message}, enc, next) =>
    console.log message

class VatOutputNode extends EngineOutputNode
  constructor: -> super EngineOutput: VatOutput

module.exports = VatNodeAssembler
