local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)

local Constants = require(Foundation.Constants)

local Components = Foundation.Components
local InternalInput = require(Components.InternalInput)
local Text = require(Components.Text)
require(Components.Types)
local useUncontrolledState = require(Components.InternalInput.useUncontrolledState)

local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)

local useCheckboxVariants = require(script.Parent.useCheckboxVariants)

local InputSize = require(Foundation.Enums.InputSize)

local InputPlacement = require(Foundation.Enums.InputPlacement)

local useInputGroupDefaults = require(Components.InternalInputGroup.useInputGroupDefaults)

local v = {
	size = InputSize.Medium,
	placement = InputPlacement.Start,
	Selectable = true,
	testId = "--foundation-checkbox"
}

local function Checkbox(p, ref)
	local v2 = useInputGroupDefaults(p, v)

	local v3 = useCheckboxVariants(useTokens(), v2.size)

	local isChecked, onActivated = useUncontrolledState(v2.isChecked, v2.onActivated)
	local isIndeterminate = v2.isIndeterminate or false

	local createElement = React.createElement

	local v4 = withCommonProps(v2, {
		isChecked = isChecked,
		isIndeterminate = isIndeterminate,
		isDisabled = v2.isDisabled,
		onActivated = onActivated,
		label = {
			text = v2.label,
			position = Constants.INPUT_PLACEMENT_TO_LABEL_ALIGNMENT[v2.placement],
			hint = v2.hint
		},
		customVariantProps = v3.input,
		size = v2.size,
		Selectable = v2.Selectable,
		NextSelectionUp = v2.NextSelectionUp,
		NextSelectionDown = v2.NextSelectionDown,
		NextSelectionLeft = v2.NextSelectionLeft,
		NextSelectionRight = v2.NextSelectionRight,
		ref = ref
	})
	local checkmark

	if isChecked or isIndeterminate then
		local createElement2 = React.createElement
		local text

		if isIndeterminate then
			text = BuilderIcons.Icon.Minus
		else
			text = BuilderIcons.Icon.Check
		end

		checkmark = createElement2(Text, {
			Text = text,
			fontStyle = { Font = BuilderIcons.Font[BuilderIcons.IconVariant.Filled] },
			TextScaled = true,
			tag = v3.checkmark.tag,
			testId = `{v2.testId}--checkmark`
		})
	end

	return createElement(InternalInput, v4, { Checkmark = checkmark })
end

return React.memo(React.forwardRef(Checkbox))
