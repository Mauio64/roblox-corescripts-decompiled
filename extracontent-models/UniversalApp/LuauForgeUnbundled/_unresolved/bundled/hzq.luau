local module = require("@luauforge/bundled/hyZ")
local module2 = require("@luauforge/bundled/hzb")
local module3 = require("@luauforge/bundled/hzr")

local module4 = require("@luauforge/bundled/hzt")

return module.forwardRef(function(props, p2)
	local v5 = module3()

	local udim = UDim.new(
		not v5.ReportHeader.size and 0 or v5.ReportHeader.size.Y.Scale,
		not v5.ReportHeader.size and 0 or v5.ReportHeader.size.Y.Offset
	)

	return module.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v5.ReportBackground.backgroundColor and v5.ReportBackground.backgroundColor.Color3,
		ref = p2
	}, {
		Gradient = module.createElement("UIGradient", {
			Rotation = v5.ReportBackground.gradientRotation,
			Transparency = v5.ReportBackground.gradientTransparency
		}),
		Layout = module.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Header = module.createElement(module4, {
			title = props.title,
			subtitle = props.subtitle,
			layoutOrder = 1,
			hasDivider = true
		}),
		Body = module.createElement("Frame", {
			Size = UDim2.new(1, 0, 1 - udim.Scale, -udim.Offset),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}, module2.Dictionary.join({
			Layout = props.children and module.createElement(
				"UIListLayout",
				{
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				} or nil
			)
		}, props.children or {}))
	})
end)
