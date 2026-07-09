local Parent = script:FindFirstAncestor("WechatQQAuth").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationImage = Foundation.Image
local FoundationText = Foundation.Text

local function WechatQQButton(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), View (copy), FoundationImage (copy), FoundationText (copy)
	return React.createElement(View, {
		tag = "size-full-1200 row align-y-center radius-medium padding-medium",
		LayoutOrder = t1.layoutOrder or 1,
		onActivated = t1.onActivated,
		backgroundStyle = {
			Transparency = 0,
			Color3 = Color3.fromHex(t1.backgroundColor)
		}
	}, {
		IconContainer = React.createElement(View, {
			tag = "row align-x-right align-y-center",
			LayoutOrder = 1,
			Size = UDim2.new(0.4, 0, 1, 0)
		}, {
			ButtonIcon = React.createElement(FoundationImage, {
				tag = "gui-object-defaults size-900-900",
				Image = t1.iconImage
			})
		}),
		TextContainer = React.createElement(View, {
			tag = "row align-x-left align-y-center padding-left-small",
			LayoutOrder = 2,
			Size = UDim2.new(0.6, 0, 1, 0)
		}, {
			ButtonText = React.createElement(FoundationText, {
				tag = "auto-xy text-align-x-left text-align-y-center text-body-large content-action-over-media",
				Text = t1.text
			})
		})
	})
end

return WechatQQButton
