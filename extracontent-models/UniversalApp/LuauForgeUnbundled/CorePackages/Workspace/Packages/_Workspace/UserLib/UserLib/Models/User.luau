local Players = game:GetService("Players")

local getFFlagInviteListRerank = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/SharedFlags").GetFFlagInviteListRerank

local v5 = {}

v5.PresenceType = {
	OFFLINE = "OFFLINE",
	ONLINE = "ONLINE",
	IN_GAME = "IN_GAME",
	IN_STUDIO = "IN_STUDIO"
}

function v5.new()
	return {}
end

function v5.fromData(p2, p3, isFriend, value)
	local v6 = v5.new()

	v6.id = tostring(p2)

	v6.isFetching = false
	v6.isFriend = isFriend
	v6.friendRank = value or 0
	v6.lastLocation = nil
	v6.name = p3
	v6.displayName = p3
	v6.externalAppDisplayName = p3
	v6.universeId = nil
	v6.placeId = nil
	v6.rootPlaceId = nil
	v6.gameInstanceId = nil

	local v7 = if Players.LocalPlayer and v6.id == tostring(Players.LocalPlayer.UserId) then v5.PresenceType.ONLINE or nil else nil
	v6.presence = v7

	v6.DEPRECATED_thumbnails = nil
	v6.lastOnline = nil

	return v6
end

function v5.fromDataTable(data)
	local v6 = v5.new()

	v6.id = tostring(data.id)
	v6.isFriend = data.isFriend
	v6.friendRank = data.friendRank
	local v7 = if Players.LocalPlayer and v6.id == tostring(Players.LocalPlayer.UserId) then v5.PresenceType.ONLINE or nil else nil
	v6.presence = v7

	v6.isFetching = false
	v6.lastLocation = nil
	v6.name = data.name
	v6.displayName = data.displayName or data.name
	v6.externalAppDisplayName = data.externalAppDisplayName
	v6.universeId = nil
	v6.placeId = nil
	v6.rootPlaceId = nil
	v6.gameInstanceId = nil
	v6.DEPRECATED_thumbnails = nil
	v6.lastOnline = nil
	v6.hasVerifiedBadge = data.hasVerifiedBadge

	if getFFlagInviteListRerank() then
		v6.friendFrequentRank = data.friendFrequentRank
	end

	return v6
end

function v5.compare(items, items2): boolean
	local v6 = items == nil and items2 == nil
	assert(not v6, "user1 and user2 cannot both be nil")
	assert(items == nil or typeof(items) == "table", "user1 must be a table or nil")
	assert(items2 == nil or typeof(items2) == "table", "user2 must be a table or nil")

	if not (items and items2) then
		return false
	end

	for k, item in pairs(items2) do
		if items[k] ~= item then
			return false
		end
	end

	for k, item in pairs(items) do
		if items2[k] ~= item then
			return false
		end
	end

	return true
end

function v5.userPresenceToText(object, p2)
	local presence = p2.presence
	local lastLocation = p2.lastLocation

	if not presence then
		return ""
	end

	if presence == v5.PresenceType.OFFLINE then
		return object:Format("Common.Presence.Label.Offline")
	end

	if presence == v5.PresenceType.ONLINE then
		return object:Format("Common.Presence.Label.Online")
	end

	if presence ~= v5.PresenceType.IN_GAME and presence ~= v5.PresenceType.IN_STUDIO then
		return
	end

	if lastLocation == nil then
		return object:Format("Common.Presence.Label.Online")
	end

	return lastLocation
end

return v5
