local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local CloseAffordance = require(Foundation.Components.CloseAffordance)
local CloseAffordanceVariant = require(Foundation.Enums.CloseAffordanceVariant)
local InputSize = require(Foundation.Enums.InputSize)

local Constants = require(Foundation.Constants)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useInputChipVariants = require(script.Parent.useInputChipVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = { size = InputSize.Medium, isDisabled = false, testId = "--foundation-input-chip" }

local function InputChip(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useInputChipVariants(useTokens(), v2.size)

	local createElement = React.createElement

	local v4 = { tag = v3.container.tag, GroupTransparency = 0, ref = 0 }
	local groupTransparency

	if v2.isDisabled then
		groupTransparency = Constants.DISABLED_TRANSPARENCY
	end

	v4.GroupTransparency = groupTransparency
	v4.ref = ref
	local v5 = withCommonProps(v2, v4)

	local v6 = {
		Text = React.createElement(Text, {
			Text = v2.text,
			textStyle = v3.text.contentStyle,
			tag = v3.text.tag,
			padding = v3.text.padding,
			LayoutOrder = 1,
			testId = `{v2.testId}--text`
		}),
		Close = 0
	}

	local createElement2 = React.createElement
	local v7 = {
		tag = v3.close.tag,
		padding = v3.close.padding,
		LayoutOrder = 2,
		testId = `{v2.testId}--close-container`
	}

	local createElement3 = React.createElement
	local onActivated

	if not v2.isDisabled then
		onActivated = v2.onClose
	end

	v6.Close = createElement2(View, v7, {
		CloseAffordance = createElement3(CloseAffordance, {
			onActivated = onActivated,
			size = InputSize.XSmall,
			variant = CloseAffordanceVariant.Utility,
			hasPadding = false,
			Selectable = not v2.isDisabled and nil,
			LayoutOrder = 1,
			testId = `{v2.testId}--close`
		})
	})
	return createElement(View, v5, v6)
end

return React.memo(React.forwardRef(InputChip))
