local module = require("@luauforge/bundled/gVG")
local module2 = require("@luauforge/bundled/gVI")
local view = module2.View
local text = module2.Text
local icon = module2.Icon
local iconName = module2.Enums.IconName
local iconSize = module2.Enums.IconSize

local module3 = require("@luauforge/bundled/gVL")
local module4 = require("@luauforge/bundled/gVM")

local function HeroTitleSection(props)
	local v5 = { Font = module3.BUILDER_EXTENDED_BOLD }

	return module.createElement(
		view,
		{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = props.layoutOrder },
		{
			Illustration = module.createElement(module4, { layoutOrder = 1 }),
			TitleSection = module.createElement(
				view,
				{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 2 },
				{
					TitleRow = module.createElement(
						view,
						{
							tag = "row wrap align-y-center gap-xsmall size-full-0 auto-y",
							LayoutOrder = 1
						},
						{
							Prefix = module.createElement(text, {
								tag = "auto-xy text-heading-large text-align-x-left content-emphasis",
								Text = props.titlePrefix,
								fontStyle = v5,
								LayoutOrder = 1
							}),
							RobuxIcon = module.createElement(icon, {
								name = iconName.Robux,
								size = iconSize.Large,
								LayoutOrder = 2
							}),
							Amount = module.createElement(text, {
								tag = "auto-xy text-heading-large text-align-x-left content-emphasis",
								Text = props.titleAmount,
								fontStyle = v5,
								LayoutOrder = 3
							})
						}
					),
					Description = module.createElement(text, {
						tag = "auto-xy text-body-medium text-wrap text-align-x-left content-emphasis",
						Text = props.description,
						LayoutOrder = 2
					})
				}
			)
		}
	)
end

return HeroTitleSection
