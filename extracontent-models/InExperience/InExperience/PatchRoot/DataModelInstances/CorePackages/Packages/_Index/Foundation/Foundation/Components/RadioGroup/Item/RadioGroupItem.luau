local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Constants = require(Foundation.Constants)
local Components = Foundation.Components
local InternalInput = require(Components.InternalInput)

require(Components.Types)

local View = require(Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local useRadioGroupItemVariants = require(script.Parent.useRadioGroupItemVariants)
local InputSize = require(Foundation.Enums.InputSize)
local InputPlacement = require(Foundation.Enums.InputPlacement)
local useRadioGroup = require(script.Parent.Parent.useRadioGroup)
local t1 = {
	isDisabled = false,
	size = InputSize.Medium,
	placement = InputPlacement.Start
}

local function RadioGroupItem(p1, p2) -- line: 47
	-- upvalues: withDefaults (copy), t1 (copy), useRadioGroup (copy), useTokens (copy), React (copy), useRadioGroupItemVariants (copy), InternalInput (copy), withCommonProps (copy), Constants (copy), View (copy)
	local v19 = withDefaults(p1, t1)
	local isDisabled = v19.isDisabled
	local v21 = useRadioGroup()
	local v22 = v21.value == v19.value
	local v23 = v19.label or v19.value
	local v24 = useTokens()
	local v25 = React.useCallback(function() -- line: 57
		-- upvalues: v21 (copy), v19 (copy)
		v21.onValueChanged(v19.value)
	end, {
		isDisabled,
		v19.value,
		v21.onValueChanged
	})
	local v26 = useRadioGroupItemVariants(v24, v19.size)

	v19.testId = `{ v21.testId }--item-{ v19.value }`

	return React.createElement(InternalInput, withCommonProps(v19, {
		isChecked = v22,
		isDisabled = isDisabled,
		onActivated = v25,
		label = {
			text = v23,
			position = Constants.INPUT_PLACEMENT_TO_LABEL_ALIGNMENT[v19.placement]
		},
		customVariantProps = v26.input,
		size = v19.size,
		Selectable = v21.Selectable,
		ref = p2
	}), {
		Center = if not v22 then nil else React.createElement(View, {
			tag = v26.checkmark.tag,
			backgroundStyle = v26.checkmark.style
		})
	})
end

return React.memo(React.forwardRef(RadioGroupItem))
