local SocialTab = script:FindFirstAncestor("SocialTab")
local PresenceType = require(SocialTab.dependencies).RoduxPresence.Enums.PresenceType
local t1 = {
	[PresenceType.InGame] = 3,
	[PresenceType.Online] = 2,
	[PresenceType.InStudio] = 1,
	[PresenceType.Offline] = 0
}

return function(p1, p2) -- line: 17
	-- upvalues: t1 (copy), PresenceType (copy)
	local v7 = t1[p1.userPresenceType] or t1[PresenceType.Offline]
	local v8 = t1[p2.userPresenceType] or t1[PresenceType.Offline]

	if v7 == v8 then
		return string.lower(p1.displayName) < string.lower(p2.displayName)
	end

	return v8 < v7
end
