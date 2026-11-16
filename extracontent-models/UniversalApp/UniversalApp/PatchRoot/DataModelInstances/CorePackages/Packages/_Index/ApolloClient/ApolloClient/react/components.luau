local Query = require(script.Query)
local Components = {}
Components.Query = Query.Query
local Mutation = require(script.Mutation)
Components.Mutation = Mutation.Mutation

require(script.types)

return Components
