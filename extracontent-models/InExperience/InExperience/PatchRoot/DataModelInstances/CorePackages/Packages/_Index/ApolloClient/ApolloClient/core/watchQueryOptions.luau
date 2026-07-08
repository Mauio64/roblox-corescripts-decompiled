local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.LuauPolyfill)
require(ParentParentParent.GraphQL)
require(script.Parent.watchQueryOptions_types)
require(ParentParent.jsutils.typedDocumentNode)
require(script.Parent.types)

return {}
