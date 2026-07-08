local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local UserModel = require(SocialLibraries.dependencies).UserModel

return function(p1, p2, p3) -- line: 7
	-- upvalues: UserModel (copy)
	if p1.pinnedGame and p1.pinnedGame.universeId then
		return (tostring(p1.pinnedGame.universeId))
	end

	local t1 = {}

	for _, v in pairs(p1.participants or {}) do
		local v9 = p3[v]

		if v9 ~= nil and v ~= p2 and v9.presence == UserModel.PresenceType.IN_GAME and v9.rootPlaceId then
			t1[v9.rootPlaceId] = t1[v9.rootPlaceId] or 0
			t1[v9.rootPlaceId] = t1[v9.rootPlaceId] + 1
		end
	end

	local v10 = nil
	local n1 = 0

	for k, v in pairs(t1) do
		if n1 < v then
			v10 = k
			n1 = v
		end
	end

	return v10 and tostring(v10) or nil
end
