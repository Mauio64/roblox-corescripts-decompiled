local parent = script.Parent.Parent
local parent2 = parent.Parent

require(parent2.LuauPolyfill)

require(parent2.GraphQL)

require(script.Parent.Parent.cache)

require(script.Parent.QueryInfo)

require(script.Parent.networkStatus)

require(script.Parent.ObservableQuery_types)

require(script.Parent.watchQueryOptions_types)

require(script.Parent.Parent.cache)

require(parent.jsutils.typedDocumentNode)

return {}
