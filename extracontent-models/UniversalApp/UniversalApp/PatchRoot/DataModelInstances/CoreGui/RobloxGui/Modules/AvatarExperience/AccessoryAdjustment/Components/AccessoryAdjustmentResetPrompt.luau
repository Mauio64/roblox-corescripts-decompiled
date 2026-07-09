local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Overlay = UIBlox.App.Dialog.Overlay
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useScreenSize = require(CorePackages.Workspace.Packages.RobloxAppHooks).useScreenSize
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable

local function AccessoryAdjustmentResetPrompt(t1: {[any]: any}) -- line: 32
	-- upvalues: useLocalization (copy), useScreenSize (copy), React (copy), Focusable (copy), Overlay (copy), InteractiveAlert (copy), NavigationUtils (copy), ButtonType (copy)
	local v16 = useLocalization({
		title = "Feature.Avatar.Title.ResetToDefault",
		cancel = "Feature.Avatar.Action.Cancel",
		reset = "Feature.Avatar.Action.Reset",
		bodyText = "Feature.Avatar.Message.ResetAdjustment"
	})
	local v17 = useScreenSize()

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		ZIndex = 100,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		Overlay = React.createElement(Overlay, {
			ZIndex = -1,
			showGradient = false
		}),
		InteractiveAlert = React.createElement(InteractiveAlert, {
			title = v16.title,
			bodyText = v16.bodyText,
			buttonStackInfo = {
				buttons = {
					{
						isDefaultChild = true,
						props = {
							onActivated = function() -- line: 58
								-- upvalues: NavigationUtils (copy), t1 (copy)
								NavigationUtils.closeOverlay(t1.navigation)
							end,
							text = v16.cancel
						}
					},
					{
						isDefaultChild = false,
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = function() -- line: 68
								-- upvalues: t1 (copy), NavigationUtils (copy)
								t1.resetCallback()
								NavigationUtils.closeOverlay(t1.navigation)
							end,
							text = v16.reset
						}
					}
				}
			},
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = v17,
			defaultChildRef = t1.defaultChildRef
		})
	})
end

return (withMappedNavigationParams((withOverlayFocusHandling(AccessoryAdjustmentResetPrompt))))
