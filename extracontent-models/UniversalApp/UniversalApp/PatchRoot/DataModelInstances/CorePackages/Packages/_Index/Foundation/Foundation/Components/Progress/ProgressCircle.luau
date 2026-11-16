local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local constants = require(script.Parent.constants)
local Image = require(Foundation.Components.Image)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
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

local v = { size = ProgressSize.Medium }

local function getRotationFromProgress(p: number?, side) -- 1 equivalent call inferred from this helper
	local v2 = side == Enum.HorizontalAlignment.Left and 180 or 0
	local v3 = side == Enum.HorizontalAlignment.Left and 360 or 180

	if p == nil then
		return 0
	end

	return (math.clamp(p * 360, v2, v3))
end

local function getLabelFromProgress(p: number?)
	if p == nil then
		return "0%"
	end

	return `{math.floor(p * 100)}%`
end

local function getCapAngleFromProgress(value: number?)
	return math.clamp(value or 0, 0, 1) * 360
end

local function hasVisibleArc(value: number?): boolean
	return (value or 0) > 0
end

local function ArcCap(props)
	local v2 = useTokens()

	return React.createElement(View, {
		Size = UDim2.fromScale(1, 1),
		Rotation = props.angle,
		Visible = props.isVisible,
		ZIndex = 2,
		testId = props.testId
	}, {
		Cap = React.createElement(View, {
			Position = UDim2.fromScale(0.5, 5 / 116),
			Size = UDim2.fromScale(5 / 58, 5 / 58),
			backgroundStyle = v2.Color.Content.Emphasis,
			tag = "anchor-center-center radius-circle",
			ZIndex = 2
		})
	})
end

local function ArcCaps(p)
	local isVisible = mapBindable(p.progress, hasVisibleArc)

	return React.createElement(React.Fragment, {}, {
		StartCap = React.createElement(ArcCap, {
			angle = 0,
			isVisible = isVisible,
			testId = `{p.testId}--start-cap`
		}),
		EndCap = React.createElement(ArcCap, {
			angle = mapBindable(p.progress, getCapAngleFromProgress),
			isVisible = isVisible,
			testId = `{p.testId}--end-cap`
		})
	})
end

local function ProgressGradient(props)
	local side = props.side
	local isIndeterminate = props.isIndeterminate
	local progress = props.progress
	local pulse = props.pulse

	local v2 = useTokens()
	local v3 = usePreferences()

	local transparency = React.useMemo(function()
		local transparency = v2.Color.Content.Emphasis.Transparency
		local v4 = isIndeterminate and 1 or v2.Color.Shift.Shift_200.Transparency

		return NumberSequence.new({
			NumberSequenceKeypoint.new(0, transparency),
			NumberSequenceKeypoint.new(0.4999, transparency),
			NumberSequenceKeypoint.new(0.5, v4),
			NumberSequenceKeypoint.new(1, v4)
		})
	end, { v2, isIndeterminate })

	local color = React.useMemo(function()
		return ColorSequence.new({
			ColorSequenceKeypoint.new(0, v2.Color.Content.Emphasis.Color3),
			ColorSequenceKeypoint.new(0.4999, v2.Color.Content.Emphasis.Color3),
			ColorSequenceKeypoint.new(0.5, v2.Color.Shift.Shift_200.Color3),
			ColorSequenceKeypoint.new(1, v2.Color.Shift.Shift_200.Color3)
		})
	end, { v2 })

	if isIndeterminate and v3.reducedMotion and pulse then
		return React.createElement("UIGradient", {
			Transparency = pulse:map(function(p: number)
				return NumberSequence.new((math.lerp(
					v2.Color.Content.Emphasis.Transparency,
					v2.Color.Shift.Shift_200.Transparency,
					p
				)))
			end),
			Color = pulse:map(function(p: number)
				return ColorSequence.new(v2.Color.Content.Emphasis.Color3:Lerp(v2.Color.Shift.Shift_200.Color3, p))
			end),
			Rotation = side == Enum.HorizontalAlignment.Left and 0 or 180
		})
	end

	return (React.createElement("UIGradient", {
		Transparency = transparency,
		Color = color,
		Rotation = mapBindable(progress, function(p: number?)
			return getRotationFromProgress(p, side) -- inferred equivalent call
		end)
	}))
end

local function ProgressRing(props)
	local createElement = React.createElement
	local fragment = React.Fragment
	local v2 = {
		LeftGradient = React.createElement(
			View,
			{
				Size = UDim2.fromScale(0.5, 1),
				tag = "position-top-left clip",
				testId = `{props.testId}--left-gradient`
			},
			{
				Image = React.createElement(
					Image,
					{
						Image = "rbxasset://textures/ui/Controls/RadialFill.png",
						Size = UDim2.fromScale(2, 1),
						tag = "position-top-left content-emphasis"
					},
					{
						Gradient = React.createElement(ProgressGradient, {
							side = Enum.HorizontalAlignment.Left,
							isIndeterminate = props.isIndeterminate,
							progress = props.progress,
							pulse = props.pulse
						})
					}
				)
			}
		),
		RightGradient = React.createElement(
			View,
			{
				Size = UDim2.fromScale(0.5, 1),
				tag = "position-top-center clip",
				testId = `{props.testId}--right-gradient`
			},
			{
				Image = React.createElement(
					Image,
					{
						Image = "rbxasset://textures/ui/Controls/RadialFill.png",
						Size = UDim2.fromScale(2, 1),
						Position = UDim2.fromScale(-1, 0),
						tag = "content-emphasis"
					},
					{
						Gradient = React.createElement(ProgressGradient, {
							side = Enum.HorizontalAlignment.Right,
							isIndeterminate = props.isIndeterminate,
							progress = props.progress,
							pulse = props.pulse
						})
					}
				)
			}
		),
		Caps = 0
	}
	local caps

	if props.hasCaps then
		caps = React.createElement(ArcCaps, { progress = props.progress, testId = props.testId })
	end

	v2.Caps = caps
	return createElement(fragment, {}, v2)
end

local function SpinningRing(props)
	return React.createElement(
		View,
		{
			Size = props.size,
			Rotation = props.rotation,
			testId = `{props.testId}--indeterminate-container`
		},
		{
			Ring = React.createElement(ProgressRing, {
				progress = 0.8,
				isIndeterminate = true,
				hasCaps = props.hasCaps,
				testId = props.testId
			})
		}
	)
end

local function ProgressCircle(p)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local v4 = usePreferences()
	local v5 = useProgressVariants(v3, v2.size)
	local progress, isIndeterminate = useProgressBinding(v2.value)
	local rotation = useRotation(1)
	local pulse = usePulseBinding(1 / constants.INDETERMINATE_SHIMMER_SPEED)

	local udim = UDim2.fromOffset(v5.circle.size, v5.circle.size)

	if isIndeterminate and not v4.reducedMotion then
		return React.createElement(View, withCommonProps(v2, { tag = "auto-xy", ref = v2.ref }), {
			IndeterminateContainer = React.createElement(SpinningRing, {
				size = udim,
				rotation = rotation,
				hasCaps = true,
				testId = v2.testId
			})
		})
	end

	local createElement = React.createElement

	local v6 = withCommonProps(v2, { Size = udim, ref = v2.ref })

	local v7 = {
		Ring = React.createElement(ProgressRing, {
			progress = progress,
			isIndeterminate = isIndeterminate,
			pulse = pulse,
			hasCaps = not isIndeterminate,
			testId = v2.testId
		}),
		ProgressLabel = 0
	}
	local progressLabel

	if v5.circle.labelFont and not isIndeterminate then
		progressLabel = React.createElement(Text, {
			Text = mapBindable(progress, getLabelFromProgress),
			fontStyle = v5.circle.labelFont,
			tag = "position-center-center anchor-center-center",
			testId = `{v2.testId}--label`
		})
	end

	v7.ProgressLabel = progressLabel
	return createElement(View, v6, v7)
end

return ProgressCircle
