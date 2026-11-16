local module = require("@luauforge/bundled/hyZ")
local module2 = require("@luauforge/bundled/hzy")
require("@luauforge/bundled/hzj")
local module3 = require("@luauforge/bundled/hzr")

local buttonStack = module2.App.Button.ButtonStack
local buttonType = module2.App.Button.Enum.ButtonType

local udim = UDim2.new(1, 0, 0, 200)

local function ReportActionBar(p2)
	local reportActionBar = module3().ReportActionBar

	local size = reportActionBar.size or udim
	local buttonHeight = reportActionBar.buttonHeight or 48
	local buttonWidth = reportActionBar.buttonWidth or 500
	local udim2 = UDim2.fromOffset(buttonWidth, buttonHeight)

	local v5 = {}

	for k, button in p2.buttons do
		table.insert(v5, {
			buttonType = button.buttonType or buttonType.Secondary,
			props = {
				onActivated = button.onActivated,
				size = udim2,
				text = button.text
			}
		})
	end

	return module.createElement(
		"Frame",
		{ LayoutOrder = p2.layoutOrder, Size = size, BackgroundTransparency = 1 },
		{
			Layout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			ActionButtons = module.createElement(buttonStack, {
				marginBetween = reportActionBar.buttonListHorizontalPadding,
				buttonHeight = buttonHeight,
				buttons = v5
			})
		}
	)
end

return ReportActionBar
