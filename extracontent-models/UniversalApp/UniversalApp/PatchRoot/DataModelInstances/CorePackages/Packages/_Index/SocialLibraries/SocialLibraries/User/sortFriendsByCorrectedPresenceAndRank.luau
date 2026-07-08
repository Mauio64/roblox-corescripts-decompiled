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

return function(t3: {[any]: any}, t4: {[any]: any}) -- line: 94
	-- upvalues: PresenceType (copy), t (copy), t1 (copy), UserModel (copy), t2 (copy)
	local n1 = 0
	local n2 = 0

	if t3.userPresenceType and t4.userPresenceType then
		local userPresenceType = t3.userPresenceType
		local v47 = t3.lastLocation or ""
		local v48 = if userPresenceType ~= PresenceType.InGame and userPresenceType ~= PresenceType.InStudio or #v47 ~= 0 then userPresenceType.rawValue() else PresenceType.Online.rawValue()

		n1 = t.number(v48) and t1[v48] or t1[PresenceType.Offline]

		local userPresenceType2 = t4.userPresenceType
		local v50 = t4.lastLocation or ""
		local v51 = if userPresenceType2 ~= PresenceType.InGame and userPresenceType2 ~= PresenceType.InStudio or #v50 ~= 0 then userPresenceType2.rawValue() else PresenceType.Online.rawValue()

		n2 = t.number(v51) and t1[v51] or t1[PresenceType.Offline]
	elseif t3.presence and t4.presence then
		local presence = t3.presence
		local v53 = t3.lastLocation or ""
		local v54 = if presence ~= UserModel.PresenceType.IN_GAME and presence ~= UserModel.PresenceType.IN_STUDIO or #v53 ~= 0 then presence else UserModel.PresenceType.ONLINE

		n1 = t.string(v54) and t2[v54] or t2[UserModel.PresenceType.OFFLINE]

		local presence2 = t4.presence
		local v56 = t4.lastLocation or ""
		local v57 = if presence2 ~= UserModel.PresenceType.IN_GAME and presence2 ~= UserModel.PresenceType.IN_STUDIO or #v56 ~= 0 then presence2 else UserModel.PresenceType.ONLINE

		n2 = t.string(v57) and t2[v57] or t2[UserModel.PresenceType.OFFLINE]
	end

	if n1 ~= n2 then
		return n2 < n1
	end

	local v58 = t.number(t3.friendRank) and t3.friendRank or 0
	local v59 = t.number(t4.friendRank) and t4.friendRank or 0

	if v58 ~= v59 then
		return v58 < v59
	end

	local v60 = t.string(t3.displayName) and t3.displayName or ""
	local v61 = t.string(t4.displayName) and t4.displayName or ""

	if string.lower(v60) ~= string.lower(v61) then
		return string.lower(v60) < string.lower(v61)
	end

	local v62 = t3.username or (t3.name or "")
	local v63 = t4.username or (t4.name or "")

	return string.lower(v62) < string.lower(v63)
end
