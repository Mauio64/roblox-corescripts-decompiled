local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local DividerVariant = require(Foundation.Enums.DividerVariant)
local Orientation = require(Foundation.Enums.Orientation)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useDividerVariants = require(script.Parent.useDividerVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local t1 = {
	testId = "--foundation-divider",
	variant = DividerVariant.Default,
	orientation = Orientation.Horizontal
}

local function Divider(p1, p2) -- line: 29
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useDividerVariants (copy), DividerVariant (copy), Orientation (copy), React (copy), View (copy), withCommonProps (copy)
	local v15 = withDefaults(p1, t1)
	local v16 = useTokens()
	local v17 = useDividerVariants(v16, v15.variant, v15.orientation)
	local v18 = v15.variant == DividerVariant.Heavy and v15.orientation ~= Orientation.Vertical

	return React.createElement(View, withCommonProps(v15, {
		tag = v17.container.tag,
		ref = p2
	}), {
		DividerStroke = React.createElement(View, {
			Size = v17.stroke.Size,
			backgroundStyle = v17.stroke.backgroundStyle
		}),
		DividerLine = if not v18 then nil else React.createElement(View, {
			tag = v17.line.tag,
			Position = v17.line.position,
			backgroundStyle = v17.line.backgroundStyle
		})
	})
end

return React.memo(React.forwardRef(Divider))
