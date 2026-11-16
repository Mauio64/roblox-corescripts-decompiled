local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local computeProfileFramesGating = require(AvatarExperienceProfilePictureEditor.Utils.computeProfileFramesGating)
local getProfileFrameAmpAccess = require(AvatarExperienceProfilePictureEditor.Utils.getProfileFrameAmpAccess)

local FFlagEditProfileFramesEnabled = SharedFlags.FFlagEditProfileFramesEnabled

local function useProfileFramesGating()
	local fFlagEditProfileFramesEnabled = FFlagEditProfileFramesEnabled
	local plusPurchasingBlocked = useAppPolicy(function(p)
		return p.getDisableBlackbirdEntrypoints()
	end)

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)

	local refetchAmpAccess = React.useCallback(function()
		if fFlagEditProfileFramesEnabled then
			setState2(true)
			setState(getProfileFrameAmpAccess())
		else
			setState(nil)
		end

		setState2(false)
	end, { fFlagEditProfileFramesEnabled })

	React.useEffect(function()
		refetchAmpAccess()
	end, { refetchAmpAccess })
	local access

	if state then
		access = state.access
	end

	local v = if state then state.hasError else false
	local v2 = if access then access.granted else false
	local v3 = if access then access.canUpsell else false

	local v4 = computeProfileFramesGating(fFlagEditProfileFramesEnabled, plusPurchasingBlocked, v2, v3, v)

	return {
		shouldShowFrames = v4.shouldShowFrames,
		shouldShowUpsell = v4.shouldShowUpsell,
		canEquipFrame = v4.canEquipFrame,
		ampAccessError = v4.ampAccessError,
		plusPurchasingBlocked = plusPurchasingBlocked,
		ampAccess = access,
		isAmpLoading = state2,
		refetchAmpAccess = refetchAmpAccess
	}
end

return useProfileFramesGating
