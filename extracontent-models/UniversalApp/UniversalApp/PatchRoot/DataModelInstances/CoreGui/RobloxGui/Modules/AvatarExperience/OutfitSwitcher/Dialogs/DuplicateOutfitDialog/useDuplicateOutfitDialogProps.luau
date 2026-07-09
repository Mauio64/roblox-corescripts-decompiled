local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
require(script.Parent.Parent.Shared.BaseDialog)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useOnAddOutfit = require(Modules.AvatarExperience.OutfitSwitcher.Hooks.useOnAddOutfit)
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError

local function useDuplicateOutfitDialogProps() -- line: 20
	-- upvalues: useNavigation (copy), Constants (copy), mutedError (copy), useLocalization (copy), React (copy), NavigationUtils (copy), useOnAddOutfit (copy)
	local v11 = useNavigation()
	local v12 = v11.getParam("outfitType")

	if not v12 then
		v12 = Constants.OutfitTypes.Avatar
		mutedError("outfitType is required")
	end

	local v13 = v11.getParam("duplicateOutfitName")

	if not v13 then
		v13 = ""
		mutedError("duplicateOutfitName is required")
	end

	local u14 = v11.getParam("saveAsNew")

	if u14 == nil then
		u14 = true
		mutedError("saveAsNew is required")
	end

	local v15 = v11.getParam("onOverlayClosed")

	if not v15 then
		function v15() -- line: 39
		end

		mutedError("onOverlayClosed is required")
	end

	local v16 = useLocalization({
		cancel = "Feature.Avatar.Action.Cancel",
		title = v12 ~= Constants.OutfitTypes.Avatar and "Feature.Avatar.Title.DuplicateMakeupLook" or "Feature.Avatar.Label.Title.DuplicateAvatar",
		subtitle = if v12 ~= Constants.OutfitTypes.Avatar then {
			"Feature.Avatar.Label.DuplicateMakeupLookDialog",
			lookName = v13
		} else {
			"Feature.Avatar.Message.AddAvatarAgain",
			prevAvatar = v13
		},
		add = not u14 and "Feature.Avatar.Label.Replace" or "Feature.Avatar.Label.Add"
	})
	local v17 = React.useCallback(function() -- line: 54
		-- upvalues: NavigationUtils (copy), v11 (copy)
		NavigationUtils.closeOverlay(v11)
	end, { v11 })
	local v18 = useOnAddOutfit(v11, v12, v15, true)
	local v19 = React.useCallback(function() -- line: 60
		-- upvalues: u14 (ref), v18 (copy)
		if u14 then
			v18()

			return
		end

		v18()
	end, {
		v18,
		u14
	})

	return {
		titleText = v16.title,
		bodyText = v16.subtitle,
		cancelButtonText = v16.cancel,
		confirmButtonText = v16.add,
		onClose = v17,
		onConfirm = v19
	}
end

return useDuplicateOutfitDialogProps
