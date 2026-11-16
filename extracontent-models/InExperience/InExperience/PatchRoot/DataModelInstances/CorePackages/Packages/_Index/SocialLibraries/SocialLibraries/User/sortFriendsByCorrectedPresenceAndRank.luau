local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roduxPresence = dependencies.RoduxPresence
local userModel = dependencies.UserModel
local t = dependencies.t
local presenceType = roduxPresence.Enums.PresenceType

local _ = { InGame = 3, Online = 2, InStudio = 1, Offline = 0 }

local v = {
	[presenceType.InGame.rawValue()] = 3,
	[presenceType.Online.rawValue()] = 2,
	[presenceType.InStudio.rawValue()] = 1,
	[presenceType.Offline.rawValue()] = 0
}

local v2 = {
	[userModel.PresenceType.IN_GAME] = 3,
	[userModel.PresenceType.ONLINE] = 2,
	[userModel.PresenceType.IN_STUDIO] = 1,
	[userModel.PresenceType.OFFLINE] = 0
}

local function fn(p, p2) -- 1 equivalent call inferred from this helper
	local v3 = 0
	local v4 = 0

	if p.userPresenceType and p2.userPresenceType then
		v3 = UNNAMED_122(p) -- inferred equivalent call
		local v5 = UNNAMED_120(p2) -- inferred equivalent call
		v4 = t.number(v5) and v[v5]

		if v4 then
			return v3, v4
		end

		return v3, v[presenceType.Offline]
	end

	if p.presence and p2.presence then
		v3 = UNNAMED_123(p) -- inferred equivalent call
		local v5 = UNNAMED_121(p2) -- inferred equivalent call
		v4 = t.string(v5) and v2[v5] or v2[userModel.PresenceType.OFFLINE]
	end

	return v3, v4
end

local function fn2(p, p2) -- 1 equivalent call inferred from this helper
	return p.username or p.name or "", p2.username or p2.name or ""
end

return function(p, p2): boolean
	local v3, v4 = fn(p, p2) -- inferred equivalent call

	if v3 ~= v4 then
		return v4 < v3
	end

	local friendRank = t.number(p.friendRank) and p.friendRank or 0
	local friendRank2 = t.number(p2.friendRank) and p2.friendRank or 0

	if friendRank ~= friendRank2 then
		return friendRank < friendRank2
	end

	local displayName = t.string(p.displayName) and p.displayName or ""
	local displayName2 = t.string(p2.displayName) and p2.displayName or ""

	if string.lower(displayName) ~= string.lower(displayName2) then
		return string.lower(displayName) < string.lower(displayName2)
	end

	local v5, v6 = fn2(p, p2) -- inferred equivalent call
	return string.lower(v5) < string.lower(v6)
end
