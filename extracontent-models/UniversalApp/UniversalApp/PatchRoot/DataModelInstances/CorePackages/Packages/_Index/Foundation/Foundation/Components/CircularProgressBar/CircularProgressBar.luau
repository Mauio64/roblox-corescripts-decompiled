local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Image = require(Foundation.Components.Image)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local t1 = {
	testId = "--foundation-circular-progress-bar"
}

local function CircularProgressBar(p1, p2) -- line: 22
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), React (copy), View (copy), withCommonProps (copy), Image (copy)
	local v13 = withDefaults(p1, t1)
	local v14 = useTokens()
	local numberSequence = NumberSequence.new({
		NumberSequenceKeypoint.new(0, v14.Color.Content.Emphasis.Transparency),
		NumberSequenceKeypoint.new(0.4999, v14.Color.Content.Emphasis.Transparency),
		NumberSequenceKeypoint.new(0.5, v14.Color.Content.Muted.Transparency),
		NumberSequenceKeypoint.new(1, v14.Color.Content.Muted.Transparency)
	})
	local colorSequence = ColorSequence.new({
		ColorSequenceKeypoint.new(0, v14.Color.Content.Emphasis.Color3),
		ColorSequenceKeypoint.new(0.4999, v14.Color.Content.Emphasis.Color3),
		ColorSequenceKeypoint.new(0.5, v14.Color.Content.Muted.Color3),
		ColorSequenceKeypoint.new(1, v14.Color.Content.Muted.Color3)
	})

	return React.createElement(View, withCommonProps(v13, {
		tag = "size-full-full",
		ref = p2
	}), {
		LeftGradient = React.createElement(View, {
			tag = "position-top-left clip",
			Size = UDim2.fromScale(0.5, 1)
		}, {
			Image = React.createElement(Image, {
				Image = "rbxasset://textures/ui/Controls/RadialFill.png",
				tag = "position-top-left content-emphasis",
				Size = UDim2.fromScale(2, 1),
				testId = `{ v13.testId }--left-gradient`
			}, {
				Gradient = React.createElement("UIGradient", {
					Transparency = numberSequence,
					Color = colorSequence,
					Rotation = v13.progress:map(function(n1: number) -- line: 60
						return (math.clamp(n1 * 360, 180, 360))
					end)
				})
			})
		}),
		RightGradient = React.createElement(View, {
			tag = "position-top-center clip",
			Size = UDim2.fromScale(0.5, 1)
		}, {
			Image = React.createElement(Image, {
				Image = "rbxasset://textures/ui/Controls/RadialFill.png",
				tag = "content-emphasis",
				Size = UDim2.fromScale(2, 1),
				Position = UDim2.fromScale(-1, 0),
				testId = `{ v13.testId }--right-gradient`
			}, {
				Gradient = React.createElement("UIGradient", {
					Transparency = numberSequence,
					Color = colorSequence,
					Rotation = v13.progress:map(function(n2: number) -- line: 80
						return (math.clamp(n2 * 360, 0, 180))
					end)
				})
			})
		})
	})
end

return React.memo(React.forwardRef(CircularProgressBar))
