local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Constants = require(Foundation.Constants)

local Components = Foundation.Components
local InternalInput = require(Components.InternalInput)
require(Components.Types)
local View = require(Components.View)

local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)

local useRadioGroupItemVariants = require(script.Parent.useRadioGroupItemVariants)

local InputSize = require(Foundation.Enums.InputSize)

local InputPlacement = require(Foundation.Enums.InputPlacement)

local useInputGroupDefaults = require(Foundation.Components.InternalInputGroup.useInputGroupDefaults)
local useRadioGroup = require(script.Parent.Parent.useRadioGroup)

local v = { size = InputSize.Medium, isDisabled = false, placement = InputPlacement.Start }

local function RadioGroupItem(p, ref)
	local v2 = useInputGroupDefaults(p, v)
	local isDisabled = v2.isDisabled
	local v3 = useRadioGroup()

	local isChecked = v3.value == v2.value
	local label = v2.label or v2.value

	local v4 = useTokens()

	local onActivated = React.useCallback(function()
		v3.onValueChanged(v2.value)
	end, { isDisabled, v2.value, v3.onValueChanged })

	local v5 = useRadioGroupItemVariants(v4, v2.size)

	v2.testId = `{v3.testId}--item-{v2.value}`

	local createElement = React.createElement

	local v6 = withCommonProps(v2, {
		isChecked = isChecked,
		isDisabled = isDisabled,
		onActivated = onActivated,
		label = {
			text = label,
			position = Constants.INPUT_PLACEMENT_TO_LABEL_ALIGNMENT[v2.placement],
			hint = v2.hint
		},
		customVariantProps = v5.input,
		size = v2.size,
		Selectable = v3.Selectable,
		ref = ref
	})
	local center

	if isChecked then
		center = React.createElement(View, {
			tag = v5.checkmark.tag,
			backgroundStyle = v5.checkmark.style
		})
	end

	return createElement(InternalInput, v6, { Center = center })
end

return React.memo(React.forwardRef(RadioGroupItem))
