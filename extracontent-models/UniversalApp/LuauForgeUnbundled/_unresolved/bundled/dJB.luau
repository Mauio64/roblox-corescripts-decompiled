local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/bundled/dJa")
local UIBlox = require("@game/CorePackages/Workspace/Packages/UIBlox")
local module3 = require("@luauforge/bundled/dJC")

local screenSizeSelector = require("@luauforge/bundled/dJD").screenSizeSelector
local getMiddleContentWidth = require("@luauforge/bundled/dJD").getMiddleContentWidth
local getAdjustedTitleToScreenString = require("@luauforge/bundled/dJD").getAdjustedTitleToScreenString
local DEFAULT_PADDING = require("@luauforge/bundled/dJE").DEFAULT_PADDING

local useSelector = module3.Hooks.RoactRodux.useSelector
local withStyle = UIBlox.Core.Style.withStyle
local fullPageModal = UIBlox.App.Dialog.Modal.FullPageModal

return function(data)
	local v5 = useSelector(screenSizeSelector)
	local middleContentWidth = getMiddleContentWidth(v5.X)
	local y = UserInputService.StatusBarSize.Y

	local buttonConfig = data.buttonConfig
	local makeBodyFragment = data.makeBodyFragment
	local footerContent = data.footerContent
	local v6 = not data.hideCloseButton
	local title = data.title

	return withStyle(function(p2)
		local adjustedTitleToScreenString = getAdjustedTitleToScreenString(title, middleContentWidth, p2)
		return module.createElement(fullPageModal, {
			title = adjustedTitleToScreenString,
			screenSize = v5,
			buttonStackProps = buttonConfig,
			onCloseClicked = v6 and data.closeModal,
			distanceFromTop = y,
			footerContent = footerContent
		}, {
			Middle = module.createElement(
				"Frame",
				{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
				{
					ContentPadding = module.createElement("UIPadding", {
						PaddingBottom = buttonConfig and UDim.new(0, DEFAULT_PADDING),
						PaddingTop = UDim.new(0, DEFAULT_PADDING)
					}),
					ListLayout = module.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, DEFAULT_PADDING),
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					BodyFragment = makeBodyFragment(middleContentWidth)
				}
			)
		})
	end)
end
