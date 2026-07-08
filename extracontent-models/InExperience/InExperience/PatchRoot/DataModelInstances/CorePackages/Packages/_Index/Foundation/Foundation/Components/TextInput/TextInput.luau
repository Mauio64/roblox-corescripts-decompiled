local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Components = Foundation.Components
local Icon = require(Components.Icon)
local IconButton = require(Components.IconButton)
local InputField = require(Components.InputField)
local InternalTextInput = require(Components.InternalTextInput)

require(Foundation.Components.Types)

local View = require(Components.View)
local Flags = require(Foundation.Utility.Flags)
local useTextInputVariants = require(Foundation.Components.TextInput.useTextInputVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.InputVariant)

local getInputTextSize = require(Foundation.Utility.getInputTextSize)

require(Foundation.Enums.ControlState)

local t1 = {
	testId = "--foundation-text-input",
	size = InputSize.Large
}

local function TextInput(p1, p2) -- line: 52
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useTextInputVariants (copy), React (copy), InputField (copy), withCommonProps (copy), getInputTextSize (copy), InternalTextInput (copy), Flags (copy), View (copy), Icon (copy), IconButton (copy)
	local v21 = withDefaults(p1, t1)
	local v22 = useTokens()
	local v23 = useTextInputVariants(v22, v21.size, v21.variant)

	return React.createElement(InputField, withCommonProps(v21, {
		width = v21.width,
		ref = p2,
		label = v21.label,
		size = getInputTextSize(v21.size),
		isRequired = v21.isRequired,
		isDisabled = v21.isDisabled,
		hasError = v21.hasError,
		hint = v21.hint,
		textBoxRef = v21.textBoxRef,
		input = function(p3) -- line: 69
			-- upvalues: React (copy), InternalTextInput (copy), v21 (copy), Flags (copy), v23 (copy), View (copy), Icon (copy), IconButton (copy)
			return React.createElement(InternalTextInput, {
				ref = p3,
				inputRef = v21.inputRef,
				hasError = v21.hasError,
				isDisabled = v21.isDisabled,
				hasClearButton = v21.hasClearButton,
				text = v21.text,
				textInputType = v21.textInputType,
				focusBehavior = v21.focusBehavior,
				size = v21.size,
				variant = v21.variant,
				Selectable = if not Flags.FoundationInputSelectionProps then nil else v21.Selectable,
				NextSelectionUp = if not Flags.FoundationInputSelectionProps then nil else v21.NextSelectionUp,
				NextSelectionDown = if not Flags.FoundationInputSelectionProps then nil else v21.NextSelectionDown,
				NextSelectionLeft = if not Flags.FoundationInputSelectionProps then nil else v21.NextSelectionLeft,
				NextSelectionRight = if not Flags.FoundationInputSelectionProps then nil else v21.NextSelectionRight,
				horizontalPadding = {
					left = v23.container.horizontalPadding,
					right = v23.container.horizontalPadding
				},
				onChanged = v21.onChanged,
				onFocus = v21.onFocusGained,
				onFocusLost = v21.onFocusLost,
				onReturnPressed = v21.onReturnPressed,
				placeholder = v21.placeholder,
				leadingElement = if not v21.leadingIcon then nil else React.createElement(View, {
					tag = "row align-y-center size-0-full auto-x"
				}, React.createElement(Icon, {
					name = v21.leadingIcon,
					style = v23.icon.style,
					size = v23.icon.size
				})),
				trailingElement = if not v21.iconTrailing then nil else React.createElement(View, {
					tag = "row align-y-center size-0-full auto-x"
				}, if type(v21.iconTrailing) ~= "table" or not v21.iconTrailing.onActivated then React.createElement(Icon, {
					name = if type(v21.iconTrailing) ~= "table" then v21.iconTrailing else v21.iconTrailing.name,
					style = v23.icon.style,
					size = v23.icon.size
				}) else React.createElement(IconButton, {
					onActivated = v21.iconTrailing.onActivated,
					isDisabled = v21.isDisabled,
					size = v23.icon.size,
					icon = v21.iconTrailing.name,
					testId = `{ v21.testId }--trailing-icon-button`
				})),
				testId = `{ v21.testId }--internal-text-input`
			})
		end
	}))
end

return React.memo(React.forwardRef(TextInput))
