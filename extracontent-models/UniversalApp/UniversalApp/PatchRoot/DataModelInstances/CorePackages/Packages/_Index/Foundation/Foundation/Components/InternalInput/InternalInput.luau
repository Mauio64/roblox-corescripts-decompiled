local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Flags = require(Foundation.Utility.Flags)
local useMotion = require(FoundationParent.Motion).useMotion
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local Components = Foundation.Components
local InputLabel = require(Components.InputLabel)

require(Components.Types)

local View = require(Components.View)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local useInputMotionStates = require(script.Parent.useInputMotionStates)
local useInputVariants = require(script.Parent.useInputVariants)
local getInputTextSize = require(Foundation.Utility.getInputTextSize)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local Constants = require(Foundation.Constants)
local ControlState = require(Foundation.Enums.ControlState)
local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.CursorType)
require(Foundation.Providers.Style.Tokens)

local t1 = {
	Selectable = true,
	testId = "--foundation-internal-input",
	size = InputSize.Medium
}

local function InternalInput(p1, p2) -- line: 83
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), useTokens (copy), useInputVariants (copy), useInputMotionStates (copy), Flags (copy), useMotion (copy), ControlState (copy), Constants (copy), StateLayerAffordance (copy), View (copy), withCommonProps (copy), Dash (copy), InputLabel (copy), getInputTextSize (copy)
	local v24 = withDefaults(p1, t1)
	local text = v24.label.text
	local v26 = v24.label.position or Enum.HorizontalAlignment.Right
	local v27 = if typeof(text) ~= "string" then text ~= nil else #text > 0
	local v28, v29 = React.useState(false)
	local v30 = useTokens()
	local v31 = v24.isChecked or v24.isIndeterminate
	local v32 = useInputVariants(v30, v24.size, v26)
	local v33 = React.useMemo(function() -- line: 96
		-- upvalues: v24 (copy), v30 (copy)
		return {
			radius = v24.customVariantProps.cursorRadius or UDim.new(0, 0),
			offset = v30.Size.Size_200,
			borderWidth = v30.Stroke.Thicker
		}
	end, {
		v30,
		v27,
		v24.customVariantProps.cursorRadius
	})
	local v34 = useInputMotionStates(v30, if not Flags.FoundationToggleVisualUpdate then v24.customVariantProps.checkedStyle else v24.customVariantProps.colors)
	local v35, v36 = useMotion(v34.Default)

	React.useEffect(function() -- line: 113
		-- upvalues: v31 (copy), v36 (copy), v34 (copy), v28 (copy)
		if v31 then
			v36(v34.Checked)

			return
		end

		if v28 then
			v36(v34.Hover)

			return
		end

		v36(v34.Default)
	end, {
		v31,
		v28,
		v34
	})

	local v37 = React.useCallback(function(p3) -- line: 123
		-- upvalues: v29 (copy), ControlState (copy)
		v29(p3 == ControlState.Hover)
	end, {})
	local v38 = React.useCallback(function() -- line: 127
		-- upvalues: v24 (copy)
		if v24.isDisabled then
			return
		end

		v24.onActivated(not v24.isChecked)
	end, {
		v24.isDisabled,
		v24.isChecked,
		v24.onActivated
	})
	local t2 = {
		Selectable = not v24.isDisabled and v24.Selectable,
		NextSelectionUp = v24.NextSelectionUp,
		NextSelectionDown = v24.NextSelectionDown,
		NextSelectionLeft = v24.NextSelectionLeft,
		NextSelectionRight = v24.NextSelectionRight
	}
	local t3 = {
		Active = not v24.isDisabled,
		GroupTransparency = not v24.isDisabled and 0 or Constants.DISABLED_TRANSPARENCY,
		onActivated = v38,
		onStateChanged = v37,
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		selection = if not v27 then t2 else {
			Selectable = false
		},
		cursor = if not v27 then v33 else nil,
		isDisabled = v24.isDisabled,
		ref = p2
	}
	local v41 = if not Flags.FoundationToggleVisualUpdate or (not v24.customVariantProps.stroke or v24.customVariantProps.stroke.thickness == nil) then v32.input.stroke.thickness else v24.customVariantProps.stroke.thickness
	local t4 = {
		tag = v24.customVariantProps.tag,
		Size = v24.customVariantProps.size - UDim2.fromOffset(v41, v41),
		backgroundStyle = v35.backgroundStyle,
		onActivated = v38,
		stateLayer = {
			affordance = StateLayerAffordance.Background
		},
		stroke = {
			Color = v35.strokeStyle:map(function(p4) -- line: 168
				return p4.Color3
			end),
			Transparency = v35.strokeStyle:map(function(p5) -- line: 171
				-- upvalues: v24 (copy), v27 (copy), Constants (copy)
				if v24.isDisabled and not v27 then
					return Constants.DISABLED_TRANSPARENCY
				end

				return p5.Transparency
			end),
			Thickness = v41,
			BorderStrokePosition = Enum.BorderStrokePosition.Inner
		},
		selection = t2,
		cursor = if not v27 then nil else v33,
		LayoutOrder = if not v27 then nil else v26 ~= Enum.HorizontalAlignment.Left and -1 or 1,
		testId = `{ v24.testId }--container`
	}

	if not v27 then
		return React.createElement(View, withCommonProps(v24, Dash.union(t3, t4)), v24.children)
	end

	local t5 = {
		tag = v32.container.tag,
		padding = {
			top = v32.container.padding,
			bottom = v32.container.padding,
			left = if v26 ~= Enum.HorizontalAlignment.Right then nil else v32.container.padding,
			right = if v26 ~= Enum.HorizontalAlignment.Left then nil else v32.container.padding
		}
	}

	return React.createElement(View, withCommonProps(v24, Dash.union(t5, t3)), {
		Input = React.createElement(View, t4, v24.children),
		InputLabel = if typeof(text) ~= "string" then text else React.createElement(InputLabel, {
			Text = text,
			textStyle = v35.labelStyle,
			size = getInputTextSize(v24.size),
			testId = `{ v24.testId }--label`
		})
	})
end

return React.memo(React.forwardRef(InternalInput))
