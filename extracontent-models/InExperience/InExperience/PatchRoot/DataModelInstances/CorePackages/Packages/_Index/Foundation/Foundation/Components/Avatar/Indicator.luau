local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Image = require(Foundation.Components.Image)
local IndicatorShape = require(Foundation.Enums.IndicatorShape)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local IndicatorVariant = require(Foundation.Enums.IndicatorVariant)
local useIndicatorVariants = require(script.Parent.useIndicatorVariants)
local t1 = {
	shape = IndicatorShape.Circle,
	variant = IndicatorVariant.Success
}

local function Indicator(p1) -- line: 30
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useIndicatorVariants (copy), React (copy), Image (copy), View (copy), withCommonProps (copy)
	local v15 = withDefaults(p1, t1)
	local v16 = useTokens()
	local v17 = useIndicatorVariants(v16, v15.shape, v15.variant, v15.size)

	return React.createElement(if not v17.indicator.Image then View else Image, withCommonProps(v15, v17.indicator))
end

return React.memo(Indicator)
