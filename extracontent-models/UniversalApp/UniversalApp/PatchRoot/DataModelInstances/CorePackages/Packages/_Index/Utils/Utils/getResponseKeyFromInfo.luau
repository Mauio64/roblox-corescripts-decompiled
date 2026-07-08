local ParentParent = script.Parent.Parent
local t1 = {}

require(ParentParent.GraphQL)

function t1.getResponseKeyFromInfo(p1) -- line: 14
	if p1.fieldNodes[1] and p1.fieldNodes[1].alias ~= nil then
		return p1.fieldNodes[1].alias.value
	end

	return p1.fieldName
end

return t1
