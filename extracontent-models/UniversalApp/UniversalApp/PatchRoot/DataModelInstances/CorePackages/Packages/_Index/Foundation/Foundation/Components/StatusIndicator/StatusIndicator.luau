local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)
local Flags = require(Foundation.Utility.Flags)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useStatusIndicatorVariants = require(script.Parent.useStatusIndicatorVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local v13 = _G.__DEV__ == true
local StatusIndicatorVariant = require(Foundation.Enums.StatusIndicatorVariant)
local StatusIndicatorShape = require(Foundation.Enums.StatusIndicatorShape)
local ValidNumericVariants = require(script.Parent.ValidNumericVariants)
local t1 = {
	max = 1e999,
	testId = "--foundation-status-indicator",
	variant = StatusIndicatorVariant.Standard,
	shape = StatusIndicatorShape.Circle
}

local function StatusIndicator(p1, p2) -- line: 55
	-- upvalues: withDefaults (copy), t1 (copy), StatusIndicatorShape (copy), v13 (copy), ValidNumericVariants (copy), Dash (copy), useTokens (copy), useStatusIndicatorVariants (copy), React (copy), View (copy), withCommonProps (copy), Text (copy), ReactIs (copy), Flags (copy)
	local v21 = withDefaults(p1, t1)
	local v22 = if not v21.value then v21.shape else StatusIndicatorShape.Circle

	if v13 and v21.value ~= nil then
		assert(ValidNumericVariants[v21.variant], `{ v21.variant } is not a supported numeric variant. The following are valid numeric variants: { table.concat(Dash.filter(Dash.keys(ValidNumericVariants), function(p3, _) -- line: 63
			-- upvalues: ValidNumericVariants (copy)
			return ValidNumericVariants[p3] == true
		end), ",") }`)
	end

	local v23 = useTokens()
	local v24 = v21.value ~= nil
	local v25 = useStatusIndicatorVariants(v23, v21.variant, v24, v22)
	local v26 = React.useCallback(function(n1: number) -- line: 75
		-- upvalues: v21 (copy)
		if v21.max and n1 > v21.max then
			return `{ v21.max }+`
		end

		return (tostring(n1))
	end, { v21.max })

	return React.createElement(View, withCommonProps(v21, {
		tag = v25.container.tag,
		backgroundStyle = if not v25.container.backgroundStyle then nil else v25.container.backgroundStyle,
		ref = p2
	}), {
		Text = if not v24 or not v25.content.style then nil else React.createElement(Text, {
			Text = if not ReactIs.isBinding(v21.value) then v26(v21.value) else v21.value:map(v26),
			textStyle = v25.content.style,
			fontStyle = if not Flags.FoundationStatusIndicatorBeta then nil else {
				Font = v25.content.font,
				FontSize = v23.Typography.LabelSmall.FontSize,
				LineHeight = v23.Typography.LabelSmall.LineHeight
			},
			tag = v25.content.tag,
			testId = `{ v21.testId }--text`
		}),
		InnerRing = if not v25.ring then nil else React.createElement(View, {
			tag = v25.ring.tag,
			testId = `{ v21.testId }--ring`
		})
	})
end

return React.memo(React.forwardRef(StatusIndicator))
