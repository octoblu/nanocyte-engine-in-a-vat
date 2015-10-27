_ = require 'lodash'
{Transform} = require 'stream'

class AddNodeInfoStream extends Transform
  constructor: ({@flowData, @nanocyteConfig})->
    super objectMode: true

  _transform: (envelope, enc, next) =>
    fromNode = @nanocyteConfig[envelope.metadata.fromNodeId]
    toNode = @nanocyteConfig[envelope.metadata.toNodeId]

    debugInfo =
      fromNode: fromNode
      toNode: toNode
      timestamp: Date.now()

    newEnvelope = _.extend debugInfo: debugInfo, envelope
    @push newEnvelope
    next()

module.exports = AddNodeInfoStream
