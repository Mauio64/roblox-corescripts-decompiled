local module = require("@luauforge/bundled/gVG")
local module2 = require("@luauforge/bundled/gVI")
local view = module2.View
local text = module2.Text
local icon = module2.Icon
local iconSize = module2.Enums.IconSize

local udim = UDim2.fromOffset(40, 40)

local function RewardRow(props)
	return module.createElement(
		view,
		{
			tag = "row align-y-center size-full-0 auto-y",
			LayoutOrder = props.layoutOrder
		},
		{
			RewardIcon = module.createElement(
				view,
				{
					tag = "align-x-center align-y-center items-center radius-circle bg-shift-200",
					Size = udim,
					LayoutOrder = 1
				},
				{
					Icon = module.createElement(icon, {
						name = props.iconName,
						size = iconSize.Medium
					})
				}
			),
			TextColumn = module.createElement(
				view,
				{
					tag = "col grow gap-xxsmall auto-y padding-left-small",
					LayoutOrder = 2
				},
				{
					Title = module.createElement(text, {
						tag = "auto-xy text-title-medium text-align-x-left content-emphasis",
						Text = props.title,
						LayoutOrder = 1
					}),
					Description = module.createElement(text, {
						tag = "auto-xy text-body-medium text-wrap text-align-x-left content-muted",
						Text = props.description,
						LayoutOrder = 2
					})
				}
			)
		}
	)
end

return RewardRow
