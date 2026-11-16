local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url

local SharedFlags = require(parent.SharedFlags)
local FFlagFriendsSignalMigrationTelemetry = SharedFlags.FFlagFriendsSignalMigrationTelemetry
local FFlagFriendsSkipInvalidUserIdFetches = require(DataHydration.Flags.FFlagFriendsSkipInvalidUserIdFetches)
local Friends = DataHydration.Friends
local isInvalidUserId = require(Friends.isInvalidUserId)
local myHttpRequest = require(Friends.Networking.myHttpRequest)
local FriendsRequestTelemetry = require(script.Parent.FriendsRequestTelemetry)

local function collectFriendIdsFromResponse(responseBody)
	local ids = {}

	for _, v in responseBody and responseBody.data or {} do
		if v.id ~= nil then
			table.insert(ids, (tostring(v.id)))
		end
	end

	return ids
end

return function(p)
	if FFlagFriendsSkipInvalidUserIdFetches then
		if isInvalidUserId(p) then
			return Promise.reject(`GetOnlineFriends called with invalid userId: {p}`)
		end
	elseif p == nil or tostring(p) == "" then
		return Promise.reject("GetOnlineFriends called with nil userId")
	end

	local v

	if FFlagFriendsSignalMigrationTelemetry then
		v = FriendsRequestTelemetry.generateRequestId()
	else
		v = nil
	end

	local v2

	if FFlagFriendsSignalMigrationTelemetry then
		v2 = FriendsRequestTelemetry.getRequestOptions(v)
	end

	return myHttpRequest(string.format("%s/users/%s/friends/online", Url.FRIEND_URL, (tostring(p))), "GET", v2):andThen(function(p2)
		local responseBody

		if p2 then
			responseBody = p2.responseBody
		end

		if FFlagFriendsSignalMigrationTelemetry and v and responseBody then
			FriendsRequestTelemetry.emitGetAllOnlineFriendsResponse(v, collectFriendIdsFromResponse(responseBody))
		end

		return responseBody
	end)
end
