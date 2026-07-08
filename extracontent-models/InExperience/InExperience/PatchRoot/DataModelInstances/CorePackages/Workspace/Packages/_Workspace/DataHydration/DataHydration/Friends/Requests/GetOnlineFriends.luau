local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Promise = require(DataHydrationParent.Promise)
local Url = require(DataHydrationParent.Http).Url
local FFlagFriendsSignalMigrationTelemetry = require(DataHydrationParent.SharedFlags).FFlagFriendsSignalMigrationTelemetry
local Friends = DataHydration.Friends
local myHttpRequest = require(Friends.Networking.myHttpRequest)
local FriendsRequestTelemetry = require(script.Parent.FriendsRequestTelemetry)

local function collectFriendIdsFromResponse(t1: {[any]: any}?) -- line: 33
	local t2 = {}

	for _, v13 in t1 and t1.data or {} do
		if v13.id ~= nil then
			table.insert(t2, (tostring(v13.id)))
		end
	end

	return t2
end

return function(p1) -- line: 43
	-- upvalues: Promise (copy), FFlagFriendsSignalMigrationTelemetry (copy), FriendsRequestTelemetry (copy), Url (copy), myHttpRequest (copy), collectFriendIdsFromResponse (copy)
	if p1 == nil or tostring(p1) == "" then
		return Promise.reject("GetOnlineFriends called with nil userId")
	end

	local v15 = if not FFlagFriendsSignalMigrationTelemetry then nil else FriendsRequestTelemetry.generateRequestId()
	local v16 = if not FFlagFriendsSignalMigrationTelemetry then nil else FriendsRequestTelemetry.getRequestOptions(v15)
	local v17 = string.format("%s/users/%s/friends/online", Url.FRIEND_URL, (tostring(p1)))

	return myHttpRequest(v17, "GET", v16):andThen(function(p2) -- line: 54
		-- upvalues: FFlagFriendsSignalMigrationTelemetry (copy), v15 (copy), FriendsRequestTelemetry (copy), collectFriendIdsFromResponse (copy)
		local v19 = if not p2 then nil else p2.responseBody

		if FFlagFriendsSignalMigrationTelemetry and (v15 and v19) then
			FriendsRequestTelemetry.emitGetAllOnlineFriendsResponse(v15, (collectFriendIdsFromResponse(v19)))
		end

		return v19
	end)
end
