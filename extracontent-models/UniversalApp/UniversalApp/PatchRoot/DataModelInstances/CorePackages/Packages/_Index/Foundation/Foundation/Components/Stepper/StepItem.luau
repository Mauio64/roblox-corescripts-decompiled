local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)

local FillBehavior = require(Foundation.Enums.FillBehavior)
local Icon = require(Foundation.Components.Icon)
require(Foundation.Enums.InputSize)

local StepperStepState = require(Foundation.Enums.StepperStepState)

local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)

local useStepperVariants = require(script.Parent.useStepperVariants)

local icon = BuilderIcons.Icon
local IconVariant = BuilderIcons.IconVariant

local function StepItem(props, ref)
	local v = useTokens()
	local v2 = props.fillBehavior == FillBehavior.Fill
	local v3 = useStepperVariants(v, props.size, props.stepState, v2)

	local createElement = React.createElement
	local v4 = { tag = v3.container.tag, testId = props.testId, LayoutOrder = props.LayoutOrder }
	local v5 = {
		Measure = React.createElement(View, { LayoutOrder = 1, tag = "size-full", ref = ref }),
		Content = 0
	}

	local createElement2 = React.createElement
	local v6 = {
		LayoutOrder = 2,
		tag = v3.content.tag,
		padding = v3.content.padding,
		testId = `{props.testId}--content`
	}

	local createElement3 = React.createElement
	local v7 = {
		LayoutOrder = 1,
		tag = v3.indicatorOuter.tag,
		testId = `{props.testId}--indicator-outer`
	}

	local createElement4 = React.createElement
	local v8 = { tag = v3.indicatorInner.tag, testId = `{props.testId}--indicator` }
	local stepIndex

	if props.stepState == StepperStepState.Complete then
		stepIndex = React.createElement(Icon, {
			name = icon.Check,
			style = v.Inverse.Content.Emphasis,
			size = v3.icon.size,
			variant = IconVariant.Filled,
			testId = `{props.testId}--check`
		})
	else
		stepIndex = React.createElement(Text, {
			Text = tostring(props.index),
			tag = v3.index.tag,
			testId = `{props.testId}--index`
		})
	end

	local children = {
		IndicatorOuter = createElement3(View, v7, {
			Indicator = createElement4(View, v8, { StepIndex = stepIndex })
		}),
		TextColumn = 0
	}

	local createElement5 = React.createElement
	local v9 = {
		LayoutOrder = 2,
		tag = v3.textColumn.tag,
		padding = v3.textColumn.padding,
		testId = `{props.testId}--text-column`
	}
	local v10 = {
		Label = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.step.label,
			tag = v3.label.tag,
			testId = `{props.testId}--label`
		}),
		Description = 0
	}
	local description

	if props.step.description then
		description = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.step.description,
			tag = v3.description.tag,
			testId = `{props.testId}--description`
		})
	end

	v10.Description = description
	children.TextColumn = createElement5(View, v9, v10)
	v5.Content = createElement2(View, v6, children)
	return createElement(View, v4, v5)
end

return React.memo(React.forwardRef(StepItem))
