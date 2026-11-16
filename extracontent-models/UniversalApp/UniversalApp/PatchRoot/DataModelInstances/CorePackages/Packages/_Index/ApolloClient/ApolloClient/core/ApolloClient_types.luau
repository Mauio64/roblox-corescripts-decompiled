local parent = script.Parent.Parent
local parent2 = parent.Parent

require(parent2.LuauPolyfill)

require(parent2.GraphQL)

require(script.Parent.Parent.link.core)

require(script.Parent.Parent.cache)

require(script.Parent.Parent.utilities)

require(script.Parent.Parent.link.http)

require(script.Parent.ObservableQuery_types)

require(parent.core.types)

require(script.Parent.watchQueryOptions_types)

require(script.Parent.watchQueryOptions)

return {}
