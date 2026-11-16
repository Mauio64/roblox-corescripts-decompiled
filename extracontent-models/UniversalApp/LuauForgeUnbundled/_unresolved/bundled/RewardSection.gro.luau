local module = require("@luauforge/bundled/grg")
local module2 = require("@luauforge/bundled/gri")
local view = module2.View
local text = module2.Text

local module3 = require("@luauforge/bundled/grp")

local function RewardSection(props)
	return module.createElement(
		view,
		{ tag = "col gap-xlarge size-full-0 auto-y", LayoutOrder = props.layoutOrder },
		{
			YouGet = module.createElement(
				view,
				{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = 1 },
				{
					Header = module.createElement(text, {
						tag = "auto-xy text-title-large text-align-x-left content-emphasis",
						Text = props.youGet.label,
						LayoutOrder = 1
					}),
					Reward = module.createElement(module3, {
						iconName = props.youGet.iconName,
						title = props.youGet.title,
						description = props.youGet.description,
						layoutOrder = 2
					})
				}
			),
			TheyGet = module.createElement(
				view,
				{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = 2 },
				{
					Header = module.createElement(text, {
						tag = "auto-xy text-title-large text-align-x-left content-emphasis",
						Text = props.theyGet.label,
						LayoutOrder = 1
					}),
					Reward = module.createElement(module3, {
						iconName = props.theyGet.iconName,
						title = props.theyGet.title,
						description = props.theyGet.description,
						layoutOrder = 2
					})
				}
			)
		}
	)
end

return RewardSection
