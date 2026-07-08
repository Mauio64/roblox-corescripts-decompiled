local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.GraphQL)
require(ParentParent.jsutils.typedDocumentNode)
require(ParentParent.react.types.types)

local useBaseQuery = require(script.Parent.utils.useBaseQuery).useBaseQuery

require(ParentParent.core)

return {
	useLazyQuery = function(p1, p2) -- line: 26
		-- upvalues: useBaseQuery (copy)
		return useBaseQuery(p1, p2, true)
	end
}
