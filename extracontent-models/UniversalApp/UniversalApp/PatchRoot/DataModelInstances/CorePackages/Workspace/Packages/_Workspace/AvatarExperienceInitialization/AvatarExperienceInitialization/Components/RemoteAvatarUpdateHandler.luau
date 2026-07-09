local AvatarExperienceInitialization = script:FindFirstAncestor("AvatarExperienceInitialization")
local useRemoteAvatarUpdateEffect = require(AvatarExperienceInitialization.Hooks.useRemoteAvatarUpdateEffect)
local useAvatarUpdateOnGameLeave = require(AvatarExperienceInitialization.Hooks.useAvatarUpdateOnGameLeave)
local v4 = game:DefineFastFlag("AXUpdateAvatarOnGameLeave", false)

local function RemoteAvatarUpdateHandler(t1: {[any]: any}) -- line: 12
	-- upvalues: useRemoteAvatarUpdateEffect (copy), v4 (copy), useAvatarUpdateOnGameLeave (copy)
	useRemoteAvatarUpdateEffect(t1.onUpdated)

	if v4 then
		useAvatarUpdateOnGameLeave(t1.onUpdated)
	end
end

return RemoteAvatarUpdateHandler
