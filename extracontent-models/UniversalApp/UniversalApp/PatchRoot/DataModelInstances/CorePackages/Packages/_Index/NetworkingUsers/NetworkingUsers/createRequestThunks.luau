local networkRequests = script.Parent.networkRequests
local createGetSkinnyUsersFromUserIds = require(networkRequests.createGetSkinnyUsersFromUserIds)
local createGetUsernameHistoryFromUserId = require(networkRequests.createGetUsernameHistoryFromUserId)
local createGetUserV2FromUserId = require(networkRequests.createGetUserV2FromUserId)
local createGetDisplayNameValidation = require(networkRequests.createGetDisplayNameValidation)
local createSetDisplayName = require(networkRequests.createSetDisplayName)
local createSetDescription = require(networkRequests.createSetDescription)

return function(p)
	return {
		GetSkinnyUsersFromUserIds = createGetSkinnyUsersFromUserIds(p),
		GetUsernameHistoryFromUserId = createGetUsernameHistoryFromUserId(p),
		GetUserV2FromUserId = createGetUserV2FromUserId(p),
		GetDisplayNameValidation = createGetDisplayNameValidation(p),
		SetDisplayName = createSetDisplayName(p),
		SetDescription = createSetDescription(p)
	}
end
