_ = require 'lodash'
{Transform} = require 'stream'

class AddNodeInfoStream extends Transform
  constructor: ({@flowData, @nanocyteConfig})->
    super objectMode: true

  _transform: ({metadata, message}, enc, next) =>
    node = @nanocyteConfig[metadata.fromNodeId]
    @push metadata: metadata, message: message, node: node?.config?.name
    next()

module.exports = AddNodeInfoStream
