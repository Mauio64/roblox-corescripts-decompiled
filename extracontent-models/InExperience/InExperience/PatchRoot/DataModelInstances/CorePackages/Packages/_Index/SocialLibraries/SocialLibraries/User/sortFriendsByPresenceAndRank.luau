local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local RoduxPresence = dependencies.RoduxPresence
local UserModel = dependencies.UserModel
local t = dependencies.t
local PresenceType = RoduxPresence.Enums.PresenceType
local _ = {
	InGame = 3,
	Online = 2,
	InStudio = 1,
	Offline = 0
}
local t1 = {
	[PresenceType.InGame.rawValue()] = 3,
	[PresenceType.Online.rawValue()] = 2,
	[PresenceType.InStudio.rawValue()] = 1,
	[PresenceType.Offline.rawValue()] = 0
}
local t2 = {
	[UserModel.PresenceType.IN_GAME] = 3,
	[UserModel.PresenceType.ONLINE] = 2,
	[UserModel.PresenceType.IN_STUDIO] = 1,
	[UserModel.PresenceType.OFFLINE] = 0
}

local function v10(t3: {[any]: any}, t4: {[any]: any}) -- line: 53
	-- upvalues: t (copy), t1 (copy), PresenceType (copy), t2 (copy), UserModel (copy)
	local n1 = 0
	local n2 = 0

	if t3.userPresenceType and t4.userPresenceType then
		local v17 = t3.userPresenceType.rawValue()

		n1 = t.number(v17) and t1[v17] or t1[PresenceType.Offline]

		local v18 = t4.userPresenceType.rawValue()

		if not t.number(v18) then
			return n1, t1[PresenceType.Offline]
		end

		n2 = t1[v18]

		if not n2 then
			return n1, t1[PresenceType.Offline]
		end
	elseif t3.presence and t4.presence then
		local presence = t3.presence

		n1 = t.string(presence) and t2[presence] or t2[UserModel.PresenceType.OFFLINE]

		local presence2 = t4.presence

		n2 = t.string(presence2) and t2[presence2] or t2[UserModel.PresenceType.OFFLINE]
	end

	return n1, n2
end

return function(t5: {[any]: any}, t6: {[any]: any}) -- line: 72
	-- upvalues: v10 (copy), t (copy)
	local v25, v26 = v10(t5, t6)

	if v25 ~= v26 then
		return v26 < v25
	end

	local v27 = t.number(t5.friendRank) and t5.friendRank or 0
	local v28 = t.number(t6.friendRank) and t6.friendRank or 0

	if v27 ~= v28 then
		return v27 < v28
	end

	local v29 = t.string(t5.displayName) and t5.displayName or ""
	local v30 = t.string(t6.displayName) and t6.displayName or ""

	if string.lower(v29) ~= string.lower(v30) then
		return string.lower(v29) < string.lower(v30)
	end

	local v31 = t5.username or (t5.name or "")
	local v32 = t6.username or (t6.name or "")

	return string.lower(v31) < string.lower(v32)
end
