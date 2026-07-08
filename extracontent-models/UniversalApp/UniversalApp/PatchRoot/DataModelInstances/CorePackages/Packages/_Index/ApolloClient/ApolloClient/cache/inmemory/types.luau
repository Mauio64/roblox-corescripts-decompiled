local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.LuauPolyfill)
require(ParentParentParent.GraphQL)
require(ParentParent.utilities.graphql.types)
require(script.Parent.policies_types)
require(ParentParent.cache.core.types.common)

return {}
