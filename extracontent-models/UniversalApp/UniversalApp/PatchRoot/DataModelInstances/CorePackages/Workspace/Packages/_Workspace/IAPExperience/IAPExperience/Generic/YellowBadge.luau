local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local FoundationImage = Foundation.Image
local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: useTokens (copy), React (copy), View (copy), FoundationImage (copy), FoundationText (copy)
	local Emphasis = useTokens().LightMode.Content.Emphasis
	local color3 = Color3.fromRGB(239, 215, 140)

	return React.createElement(View, {
		tag = "radius-circle padding-small row gap-xsmall align-y-center align-x-center auto-xy",
		LayoutOrder = t1.LayoutOrder,
		backgroundStyle = {
			Transparency = 0,
			Color3 = color3
		}
	}, {
		Icon = if not t1.Icon then nil else React.createElement(FoundationImage, {
			LayoutOrder = 1,
			tag = "size-300",
			Image = t1.Icon,
			imageStyle = Emphasis
		}),
		Text = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "text-caption-small content-emphasis text-align-x-center auto-xy",
			Text = t1.Text,
			textStyle = Emphasis
		})
	})
end
