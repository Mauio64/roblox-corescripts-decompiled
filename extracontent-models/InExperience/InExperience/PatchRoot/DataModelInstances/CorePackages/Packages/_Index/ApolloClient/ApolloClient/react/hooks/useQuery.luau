local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.GraphQL)
require(ParentParent.jsutils.typedDocumentNode)
require(script.Parent.Parent.types.types)

local useBaseQuery = require(script.Parent.utils.useBaseQuery).useBaseQuery

require(ParentParent.core)

function t1.useQuery(p1, p2) -- line: 27
	-- upvalues: useBaseQuery (copy)
	return useBaseQuery(p1, p2, false)
end

return t1
