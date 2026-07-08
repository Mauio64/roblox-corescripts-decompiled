local HttpService = game:GetService("HttpService")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Promise = require(DataHydrationParent.Promise)
local Url = require(DataHydrationParent.Http).Url
local FFlagFriendsSignalMigrationTelemetry = require(DataHydrationParent.SharedFlags).FFlagFriendsSignalMigrationTelemetry
local Friends = DataHydration.Friends
local myHttpRequest = require(Friends.Networking.myHttpRequest)
local FriendsRequestTelemetry = require(script.Parent.FriendsRequestTelemetry)

local function collectFriendIdsFromResponse(t1: {[any]: any}?) -- line: 34
	local t2 = {}

	for _, v14 in t1 and t1.PageItems or {} do
		if v14.id ~= nil then
			table.insert(t2, (tostring(v14.id)))
		end
	end

	return t2
end

return function(p1, t3: {[any]: any}) -- line: 44
	-- upvalues: Promise (copy), Url (copy), HttpService (copy), FFlagFriendsSignalMigrationTelemetry (copy), FriendsRequestTelemetry (copy), myHttpRequest (copy), collectFriendIdsFromResponse (copy)
	if p1 == nil or tostring(p1) == "" then
		return Promise.reject("GetFindFriendsPage called with nil userId")
	end

	local limit = t3.limit
	local v18 = string.format("%s/users/%s/friends/find?limit=%d", Url.FRIEND_URL, tostring(p1), limit)
	local cursor = t3.cursor

	if cursor and cursor ~= "" then
		v18 = string.format("%s&cursor=%s", v18, HttpService:UrlEncode(cursor))
	end

	local sort = t3.sort

	if sort ~= nil then
		v18 = string.format("%s&userSort=%d", v18, sort)
	end

	local v21 = if not FFlagFriendsSignalMigrationTelemetry then nil else FriendsRequestTelemetry.generateRequestId()
	local v22 = if not FFlagFriendsSignalMigrationTelemetry then nil else FriendsRequestTelemetry.getRequestOptions(v21)

	return myHttpRequest(v18, "GET", v22):andThen(function(p2) -- line: 70
		-- upvalues: FFlagFriendsSignalMigrationTelemetry (copy), v21 (copy), FriendsRequestTelemetry (copy), collectFriendIdsFromResponse (copy)
		local v24 = if not p2 then nil else p2.responseBody

		if FFlagFriendsSignalMigrationTelemetry and (v21 and v24) then
			FriendsRequestTelemetry.emitFindFriendsResponse(v21, (collectFriendIdsFromResponse(v24)))
		end

		return v24
	end)
end
