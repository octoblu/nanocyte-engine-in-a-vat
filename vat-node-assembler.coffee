NodeAssembler = require('@octoblu/nanocyte-engine-simple/src/models/node-assembler')
VatOutputNode = require './vat-output-node'

class VatNodeAssembler extends NodeAssembler
  constructor: ->
    super arguments
    @_assembleNodes = @assembleNodes
    @assembleNodes = @assembleVatNodes

  assembleVatNodes: =>
    nodes = @_assembleNodes.apply arguments
    nodes['engine-output'] = VatOutputNode

    nodes

module.exports = VatNodeAssembler
