local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

require(parent2.LuauPolyfill)

require(parent2.GraphQL)

require(parent.utilities.graphql.types)

require(script.Parent.policies_types)

require(parent.cache.core.types.common)

return {}
