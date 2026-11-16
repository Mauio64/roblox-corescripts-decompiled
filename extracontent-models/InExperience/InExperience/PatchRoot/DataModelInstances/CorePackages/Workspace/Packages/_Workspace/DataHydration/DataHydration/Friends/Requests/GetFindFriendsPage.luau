local HttpService = game:GetService("HttpService")
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

	for _, v in responseBody and responseBody.PageItems or {} do
		if v.id ~= nil then
			table.insert(ids, (tostring(v.id)))
		end
	end

	return ids
end

return function(p, data)
	if FFlagFriendsSkipInvalidUserIdFetches then
		if isInvalidUserId(p) then
			return Promise.reject(`GetFindFriendsPage called with invalid userId: {p}`)
		end
	elseif p == nil or tostring(p) == "" then
		return Promise.reject("GetFindFriendsPage called with nil userId")
	end

	local limit = data.limit
	local v = string.format("%s/users/%s/friends/find?limit=%d", Url.FRIEND_URL, tostring(p), limit)

	local cursor = data.cursor

	if cursor and cursor ~= "" then
		v = string.format("%s&cursor=%s", v, HttpService:UrlEncode(cursor))
	end

	local sort = data.sort

	if sort ~= nil then
		v = string.format("%s&userSort=%d", v, sort)
	end

	local v2

	if FFlagFriendsSignalMigrationTelemetry then
		v2 = FriendsRequestTelemetry.generateRequestId()
	else
		v2 = nil
	end

	local v3

	if FFlagFriendsSignalMigrationTelemetry then
		v3 = FriendsRequestTelemetry.getRequestOptions(v2)
	end

	return myHttpRequest(v, "GET", v3):andThen(function(p2)
		local responseBody

		if p2 then
			responseBody = p2.responseBody
		end

		if FFlagFriendsSignalMigrationTelemetry and v2 and responseBody then
			FriendsRequestTelemetry.emitFindFriendsResponse(v2, collectFriendIdsFromResponse(responseBody))
		end

		return responseBody
	end)
end
