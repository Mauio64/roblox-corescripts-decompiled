local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local FoundationImage = Foundation.Image
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function RadialProgressBar(t1: {[any]: any}) -- line: 18
	-- upvalues: useTokens (copy), React (copy), View (copy), FoundationImage (copy)
	local v9 = useTokens()
	local Background = v9.Color.ActionSubtle.Background
	local Foreground = v9.Color.ActionSubtle.Foreground
	local numberSequence = NumberSequence.new({
		NumberSequenceKeypoint.new(0, Foreground.Transparency),
		NumberSequenceKeypoint.new(0.4999, Foreground.Transparency),
		NumberSequenceKeypoint.new(0.5, Background.Transparency),
		NumberSequenceKeypoint.new(1, Background.Transparency)
	})
	local colorSequence = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Foreground.Color3),
		ColorSequenceKeypoint.new(0.4999, Foreground.Color3),
		ColorSequenceKeypoint.new(0.5, Background.Color3),
		ColorSequenceKeypoint.new(1, Background.Color3)
	})

	return React.createElement(View, {
		BackgroundTransparency = 1,
		tag = "anchor-center-center bg-action-subtle position-center-center size-full"
	}, {
		LeftGradient = React.createElement(View, {
			tag = "bg-action-subtle clip",
			Size = UDim2.fromScale(0.5, 1)
		}, {
			Image = React.createElement(FoundationImage, {
				Image = "rbxasset://textures/ui/Controls/RadialFill.png",
				Size = UDim2.fromScale(2, 1)
			}, {
				Gradient = React.createElement("UIGradient", {
					Transparency = numberSequence,
					Color = colorSequence,
					Rotation = t1.progress:map(function(n1: number) -- line: 52
						return (math.clamp(n1 * 360, 180, 360))
					end)
				})
			})
		}),
		RightGradient = React.createElement(View, {
			tag = "bg-action-subtle clip position-top-center",
			Size = UDim2.fromScale(0.5, 1)
		}, {
			Image = React.createElement(FoundationImage, {
				Image = "rbxasset://textures/ui/Controls/RadialFill.png",
				Size = UDim2.fromScale(2, 1),
				Position = UDim2.fromScale(-1, 0)
			}, {
				Gradient = React.createElement("UIGradient", {
					Transparency = numberSequence,
					Color = colorSequence,
					Rotation = t1.progress:map(function(n2: number) -- line: 71
						return (math.clamp(n2 * 360, 0, 180))
					end)
				})
			})
		})
	})
end

return React.memo(React.forwardRef(RadialProgressBar))
