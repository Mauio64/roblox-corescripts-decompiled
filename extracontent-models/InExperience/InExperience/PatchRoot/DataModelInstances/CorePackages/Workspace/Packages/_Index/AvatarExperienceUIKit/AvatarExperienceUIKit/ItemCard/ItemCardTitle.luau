local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXAddTextXAlignmentProp = AvatarExperienceFlags.FFlagAXAddTextXAlignmentProp
local AvatarExperienceFlags2 = require(parent.AvatarExperienceFlags)

local function ItemCardTitle(props)
	local v = useTokens()
	local createElement = React.createElement
	local v2 = {
		textStyle = v.Color.Content.Emphasis,
		fontStyle = 0,
		LayoutOrder = 0,
		Text = 0,
		TextXAlignment = 0,
		Size = 0,
		AutomaticSize = 0,
		TextTruncate = 0
	}
	local fontStyle

	if props.titleTextSize then
		fontStyle = props.titleTextSize
	else
		fontStyle = v.Typography.TitleMedium
	end

	v2.fontStyle = fontStyle
	v2.LayoutOrder = props.LayoutOrder
	v2.Text = props.title
	local textXAlignment

	if FFlagAXAddTextXAlignmentProp and props.TextXAlignment then
		textXAlignment = props.TextXAlignment
	else
		textXAlignment = Enum.TextXAlignment.Left
	end

	v2.TextXAlignment = textXAlignment

	v2.Size = UDim2.fromScale(1, 0)
	v2.AutomaticSize = Enum.AutomaticSize.Y
	v2.TextTruncate = Enum.TextTruncate.SplitWord
	return createElement(Text, v2)
end

if AvatarExperienceFlags2.FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardTitle))
end

return ItemCardTitle
