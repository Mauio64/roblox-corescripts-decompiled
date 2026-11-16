local parent = script.Parent.Parent
local parent2 = parent.Parent
require(parent2.LuauPolyfill)

require(parent2.GraphQL)

require(script.Parent.watchQueryOptions_types)

require(parent.jsutils.typedDocumentNode)

require(script.Parent.types)
return {}
