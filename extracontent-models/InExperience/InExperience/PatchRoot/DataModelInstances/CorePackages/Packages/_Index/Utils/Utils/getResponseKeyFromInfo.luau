local parent = script.Parent.Parent
local GetResponseKeyFromInfo = {}

require(parent.GraphQL)

function GetResponseKeyFromInfo.getResponseKeyFromInfo(p)
	if p.fieldNodes[1] and p.fieldNodes[1].alias ~= nil then
		return p.fieldNodes[1].alias.value
	end

	return p.fieldName
end
return GetResponseKeyFromInfo
