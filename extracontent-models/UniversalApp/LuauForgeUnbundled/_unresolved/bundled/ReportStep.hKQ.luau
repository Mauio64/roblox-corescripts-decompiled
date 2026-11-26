local module = require("@luauforge/bundled/hKp")
local normalizeFontFace = require("@luauforge/bundled/hKK").Utility.normalizeFontFace
local module2 = require("@luauforge/bundled/hKL")
require("@luauforge/bundled/hKz")
local module3 = require("@luauforge/bundled/hKH")

local module4 = require("@luauforge/bundled/hKR")

local udim = UDim2.fromScale(1, 1)
local udim2 = UDim.new(0, 10)

local function ReportStep(props)
	local v5 = module3()
	local reportStep = v5.ReportStep
	local size = reportStep.size and reportStep.size or udim
	local verticalPadding = reportStep.verticalPadding or udim2
	local udim3 = UDim.new(
		(v5.ReportActionBar.size and v5.ReportActionBar.size.Y.Scale or 0) + 2 * verticalPadding.Scale,
		(v5.ReportActionBar.size and v5.ReportActionBar.size.Y.Offset or 0) + 2 * verticalPadding.Offset
	)

	local createElement = module.createElement

	local children = {
		Layout = module.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = verticalPadding,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Title = 0,
		Body = 0,
		Actions = 0
	}
	local v8

	if props.title then
		local createElement2 = module.createElement
		local v10 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			Text = props.title,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			TextSize = 0,
			LineHeight = 0,
			LayoutOrder = 1
		}

		local v11 = if not module2 then reportStep.headerFontStyle and reportStep.headerFontStyle.Font else nil
		v10.Font = v11

		local v12 = if module2 and reportStep.headerFontStyle then normalizeFontFace(reportStep.headerFontStyle.Font) else nil
		v10.FontFace = v12

		v10.TextColor3 = reportStep.headerTextColor and reportStep.headerTextColor.Color3
		v10.TextSize = reportStep.headerFontStyle and reportStep.headerFontStyle.FontSize
		v10.LineHeight = reportStep.headerFontStyle and reportStep.headerFontStyle.LineHeight
		v8 = createElement2("TextLabel", v10) or nil
	end

	children.Title = v8

	children.Body = module.createElement("Frame", {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 1 - udim3.Scale, -udim3.Offset),
		BackgroundTransparency = 1
	}, props.children)

	children.Actions = module.createElement(module4, {
		layoutOrder = 3,
		buttons = props.buttons,
		tokens = v5.ReportActionBar
	})
	return createElement("Frame", { Size = size, BackgroundTransparency = 1 }, children)
end

return ReportStep
