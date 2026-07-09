local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local FFlagAXAddTextXAlignmentProp = require(Parent.AvatarExperienceFlags).FFlagAXAddTextXAlignmentProp
local FFlagAXRootSlotBasedEditorFlag = require(Parent.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag

local function ItemCardTitle(t1: {[any]: any}) -- line: 20
	-- upvalues: useTokens (copy), React (copy), FoundationText (copy), FFlagAXRootSlotBasedEditorFlag (copy), FFlagAXAddTextXAlignmentProp (copy)
	local v10 = useTokens()

	return React.createElement(FoundationText, {
		textStyle = v10.Color.Content.Emphasis,
		fontStyle = if not FFlagAXRootSlotBasedEditorFlag or not t1.titleTextSize then v10.Typography.TitleMedium else t1.titleTextSize,
		LayoutOrder = t1.LayoutOrder,
		Text = t1.title,
		TextXAlignment = if not FFlagAXAddTextXAlignmentProp or not t1.TextXAlignment then Enum.TextXAlignment.Left else t1.TextXAlignment,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextTruncate = Enum.TextTruncate.SplitWord
	})
end

if require(Parent.AvatarExperienceFlags).FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardTitle))
end

return ItemCardTitle
