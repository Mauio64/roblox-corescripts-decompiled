local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)

local function selectScreenSize(p1) -- line: 20
	return p1.ScreenSize
end
local function LooksConfirmationPrompt(t1: {[any]: any}) -- line: 24
	-- upvalues: useNavigation (copy), useSelector (copy), selectScreenSize (copy), useLocalization (copy), React (copy), NavigationUtils (copy), InteractiveAlert (copy), ButtonType (copy)
	local v16 = useNavigation()
	local v17 = useSelector(selectScreenSize)
	local v18 = useLocalization({
		confirmationModalTitle = "Feature.Avatar.Title.UnsavedChanges",
		confirmationModalDescription = "Feature.Avatar.Message.LeavingComposerWithoutSave",
		confirmationModalLeftButton = "Feature.Avatar.Action.Stay",
		confirmationModalRightButton = "Feature.Avatar.Action.Leave"
	})
	local v19 = React.useCallback(function() -- line: 35
		-- upvalues: NavigationUtils (copy), v16 (copy)
		NavigationUtils.closeFocusedScreen(v16)
	end, { v16 })

	return React.createElement(InteractiveAlert, {
		title = v18.confirmationModalTitle,
		bodyText = v18.confirmationModalDescription,
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = v19,
						text = v18.confirmationModalLeftButton
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = t1.onOverlayClosed,
						text = v18.confirmationModalRightButton
					}
				}
			}
		},
		screenSize = v17
	})
end

return (require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)((withOverlayFocusHandling(LooksConfirmationPrompt))))
