local module = require("@luauforge/bundled/ggX")
local module2 = require("@luauforge/bundled/gjJ")

local view = module2.View
local text = module2.Text
local divider = module2.Divider
local orientation = module2.Enums.Orientation

local function LoginV2OrDivider(p2)
	return module.createElement(
		view,
		{
			LayoutOrder = p2.layoutOrder,
			tag = "row align-y-center gap-medium size-full-0 auto-y"
		},
		{
			LeftLine = module.createElement(view, {
				LayoutOrder = 1,
				tag = "grow auto-y"
			}, {
				Line = module.createElement(divider, {
					orientation = orientation.Horizontal
				})
			}),
			OrText = module.createElement(text, {
				LayoutOrder = 2,
				Text = p2.orText,
				tag = "auto-xy text-caption-small content-muted"
			}),
			RightLine = module.createElement(view, {
				LayoutOrder = 3,
				tag = "grow auto-y"
			}, {
				Line = module.createElement(divider, {
					orientation = orientation.Horizontal
				})
			})
		}
	)
end

return LoginV2OrDivider
