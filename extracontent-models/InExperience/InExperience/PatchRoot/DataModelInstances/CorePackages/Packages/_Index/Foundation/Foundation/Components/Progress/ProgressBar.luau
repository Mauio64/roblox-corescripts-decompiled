local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local constants = require(script.Parent.constants)
local Flags = require(Foundation.Utility.Flags)
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

local function getBarSequenceFromProgress(value: number?)
	local v = value or 0

	if v == 0 then
		return NumberSequence.new(1)
	elseif v == 1 then
		return NumberSequence.new(0)
	end

	local numberSequenceKeypoints = {
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(v, 0),
		NumberSequenceKeypoint.new(math.min(v + 0.001, 1), 1)
	}

	if v < 0.999 then
		table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1, 1))
	end

	return NumberSequence.new(numberSequenceKeypoints)
end

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

	if Flags.FoundationProgressBarBetaUpdate then
		if v2.size == ProgressSize.Small then
			v5 = ProgressSize.Small
		else
			v5 = ProgressSize.Medium
		end
	else
		v5 = v2.size
	end

	local v6 = useProgressVariants(v3, v5)

	local v7, v8 = useProgressBinding(v2.value)
	local v9 = useRotation(1)
	local v10 = usePulseBinding(1 / constants.INDETERMINATE_SHIMMER_SPEED)
	local transparency = mapBindable(v7, getBarSequenceFromProgress)

	local createElement = React.createElement

	local v11 = {
		tag = Flags.FoundationProgressBarBetaUpdate and "col gap-xsmall size-full-0 auto-y" or "radius-small bg-shift-400",
		Size = 0,
		ref = 0
	}
	local size

	if Flags.FoundationProgressBarBetaUpdate then
		size = UDim2.new(v2.width, UDim.new(0, 0))
	else
		size = UDim2.new(v2.width, UDim.new(0, v6.bar.height))
	end

	v11.Size = size

	v11.ref = v2.ref
	local v12 = withCommonProps(v2, v11)
	local children

	if Flags.FoundationProgressBarBetaUpdate then
		children = { Track = 0, Labels = 0 }
		local createElement2 = React.createElement
		local v13 = {
			Size = UDim2.new(UDim.new(1, 0), UDim.new(0, v6.bar.height)),
			cornerRadius = UDim.new(0, v3.Radius.Circle),
			tag = "size-full-0 clip bg-shift-400",
			LayoutOrder = 1,
			testId = `{v2.testId}--track`
		}

		local createElement3 = React.createElement

		local v14 = {
			backgroundStyle = v3.Color.Content.Emphasis,
			cornerRadius = UDim.new(0, v3.Radius.Circle),
			Size = 0,
			tag = 0,
			testId = 0
		}
		local size2

		if v8 then
			size2 = UDim2.fromScale(1, 1)
		else
			size2 = mapBindable(v7, getFillSizeFromProgress)
		end

		v14.Size = size2

		v14.tag = v8 and "size-full" or nil
		v14.testId = `{v2.testId}--fill`
		children.Track = createElement2(View, v13, {
			Fill = createElement3(View, v14, v8 and {
				Gradient = React.createElement(ProgressBarIndeterminateGradient, {
					emphasisColor3 = v3.Color.Content.Emphasis.Color3,
					emphasisTransparency = v3.Color.Content.Emphasis.Transparency,
					reducedMotion = v4.reducedMotion,
					testId = `{v2.testId}--fill--gradient`
				})
			} or nil)
		})
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

		children.Labels = labels
	else
		children = { Fill = 0 }
		local createElement2 = React.createElement
		local v13 = {
			backgroundStyle = v3.Color.Content.Emphasis,
			tag = "size-full radius-small",
			ref = v2.ref,
			testId = `{v2.testId}--fill`
		}

		local createElement3 = React.createElement
		local v14 = {
			Color = ColorSequence.new(v3.Color.Content.Emphasis.Color3),
			Transparency = 0,
			Offset = 0
		}

		if v8 then
			transparency = v10:map(function(p2: number)
				if v4.reducedMotion then
					return NumberSequence.new(p2)
				end

				return NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.2, 1),
					NumberSequenceKeypoint.new(0.5, v3.Color.Content.Emphasis.Transparency),
					NumberSequenceKeypoint.new(0.8, 1),
					NumberSequenceKeypoint.new(1, 1)
				})
			end)
		end

		v14.Transparency = transparency
		local offset

		if v8 then
			offset = v9:map(function(p2: number)
				if v4.reducedMotion then
					return Vector2.new(0, 0)
				end

				return Vector2.new(p2 * constants.INDETERMINATE_SHIMMER_SPEED % 360 / 360 * 2 - 1, 0)
			end)
		end

		v14.Offset = offset
		children.Fill = createElement2(View, v13, {
			Gradient = createElement3("UIGradient", v14)
		})
	end

	return createElement(View, v12, children)
end

return ProgressBar
