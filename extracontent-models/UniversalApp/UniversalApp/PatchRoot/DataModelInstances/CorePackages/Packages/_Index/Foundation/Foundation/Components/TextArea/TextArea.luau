local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

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

local v = { size = InputSize.Medium, numLines = 3, testId = "--foundation-text-area" }

local function TextArea(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local v4 = useTextInputVariants(v3, v2.size, v2.variant)

	local createElement = React.createElement
	local width

	if v2.width then
		width = v2.width
	end

	return createElement(InputField, withCommonProps(v2, {
		width = width,
		label = v2.label,
		size = getInputTextSize(v2.size),
		hint = v2.hint,
		hasError = v2.hasError,
		isDisabled = v2.isDisabled,
		isRequired = v2.isRequired,
		input = function(ref2)
			return React.createElement(InternalTextInput, {
				inputRef = v2.inputRef,
				size = v2.size,
				variant = v2.variant,
				numLines = v2.numLines,
				focusBehavior = v2.focusBehavior,
				onFocus = v2.onFocusGained,
				onFocusLost = v2.onFocusLost,
				onChanged = v2.onChanged,
				text = v2.text,
				hasError = v2.hasError,
				isDisabled = v2.isDisabled,
				hasClearButton = v2.hasClearButton,
				placeholder = v2.placeholder,
				horizontalPadding = {
					left = v4.container.horizontalPadding,
					right = v4.container.horizontalPadding - UDim.new(0, v3.Size.Size_150)
				},
				LayoutOrder = 2,
				ref = ref2,
				testId = `{v2.testId}--input`
			})
		end,
		textBoxRef = v2.textBoxRef,
		ref = ref
	}))
end

return React.memo(React.forwardRef(TextArea))
