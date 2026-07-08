local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Text = require(Foundation.Components.Text)
local React = require(FoundationParent.React)
local Translator = require(Foundation.Utility.Localization.Translator)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)

require(Foundation.Components.Types)

local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local ControlState = require(Foundation.Enums.ControlState)
local InputLabelSize = require(Foundation.Enums.InputLabelSize)

local function labelText(s1: string, b1: boolean?) -- line: 43
	-- upvalues: React (copy), Translator (copy)
	if b1 == nil or b1 == React.None then
		return s1
	end

	if b1 then
		return s1 .. "*"
	end

	return (Translator:FormatByKey("CommonUI.Controls.Input.Optional", {
		inputLabel = s1
	}))
end

local t1 = {
	testId = "--foundation-input-label",
	size = InputLabelSize.Medium
}

local function InputLabel(p1, p2) -- line: 58
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), ControlState (copy), Text (copy), withCommonProps (copy), Translator (copy), StateLayerAffordance (copy), InputLabelSize (copy)
	local v18 = withDefaults(p1, t1)
	local v19 = React.useMemo(function() -- line: 60
		-- upvalues: v18 (copy), ControlState (copy)
		if v18.onHover ~= nil then
			return function(p3) -- line: 62
				-- upvalues: v18 (copy), ControlState (copy)
				v18.onHover(p3 == ControlState.Hover)
			end
		end

		return nil
	end, { v18.onHover })
	local createElement = React.createElement
	local v21 = Text
	local v22 = withCommonProps
	local t2 = {}
	local Text2 = v18.Text
	local isRequired = v18.isRequired

	t2.Text = if isRequired ~= nil and isRequired ~= React.None then if not isRequired then Translator:FormatByKey("CommonUI.Controls.Input.Optional", {
		inputLabel = Text2
	}) else Text2 .. "*" else Text2
	t2.RichText = v18.RichText
	t2.selection = {
		Selectable = false
	}
	t2.onActivated = if v18.isDisabled then nil else v18.onActivated
	t2.onStateChanged = if v18.isDisabled then nil else v19
	t2.stateLayer = {
		affordance = StateLayerAffordance.None
	}
	t2.textStyle = v18.textStyle
	t2.tag = {
		["size-0 auto-xy text-wrap text-align-x-left text-align-y-top"] = true,
		["content-muted"] = v18.isDisabled,
		["content-default"] = not v18.isDisabled,
		["text-title-small"] = v18.size == InputLabelSize.Small,
		["text-title-medium"] = v18.size == InputLabelSize.Medium,
		["text-title-large"] = v18.size == InputLabelSize.Large
	}
	t2.ref = p2

	return createElement(v21, v22(v18, t2))
end

return React.memo(React.forwardRef(InputLabel))
