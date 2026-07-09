local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals

local function GenericPrompt(t1: {[any]: any}) -- line: 28
	-- upvalues: useSelector (copy), getUseSelectorDeepEquals (copy), React (copy), NavigationUtils (copy), InteractiveAlert (copy), ButtonType (copy)
	local v13 = useSelector(function(p1) -- line: 29
		return p1.ScreenSize
	end, getUseSelectorDeepEquals())
	local v14 = React.useCallback(function() -- line: 33
		-- upvalues: NavigationUtils (copy), t1 (copy)
		NavigationUtils.closeOverlay(t1.navigation)
	end, { t1.navigation })

	return React.createElement(InteractiveAlert, {
		title = t1.navigation.state.params.titleText,
		bodyText = t1.navigation.state.params.bodyText,
		buttonStackInfo = {
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = v14,
					text = t1.navigation.state.params.buttonText
				}
			}}
		},
		screenSize = v13
	})
end

return withOverlayFocusHandling(GenericPrompt)
