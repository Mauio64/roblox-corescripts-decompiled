local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(script.Parent.Parent.Shared.BaseDialogWithTextbox)

local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useCheckDuplicateOutfitName = require(Modules.AvatarExperience.OutfitSwitcher.Hooks.useCheckDuplicateOutfitName)
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local t1 = {
	[Constants.OutfitTypes.Avatar] = {
		title = "Feature.Avatar.Label.Title.AvatarName",
		add = "Feature.Avatar.Label.Add",
		cancel = "Feature.Avatar.Action.Cancel",
		nameInvalid = "Feature.Avatar.Label.CostumeWarning"
	},
	[Constants.OutfitTypes.Makeup] = {
		title = "Feature.Avatar.Title.SaveMakeupLook",
		add = "Feature.Avatar.Label.Add",
		cancel = "Feature.Avatar.Action.Cancel",
		nameInvalid = "Feature.Avatar.Label.CostumeWarning"
	}
}

local function useAddOutfitDialogProps() -- line: 31
	-- upvalues: useNavigation (copy), Constants (copy), mutedError (copy), useLocalization (copy), t1 (copy), React (copy), NavigationUtils (copy), useCheckDuplicateOutfitName (copy), AvatarScreen (copy)
	local v13 = useNavigation()
	local v14 = v13.getParam("outfitType")

	if not v14 then
		v14 = Constants.OutfitTypes.Avatar
		mutedError("outfitType is missing")
	end

	local u15 = v13.getParam("onComplete")

	if not u15 then
		function u15(_, _) -- line: 42
		end

		mutedError("onComplete is missing")
	end

	local v16 = v13.getParam("defaultName")
	local v17 = useLocalization(t1[v14])
	local v18 = React.useCallback(function() -- line: 49
		-- upvalues: NavigationUtils (copy), v13 (copy)
		NavigationUtils.closeOverlay(v13)
	end, { v13 })
	local v19 = useCheckDuplicateOutfitName(v14, AvatarScreen.AddOutfitDialog)
	local v20 = React.useCallback(function(s1: string) -- line: 55
		-- upvalues: v19 (copy), u15 (ref), v18 (copy)
		if not v19(s1, u15) then
			u15(s1, v18)
		end
	end, {
		u15,
		v19,
		v18
	})
	local v21 = React.useCallback(function(p3) -- line: 61
		-- upvalues: v17 (copy)
		if not string.match(p3, "%S") then
			return false, nil
		end

		if not string.match(p3, "^[0-9a-zA-Z%s]+$") then
			return false, v17.nameInvalid
		end

		return true, nil
	end, { v17.nameInvalid })

	return {
		titleText = v17.title,
		confirmButtonText = v17.add,
		cancelButtonText = v17.cancel,
		onClose = v18,
		onConfirm = v20,
		defaultText = v16,
		isTextValid = v21
	}
end

return useAddOutfitDialogProps
