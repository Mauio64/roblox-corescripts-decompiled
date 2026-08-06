local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Otter = require(FoundationParent.Otter)
local React = require(FoundationParent.React)
local Constants = require(Foundation.Constants)
local Components = Foundation.Components
local InternalInput = require(Components.InternalInput)
local Knob = require(Components.Knob)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)

require(Components.Types)

local useUncontrolledState = require(Components.InternalInput.useUncontrolledState)
local BuilderIcons = require(FoundationParent.BuilderIcons)
local Flags = require(Foundation.Utility.Flags)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local ColorNamespace = require(Foundation.Enums.ColorNamespace)

require(Foundation.Enums.ControlState)

local useToggleVariants = require(script.Parent.useToggleVariants)
local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.InputLabelSize)

local InputPlacement = require(Foundation.Enums.InputPlacement)
local t1 = {
	frequency = 4
}
local t2 = {
	Selectable = true,
	testId = "--foundation-toggle",
	size = InputSize.Medium,
	placement = InputPlacement.Start
}
local t3 = {
	colorNamespace = ColorNamespace.Color
}

local function Toggle(p1, p2) -- line: 66
	-- upvalues: withDefaults (copy), t2 (copy), useTokens (copy), useToggleVariants (copy), useUncontrolledState (copy), Flags (copy), InputSize (copy), React (copy), Otter (copy), t1 (copy), InternalInput (copy), withCommonProps (copy), Constants (copy), PresentationContext (copy), t3 (copy), Knob (copy), BuilderIcons (copy)
	local v26 = withDefaults(p1, t2)
	local v27 = useTokens()
	local v28 = useToggleVariants(v27, v26.size)
	local v29, v30 = useUncontrolledState(v26.isChecked, v26.onActivated)
	local v31 = if not Flags.FoundationToggleVisualUpdate then v26.size else if p1.size ~= InputSize.Large then v26.size else InputSize.Medium
	local v32 = not Flags.FoundationToggleVisualUpdate
	local v33 = not v29 and 0 or 1
	local v34, v35 = React.useBinding(v33)
	local v36 = React.useRef(nil)
	local v37 = v34:map(function(p3) -- line: 82
		-- upvalues: v28 (copy)
		return v28.knob.offPosition:Lerp(v28.knob.onPosition, p3)
	end)

	React.useEffect(function() -- line: 86
		-- upvalues: Otter (copy), v33 (copy), v36 (copy), v35 (copy)
		local v39 = Otter.createSingleMotor(v33)

		v36.current = v39
		v39:start()
		v39:onStep(function(p4) -- line: 91
			-- upvalues: v35 (copy)
			v35(p4)
		end)

		return function() -- line: 95
			-- upvalues: v39 (copy)
			v39:destroy()
		end
	end, {})
	React.useEffect(function() -- line: 100
		-- upvalues: v29 (copy), v36 (copy), Otter (copy), t1 (copy)
		local v40 = not v29 and 0 or 1

		if v36.current then
			v36.current:setGoal(Otter.spring(v40, t1))
		end
	end, { v29 })

	return React.createElement(InternalInput, withCommonProps(v26, {
		isChecked = v29,
		isDisabled = v26.isDisabled,
		onActivated = v30,
		label = {
			text = v26.label,
			position = Constants.INPUT_PLACEMENT_TO_LABEL_ALIGNMENT[v26.placement]
		},
		customVariantProps = v28.input,
		size = v26.size,
		Selectable = v26.Selectable,
		NextSelectionUp = v26.NextSelectionUp,
		NextSelectionDown = v26.NextSelectionDown,
		NextSelectionLeft = v26.NextSelectionLeft,
		NextSelectionRight = v26.NextSelectionRight,
		ref = p2
	}), React.createElement(PresentationContext.Provider, {
		value = t3
	}, {
		Knob = if not Flags.FoundationToggleVisualUpdate then React.createElement(Knob, {
			size = v31,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = v37,
			testId = `{ v26.testId }--knob`
		}) else React.createElement(Knob, {
			size = v31,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = v37,
			hasShadow = v32,
			icon = if not v29 then nil else {
				name = BuilderIcons.Icon.Check,
				variant = BuilderIcons.IconVariant.Regular
			},
			testId = `{ v26.testId }--knob`
		})
	}))
end

return React.memo(React.forwardRef(Toggle))
