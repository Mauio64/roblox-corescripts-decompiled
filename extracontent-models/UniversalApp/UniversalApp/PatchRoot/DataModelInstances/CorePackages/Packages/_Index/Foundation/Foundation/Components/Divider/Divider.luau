local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local DividerVariant = require(Foundation.Enums.DividerVariant)
local Orientation = require(Foundation.Enums.Orientation)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useDividerVariants = require(script.Parent.useDividerVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = {
	variant = DividerVariant.Default,
	orientation = Orientation.Horizontal,
	testId = "--foundation-divider"
}

local function Divider(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useDividerVariants(useTokens(), v2.variant, v2.orientation)
	local v4

	if v2.variant == DividerVariant.Heavy then
		v4 = v2.orientation ~= Orientation.Vertical
	else
		v4 = false
	end

	local createElement = React.createElement

	local v5 = withCommonProps(v2, { tag = v3.container.tag, ref = ref })

	local v6 = {
		DividerStroke = React.createElement(View, {
			Size = v3.stroke.Size,
			backgroundStyle = v3.stroke.backgroundStyle
		}),
		DividerLine = 0
	}
	local dividerLine

	if v4 then
		dividerLine = React.createElement(View, {
			tag = v3.line.tag,
			Position = v3.line.position,
			backgroundStyle = v3.line.backgroundStyle
		})
	end

	v6.DividerLine = dividerLine
	return createElement(View, v5, v6)
end

return React.memo(React.forwardRef(Divider))
