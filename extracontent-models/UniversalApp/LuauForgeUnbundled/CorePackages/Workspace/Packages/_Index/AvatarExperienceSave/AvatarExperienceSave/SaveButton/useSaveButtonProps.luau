local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/SignalsReact")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/AvatarExperienceNavigation")
local slotBasedEditorAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/AvatarExperienceAnalytics").Surfaces.SlotBasedEditorAnalytics

local SaveStatusEnum = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Enums/SaveStatusEnum")

local useAvatarSaveContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/useAvatarSaveContext")
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

local function useSaveButtonProps()
	local v5 = useAvatarRoute()
	local v6 = useAvatarSaveContext()

	local getSaveEligibilityStatusSignal = v6.getSaveEligibilityStatusSignal
	local trySaveAvatar = v6.trySaveAvatar

	local v7 = SignalsReact.useSignalState(getSaveEligibilityStatusSignal)

	local v8 = React.useMemo(function()
		return v7 ~= SaveStatusEnum.Eligible or v5.isOverlayVisible
	end, { v7, v5.isOverlayVisible })

	return {
		disabled = v8,
		onActivated = React.useCallback(function()
			if not v8 and trySaveAvatar then
				trySaveAvatar()
				slotBasedEditorAnalytics.trackSaveClick()
			end
		end, { v8, trySaveAvatar })
	}
end

return useSaveButtonProps
