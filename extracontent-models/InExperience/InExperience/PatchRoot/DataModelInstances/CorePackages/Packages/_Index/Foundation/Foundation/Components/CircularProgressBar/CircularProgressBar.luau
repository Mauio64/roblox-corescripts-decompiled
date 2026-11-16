local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Image = require(Foundation.Components.Image)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = { testId = "--foundation-circular-progress-bar" }

local function CircularProgressBar(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()

	local numberSequence = NumberSequence.new({
		NumberSequenceKeypoint.new(0, v3.Color.Content.Emphasis.Transparency),
		NumberSequenceKeypoint.new(0.4999, v3.Color.Content.Emphasis.Transparency),
		NumberSequenceKeypoint.new(0.5, v3.Color.Content.Muted.Transparency),
		NumberSequenceKeypoint.new(1, v3.Color.Content.Muted.Transparency)
	})

	local colorSequence = ColorSequence.new({
		ColorSequenceKeypoint.new(0, v3.Color.Content.Emphasis.Color3),
		ColorSequenceKeypoint.new(0.4999, v3.Color.Content.Emphasis.Color3),
		ColorSequenceKeypoint.new(0.5, v3.Color.Content.Muted.Color3),
		ColorSequenceKeypoint.new(1, v3.Color.Content.Muted.Color3)
	})

	return React.createElement(View, withCommonProps(v2, { tag = "size-full-full", ref = ref }), {
		LeftGradient = React.createElement(View, {
			Size = UDim2.fromScale(0.5, 1),
			tag = "position-top-left clip"
		}, {
			Image = React.createElement(
				Image,
				{
					Image = "rbxasset://textures/ui/Controls/RadialFill.png",
					Size = UDim2.fromScale(2, 1),
					tag = "position-top-left content-emphasis",
					testId = `{v2.testId}--left-gradient`
				},
				{
					Gradient = React.createElement("UIGradient", {
						Transparency = numberSequence,
						Color = colorSequence,
						Rotation = v2.progress:map(function(p2: number)
							return (math.clamp(p2 * 360, 180, 360))
						end)
					})
				}
			)
		}),
		RightGradient = React.createElement(
			View,
			{ Size = UDim2.fromScale(0.5, 1), tag = "position-top-center clip" },
			{
				Image = React.createElement(Image, {
					Image = "rbxasset://textures/ui/Controls/RadialFill.png",
					Size = UDim2.fromScale(2, 1),
					Position = UDim2.fromScale(-1, 0),
					tag = "content-emphasis",
					testId = `{v2.testId}--right-gradient`
				}, {
					Gradient = React.createElement("UIGradient", {
						Transparency = numberSequence,
						Color = colorSequence,
						Rotation = v2.progress:map(function(p2: number)
							return (math.clamp(p2 * 360, 0, 180))
						end)
					})
				})
			}
		)
	})
end

return React.memo(React.forwardRef(CircularProgressBar))
