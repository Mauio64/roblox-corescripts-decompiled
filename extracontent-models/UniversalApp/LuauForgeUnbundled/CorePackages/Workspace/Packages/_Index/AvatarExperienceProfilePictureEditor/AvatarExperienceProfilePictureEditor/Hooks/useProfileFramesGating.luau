local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/SharedFlags")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/UniversalAppPolicy").useAppPolicy

local computeProfileFramesGating = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/computeProfileFramesGating")
local getProfileFrameAmpAccess = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/getProfileFrameAmpAccess")

local fFlagEditProfileFramesEnabled = SharedFlags.FFlagEditProfileFramesEnabled

local function useProfileFramesGating()
	local v5 = fFlagEditProfileFramesEnabled
	local v6 = useAppPolicy(function(p2)
		return p2.getDisableBlackbirdEntrypoints()
	end)

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)

	local v7 = React.useCallback(function()
		if v5 then
			setState2(true)
			setState(getProfileFrameAmpAccess())
		else
			setState(nil)
		end

		setState2(false)
	end, { v5 })

	React.useEffect(function()
		v7()
	end, { v7 })

	local access = if state then state.access else nil
	local v8 = if state then state.hasError else false
	local v9 = if access then access.granted else false
	local v10 = if access then access.canUpsell else false

	local v11 = computeProfileFramesGating(v5, v6, v9, v10, v8)

	return {
		shouldShowFrames = v11.shouldShowFrames,
		shouldShowUpsell = v11.shouldShowUpsell,
		canEquipFrame = v11.canEquipFrame,
		ampAccessError = v11.ampAccessError,
		plusPurchasingBlocked = v6,
		ampAccess = access,
		isAmpLoading = state2,
		refetchAmpAccess = v7
	}
end

return useProfileFramesGating
