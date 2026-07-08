local networkRequests = script.Parent.networkRequests
local createGetSkinnyUsersFromUserIds = require(networkRequests.createGetSkinnyUsersFromUserIds)
local createGetUsernameHistoryFromUserId = require(networkRequests.createGetUsernameHistoryFromUserId)
local createGetUserV2FromUserId = require(networkRequests.createGetUserV2FromUserId)
local createGetDisplayNameValidation = require(networkRequests.createGetDisplayNameValidation)
local createSetDisplayName = require(networkRequests.createSetDisplayName)
local createSetDescription = require(networkRequests.createSetDescription)

return function(p1) -- line: 9
	-- upvalues: createGetSkinnyUsersFromUserIds (copy), createGetUsernameHistoryFromUserId (copy), createGetUserV2FromUserId (copy), createGetDisplayNameValidation (copy), createSetDisplayName (copy), createSetDescription (copy)
	return {
		GetSkinnyUsersFromUserIds = createGetSkinnyUsersFromUserIds(p1),
		GetUsernameHistoryFromUserId = createGetUsernameHistoryFromUserId(p1),
		GetUserV2FromUserId = createGetUserV2FromUserId(p1),
		GetDisplayNameValidation = createGetDisplayNameValidation(p1),
		SetDisplayName = createSetDisplayName(p1),
		SetDescription = createSetDescription(p1)
	}
end
