local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)

require(script.Parent.Parent.Shared.BaseDialog)

local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError

local function useDuplicateOutfitNameDialogProps() -- line: 19
	-- upvalues: useNavigation (copy), useDispatch (copy), Constants (copy), mutedError (copy), AvatarScreen (copy), useLocalization (copy), React (copy), NavigateWithLock (copy), NavigationUtils (copy)
	local v13 = useNavigation()
	local v14 = useDispatch()
	local u15 = v13.getParam("outfitType")

	if not u15 then
		u15 = Constants.OutfitTypes.Avatar
		mutedError("outfitType is required")
	end

	local u16 = v13.getParam("outfitName")

	if not u16 then
		u16 = ""
		mutedError("outfitName is required")
	end

	local u17 = v13.getParam("onComplete")

	if not u17 then
		function u17(_, _) -- line: 34
		end

		mutedError("onComplete is required")
	end

	local u18 = v13.getParam("backScreen")

	if not u18 then
		u18 = AvatarScreen.AddOutfitDialog
		mutedError("backScreen is required")
	end

	local v19 = useLocalization({
		title = "Feature.Avatar.Heading.UsedName",
		body = "Feature.Avatar.Label.UsedNameLong",
		confirm = "Feature.Avatar.Action.Save",
		cancel = "Feature.Avatar.Label.Back"
	})
	local v20 = React.useCallback(function() -- line: 50
		-- upvalues: v14 (copy), NavigateWithLock (copy), NavigationUtils (copy), v13 (copy), u18 (ref), u15 (ref), u16 (ref), u17 (ref)
		v14(NavigateWithLock(function() -- line: 51
			-- upvalues: NavigationUtils (copy), v13 (copy), u18 (ref), u15 (ref), u16 (ref), u17 (ref)
			NavigationUtils.navigateToNextOverlay(v13, u18, {
				outfitType = u15,
				defaultName = u16,
				onComplete = u17
			})
		end))
	end, {
		v13,
		u15,
		u16,
		u17,
		u18,
		v14
	})
	local v21 = React.useCallback(function() -- line: 60
		-- upvalues: NavigationUtils (copy), v13 (copy)
		NavigationUtils.closeOverlay(v13)
	end, { v13 })
	local v22 = React.useCallback(function() -- line: 64
		-- upvalues: u17 (ref), u16 (ref), v21 (copy)
		u17(u16, v21)
	end, {
		u17,
		u16,
		v21
	})

	return {
		titleText = v19.title,
		bodyText = v19.body,
		confirmButtonText = v19.confirm,
		cancelButtonText = v19.cancel,
		onConfirm = v22,
		onClose = v20
	}
end

return useDuplicateOutfitNameDialogProps
