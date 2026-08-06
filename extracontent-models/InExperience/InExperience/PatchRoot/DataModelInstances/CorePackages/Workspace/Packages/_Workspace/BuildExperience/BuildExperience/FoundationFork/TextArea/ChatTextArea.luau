local Foundation = game:GetService("CorePackages").Packages._Index.Foundation.Foundation
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Components = Foundation.Components
local InputField = require(Components.InputField)

require(Foundation.Components.Types)

local ChatInternalTextInput = require(script.Parent.ChatInternalTextInput)
local useTextInputVariants = require(Components.TextInput.useTextInputVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local InputSize = require(Foundation.Enums.InputSize)
local t1 = {
	maxLines = 5,
	testId = "--build-experience-chat-text-area",
	size = InputSize.Large
}

local function ChatTextArea(p1, p2) -- line: 36
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useTextInputVariants (copy), React (copy), InputField (copy), withCommonProps (copy), ChatInternalTextInput (copy)
	local v16 = withDefaults(p1, t1)
	local v17 = useTokens()
	local v18 = useTextInputVariants(v17, v16.size, v16.variant)

	return React.createElement(InputField, withCommonProps(v16, {
		width = if not v16.width then nil else v16.width,
		label = v16.label,
		hint = v16.hint,
		hasError = v16.hasError,
		isDisabled = v16.trailingElement == nil and v16.isDisabled,
		isRequired = v16.isRequired,
		input = function(p3) -- line: 51
			-- upvalues: React (copy), ChatInternalTextInput (copy), v16 (copy), v17 (copy), v18 (copy)
			return React.createElement(ChatInternalTextInput, {
				alwaysMultiLine = true,
				manualFocusRelease = true,
				textPaddingOnParent = true,
				LayoutOrder = 2,
				size = v16.size,
				variant = v16.variant,
				maxLines = v16.maxLines,
				trailingAlignBottom = v16.trailingElement ~= nil,
				composerDebug = v16.composerDebug,
				focusBehavior = v16.focusBehavior,
				onFocus = v16.onFocusGained,
				onFocusLost = v16.onFocusLost,
				onReturnPressed = v16.onReturnPressed,
				onChanged = v16.onChanged,
				text = v16.text,
				hasError = v16.hasError,
				isDisabled = v16.isDisabled,
				hasClearButton = v16.hasClearButton,
				placeholder = v16.placeholder,
				horizontalPadding = {
					left = UDim.new(0, v17.Padding.Large),
					right = if not v16.trailingElement then v18.container.horizontalPadding else UDim.new(0, v17.Padding.XSmall)
				},
				trailingElement = v16.trailingElement,
				ref = p3,
				testId = `{ v16.testId }--input`
			})
		end,
		textBoxRef = v16.textBoxRef,
		ref = p2
	}))
end

return React.memo(React.forwardRef(ChatTextArea))
