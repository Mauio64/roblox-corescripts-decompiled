local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Icon = Foundation.Icon
local useTokens = Foundation.Hooks.useTokens
local IconSize = Foundation.Enums.IconSize

local function ItemCardIcon(t1: {[any]: any}) -- line: 11
	-- upvalues: useTokens (copy), React (copy), Icon (copy), IconSize (copy)
	local v9 = useTokens()

	return React.createElement(Icon, {
		name = t1.icon,
		style = t1.iconStyle or v9.Color.Content.Emphasis,
		size = IconSize.Small,
		LayoutOrder = t1.LayoutOrder,
		testId = `icon-{ t1.icon }`
	})
end

if require(Parent.AvatarExperienceFlags).FFlagAXItemCardComponentsMemo then
	return (React.memo(ItemCardIcon))
end

return ItemCardIcon
