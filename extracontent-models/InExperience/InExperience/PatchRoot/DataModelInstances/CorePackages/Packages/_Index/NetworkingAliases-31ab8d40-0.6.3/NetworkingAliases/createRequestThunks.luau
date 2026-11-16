local networkRequests = script.Parent.networkRequests
local createGetTagsFromUserIds = require(networkRequests.createGetTagsFromUserIds)
local createSetUserTag = require(networkRequests.createSetUserTag)
require(script.Parent.networkingAliasesTypes)

return function(p)
	return { GetTagsFromUserIds = createGetTagsFromUserIds(p), SetUserTag = createSetUserTag(p) }
end
