local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function ItemCardStatus(p)
	local v = useTokens()
	return React.createElement(Text, {
		textStyle = v.Inverse.Content.Emphasis,
		fontStyle = v.Typography.LabelSmall,
		LayoutOrder = p.LayoutOrder,
		Text = p.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		backgroundStyle = v.Color.System.Contrast,
		padding = v.Padding.Small,
		cornerRadius = UDim.new(0.5, 0)
	})
end

return ItemCardStatus
