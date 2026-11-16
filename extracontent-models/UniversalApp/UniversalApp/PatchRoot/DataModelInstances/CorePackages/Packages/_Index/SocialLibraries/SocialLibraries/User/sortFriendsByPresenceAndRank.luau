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

local function fn(p: number?) -- 1 equivalent call inferred from this helper
	return t.number(p) and v[p] or v[presenceType.Offline]
end

local function fn2(presence: string?) -- 2 equivalent calls inferred from this helper
	return t.string(presence) and v2[presence] or v2[userModel.PresenceType.OFFLINE]
end

local function fn3(p, p2)
	local v3 = 0
	local v4 = 0

	if p.userPresenceType and p2.userPresenceType then
		v3 = fn(p.userPresenceType.rawValue()) -- inferred equivalent call
		local rawValue = p2.userPresenceType.rawValue()
		v4 = t.number(rawValue) and v[rawValue]

		if v4 then
			return v3, v4
		end

		return v3, v[presenceType.Offline]
	end

	if p.presence and p2.presence then
		v3 = fn2(p.presence) -- inferred equivalent call
		v4 = fn2(p2.presence) -- inferred equivalent call
	end

	return v3, v4
end

local function fn4(p, p2) -- 1 equivalent call inferred from this helper
	return p.username or p.name or "", p2.username or p2.name or ""
end

return function(p, p2): boolean
	local v3, v4 = fn3(p, p2)

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

	local v5, v6 = fn4(p, p2) -- inferred equivalent call
	return string.lower(v5) < string.lower(v6)
end
