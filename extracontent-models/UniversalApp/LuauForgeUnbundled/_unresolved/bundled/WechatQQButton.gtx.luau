local module = require("@luauforge/bundled/gtr")
local module2 = require("@luauforge/bundled/gtv")

local view = module2.View
local image = module2.Image
local text = module2.Text

local function WechatQQButton(props)
	return module.createElement(view, {
		tag = "size-full-1200 row align-y-center radius-medium padding-medium",
		LayoutOrder = props.layoutOrder or 1,
		onActivated = props.onActivated,
		backgroundStyle = {
			Color3 = Color3.fromHex(props.backgroundColor),
			Transparency = 0
		}
	}, {
		IconContainer = module.createElement(
			view,
			{
				tag = "row align-x-right align-y-center",
				Size = UDim2.new(0.4, 0, 1, 0),
				LayoutOrder = 1
			},
			{
				ButtonIcon = module.createElement(image, {
					tag = "gui-object-defaults size-900-900",
					Image = props.iconImage
				})
			}
		),
		TextContainer = module.createElement(
			view,
			{
				tag = "row align-x-left align-y-center padding-left-small",
				Size = UDim2.new(0.6, 0, 1, 0),
				LayoutOrder = 2
			},
			{
				ButtonText = module.createElement(text, {
					tag = "auto-xy text-align-x-left text-align-y-center text-body-large content-action-over-media",
					Text = props.text
				})
			}
		)
	})
end

return WechatQQButton
