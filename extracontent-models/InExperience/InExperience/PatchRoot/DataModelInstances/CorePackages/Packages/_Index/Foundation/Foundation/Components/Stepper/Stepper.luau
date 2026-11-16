local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

local FillBehavior = require(Foundation.Enums.FillBehavior)
local InputSize = require(Foundation.Enums.InputSize)
local OverflowScrollContainer = require(Foundation.Components.OverflowScrollContainer)
local StepperStepState = require(Foundation.Enums.StepperStepState)

local StepItem = require(script.Parent.StepItem)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useAnimatedHighlight = require(Foundation.Utility.useAnimatedHighlight)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = {
	fillBehavior = FillBehavior.Fill,
	size = InputSize.Medium,
	testId = "--foundation-stepper",
	ZIndex = 1
}

local function getStepState(p: number, p2: number, flag: boolean)
	if flag then
		return StepperStepState.Current
	end

	if p < p2 then
		return StepperStepState.Complete
	end

	return StepperStepState.Incomplete
end

local function Stepper(p, p2)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()

	local activeStepId = v2.activeStepId or Dash.get(v2, { "steps", 1, "id" })
	local v4 = Dash.findIndex(v2.steps, function(p3): boolean
		return p3.id == activeStepId
	end) or 1

	local sizefull = v2.fillBehavior == FillBehavior.Fill

	local ref = React.useRef(nil)

	local ref2 = React.useRef({})
	local v5 = React.useMemo(function()
		local current = ref2.current

		for _, step in v2.steps do
			if not current[step.id] then
				current[step.id] = React.createRef()
			end
		end

		return current
	end, { v2.steps })

	local v6 = useAnimatedHighlight(activeStepId, p2 or ref, v5, v2.size, v2.fillBehavior)

	local v7, v8 = React.useBinding(0)
	local onAbsoluteSizeChanged = React.useCallback(function(p3)
		v8(p3.AbsoluteSize.X)
	end, {})

	local standard = v3.Stroke.Standard

	local children = {}

	for i, step in ipairs(v2.steps) do
		local stepState

		if activeStepId == step.id then
			stepState = StepperStepState.Current
		elseif i < v4 then
			stepState = StepperStepState.Complete
		else
			stepState = StepperStepState.Incomplete
		end

		children[`Step{step.id}`] = React.createElement(StepItem, {
			step = step,
			index = i,
			stepState = stepState,
			size = v2.size,
			fillBehavior = v2.fillBehavior,
			LayoutOrder = i,
			testId = `{v2.testId}--step-{step.id}`,
			ref = v5[step.id]
		})
	end

	return React.createElement(View, withCommonProps(v2, {
		tag = "size-full-0 auto-y no-clip",
		sizeConstraint = not sizefull and {
			MaxSize = v7:map(function(p3: number)
				return Vector2.new(p3, 1e999)
			end)
		} or nil
	}), {
		Stepper = React.createElement(View, {
			ref = p2 or ref,
			tag = "col size-full-0 auto-y",
			ZIndex = v2.ZIndex,
			testId = `{v2.testId}--container`
		}, {
			ScrollContainer = React.createElement(
				OverflowScrollContainer,
				{
					LayoutOrder = 1,
					size = v2.size,
					scrimBottomInset = standard,
					testId = `{v2.testId}--scroll-container`
				},
				{
					StepList = React.createElement(View, {
						onAbsoluteSizeChanged = onAbsoluteSizeChanged,
						tag = { ["row flex-y-fill auto-xy"] = true, ["size-full-0"] = sizefull },
						testId = `{v2.testId}--list`
					}, children)
				}
			),
			Border = React.createElement(View, {
				LayoutOrder = 2,
				tag = "position-bottom-left anchor-bottom-left",
				Size = UDim2.new(1, 0, 0, v3.Stroke.Standard),
				backgroundStyle = v3.Color.Stroke.Default,
				testId = `{v2.testId}--border`
			})
		}),
		AnimatedBorder = React.createElement(View, {
			LayoutOrder = 0,
			ZIndex = v2.ZIndex + 1,
			tag = "anchor-bottom-left bg-system-contrast",
			Size = v6.highlightWidth:map(function(p3)
				return UDim2.fromOffset(p3, standard)
			end),
			Position = React.joinBindings({ v6.highlightPosition, v6.activeItemHeight }):map(function(list)
				local item = list[1]
				local item2 = list[2]
				return UDim2.fromOffset(item, item2)
			end),
			testId = `{v2.testId}--animated-border`
		})
	})
end

return React.memo(React.forwardRef(Stepper))
