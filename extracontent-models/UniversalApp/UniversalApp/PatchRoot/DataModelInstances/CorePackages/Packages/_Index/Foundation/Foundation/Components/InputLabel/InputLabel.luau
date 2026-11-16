local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Text = require(Foundation.Components.Text)

local React = require(parent.React)
local Translator = require(Foundation.Utility.Localization.Translator)

local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
require(Foundation.Components.Types)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local ControlState = require(Foundation.Enums.ControlState)

local InputLabelSize = require(Foundation.Enums.InputLabelSize)

local function labelText(text: string, isRequired: boolean?) -- 1 equivalent call inferred from this helper
	if isRequired == nil or isRequired == React.None then
		return text
	end

	if isRequired then
		return text .. " *"
	end

	return (Translator:FormatByKey("CommonUI.Controls.Input.Optional", { inputLabel = text }))
end

local v = { size = InputLabelSize.Medium, testId = "--foundation-input-label" }

local function InputLabel(p, ref)
	local v2 = withDefaults(p, v)
	local onStateChanged = React.useMemo(function()
		if v2.onHover == nil then
			return nil
		end

		return function(p2)
			v2.onHover(p2 == ControlState.Hover)
		end
	end, { v2.onHover })

	local createElement = React.createElement

	local v3 = {
		Text = labelText(v2.Text, v2.isRequired), -- inferred equivalent call
		RichText = v2.RichText,
		selection = { Selectable = false },
		onActivated = 0,
		onStateChanged = 0,
		stateLayer = 0,
		textStyle = 0,
		tag = 0,
		ref = 0
	}
	local onActivated

	if not v2.isDisabled then
		onActivated = v2.onActivated
	end

	v3.onActivated = onActivated

	if v2.isDisabled then
		onStateChanged = nil
	end

	v3.onStateChanged = onStateChanged
	v3.stateLayer = { affordance = StateLayerAffordance.None }
	v3.textStyle = v2.textStyle
	v3.tag = {
		["size-0 auto-xy text-wrap text-align-x-left text-align-y-top"] = true,
		["padding-top-xxsmall"] = v2.size ~= InputLabelSize.XSmall,
		["content-muted"] = v2.isDisabled,
		["content-emphasis"] = not v2.isDisabled,
		["text-body-small"] = v2.size == InputLabelSize.Small or v2.size == InputLabelSize.XSmall,
		["text-body-medium"] = v2.size == InputLabelSize.Medium,
		["text-body-large"] = v2.size == InputLabelSize.Large
	}

	v3.ref = ref
	return createElement(Text, withCommonProps(v2, v3))
end

return React.memo(React.forwardRef(InputLabel))
