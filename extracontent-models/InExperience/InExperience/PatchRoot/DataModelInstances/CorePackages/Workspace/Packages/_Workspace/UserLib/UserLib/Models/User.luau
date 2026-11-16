local Players = game:GetService("Players")
local parent = script:FindFirstAncestor("UserLib").Parent

local SharedFlags = require(parent.SharedFlags)
local GetFFlagInviteListRerank = SharedFlags.GetFFlagInviteListRerank

local User = {}

User.PresenceType = {
	OFFLINE = "OFFLINE",
	ONLINE = "ONLINE",
	IN_GAME = "IN_GAME",
	IN_STUDIO = "IN_STUDIO"
}

function User.new()
	return {}
end

function User.fromData(p, p2, isFriend, value)
	local v = User.new()

	v.id = tostring(p)

	v.isFetching = false
	v.isFriend = isFriend
	v.friendRank = value or 0
	v.lastLocation = nil
	v.name = p2
	v.displayName = p2
	v.externalAppDisplayName = p2
	v.universeId = nil
	v.placeId = nil
	v.rootPlaceId = nil
	v.gameInstanceId = nil
	local presence

	if Players.LocalPlayer and v.id == tostring(Players.LocalPlayer.UserId) then
		presence = User.PresenceType.ONLINE or nil
	end

	v.presence = presence

	v.DEPRECATED_thumbnails = nil
	v.lastOnline = nil

	return v
end

function User.fromDataTable(data)
	local v = User.new()

	v.id = tostring(data.id)
	v.isFriend = data.isFriend
	v.friendRank = data.friendRank
	local presence

	if Players.LocalPlayer and v.id == tostring(Players.LocalPlayer.UserId) then
		presence = User.PresenceType.ONLINE or nil
	end

	v.presence = presence

	v.isFetching = false
	v.lastLocation = nil
	v.name = data.name
	v.displayName = data.displayName or data.name
	v.externalAppDisplayName = data.externalAppDisplayName
	v.universeId = nil
	v.placeId = nil
	v.rootPlaceId = nil
	v.gameInstanceId = nil
	v.DEPRECATED_thumbnails = nil
	v.lastOnline = nil
	v.hasVerifiedBadge = data.hasVerifiedBadge

	if GetFFlagInviteListRerank() then
		v.friendFrequentRank = data.friendFrequentRank
	end

	return v
end

function User.compare(items, items2): boolean
	local v = items == nil and items2 == nil
	assert(not v, "user1 and user2 cannot both be nil")
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

function User.userPresenceToText(object, p)
	local presence = p.presence
	local lastLocation = p.lastLocation

	if not presence then
		return ""
	end

	if presence == User.PresenceType.OFFLINE then
		return object:Format("Common.Presence.Label.Offline")
	end

	if presence == User.PresenceType.ONLINE then
		return object:Format("Common.Presence.Label.Online")
	end

	if presence ~= User.PresenceType.IN_GAME and presence ~= User.PresenceType.IN_STUDIO then
		return
	end

	if lastLocation == nil then
		return object:Format("Common.Presence.Label.Online")
	end

	return lastLocation
end

return User
