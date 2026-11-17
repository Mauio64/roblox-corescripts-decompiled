local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local constants = require(script.Parent.constants)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local getTestIdTag = require(Foundation.Utility.getTestIdTag)
local mapBindable = require(Foundation.Utility.mapBindable)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local useProgressBinding = require(script.Parent.useProgressBinding)
local useProgressVariants = require(script.Parent.useProgressVariants)
local usePulseBinding = require(Foundation.Utility.usePulseBinding)
local useRotation = require(Foundation.Utility.useRotation)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

require(Foundation.Enums.ProgressShape)

local ProgressSize = require(Foundation.Enums.ProgressSize)

local function getFillSizeFromProgress(value: number?)
	return UDim2.fromScale(value or 0, 1)
end

local function getIndeterminateShimmerTransparency(p: number, reducedMotion: boolean, emphasisTransparency: number)
	if reducedMotion then
		return NumberSequence.new(p)
	end

	return NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.2, 1),
		NumberSequenceKeypoint.new(0.5, emphasisTransparency),
		NumberSequenceKeypoint.new(0.8, 1),
		NumberSequenceKeypoint.new(1, 1)
	})
end

local function getIndeterminateShimmerOffset(p: number, reducedMotion: boolean)
	if reducedMotion then
		return Vector2.new(0, 0)
	end

	return Vector2.new(p * constants.INDETERMINATE_SHIMMER_SPEED % 360 / 360 * 2 - 1, 0)
end

local function ProgressBarIndeterminateGradient(props)
	local v = useRotation(1)
	local v2 = usePulseBinding(1 / constants.INDETERMINATE_SHIMMER_SPEED)

	return React.createElement("UIGradient", {
		Color = ColorSequence.new(props.emphasisColor3),
		Transparency = v2:map(function(p: number)
			return getIndeterminateShimmerTransparency(p, props.reducedMotion, props.emphasisTransparency)
		end),
		Offset = v:map(function(p: number)
			return getIndeterminateShimmerOffset(p, props.reducedMotion)
		end),
		[React.Tag] = getTestIdTag(props.testId)
	})
end

local v = {
	size = ProgressSize.Medium,
	width = UDim.new(1, 0),
	showLabel = false,
	minValueLabel = "0",
	maxValueLabel = "100"
}

local function ProgressBar(p)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local v4 = usePreferences()
	local v5

	if v2.size == ProgressSize.Small then
		v5 = ProgressSize.Small
	else
		v5 = ProgressSize.Medium
	end

	local v6 = useProgressVariants(v3, v5)

	local v7, v8 = useProgressBinding(v2.value)

	local createElement = React.createElement

	local v9 = withCommonProps(v2, {
		tag = "col gap-xsmall size-full-0 auto-y",
		Size = UDim2.new(v2.width, UDim.new(0, 0)),
		ref = v2.ref
	})

	local createElement2 = React.createElement
	local v11 = {
		Size = UDim2.new(UDim.new(1, 0), UDim.new(0, v6.bar.height)),
		cornerRadius = UDim.new(0, v3.Radius.Circle),
		tag = "size-full-0 clip bg-shift-400",
		LayoutOrder = 1,
		testId = `{v2.testId}--track`
	}

	local createElement3 = React.createElement

	local v12 = {
		backgroundStyle = v3.Color.Content.Emphasis,
		cornerRadius = UDim.new(0, v3.Radius.Circle),
		Size = 0,
		tag = 0,
		testId = 0
	}
	local size

	if v8 then
		size = UDim2.fromScale(1, 1)
	else
		size = mapBindable(v7, getFillSizeFromProgress)
	end

	v12.Size = size

	v12.tag = v8 and "size-full" or nil
	v12.testId = `{v2.testId}--fill`
	local v10 = {
		Track = createElement2(View, v11, {
			Fill = createElement3(View, v12, v8 and {
				Gradient = React.createElement(ProgressBarIndeterminateGradient, {
					emphasisColor3 = v3.Color.Content.Emphasis.Color3,
					emphasisTransparency = v3.Color.Content.Emphasis.Transparency,
					reducedMotion = v4.reducedMotion,
					testId = `{v2.testId}--fill--gradient`
				})
			} or nil)
		}),
		Labels = 0
	}
	local labels

	if v2.showLabel and not v8 then
		labels = React.createElement(
			View,
			{ tag = "row size-full-0 auto-y", LayoutOrder = 2, testId = `{v2.testId}--labels` },
			{
				MinValue = React.createElement(Text, {
					Text = v2.minValueLabel,
					tag = "fill auto-xy text-label-medium text-align-x-left content-default",
					LayoutOrder = 1,
					testId = `{v2.testId}--label-min`
				}),
				MaxValue = React.createElement(Text, {
					Text = v2.maxValueLabel,
					tag = "fill auto-xy text-label-medium text-align-x-right content-default",
					LayoutOrder = 2,
					testId = `{v2.testId}--label-max`
				})
			}
		)
	end

	v10.Labels = labels
	return createElement(View, v9, v10)
end

return ProgressBar
