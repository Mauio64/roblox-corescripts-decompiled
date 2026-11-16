local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")
local icon = Foundation.Icon
local useTokens = Foundation.Hooks.useTokens
local iconSize = Foundation.Enums.IconSize

local function ItemCardIcon(props)
	local v5 = useTokens()
	return React.createElement(icon, {
		name = props.icon,
		style = props.iconStyle or v5.Color.Content.Emphasis,
		size = iconSize.Small,
		LayoutOrder = props.LayoutOrder,
		testId = `icon-{props.icon}`
	})
end

if require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags").FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardIcon))
end

return ItemCardIcon
