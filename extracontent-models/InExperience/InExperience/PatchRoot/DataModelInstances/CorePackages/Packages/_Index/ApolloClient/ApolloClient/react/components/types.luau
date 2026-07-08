local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.GraphQL)
require(ParentParent.jsutils.typedDocumentNode)
require(script.Parent.Parent.Parent.core)
require(script.Parent.Parent.Parent.cache)
require(script.Parent.Parent.types.types)

return {}
