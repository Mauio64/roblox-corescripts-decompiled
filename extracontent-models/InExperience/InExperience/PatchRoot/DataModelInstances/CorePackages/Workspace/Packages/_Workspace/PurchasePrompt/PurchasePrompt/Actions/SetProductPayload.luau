local makeActionCreator = require(script.Parent.makeActionCreator)

require(script.Parent.Parent.types)

return makeActionCreator(script.Name, "productPayload")
