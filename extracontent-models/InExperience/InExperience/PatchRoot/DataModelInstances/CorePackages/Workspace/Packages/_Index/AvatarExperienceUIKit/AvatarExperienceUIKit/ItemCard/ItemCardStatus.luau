local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function ItemCardStatus(t1: {[any]: any}) -- line: 13
	-- upvalues: useTokens (copy), React (copy), FoundationText (copy)
	local v8 = useTokens()

	return React.createElement(FoundationText, {
		textStyle = v8.Inverse.Content.Emphasis,
		fontStyle = v8.Typography.LabelSmall,
		LayoutOrder = t1.LayoutOrder,
		Text = t1.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		backgroundStyle = v8.Color.System.Contrast,
		padding = v8.Padding.Small,
		cornerRadius = UDim.new(0.5, 0)
	})
end

return ItemCardStatus
