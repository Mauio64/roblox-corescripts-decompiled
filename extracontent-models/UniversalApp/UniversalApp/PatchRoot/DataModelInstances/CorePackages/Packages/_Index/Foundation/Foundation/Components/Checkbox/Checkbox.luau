local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BuilderIcons = require(FoundationParent.BuilderIcons)
local React = require(FoundationParent.React)
local Constants = require(Foundation.Constants)
local Components = Foundation.Components
local InternalInput = require(Components.InternalInput)
local Text = require(Components.Text)

require(Components.Types)

local useUncontrolledState = require(Components.InternalInput.useUncontrolledState)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local useCheckboxVariants = require(script.Parent.useCheckboxVariants)
local InputSize = require(Foundation.Enums.InputSize)
local InputPlacement = require(Foundation.Enums.InputPlacement)
local t1 = {
	Selectable = true,
	testId = "--foundation-checkbox",
	size = InputSize.Medium,
	placement = InputPlacement.Start
}

local function Checkbox(p1, p2) -- line: 53
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useCheckboxVariants (copy), useUncontrolledState (copy), React (copy), InternalInput (copy), withCommonProps (copy), Constants (copy), Text (copy), BuilderIcons (copy)
	local v20 = withDefaults(p1, t1)
	local v21 = useTokens()
	local v22 = useCheckboxVariants(v21, v20.size)
	local v23, v24 = useUncontrolledState(v20.isChecked, v20.onActivated)
	local v25 = v20.isIndeterminate or false

	return React.createElement(InternalInput, withCommonProps(v20, {
		isChecked = v23,
		isIndeterminate = v25,
		isDisabled = v20.isDisabled,
		onActivated = v24,
		label = {
			text = v20.label,
			position = Constants.INPUT_PLACEMENT_TO_LABEL_ALIGNMENT[v20.placement]
		},
		customVariantProps = v22.input,
		size = v20.size,
		Selectable = v20.Selectable,
		NextSelectionUp = v20.NextSelectionUp,
		NextSelectionDown = v20.NextSelectionDown,
		NextSelectionLeft = v20.NextSelectionLeft,
		NextSelectionRight = v20.NextSelectionRight,
		ref = p2
	}), {
		Checkmark = if not v23 and not v25 then nil else React.createElement(Text, {
			TextScaled = true,
			Text = if not v25 then BuilderIcons.Icon.Check else BuilderIcons.Icon.Minus,
			fontStyle = {
				Font = BuilderIcons.Font[BuilderIcons.IconVariant.Filled]
			},
			tag = v22.checkmark.tag,
			testId = `{ v20.testId }--checkmark`
		})
	})
end

return React.memo(React.forwardRef(Checkbox))
