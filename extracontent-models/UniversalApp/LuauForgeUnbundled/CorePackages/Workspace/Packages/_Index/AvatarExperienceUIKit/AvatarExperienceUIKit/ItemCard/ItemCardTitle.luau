local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local fFlagAXAddTextXAlignmentProp = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags").FFlagAXAddTextXAlignmentProp

local function ItemCardTitle(props)
	local v5 = useTokens()
	local createElement = React.createElement
	local v7 = {
		textStyle = v5.Color.Content.Emphasis,
		fontStyle = 0,
		LayoutOrder = 0,
		Text = 0,
		TextXAlignment = 0,
		Size = 0,
		AutomaticSize = 0,
		TextTruncate = 0
	}
	local v8 = if props.titleTextSize then props.titleTextSize else v5.Typography.TitleMedium
	v7.fontStyle = v8
	v7.LayoutOrder = props.LayoutOrder
	v7.Text = props.title
	local v9 = if fFlagAXAddTextXAlignmentProp and props.TextXAlignment then props.TextXAlignment else Enum.TextXAlignment.Left
	v7.TextXAlignment = v9

	v7.Size = UDim2.fromScale(1, 0)
	v7.AutomaticSize = Enum.AutomaticSize.Y
	v7.TextTruncate = Enum.TextTruncate.SplitWord
	return createElement(text, v7)
end

if require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags").FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardTitle))
end

return ItemCardTitle
