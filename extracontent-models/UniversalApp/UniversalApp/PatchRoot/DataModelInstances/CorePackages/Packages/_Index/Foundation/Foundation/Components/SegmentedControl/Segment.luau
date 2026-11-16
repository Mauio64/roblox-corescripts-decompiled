local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(parent.BuilderIcons)

local Icon = require(Foundation.Components.Icon)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

require(Foundation.Enums.FillBehavior)
local Flags = require(Foundation.Utility.Flags)
require(Foundation.Enums.IconSize)
require(Foundation.Enums.InputSize)
require(Foundation.Enums.SegmentedControlVariant)

local devAssert = require(Foundation.Utility.devAssert)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)

local useSegmentedControlVariants = require(script.Parent.useSegmentedControlVariants)

local function Segment(props, ref)
	local variant

	if Flags.FoundationSegmentedControlBeta then
		variant = props.variant
	end

	local fillBehavior

	if Flags.FoundationSegmentedControlBeta then
		fillBehavior = props.fillBehavior
	end

	local v = useTokens()

	local size = props.size

	if not Flags.FoundationSegmentedControlBeta then
		variant = nil
	end

	if not Flags.FoundationSegmentedControlBeta then
		fillBehavior = nil
	end

	local isCircular = props.isCircular
	local v2

	if Flags.FoundationSegmentedControlBeta then
		v2 = props.isActive
	end

	local v3 = useSegmentedControlVariants(v, size, variant, fillBehavior, isCircular, v2)

	devAssert(
		props.text == nil or props.icon == nil,
		"Segment: `text` and `icon` are mutually exclusive. Only one can be provided."
	)

	local v4 = props.icon ~= nil

	local variant2 = nil
	local name, icon

	if v4 then
		if typeof(props.icon) == "table" then
			local icon2 = props.icon

			name = icon2.name
			variant2 = icon2.variant
		else
			name = props.icon
		end

		icon = v3.icon
	end

	local createElement = React.createElement

	local v5 = withCommonProps(props, {
		tag = v3.segment.tag,
		onActivated = function()
			props.onActivated(props.id)
		end,
		ref = ref
	})
	local text

	if v4 then
		local createElement2 = React.createElement
		local v6 = {
			name = name,
			variant = variant2,
			size = icon.size,
			style = icon.style,
			testId = 0
		}
		local testId

		if Flags.FoundationSegmentedControlBeta then
			testId = `{props.testId}--icon`
		end

		v6.testId = testId
		text = createElement2(Icon, v6)
	else
		local createElement2 = React.createElement
		local v6 = { tag = v3.text.tag, Text = props.text, textStyle = 0, testId = 0 }
		local textStyle

		if Flags.FoundationSegmentedControlBeta then
			textStyle = v3.text.style
		end

		v6.textStyle = textStyle
		local testId

		if Flags.FoundationSegmentedControlBeta then
			testId = `{props.testId}--text`
		end

		v6.testId = testId
		text = createElement2(Text, v6)
	end

	return createElement(View, v5, { Text = text })
end

return React.memo(React.forwardRef(Segment))
