local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local UserModel = require(SocialLibraries.dependencies).UserModel
local t1 = {
	[UserModel.PresenceType.IN_GAME] = 3,
	[UserModel.PresenceType.ONLINE] = 2,
	[UserModel.PresenceType.IN_STUDIO] = 1,
	[UserModel.PresenceType.OFFLINE] = 0
}

return function(p1, p2) -- line: 13
	-- upvalues: t1 (copy)
	local v6 = p1 or {}
	local v7 = p2 or {}
	local presence = v6.presence
	local presence2 = v7.presence

	if presence and (presence2 and t1[presence] ~= t1[presence2]) then
		return t1[presence] > t1[presence2]
	end

	return v6.displayName < v7.displayName
end
