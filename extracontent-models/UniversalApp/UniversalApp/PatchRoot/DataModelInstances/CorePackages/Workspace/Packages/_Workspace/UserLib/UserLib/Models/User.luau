local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("UserLib").Parent
local GetFFlagInviteListRerank = require(Parent.SharedFlags).GetFFlagInviteListRerank
local t1 = {
	PresenceType = {
		OFFLINE = "OFFLINE",
		ONLINE = "ONLINE",
		IN_GAME = "IN_GAME",
		IN_STUDIO = "IN_STUDIO"
	},
	new = function() -- line: 17
		return {}
	end
}

function t1.fromData(p1, p2, p3, p4) -- line: 25
	-- upvalues: t1 (copy), Players (copy)
	local v9 = t1.new()

	v9.id = tostring(p1)
	v9.isFetching = false
	v9.isFriend = p3
	v9.friendRank = p4 or 0
	v9.lastLocation = nil
	v9.name = p2
	v9.displayName = p2
	v9.externalAppDisplayName = p2
	v9.universeId = nil
	v9.placeId = nil
	v9.rootPlaceId = nil
	v9.gameInstanceId = nil
	v9.presence = Players.LocalPlayer and (v9.id == tostring(Players.LocalPlayer.UserId) and t1.PresenceType.ONLINE) or nil
	v9.DEPRECATED_thumbnails = nil
	v9.lastOnline = nil

	return v9
end
function t1.fromDataTable(p5) -- line: 51
	-- upvalues: t1 (copy), Players (copy), GetFFlagInviteListRerank (copy)
	local v11 = t1.new()

	v11.id = tostring(p5.id)
	v11.isFriend = p5.isFriend
	v11.friendRank = p5.friendRank
	v11.presence = Players.LocalPlayer and (v11.id == tostring(Players.LocalPlayer.UserId) and t1.PresenceType.ONLINE) or nil
	v11.isFetching = false
	v11.lastLocation = nil
	v11.name = p5.name
	v11.displayName = p5.displayName or p5.name
	v11.externalAppDisplayName = p5.externalAppDisplayName
	v11.universeId = nil
	v11.placeId = nil
	v11.rootPlaceId = nil
	v11.gameInstanceId = nil
	v11.DEPRECATED_thumbnails = nil
	v11.lastOnline = nil
	v11.hasVerifiedBadge = p5.hasVerifiedBadge

	if GetFFlagInviteListRerank() then
		v11.friendFrequentRank = p5.friendFrequentRank
	end

	return v11
end
function t1.compare(p6, p7) -- line: 80
	assert(not (p6 == nil and p7 == nil), "user1 and user2 cannot both be nil")
	assert(p6 == nil or typeof(p6) == "table", "user1 must be a table or nil")
	assert(p7 == nil or typeof(p7) == "table", "user2 must be a table or nil")

	if not p6 or not p7 then
		return false
	end

	for k, v in pairs(p7) do
		if v ~= p6[k] then
			return false
		end
	end

	for k, v in pairs(p6) do
		if v ~= p7[k] then
			return false
		end
	end

	return true
end
function t1.userPresenceToText(p8, p9) -- line: 105
	-- upvalues: t1 (copy)
	local presence = p9.presence
	local lastLocation = p9.lastLocation

	if not presence then
		return ""
	end

	if presence == t1.PresenceType.OFFLINE then
		return p8:Format("Common.Presence.Label.Offline")
	end

	if presence == t1.PresenceType.ONLINE then
		return p8:Format("Common.Presence.Label.Online")
	end

	if presence == t1.PresenceType.IN_GAME or presence == t1.PresenceType.IN_STUDIO then
		if lastLocation ~= nil then
			return lastLocation
		end

		return p8:Format("Common.Presence.Label.Online")
	end
end

return t1
