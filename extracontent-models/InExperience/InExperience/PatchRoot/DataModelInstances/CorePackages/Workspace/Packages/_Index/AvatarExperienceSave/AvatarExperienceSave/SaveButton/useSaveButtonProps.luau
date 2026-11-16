local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")

local parent = AvatarExperienceSave.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)

local SlotBasedEditorAnalytics = AvatarExperienceAnalytics.Surfaces.SlotBasedEditorAnalytics

local SaveStatusEnum = require(AvatarExperienceSave.Enums.SaveStatusEnum)

local useAvatarSaveContext = require(AvatarExperienceSave.Context.useAvatarSaveContext)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

local function useSaveButtonProps()
	local v = useAvatarRoute()
	local v2 = useAvatarSaveContext()

	local getSaveEligibilityStatusSignal = v2.getSaveEligibilityStatusSignal
	local trySaveAvatar = v2.trySaveAvatar

	local v3 = SignalsReact.useSignalState(getSaveEligibilityStatusSignal)

	local disabled = React.useMemo(function()
		return v3 ~= SaveStatusEnum.Eligible or v.isOverlayVisible
	end, { v3, v.isOverlayVisible })

	return {
		disabled = disabled,
		onActivated = React.useCallback(function()
			if not disabled and trySaveAvatar then
				trySaveAvatar()
				SlotBasedEditorAnalytics.trackSaveClick()
			end
		end, { disabled, trySaveAvatar })
	}
end

return useSaveButtonProps
