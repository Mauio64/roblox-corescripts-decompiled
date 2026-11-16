local CorePackages = game:GetService("CorePackages")
local foundation = CorePackages.Packages._Index.Foundation.Foundation
local parent = foundation.Parent

local React = require(parent.React)

local components = foundation.Components
local InputField = require(components.InputField)
require(foundation.Components.Types)

local ComposerTextInput = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/Composer/ComposerTextInput")

local fFlagComposerFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").FFlagComposerFooter
local useTextInputVariants = require(components.TextInput.useTextInputVariants)
local useTokens = require(foundation.Providers.Style.useTokens)
local withCommonProps = require(foundation.Utility.withCommonProps)
local withDefaults = require(foundation.Utility.withDefaults)

local InputSize = require(foundation.Enums.InputSize)

local v5 = {
	size = InputSize.Large,
	minLines = 1,
	maxLines = 5,
	testId = "--app-blox-composer"
}

local function Composer(p2, ref)
	local v6 = withDefaults(p2, v5)
	local v7 = useTokens()
	local v8 = useTextInputVariants(v7, v6.size, v6.variant)
	local v9

	if fFlagComposerFooter then
		if v6.leadingElement == nil and v6.trailingElement == nil and v6.footerElement == nil then
			v9 = v6.isDisabled
		else
			v9 = false
		end
	else
		v9 = v6.leadingElement == nil and v6.trailingElement == nil and v6.isDisabled
	end

	local createElement = React.createElement

	local v13 = if v6.width then v6.width else nil
	return createElement(InputField, withCommonProps(v6, {
		width = v13,
		label = v6.label,
		hint = v6.hint,
		hasError = v6.hasError,
		isDisabled = v9,
		isRequired = v6.isRequired,
		input = function(ref2)
			local createElement2 = React.createElement
			local v15 = {
				size = v6.size,
				variant = v6.variant,
				minLines = v6.minLines,
				maxLines = v6.maxLines,
				alwaysMultiLine = true,
				manualFocusRelease = true,
				trailingAlignBottom = v6.trailingElement ~= nil,
				composerDebug = v6.composerDebug,
				focusBehavior = v6.focusBehavior,
				onFocus = v6.onFocusGained,
				onFocusLost = v6.onFocusLost,
				onReturnPressed = v6.onReturnPressed,
				onChanged = v6.onChanged,
				text = v6.text,
				hasError = v6.hasError,
				isDisabled = v6.isDisabled,
				hasClearButton = v6.hasClearButton,
				placeholder = v6.placeholder,
				horizontalPadding = 0,
				textPaddingOnParent = true,
				leadingElement = 0,
				trailingElement = 0,
				footerElement = 0,
				LayoutOrder = 2,
				ref = 0,
				testId = 0
			}

			local v17 = if v6.leadingElement then UDim.new(0, v7.Padding.XSmall) else UDim.new(0, v7.Padding.Large)
			local v18 = if v6.trailingElement then UDim.new(0, v7.Padding.XSmall) else v8.container.horizontalPadding
			v15.horizontalPadding = { left = v17, right = v18 }

			v15.leadingElement = v6.leadingElement
			v15.trailingElement = v6.trailingElement
			local v19 = if fFlagComposerFooter then v6.footerElement else nil
			v15.footerElement = v19

			v15.ref = ref2
			v15.testId = `{v6.testId}--input`
			return createElement2(ComposerTextInput, v15)
		end,
		textBoxRef = v6.textBoxRef,
		ref = ref
	}))
end

return React.memo(React.forwardRef(Composer))
