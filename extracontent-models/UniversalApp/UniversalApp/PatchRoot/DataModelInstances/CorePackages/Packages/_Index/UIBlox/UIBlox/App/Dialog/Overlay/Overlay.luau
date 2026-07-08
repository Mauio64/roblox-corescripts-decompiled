local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Core = ParentParent.Core
local useStyle = require(Core.Style.useStyle)
local ReactOtter = require(ParentParentParent.ReactOtter)
local t1 = {
	dampingRatio = 1,
	frequency = 3
}
local t2 = {
	top = 270,
	topRight = 305,
	right = 0,
	bottomRight = 45,
	bottom = 90,
	bottomLeft = 135,
	left = 180,
	topLeft = 225
}

local function Overlay(t3: {[any]: any}) -- line: 48
	-- upvalues: useStyle (copy), ReactOtter (copy), React (copy), t1 (copy), t2 (copy)
	local Theme = useStyle().Theme
	local v12 = not t3.showGradient and 1 or 0
	local v13, v14 = ReactOtter.useAnimatedBinding(v12)

	React.useEffect(function() -- line: 55
		-- upvalues: t3 (copy), v14 (copy), ReactOtter (copy), t1 (copy)
		if t3.showGradient == false then
			v14(ReactOtter.spring(1, t1))

			return
		end

		v14(ReactOtter.spring(0, t1))
	end, { t3.showGradient })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.fromScale(1, 1),
		ZIndex = t3.ZIndex
	}, {
		Overlay = React.createElement("Frame", {
			ZIndex = 1,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Theme.Overlay.Color,
			BackgroundTransparency = Theme.Overlay.Transparency
		}),
		Gradient = React.createElement("Frame", {
			ZIndex = 2,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = v13
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = t2[t3.gradientDirection],
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
					ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 0.89)
				})
			})
		})
	})
end

return Overlay
