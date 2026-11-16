local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url
local fFlagFriendsSignalMigrationTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagFriendsSignalMigrationTelemetry
local FFlagFriendsSkipInvalidUserIdFetches = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Flags/FFlagFriendsSkipInvalidUserIdFetches")

local isInvalidUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/isInvalidUserId")
local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/Networking/myHttpRequest")
local FriendsRequestTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Friends/Requests/FriendsRequestTelemetry")

local function collectFriendIdsFromResponse(responseBody)
	local ids = {}

	for k, v5 in responseBody and responseBody.PageItems or {} do
		if v5.id ~= nil then
			table.insert(ids, (tostring(v5.id)))
		end
	end

	return ids
end

return function(p2, data)
	if FFlagFriendsSkipInvalidUserIdFetches then
		if isInvalidUserId(p2) then
			return Promise.reject(`GetFindFriendsPage called with invalid userId: {p2}`)
		end
	elseif p2 == nil or tostring(p2) == "" then
		return Promise.reject("GetFindFriendsPage called with nil userId")
	end

	local limit = data.limit
	local v5 = string.format("%s/users/%s/friends/find?limit=%d", url.FRIEND_URL, tostring(p2), limit)

	local cursor = data.cursor

	if cursor and cursor ~= "" then
		v5 = string.format("%s&cursor=%s", v5, HttpService:UrlEncode(cursor))
	end

	local sort = data.sort

	if sort ~= nil then
		v5 = string.format("%s&userSort=%d", v5, sort)
	end

	local v6 = if fFlagFriendsSignalMigrationTelemetry then FriendsRequestTelemetry.generateRequestId() else nil

	local v7 = if fFlagFriendsSignalMigrationTelemetry then FriendsRequestTelemetry.getRequestOptions(v6) else nil

	return myHttpRequest(v5, "GET", v7):andThen(function(p3)
		local responseBody = if p3 then p3.responseBody else nil

		if fFlagFriendsSignalMigrationTelemetry and v6 and responseBody then
			FriendsRequestTelemetry.emitFindFriendsResponse(v6, collectFriendIdsFromResponse(responseBody))
		end

		return responseBody
	end)
end
