local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

require(parent2.GraphQL)

require(parent.jsutils.typedDocumentNode)

require(parent.react.types.types)

local useBaseQuery = require(script.Parent.utils.useBaseQuery)
local useBaseQuery2 = useBaseQuery.useBaseQuery
require(parent.core)

return {
	useLazyQuery = function(p, p2)
		return useBaseQuery2(p, p2, true)
	end
}
