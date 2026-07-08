local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Core = ParentParentParent.Core
local React = require(ParentParentParentParent.React)

require(ParentParent.Style.StyleTypes)

local useStyle = require(Core.Style.useStyle)

local function GradientFrame(t1: {[any]: any}) -- line: 29
	-- upvalues: useStyle (copy), React (copy)
	local frameRef = t1.frameRef
	local gradientStyle = t1.gradientStyle
	local height = t1.height
	local t1ZIndex = t1.ZIndex
	local Theme = useStyle().Theme
	local v14 = gradientStyle and gradientStyle.Color or Theme.BackgroundDefault.Color
	local v15 = gradientStyle and gradientStyle.Transparency or Theme.BackgroundDefault.Transparency

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = t1ZIndex,
		ref = frameRef
	}, {
		Left = React.createElement("Frame", {
			BackgroundTransparency = v15,
			BackgroundColor3 = v14,
			Size = UDim2.new(0, 50, 0, height)
		}, {
			Gradient = React.createElement("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}),
		Right = React.createElement("Frame", {
			BackgroundTransparency = v15,
			BackgroundColor3 = v14,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.new(0, 50, 0, height)
		}, {
			Gradient = React.createElement("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0)
				})
			})
		})
	})
end

return GradientFrame
