local parent = script.Parent.Parent
local parent2 = parent.Parent
require(parent2.LuauPolyfill)

require(parent2.GraphQL)

require(script.Parent.Parent.cache)

require(script.Parent.Parent.link.core)

require(parent.jsutils.typedDocumentNode)

return {}
