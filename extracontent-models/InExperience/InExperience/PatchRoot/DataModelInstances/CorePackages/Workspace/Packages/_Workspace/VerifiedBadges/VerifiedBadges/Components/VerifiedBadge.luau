local parent = script:FindFirstAncestor("VerifiedBadges").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Icon = Foundation.Icon
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant

local function VerifiedBadge(props)
	local v = useTokens()
	local size = props.size or IconSize.Small
	local backplateStyle = props.backplateStyle or v.Color.System.Emphasis
	local checkStyle = props.checkStyle or v.Color.Extended.White.White_100

	return React.createElement(View, {
		tag = "auto-xy",
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	}, {
		Backplate = React.createElement(Icon, {
			name = IconName.VerifiedBackplate,
			variant = IconVariant.Filled,
			size = size,
			style = backplateStyle,
			ZIndex = 1
		}),
		Check = React.createElement(Icon, {
			name = IconName.VerifiedCheck,
			variant = IconVariant.Filled,
			size = size,
			style = checkStyle,
			ZIndex = 2
		})
	})
end

return VerifiedBadge
