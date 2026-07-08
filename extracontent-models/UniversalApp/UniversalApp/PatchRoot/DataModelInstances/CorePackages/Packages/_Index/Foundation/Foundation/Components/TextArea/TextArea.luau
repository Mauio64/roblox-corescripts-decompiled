local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Components = Foundation.Components
local InputField = require(Components.InputField)
local InternalTextInput = require(Components.InternalTextInput)

require(Foundation.Components.Types)

local Flags = require(Foundation.Utility.Flags)
local getInputTextSize = require(Foundation.Utility.getInputTextSize)
local useTextInputVariants = require(Components.TextInput.useTextInputVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.InputVariant)
require(Foundation.Enums.ControlState)

local t1 = {
	numLines = 3,
	testId = "--foundation-text-area",
	size = InputSize.Medium
}

local function TextArea(p1, p2) -- line: 40
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useTextInputVariants (copy), React (copy), InputField (copy), withCommonProps (copy), Flags (copy), getInputTextSize (copy), InternalTextInput (copy)
	local v18 = withDefaults(p1, t1)
	local v19 = useTokens()
	local v20 = useTextInputVariants(v19, v18.size, v18.variant)

	return React.createElement(InputField, withCommonProps(v18, {
		width = if not v18.width then nil else v18.width,
		label = v18.label,
		size = if not Flags.FoundationTextInputsBetaUpdate then nil else getInputTextSize(v18.size),
		hint = v18.hint,
		hasError = v18.hasError,
		isDisabled = v18.isDisabled,
		isRequired = v18.isRequired,
		input = function(p3) -- line: 55
			-- upvalues: React (copy), InternalTextInput (copy), v18 (copy), v20 (copy), v19 (copy)
			return React.createElement(InternalTextInput, {
				LayoutOrder = 2,
				inputRef = v18.inputRef,
				size = v18.size,
				variant = v18.variant,
				numLines = v18.numLines,
				focusBehavior = v18.focusBehavior,
				onFocus = v18.onFocusGained,
				onFocusLost = v18.onFocusLost,
				onChanged = v18.onChanged,
				text = v18.text,
				hasError = v18.hasError,
				isDisabled = v18.isDisabled,
				hasClearButton = v18.hasClearButton,
				placeholder = v18.placeholder,
				horizontalPadding = {
					left = v20.container.horizontalPadding,
					right = v20.container.horizontalPadding - UDim.new(0, v19.Size.Size_150)
				},
				ref = p3,
				testId = `{ v18.testId }--input`
			})
		end,
		textBoxRef = v18.textBoxRef,
		ref = p2
	}))
end

return React.memo(React.forwardRef(TextArea))
