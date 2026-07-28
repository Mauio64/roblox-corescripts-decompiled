local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Components = Foundation.Components
local InputField = require(Components.InputField)
local InternalTextInput = require(Components.InternalTextInput)

require(Foundation.Components.Types)

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

local function TextArea(p1, p2) -- line: 39
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useTextInputVariants (copy), React (copy), InputField (copy), withCommonProps (copy), getInputTextSize (copy), InternalTextInput (copy)
	local v17 = withDefaults(p1, t1)
	local v18 = useTokens()
	local v19 = useTextInputVariants(v18, v17.size, v17.variant)

	return React.createElement(InputField, withCommonProps(v17, {
		width = if not v17.width then nil else v17.width,
		label = v17.label,
		size = getInputTextSize(v17.size),
		hint = v17.hint,
		hasError = v17.hasError,
		isDisabled = v17.isDisabled,
		isRequired = v17.isRequired,
		input = function(p3) -- line: 54
			-- upvalues: React (copy), InternalTextInput (copy), v17 (copy), v19 (copy), v18 (copy)
			return React.createElement(InternalTextInput, {
				LayoutOrder = 2,
				inputRef = v17.inputRef,
				size = v17.size,
				variant = v17.variant,
				numLines = v17.numLines,
				focusBehavior = v17.focusBehavior,
				onFocus = v17.onFocusGained,
				onFocusLost = v17.onFocusLost,
				onChanged = v17.onChanged,
				text = v17.text,
				hasError = v17.hasError,
				isDisabled = v17.isDisabled,
				hasClearButton = v17.hasClearButton,
				placeholder = v17.placeholder,
				horizontalPadding = {
					left = v19.container.horizontalPadding,
					right = v19.container.horizontalPadding - UDim.new(0, v18.Size.Size_150)
				},
				ref = p3,
				testId = `{ v17.testId }--input`
			})
		end,
		textBoxRef = v17.textBoxRef,
		ref = p2
	}))
end

return React.memo(React.forwardRef(TextArea))
