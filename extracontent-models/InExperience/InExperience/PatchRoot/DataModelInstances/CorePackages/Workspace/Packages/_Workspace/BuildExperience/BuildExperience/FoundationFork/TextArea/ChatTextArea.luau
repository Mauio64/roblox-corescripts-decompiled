local CorePackages = game:GetService("CorePackages")
local foundation = CorePackages.Packages._Index.Foundation.Foundation
local parent = foundation.Parent

local React = require(parent.React)

local components = foundation.Components
local InputField = require(components.InputField)
require(foundation.Components.Types)

local ChatInternalTextInput = require(script.Parent.ChatInternalTextInput)
local useTextInputVariants = require(components.TextInput.useTextInputVariants)
local useTokens = require(foundation.Providers.Style.useTokens)
local withCommonProps = require(foundation.Utility.withCommonProps)
local withDefaults = require(foundation.Utility.withDefaults)

local InputSize = require(foundation.Enums.InputSize)

local v = { size = InputSize.Large, maxLines = 5, testId = "--build-experience-chat-text-area" }

local function ChatTextArea(p, ref)
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
		hint = v2.hint,
		hasError = v2.hasError,
		isDisabled = v2.leadingElement == nil and v2.trailingElement == nil and v2.isDisabled,
		isRequired = v2.isRequired,
		input = function(ref2)
			local createElement2 = React.createElement
			local v5 = {
				size = v2.size,
				variant = v2.variant,
				maxLines = v2.maxLines,
				alwaysMultiLine = true,
				manualFocusRelease = true,
				trailingAlignBottom = v2.trailingElement ~= nil,
				composerDebug = v2.composerDebug,
				focusBehavior = v2.focusBehavior,
				onFocus = v2.onFocusGained,
				onFocusLost = v2.onFocusLost,
				onReturnPressed = v2.onReturnPressed,
				onChanged = v2.onChanged,
				text = v2.text,
				hasError = v2.hasError,
				isDisabled = v2.isDisabled,
				hasClearButton = v2.hasClearButton,
				placeholder = v2.placeholder,
				horizontalPadding = 0,
				textPaddingOnParent = true,
				leadingElement = 0,
				trailingElement = 0,
				LayoutOrder = 2,
				ref = 0,
				testId = 0
			}
			local left

			if v2.leadingElement then
				left = UDim.new(0, v3.Padding.XSmall)
			else
				left = UDim.new(0, v3.Padding.Large)
			end

			local right

			if v2.trailingElement then
				right = UDim.new(0, v3.Padding.XSmall)
			else
				right = v4.container.horizontalPadding
			end

			v5.horizontalPadding = { left = left, right = right }

			v5.leadingElement = v2.leadingElement
			v5.trailingElement = v2.trailingElement

			v5.ref = ref2
			v5.testId = `{v2.testId}--input`
			return createElement2(ChatInternalTextInput, v5)
		end,
		textBoxRef = v2.textBoxRef,
		ref = ref
	}))
end

return React.memo(React.forwardRef(ChatTextArea))
