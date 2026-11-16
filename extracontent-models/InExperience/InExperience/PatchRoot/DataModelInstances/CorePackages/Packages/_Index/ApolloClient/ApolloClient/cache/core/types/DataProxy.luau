local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

require(parent2.LuauPolyfill)

require(parent2.GraphQL)

require(parent.jsutils.typedDocumentNode)

require(script.Parent.common)

return {}
