local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals

local function ResaleFeePolicyPrompt(t1: {[any]: any}) -- line: 23
	-- upvalues: useSelector (copy), getUseSelectorDeepEquals (copy), React (copy), NavigationUtils (copy), useLocalization (copy), InteractiveAlert (copy), ButtonType (copy)
	local v14 = useSelector(function(p1) -- line: 24
		return p1.ScreenSize
	end, getUseSelectorDeepEquals())
	local v15 = React.useCallback(function() -- line: 28
		-- upvalues: NavigationUtils (copy), t1 (copy)
		NavigationUtils.closeOverlay(t1.navigation)
	end, { t1.navigation })
	local v16 = useLocalization({
		titleText = "Feature.Catalog.Label.ResaleFeePolicy",
		bodyText = "Feature.Catalog.Message.ResaleFeePolicy",
		gotItButtonText = "Feature.Avatar.Action.GotIt"
	})
	local v17 = v16.bodyText:gsub("({yourSharePercent})", t1.navigation.state.params.yourSharePercent):gsub("({robloxFeePercent})", t1.navigation.state.params.robloxFeePercent)

	return React.createElement(InteractiveAlert, {
		title = v16.titleText,
		bodyText = v17,
		buttonStackInfo = {
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = v15,
					text = v16.gotItButtonText
				}
			}}
		},
		screenSize = v14
	})
end

return withOverlayFocusHandling(ResaleFeePolicyPrompt)
