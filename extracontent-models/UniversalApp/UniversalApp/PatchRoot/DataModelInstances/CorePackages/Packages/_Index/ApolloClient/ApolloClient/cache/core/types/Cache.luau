local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.GraphQL)
require(ParentParent.jsutils.typedDocumentNode)
require(script.Parent.DataProxy)
require(script.Parent.common)

return {}
