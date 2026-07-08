local networkRequests = script.Parent.networkRequests
local createGetTagsFromUserIds = require(networkRequests.createGetTagsFromUserIds)
local createSetUserTag = require(networkRequests.createSetUserTag)

require(script.Parent.networkingAliasesTypes)

return function(p1) -- line: 6
	-- upvalues: createGetTagsFromUserIds (copy), createSetUserTag (copy)
	return {
		GetTagsFromUserIds = createGetTagsFromUserIds(p1),
		SetUserTag = createSetUserTag(p1)
	}
end
