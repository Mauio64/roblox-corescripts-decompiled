local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local VerifiedBadges = require(parent.VerifiedBadges)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXAddTextXAlignmentProp = AvatarExperienceFlags.FFlagAXAddTextXAlignmentProp
local AvatarExperienceFlags2 = require(parent.AvatarExperienceFlags)

local function ItemCardCreatorName(props)
	local v = useTokens()
	local createElement = React.createElement
	local v2 = {
		textStyle = v.Color.Content.Default,
		fontStyle = v.Typography.BodyMedium,
		LayoutOrder = props.LayoutOrder,
		Text = 0,
		TextXAlignment = 0,
		Size = 0,
		AutomaticSize = 0,
		TextTruncate = 0
	}
	local text

	if props.hasVerifiedBadge then
		text = `{props.name}{VerifiedBadges.emoji.verified}`
	else
		text = props.name
	end

	v2.Text = text
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
	return (React.memo(ItemCardCreatorName))
end

return ItemCardCreatorName
