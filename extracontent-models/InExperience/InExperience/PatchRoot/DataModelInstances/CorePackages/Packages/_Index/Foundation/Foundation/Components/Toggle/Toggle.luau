local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Otter = require(parent.Otter)
local React = require(parent.React)

local Constants = require(Foundation.Constants)

local Components = Foundation.Components
local InternalInput = require(Components.InternalInput)
local Knob = require(Components.Knob)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
require(Components.Types)
local useUncontrolledState = require(Components.InternalInput.useUncontrolledState)

local BuilderIcons = require(parent.BuilderIcons)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)

local ColorNamespace = require(Foundation.Enums.ColorNamespace)
require(Foundation.Enums.ControlState)

local useToggleVariants = require(script.Parent.useToggleVariants)

local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.InputLabelSize)

local InputPlacement = require(Foundation.Enums.InputPlacement)

local useInputGroupDefaults = require(Components.InternalInputGroup.useInputGroupDefaults)

local v = { frequency = 4 }

local v2 = {
	size = InputSize.Medium,
	placement = InputPlacement.Start,
	Selectable = true,
	testId = "--foundation-toggle"
}

local v3 = { colorNamespace = ColorNamespace.Color }

local function Toggle(p, ref2)
	local v4 = useInputGroupDefaults(p, v2)
	local v5 = useToggleVariants(useTokens(), v4.size)
	local isChecked, onActivated = useUncontrolledState(v4.isChecked, v4.onActivated)
	local size

	if v4.size == InputSize.Large then
		size = InputSize.Medium
	else
		size = v4.size
	end

	local v6 = isChecked and 1 or 0
	local v7, v8 = React.useBinding(v6)
	local ref = React.useRef(nil)

	local mapped = v7:map(function(p2)
		return v5.knob.offPosition:Lerp(v5.knob.onPosition, p2)
	end)

	React.useEffect(function()
		local singleMotor = Otter.createSingleMotor(v6)
		ref.current = singleMotor
		singleMotor:start()

		singleMotor:onStep(function(p2)
			v8(p2)
		end)

		return function()
			singleMotor:destroy()
		end
	end, {})

	React.useEffect(function()
		local v9 = isChecked and 1 or 0

		if ref.current then
			ref.current:setGoal(Otter.spring(v9, v))
		end
	end, { isChecked })

	return React.createElement(InternalInput, withCommonProps(v4, {
		isChecked = isChecked,
		isDisabled = v4.isDisabled,
		onActivated = onActivated,
		label = {
			text = v4.label,
			position = Constants.INPUT_PLACEMENT_TO_LABEL_ALIGNMENT[v4.placement],
			hint = v4.hint
		},
		customVariantProps = v5.input,
		size = v4.size,
		Selectable = v4.Selectable,
		NextSelectionUp = v4.NextSelectionUp,
		NextSelectionDown = v4.NextSelectionDown,
		NextSelectionLeft = v4.NextSelectionLeft,
		NextSelectionRight = v4.NextSelectionRight,
		ref = ref2
	}), React.createElement(PresentationContext.Provider, { value = v3 }, {
		Knob = React.createElement(Knob, {
			size = size,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = mapped,
			hasShadow = false,
			icon = isChecked and {
				name = BuilderIcons.Icon.Check,
				variant = BuilderIcons.IconVariant.Regular
			} or nil,
			testId = `{v4.testId}--knob`
		})
	}))
end

return React.memo(React.forwardRef(Toggle))
