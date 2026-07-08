local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.LuauPolyfill)
require(ParentParentParent.GraphQL)
require(script.Parent.Parent.cache)
require(script.Parent.QueryInfo)
require(script.Parent.networkStatus)
require(script.Parent.ObservableQuery_types)
require(script.Parent.watchQueryOptions_types)
require(script.Parent.Parent.cache)
require(ParentParent.jsutils.typedDocumentNode)

return {}
