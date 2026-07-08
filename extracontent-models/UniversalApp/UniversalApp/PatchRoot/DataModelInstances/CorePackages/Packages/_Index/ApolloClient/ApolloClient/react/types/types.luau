local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.LuauPolyfill)
require(ParentParentParent.React)
require(ParentParentParent.GraphQL)
require(ParentParent.jsutils.typedDocumentNode)
require(script.Parent.Parent.Parent.core)

return {}
