local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)
local ReactIs = require(parent.ReactIs)

local Flags = require(Foundation.Utility.Flags)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local devAssert = require(Foundation.Utility.devAssert)
local useStatusIndicatorVariants = require(script.Parent.useStatusIndicatorVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local StatusIndicatorSize = require(Foundation.Enums.StatusIndicatorSize)

local StatusIndicatorVariant = require(Foundation.Enums.StatusIndicatorVariant)

local StatusIndicatorShape = require(Foundation.Enums.StatusIndicatorShape)

local ValidNumericVariants = require(script.Parent.ValidNumericVariants)

local v = {
	variant = StatusIndicatorVariant.Standard,
	shape = StatusIndicatorShape.Circle,
	size = StatusIndicatorSize.Small,
	max = 1e999,
	testId = "--foundation-status-indicator"
}

local function StatusIndicator(p, ref)
	local v2 = withDefaults(p, v)
	local v3

	if v2.value then
		v3 = StatusIndicatorShape.Circle
	else
		v3 = v2.shape
	end

	if v2.value ~= nil then
		devAssert(
			ValidNumericVariants[v2.variant],
			`{v2.variant} is not a supported numeric variant. The following are valid numeric variants: {table.concat(Dash.filter(Dash.keys(ValidNumericVariants), function(p2, _): boolean
				return ValidNumericVariants[p2] == true
			end), ",")}`
		)
	end

	local v4 = useTokens()
	local v5 = v2.value ~= nil

	local v6 = useStatusIndicatorVariants(v4, v2.variant, v5, v3, v2.size, v2.mask)

	local v7 = React.useCallback(function(p2: number)
		if v2.max and v2.max < p2 then
			return `{v2.max}+`
		end

		return (tostring(p2))
	end, { v2.max })

	local createElement = React.createElement

	local v8 = {
		tag = v6.container.tag,
		backgroundStyle = 0,
		stroke = 0,
		ref = 0,
		Size = 0
	}
	local backgroundStyle

	if v6.container.backgroundStyle then
		backgroundStyle = v6.container.backgroundStyle
	end

	v8.backgroundStyle = backgroundStyle
	local stroke

	if v2.mask then
		stroke = v6.stroke
	end

	v8.stroke = stroke
	v8.ref = ref
	v8.Size = v6.container.size
	local v9 = withCommonProps(v2, v8)
	local text

	if v5 and v6.content.style then
		local createElement2 = React.createElement
		local text2

		if ReactIs.isBinding(v2.value) then
			text2 = v2.value:map(v7)
		else
			text2 = v7(v2.value)
		end

		local v10 = {
			Text = text2,
			textStyle = v6.content.style,
			fontStyle = 0,
			tag = 0,
			testId = 0
		}
		local fontStyle

		if Flags.FoundationStatusIndicatorDesignUpdate then
			fontStyle = {
				Font = v6.content.font,
				FontSize = v6.content.typography.FontSize,
				LineHeight = v6.content.typography.LineHeight
			}
		else
			fontStyle = {
				Font = v6.content.font,
				FontSize = v4.Typography.LabelSmall.FontSize,
				LineHeight = v4.Typography.LabelSmall.LineHeight
			}
		end

		v10.fontStyle = fontStyle

		v10.tag = v6.content.tag
		v10.testId = `{v2.testId}--text`
		text = createElement2(Text, v10)
	end

	local innerRing

	if v3 == StatusIndicatorShape.Ring and v6.ring then
		innerRing = React.createElement(View, {
			tag = v6.ring.tag,
			Size = v6.ring.size,
			testId = `{v2.testId}--ring`
		})
	end

	return createElement(View, v9, { Text = text, InnerRing = innerRing })
end

return React.memo(React.forwardRef(StatusIndicator))
