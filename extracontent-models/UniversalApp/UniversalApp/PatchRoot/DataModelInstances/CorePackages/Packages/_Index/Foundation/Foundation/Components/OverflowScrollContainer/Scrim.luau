local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(parent.Otter)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local BackgroundStyleContext = require(Foundation.Providers.Style.BackgroundStyleContext)
local Icon = require(Foundation.Components.Icon)
require(Foundation.Enums.InputSize)
local Tokens = require(Foundation.Providers.Style.Tokens)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useBackgroundStyle = BackgroundStyleContext.useBackgroundStyle
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local useScrimVariants = require(script.Parent.useScrimVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)

local v = {
	easingStyle = Tokens.defaultTokens.Ease.StandardOut,
	duration = Tokens.defaultTokens.Time.Time_200
}

local function lerpNumberSequence(gradient, hoverGradient, p: number)
	local keypoints = gradient.Keypoints
	local keypoints2 = hoverGradient.Keypoints
	local numberSequenceKeypoints = {}

	for k, keypoint in keypoints do
		local keypoint2 = keypoints2[k]
		numberSequenceKeypoints[k] = NumberSequenceKeypoint.new(
			keypoint.Time + (keypoint2.Time - keypoint.Time) * p,
			keypoint.Value + (keypoint2.Value - keypoint.Value) * p
		)
	end

	return NumberSequence.new(numberSequenceKeypoints)
end

local function Scrim(props)
	local v2 = useTokens()
	local backgroundStyle = useBackgroundStyle()
	local v3 = useScrimVariants(v2, props.alignment, props.preferredInput)

	local v4 = props.alignment == Enum.HorizontalAlignment.Right
	local v5 = props.preferredInput == Enum.PreferredInput.Touch or props.preferredInput == Enum.PreferredInput.Gamepad

	local v6, v7 = ReactOtter.useAnimatedBinding(props.isHovered and 1 or 0)
	React.useEffect(function()
		v7(ReactOtter.ease(props.isHovered and 1 or 0, v))
	end, { props.isHovered })

	local mapped = v6:map(function(p)
		if v5 then
			return UDim2.fromScale(0.5, 0.5)
		end

		return UDim2.fromScale(0.5 + (v4 and 1 or -1) * (1 - p), 0.5)
	end)

	local mapped2 = props.rowHeight:map(function(p: number)
		return UDim2.new(0, p + v3.fade, 1, 0)
	end)

	local mapped3 = v6:map(function(p)
		if v5 then
			return v3.hoverGradient
		end

		return lerpNumberSequence(v3.gradient, v3.hoverGradient, p)
	end)

	local groupTransparency, v8 = ReactOtter.useAnimatedBinding(props.isVisible and 0 or 1)
	React.useEffect(function()
		v8(ReactOtter.ease(props.isVisible and 0 or 1, v))
	end, { props.isVisible })

	return React.createElement(
		View,
		withCommonProps(props, { Size = mapped2, GroupTransparency = groupTransparency }),
		{
			Scrim = React.createElement(View, {
				tag = "size-full",
				backgroundStyle = backgroundStyle,
				onActivated = props.onActivated,
				stateLayer = { affordance = StateLayerAffordance.None },
				onStateChanged = props.onStateChanged,
				isDisabled = not props.isVisible,
				selection = { Selectable = false },
				testId = `{props.testId}--button`
			}, {
				Gradient = React.createElement("UIGradient", { Transparency = mapped3 }),
				DirectionIcon = React.createElement(View, {
					tag = v3.iconAlignmentTag,
					Size = UDim2.fromScale(0, 1),
					aspectRatio = {
						AspectRatio = 1,
						AspectType = Enum.AspectType.ScaleWithParentSize,
						DominantAxis = Enum.DominantAxis.Height
					},
					ZIndex = 2
				}, {
					Icon = React.createElement(Icon, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = mapped,
						size = props.size,
						name = v3.directionIcon,
						testId = `{props.testId}--direction-indicator`
					})
				})
			})
		}
	)
end

return Scrim
