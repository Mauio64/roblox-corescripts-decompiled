local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.LuauPolyfill)
require(ParentParentParent.GraphQL)
require(script.Parent.Parent.cache)
require(script.Parent.Parent.link.core)
require(ParentParent.jsutils.typedDocumentNode)

return {}
