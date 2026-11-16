local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local buttonType = UIBlox.App.Button.Enum.ButtonType
local overlay = UIBlox.App.Dialog.Overlay
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useScreenSize = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useScreenSize
local module = require("@luauforge/deferred/gfc")

local module2 = require("@luauforge/deferred/gfb")
local module3 = require("@luauforge/bundled/dTM")
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local function AccessoryAdjustmentResetPrompt(props)
	local v5 = useLocalization({
		title = "Feature.Avatar.Title.ResetToDefault",
		cancel = "Feature.Avatar.Action.Cancel",
		reset = "Feature.Avatar.Action.Reset",
		bodyText = "Feature.Avatar.Message.ResetAdjustment"
	})

	local v6 = useScreenSize()

	return React.createElement(
		focusable.Frame,
		{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 100 },
		{
			Overlay = React.createElement(overlay, { ZIndex = -1, showGradient = false }),
			InteractiveAlert = React.createElement(interactiveAlert, {
				title = v5.title,
				bodyText = v5.bodyText,
				buttonStackInfo = {
					buttons = {
						{
							props = {
								onActivated = function()
									module3.closeOverlay(props.navigation)
								end,
								text = v5.cancel
							},
							isDefaultChild = true
						},
						{
							buttonType = buttonType.PrimarySystem,
							props = {
								onActivated = function()
									props.resetCallback()
									module3.closeOverlay(props.navigation)
								end,
								text = v5.reset
							},
							isDefaultChild = false
						}
					}
				},
				position = UDim2.fromScale(0.5, 0.5),
				screenSize = v6,
				defaultChildRef = props.defaultChildRef
			})
		}
	)
end

return (module2((module(AccessoryAdjustmentResetPrompt))))
