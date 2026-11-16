local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Motion = require(parent.Motion)
local useMotion = Motion.useMotion

local Dash = require(parent.Dash)
local React = require(parent.React)

local Components = Foundation.Components
local InputLabel = require(Components.InputLabel)
require(Components.Types)
local View = require(Components.View)

local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)

local InputHint = require(script.Parent.InputHint)
local useInputMotionStates = require(script.Parent.useInputMotionStates)
local useInputVariants = require(script.Parent.useInputVariants)

local getInputTextSize = require(Foundation.Utility.getInputTextSize)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local Constants = require(Foundation.Constants)

local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.CursorType)

require(Foundation.Providers.Style.Tokens)

local v = { size = InputSize.Medium, Selectable = true, testId = "--foundation-internal-input" }

local function InternalInput(p, ref)
	local v2 = withDefaults(p, v)

	local v3 = v2.label.text
	local position = v2.label.position or Enum.HorizontalAlignment.Right
	local v4

	if typeof(v3) == "string" then
		v4 = #v3 > 0
	else
		v4 = v3 ~= nil
	end

	local v5 = useTokens()

	local isChecked = v2.isChecked or v2.isIndeterminate

	local v6 = useInputVariants(v5, v2.size, position)

	local cursor = React.useMemo(function()
		return {
			radius = v2.customVariantProps.cursorRadius or UDim.new(0, 0),
			offset = v5.Size.Size_200,
			borderWidth = v5.Stroke.Thicker
		}
	end, { v5, v4, v2.customVariantProps.cursorRadius })

	local v7 = useInputMotionStates(v5, v2.customVariantProps.colors)

	local v8, v9 = useMotion(v7.Default)

	React.useEffect(function()
		if isChecked then
			v9(v7.Checked)
		else
			v9(v7.Default)
		end
	end, { isChecked, v7 })

	local onActivated = React.useCallback(function()
		if v2.isDisabled then
			return
		end

		v2.onActivated(not v2.isChecked)
	end, { v2.isDisabled, v2.isChecked, v2.onActivated })

	local selection = {
		Selectable = not v2.isDisabled and v2.Selectable,
		NextSelectionUp = v2.NextSelectionUp,
		NextSelectionDown = v2.NextSelectionDown,
		NextSelectionLeft = v2.NextSelectionLeft,
		NextSelectionRight = v2.NextSelectionRight
	}

	local v10 = {
		Active = not v2.isDisabled,
		GroupTransparency = not v2.isDisabled and 0 or Constants.DISABLED_TRANSPARENCY,
		onActivated = onActivated,
		stateLayer = { affordance = StateLayerAffordance.None },
		selection = v4 and { Selectable = false } or selection,
		cursor = 0,
		isDisabled = 0,
		ref = 0
	}
	local cursor2

	if not v4 then
		cursor2 = cursor
	end

	v10.cursor = cursor2
	v10.isDisabled = v2.isDisabled
	v10.ref = ref
	local thickness

	if v2.customVariantProps.stroke and v2.customVariantProps.stroke.thickness ~= nil then
		thickness = v2.customVariantProps.stroke.thickness
	else
		thickness = v6.input.stroke.thickness
	end

	local stateLayer = React.useMemo(function()
		return { affordance = StateLayerAffordance.None, inset = nil, mode = nil }
	end, {})

	local v11 = {
		tag = v2.customVariantProps.tag,
		Size = v2.customVariantProps.size - UDim2.fromOffset(thickness, thickness),
		backgroundStyle = v8.backgroundStyle,
		onActivated = onActivated,
		stateLayer = stateLayer,
		stroke = {
			Color = v8.strokeStyle:map(function(p2)
				return p2.Color3
			end),
			Transparency = v8.strokeStyle:map(function(p2)
				if v2.isDisabled and not v4 then
					return Constants.DISABLED_TRANSPARENCY
				end

				return p2.Transparency
			end),
			Thickness = thickness,
			BorderStrokePosition = Enum.BorderStrokePosition.Inner
		},
		selection = selection,
		cursor = 0,
		LayoutOrder = 0,
		testId = 0
	}

	if not v4 then
		cursor = nil
	end

	v11.cursor = cursor

	v11.LayoutOrder = v4 and (position == Enum.HorizontalAlignment.Left and 1 or -1) or nil
	v11.testId = `{v2.testId}--container`

	if not v4 then
		return React.createElement(View, withCommonProps(v2, Dash.union(v10, v11)), v2.children)
	end

	local v12 = { tag = v6.container.tag, padding = 0 }

	local padding = {
		top = v6.container.padding,
		bottom = v6.container.padding,
		left = 0,
		right = 0
	}
	local left

	if position == Enum.HorizontalAlignment.Right then
		left = v6.container.padding
	end

	padding.left = left
	local right

	if position == Enum.HorizontalAlignment.Left then
		right = v6.container.padding
	end

	padding.right = right
	v12.padding = padding

	if typeof(v3) == "string" then
		v3 = React.createElement(InputLabel, {
			Text = v3,
			textStyle = v8.labelStyle,
			size = getInputTextSize(v2.size),
			testId = `{v2.testId}--label`
		})
	end

	local createElement = React.createElement
	local v13 = withCommonProps(v2, Dash.union(v12, v10))
	local v14 = {
		Input = React.createElement(View, v11, v2.children),
		InputLabel = 0
	}

	if v2.label.hint ~= nil and v2.label.hint ~= "" then
		v3 = React.createElement(View, { tag = "col gap-xxsmall auto-xy" }, {
			InputLabel = v3,
			Hint = React.createElement(InputHint, {
				text = v2.label.hint,
				size = getInputTextSize(v2.size),
				testId = `{v2.testId}--hint`,
				LayoutOrder = 2
			})
		})
	end

	v14.InputLabel = v3
	return createElement(View, v13, v14)
end

return React.memo(React.forwardRef(InternalInput))
