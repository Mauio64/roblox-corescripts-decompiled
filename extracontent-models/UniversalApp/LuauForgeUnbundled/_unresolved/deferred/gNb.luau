local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local overlay = UIBlox.App.Dialog.Overlay
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useScreenSize = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useScreenSize
local module = require("@luauforge/deferred/gJI")

local module2 = require("@luauforge/deferred/gJH")
local module3 = require("@luauforge/bundled/dXh")
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local function AccessoryAdjustmentUnsavedPrompt(props)
	local v5 = useLocalization({
		cancel = "Feature.Avatar.Action.Cancel",
		title = "Feature.Avatar.Title.UnsavedChanges",
		bodyText = "Feature.Avatar.Message.LeaveAccessoryAdjustmentWarning",
		discard = "Feature.Avatar.Action.Discard"
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
									module3.closeOverlay(props.navigation)
									props.exitCallback()
								end,
								text = v5.discard
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

return (module2((module(AccessoryAdjustmentUnsavedPrompt))))
