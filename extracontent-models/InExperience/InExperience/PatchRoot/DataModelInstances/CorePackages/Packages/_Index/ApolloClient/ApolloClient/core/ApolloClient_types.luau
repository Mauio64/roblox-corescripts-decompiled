local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.LuauPolyfill)
require(ParentParentParent.GraphQL)
require(script.Parent.Parent.link.core)
require(script.Parent.Parent.cache)
require(script.Parent.Parent.utilities)
require(script.Parent.Parent.link.http)
require(script.Parent.ObservableQuery_types)
require(ParentParent.core.types)
require(script.Parent.watchQueryOptions_types)
require(script.Parent.watchQueryOptions)

return {}
