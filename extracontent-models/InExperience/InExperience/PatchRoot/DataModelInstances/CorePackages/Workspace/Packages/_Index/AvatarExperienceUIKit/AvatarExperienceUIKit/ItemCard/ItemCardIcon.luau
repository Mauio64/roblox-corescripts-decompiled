local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Icon = Foundation.Icon
local useTokens = Foundation.Hooks.useTokens
local IconSize = Foundation.Enums.IconSize

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local function ItemCardIcon(props)
	local v = useTokens()
	return React.createElement(Icon, {
		name = props.icon,
		style = props.iconStyle or v.Color.Content.Emphasis,
		size = IconSize.Small,
		LayoutOrder = props.LayoutOrder,
		testId = `icon-{props.icon}`
	})
end

if AvatarExperienceFlags.FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardIcon))
end

return ItemCardIcon
