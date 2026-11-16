local parent = script:FindFirstAncestor("MomentScenes").Parent
local SafeFlags = require(parent.SafeFlags)

return {
	MomentScenesAvatarMomentUserId = SafeFlags.createGetFFlag("MomentScenesAvatarMomentUserId")()
}
