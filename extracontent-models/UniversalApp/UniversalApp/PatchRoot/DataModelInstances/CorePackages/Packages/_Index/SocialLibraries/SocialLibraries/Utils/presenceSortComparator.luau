local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)

local userModel = dependencies.UserModel

local v = {
	[userModel.PresenceType.IN_GAME] = 3,
	[userModel.PresenceType.ONLINE] = 2,
	[userModel.PresenceType.IN_STUDIO] = 1,
	[userModel.PresenceType.OFFLINE] = 0
}

return function(options, options2): boolean
	local v2 = options or {}
	local v3 = options2 or {}

	local presence = v2.presence
	local presence2 = v3.presence

	if presence and presence2 and v[presence] ~= v[presence2] then
		return v[presence] > v[presence2]
	end

	return v2.displayName < v3.displayName
end
