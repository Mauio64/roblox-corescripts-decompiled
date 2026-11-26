local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

local fFlagFriendsSignalMigrationTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagFriendsSignalMigrationTelemetry
local FFlagFriendsSkipInvalidUserIdFetches = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Flags/FFlagFriendsSkipInvalidUserIdFetches")

local isInvalidUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/isInvalidUserId")
local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/Networking/myHttpRequest")
local FriendsRequestTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/Requests/FriendsRequestTelemetry")

local function collectFriendIdsFromResponse(responseBody)
	local ids = {}

	for k, v5 in responseBody and responseBody.data or {} do
		if v5.id ~= nil then
			table.insert(ids, (tostring(v5.id)))
		end
	end

	return ids
end

return function(p2)
	if FFlagFriendsSkipInvalidUserIdFetches then
		if isInvalidUserId(p2) then
			return Promise.reject(`GetOnlineFriends called with invalid userId: {p2}`)
		end
	elseif p2 == nil or tostring(p2) == "" then
		return Promise.reject("GetOnlineFriends called with nil userId")
	end

	local v5 = if fFlagFriendsSignalMigrationTelemetry then FriendsRequestTelemetry.generateRequestId() else nil

	local v6 = if fFlagFriendsSignalMigrationTelemetry then FriendsRequestTelemetry.getRequestOptions(v5) else nil

	return myHttpRequest(string.format("%s/users/%s/friends/online", url.FRIEND_URL, (tostring(p2))), "GET", v6):andThen(function(p3)
		local responseBody = if p3 then p3.responseBody else nil

		if fFlagFriendsSignalMigrationTelemetry and v5 and responseBody then
			FriendsRequestTelemetry.emitGetAllOnlineFriendsResponse(v5, collectFriendIdsFromResponse(responseBody))
		end

		return responseBody
	end)
end
