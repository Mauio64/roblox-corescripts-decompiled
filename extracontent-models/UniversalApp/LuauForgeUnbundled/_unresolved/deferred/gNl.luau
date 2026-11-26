local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local buttonType = UIBlox.App.Button.Enum.ButtonType
local overlay = UIBlox.App.Dialog.Overlay
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useScreenSize = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useScreenSize
local module = require("@luauforge/deferred/gJI")

local module2 = require("@luauforge/deferred/gJH")
local module3 = require("@luauforge/bundled/dXh")
local module4 = require("@luauforge/bundled/gxM")
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local v5 = {
	ResetSearch = "Feature.Catalog.Heading.DescriptionLinkResetSearch",
	GoToMarketplace = "Feature.Catalog.Heading.DescriptionLinkGoToMarketplace"
}

local function DescriptionLinkSearchPrompt(props)
	local v6 = module4({
		title = v5[props.kind],
		cancel = "CommonUI.Controls.Action.Cancel",
		continue = "CommonUI.Controls.Action.Continue"
	})

	local v7 = useScreenSize()

	return React.createElement(
		focusable.Frame,
		{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 100 },
		{
			Overlay = React.createElement(overlay, { ZIndex = -1, showGradient = false }),
			InteractiveAlert = React.createElement(interactiveAlert, {
				title = v6.title,
				buttonStackInfo = {
					buttons = {
						{
							props = {
								onActivated = function()
									module3.closeOverlay(props.navigation)
								end,
								text = v6.cancel
							},
							isDefaultChild = true
						},
						{
							buttonType = buttonType.PrimarySystem,
							props = {
								onActivated = function()
									module3.closeOverlay(props.navigation)
									props.onConfirm()
								end,
								text = v6.continue
							},
							isDefaultChild = false
						}
					}
				},
				position = UDim2.fromScale(0.5, 0.5),
				screenSize = v7,
				defaultChildRef = props.defaultChildRef
			})
		}
	)
end

return (module2((module(DescriptionLinkSearchPrompt))))
