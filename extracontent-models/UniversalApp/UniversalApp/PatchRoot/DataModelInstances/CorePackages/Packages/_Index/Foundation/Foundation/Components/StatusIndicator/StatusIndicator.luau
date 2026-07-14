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
local StatusIndicatorSize = require(Foundation.Enums.StatusIndicatorSize)
local StatusIndicatorVariant = require(Foundation.Enums.StatusIndicatorVariant)
local StatusIndicatorShape = require(Foundation.Enums.StatusIndicatorShape)
local ValidNumericVariants = require(script.Parent.ValidNumericVariants)
local t1 = {
	max = 1e999,
	testId = "--foundation-status-indicator",
	variant = StatusIndicatorVariant.Standard,
	shape = StatusIndicatorShape.Circle,
	size = if not Flags.FoundationAvatarBeta then nil else StatusIndicatorSize.Small
}

local function StatusIndicator(p1, p2) -- line: 60
	-- upvalues: withDefaults (copy), t1 (copy), StatusIndicatorShape (copy), v13 (copy), ValidNumericVariants (copy), Dash (copy), useTokens (copy), useStatusIndicatorVariants (copy), Flags (copy), React (copy), View (copy), withCommonProps (copy), Text (copy), ReactIs (copy)
	local v22 = withDefaults(p1, t1)
	local v23 = if not v22.value then v22.shape else StatusIndicatorShape.Circle

	if v13 and v22.value ~= nil then
		assert(ValidNumericVariants[v22.variant], `{ v22.variant } is not a supported numeric variant. The following are valid numeric variants: { table.concat(Dash.filter(Dash.keys(ValidNumericVariants), function(p3, _) -- line: 68
			-- upvalues: ValidNumericVariants (copy)
			return ValidNumericVariants[p3] == true
		end), ",") }`)
	end

	local v24 = useTokens()
	local v25 = v22.value ~= nil
	local v26 = useStatusIndicatorVariants(v24, v22.variant, v25, v23, if not Flags.FoundationAvatarBeta then nil else v22.size)
	local v27 = React.useCallback(function(n1: number) -- line: 86
		-- upvalues: v22 (copy)
		if v22.max and n1 > v22.max then
			return `{ v22.max }+`
		end

		return (tostring(n1))
	end, { v22.max })

	return React.createElement(View, withCommonProps(v22, {
		tag = v26.container.tag,
		backgroundStyle = if not v26.container.backgroundStyle then nil else v26.container.backgroundStyle,
		ref = p2,
		Size = if not Flags.FoundationAvatarBeta then nil else v26.container.size
	}), {
		Text = if not v25 or not v26.content.style then nil else React.createElement(Text, {
			Text = if not ReactIs.isBinding(v22.value) then v27(v22.value) else v22.value:map(v27),
			textStyle = v26.content.style,
			fontStyle = if not Flags.FoundationStatusIndicatorBeta then nil else {
				Font = v26.content.font,
				FontSize = v24.Typography.LabelSmall.FontSize,
				LineHeight = v24.Typography.LabelSmall.LineHeight
			},
			tag = v26.content.tag,
			testId = `{ v22.testId }--text`
		}),
		InnerRing = if not (not Flags.FoundationAvatarBeta or v23 == StatusIndicatorShape.Ring) or not v26.ring then nil else React.createElement(View, {
			tag = v26.ring.tag,
			Size = if not Flags.FoundationAvatarBeta then nil else v26.ring.size,
			testId = `{ v22.testId }--ring`
		})
	})
end

return React.memo(React.forwardRef(StatusIndicator))
