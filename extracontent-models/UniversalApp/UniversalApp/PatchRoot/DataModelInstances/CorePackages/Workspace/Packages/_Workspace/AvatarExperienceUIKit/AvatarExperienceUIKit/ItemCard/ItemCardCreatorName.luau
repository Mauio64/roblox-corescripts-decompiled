local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local VerifiedBadges = require(Parent.VerifiedBadges)
local FFlagAXAddTextXAlignmentProp = require(Parent.AvatarExperienceFlags).FFlagAXAddTextXAlignmentProp

local function ItemCardCreatorName(t1: {[any]: any}) -- line: 19
	-- upvalues: useTokens (copy), React (copy), FoundationText (copy), VerifiedBadges (copy), FFlagAXAddTextXAlignmentProp (copy)
	local v10 = useTokens()

	return React.createElement(FoundationText, {
		textStyle = v10.Color.Content.Default,
		fontStyle = v10.Typography.BodyMedium,
		LayoutOrder = t1.LayoutOrder,
		Text = if not t1.hasVerifiedBadge then t1.name else `{ t1.name }{ VerifiedBadges.emoji.verified }`,
		TextXAlignment = if not FFlagAXAddTextXAlignmentProp or not t1.TextXAlignment then Enum.TextXAlignment.Left else t1.TextXAlignment,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextTruncate = Enum.TextTruncate.SplitWord
	})
end

if require(Parent.AvatarExperienceFlags).FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardCreatorName))
end

return ItemCardCreatorName
