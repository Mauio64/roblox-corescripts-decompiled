local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local AvatarExperienceSaveParent = AvatarExperienceSave.Parent
local React = require(AvatarExperienceSaveParent.React)
local SignalsReact = require(AvatarExperienceSaveParent.SignalsReact)
local AvatarExperienceNavigation = require(AvatarExperienceSaveParent.AvatarExperienceNavigation)
local SlotBasedEditorAnalytics = require(AvatarExperienceSaveParent.AvatarExperienceAnalytics).Surfaces.SlotBasedEditorAnalytics
local SaveStatusEnum = require(AvatarExperienceSave.Enums.SaveStatusEnum)
local useAvatarSaveContext = require(AvatarExperienceSave.Context.useAvatarSaveContext)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

local function useSaveButtonProps() -- line: 22
	-- upvalues: useAvatarRoute (copy), useAvatarSaveContext (copy), SignalsReact (copy), React (copy), SaveStatusEnum (copy), SlotBasedEditorAnalytics (copy)
	local v11 = useAvatarRoute()
	local v12 = useAvatarSaveContext()
	local getSaveEligibilityStatusSignal = v12.getSaveEligibilityStatusSignal
	local trySaveAvatar = v12.trySaveAvatar
	local v15 = SignalsReact.useSignalState(getSaveEligibilityStatusSignal)
	local v16 = React.useMemo(function() -- line: 31
		-- upvalues: v15 (copy), SaveStatusEnum (copy), v11 (copy)
		return v15 ~= SaveStatusEnum.Eligible or v11.isOverlayVisible
	end, {
		v15,
		v11.isOverlayVisible
	})
	local v17 = React.useCallback(function() -- line: 35
		-- upvalues: v16 (copy), trySaveAvatar (copy), SlotBasedEditorAnalytics (copy)
		if not v16 and trySaveAvatar then
			trySaveAvatar()
			SlotBasedEditorAnalytics.trackSaveClick()
		end
	end, {
		v16,
		trySaveAvatar
	})

	return {
		disabled = v16,
		onActivated = v17
	}
end

return useSaveButtonProps
