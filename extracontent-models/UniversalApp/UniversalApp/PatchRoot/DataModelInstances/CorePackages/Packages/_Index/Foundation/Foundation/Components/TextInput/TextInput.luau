local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Components = Foundation.Components
local Icon = require(Components.Icon)
local IconButton = require(Components.IconButton)
local InputField = require(Components.InputField)
local InternalTextInput = require(Components.InternalTextInput)
require(Foundation.Components.Types)
local View = require(Components.View)

local useTextInputVariants = require(Foundation.Components.TextInput.useTextInputVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.InputVariant)

local getInputTextSize = require(Foundation.Utility.getInputTextSize)

require(Foundation.Enums.ControlState)

local v = { size = InputSize.Large, testId = "--foundation-text-input" }

local function TextInput(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTextInputVariants(useTokens(), v2.size, v2.variant)

	return React.createElement(InputField, withCommonProps(v2, {
		width = v2.width,
		ref = ref,
		label = v2.label,
		size = getInputTextSize(v2.size),
		isRequired = v2.isRequired,
		isDisabled = v2.isDisabled,
		hasError = v2.hasError,
		hint = v2.hint,
		textBoxRef = v2.textBoxRef,
		input = function(ref2)
			local createElement = React.createElement
			local v4 = {
				ref = ref2,
				inputRef = v2.inputRef,
				hasError = v2.hasError,
				isDisabled = v2.isDisabled,
				hasClearButton = v2.hasClearButton,
				text = v2.text,
				textInputType = v2.textInputType,
				focusBehavior = v2.focusBehavior,
				size = v2.size,
				variant = v2.variant,
				Selectable = v2.Selectable,
				NextSelectionUp = v2.NextSelectionUp,
				NextSelectionDown = v2.NextSelectionDown,
				NextSelectionLeft = v2.NextSelectionLeft,
				NextSelectionRight = v2.NextSelectionRight,
				horizontalPadding = {
					left = v3.container.horizontalPadding,
					right = v3.container.horizontalPadding
				},
				onChanged = v2.onChanged,
				onFocus = v2.onFocusGained,
				onFocusLost = v2.onFocusLost,
				onReturnPressed = v2.onReturnPressed,
				placeholder = v2.placeholder,
				leadingElement = 0,
				trailingElement = 0,
				testId = 0
			}
			local leadingElement

			if v2.leadingIcon then
				leadingElement = React.createElement(
					View,
					{ tag = "row align-y-center size-0-full auto-x" },
					React.createElement(Icon, {
						name = v2.leadingIcon,
						style = v3.icon.style,
						size = v3.icon.size
					})
				)
			end

			v4.leadingElement = leadingElement
			local trailingElement

			if v2.iconTrailing then
				local createElement2 = React.createElement
				local v5

				if type(v2.iconTrailing) == "table" and v2.iconTrailing.onActivated then
					v5 = React.createElement(IconButton, {
						onActivated = v2.iconTrailing.onActivated,
						isDisabled = v2.isDisabled,
						size = v3.icon.size,
						icon = v2.iconTrailing.name,
						testId = `{v2.testId}--trailing-icon-button`
					})
				else
					local createElement3 = React.createElement
					local name

					if type(v2.iconTrailing) == "table" then
						name = v2.iconTrailing.name
					else
						name = v2.iconTrailing
					end

					v5 = createElement3(Icon, {
						name = name,
						style = v3.icon.style,
						size = v3.icon.size
					})
				end

				trailingElement = createElement2(View, {
					tag = "row align-y-center size-0-full auto-x"
				}, v5)
			end

			v4.trailingElement = trailingElement

			v4.testId = `{v2.testId}--internal-text-input`
			return createElement(InternalTextInput, v4)
		end
	}))
end

return React.memo(React.forwardRef(TextInput))
