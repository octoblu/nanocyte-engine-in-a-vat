class VatOutputNode
  message:({metadata, message}) =>
    console.log 'outputNode got', metadata, message
    process.exit -1

module.exports = VatOutputNode
