local UseQuery = {}
local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

require(parent2.GraphQL)

require(parent.jsutils.typedDocumentNode)

require(script.Parent.Parent.types.types)

local useBaseQuery = require(script.Parent.utils.useBaseQuery)
local useBaseQuery2 = useBaseQuery.useBaseQuery

require(parent.core)

function UseQuery.useQuery(p, p2)
	return useBaseQuery2(p, p2, false)
end

return UseQuery
