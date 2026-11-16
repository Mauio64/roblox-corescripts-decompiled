local module = require("@luauforge/bundled/hyZ")
local normalizeFontFace = require("@luauforge/bundled/hzu").Utility.normalizeFontFace
local module2 = require("@luauforge/bundled/hzv")
require("@luauforge/bundled/hzj")
local module3 = require("@luauforge/bundled/hzr")

local udim = UDim2.new(1, 0, 1, 0)

local function ReportHeader(props)
	local reportHeader = module3().ReportHeader

	local size = reportHeader.size or udim
	local dividerVerticalPadding = reportHeader.dividerVerticalPadding or 36
	local dividerHeight = reportHeader.dividerHeight or 2

	local createElement = module.createElement
	local v6 = {
		Size = size,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder
	}
	local v7 = {
		Layout = module.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		UIPadding = 0,
		Title = 0,
		Subtitle = 0,
		Decoration = 0
	}

	local v8 = if reportHeader.verticalPadding then module.createElement("UIPadding", {
		PaddingTop = UDim.new(0, reportHeader.verticalPadding),
		PaddingBottom = UDim.new(0, reportHeader.verticalPadding)
	}) else nil
	v7.UIPadding = v8

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

	local v11 = if not module2 then reportHeader.titleFontStyle and reportHeader.titleFontStyle.Font else nil
	v10.Font = v11

	local v12 = if module2 and reportHeader.titleFontStyle then normalizeFontFace(reportHeader.titleFontStyle.Font) else nil
	v10.FontFace = v12

	v10.TextColor3 = reportHeader.titleTextColor and reportHeader.titleTextColor.Color3
	v10.TextSize = reportHeader.titleFontStyle and reportHeader.titleFontStyle.FontSize
	v10.LineHeight = reportHeader.titleFontStyle and reportHeader.titleFontStyle.LineHeight
	v7.Title = createElement2("TextLabel", v10)
	local v13

	if props.subtitle then
		local createElement3 = module.createElement
		local v15 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			Text = props.subtitle,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			TextSize = 0,
			LineHeight = 0,
			LayoutOrder = 2
		}

		local v16 = if not module2 then reportHeader.subtitleFontStyle and reportHeader.subtitleFontStyle.Font else nil
		v15.Font = v16

		local v17 = if module2 and reportHeader.subtitleFontStyle then normalizeFontFace(reportHeader.subtitleFontStyle.Font) else nil
		v15.FontFace = v17

		v15.TextColor3 = reportHeader.subtitleTextColor and reportHeader.subtitleTextColor.Color3
		v15.TextSize = reportHeader.subtitleFontStyle and reportHeader.subtitleFontStyle.FontSize
		v15.LineHeight = reportHeader.subtitleFontStyle and reportHeader.subtitleFontStyle.LineHeight
		v13 = createElement3("TextLabel", v15)
	end

	v7.Subtitle = v13

	local v14 = if props.hasDivider then module.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, dividerVerticalPadding),
			BackgroundTransparency = 1,
			LayoutOrder = 3
		},
		{
			Divider = module.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, dividerHeight),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundColor3 = reportHeader.dividerColor and reportHeader.dividerColor.Color3,
				BackgroundTransparency = reportHeader.dividerColor and reportHeader.dividerColor.Transparency or 0.8
			})
		}
	) else nil
	v7.Decoration = v14
	return createElement("Frame", v6, v7)
end

return ReportHeader
