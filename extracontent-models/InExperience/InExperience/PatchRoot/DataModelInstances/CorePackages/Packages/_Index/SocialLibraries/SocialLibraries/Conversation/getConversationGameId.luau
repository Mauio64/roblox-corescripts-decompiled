local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)

local userModel = dependencies.UserModel

return function(p, p2, p3)
	if p.pinnedGame and p.pinnedGame.universeId then
		return (tostring(p.pinnedGame.universeId))
	end

	local v = {}

	for _, v2 in pairs(p.participants or {}) do
		local v3 = p3[v2]

		if not (v3 ~= nil and v2 ~= p2 and v3.presence == userModel.PresenceType.IN_GAME and v3.rootPlaceId) then
			continue
		end

		v[v3.rootPlaceId] = v[v3.rootPlaceId] or 0
		v[v3.rootPlaceId] = v[v3.rootPlaceId] + 1
	end

	local v2 = 0
	local v3 = nil

	for k, v4 in pairs(v) do
		if not (v2 < v4) then
			continue
		end

		v3 = k
		v2 = v4
	end

	return v3 and tostring(v3) or nil
end
