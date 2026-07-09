local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals

local function selectScreenSize(p1) -- line: 24
	return p1.ScreenSize
end
local function CollectiblesInfoPrompt(t1: {[any]: any}) -- line: 28
	-- upvalues: useSelector (copy), selectScreenSize (copy), getUseSelectorDeepEquals (copy), React (copy), NavigationUtils (copy), useLocalization (copy), InteractiveAlert (copy), ButtonType (copy)
	local v16 = useSelector(selectScreenSize, getUseSelectorDeepEquals())
	local v17 = React.useCallback(function() -- line: 31
		-- upvalues: NavigationUtils (copy), t1 (copy)
		NavigationUtils.closeOverlay(t1.navigation)
	end, { t1.navigation })
	local v18 = useLocalization({
		titleText = "Feature.Catalog.Label.NewCollectibles",
		bodyText = "Feature.Catalog.Message.CollectiblesInfo",
		okButtonText = "CommonUI.Messages.Action.OK"
	})

	return React.createElement(InteractiveAlert, {
		title = v18.titleText,
		bodyText = v18.bodyText,
		buttonStackInfo = {
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = v17,
					text = v18.okButtonText
				}
			}}
		},
		screenSize = v16
	})
end

return withOverlayFocusHandling(CollectiblesInfoPrompt)
