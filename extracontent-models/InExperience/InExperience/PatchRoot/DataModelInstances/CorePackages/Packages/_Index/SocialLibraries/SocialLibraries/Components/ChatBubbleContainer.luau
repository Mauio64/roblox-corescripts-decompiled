local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local RoactFitComponents = dependencies.RoactFitComponents
local FitFrameOnAxis = RoactFitComponents.FitFrameOnAxis
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local rect = Rect.new(10, 10, 11, 11)
local v8 = Roact.PureComponent:extend("ChatBubbleContainer")

v8.TAIL_WIDTH = 6
v8.defaultProps = {
	isIncoming = false,
	hasTail = false,
	padding = 12,
	LayoutOrder = 0,
	isPending = false,
	[Roact.Change.AbsoluteSize] = function() -- line: 24
	end,
	overrideImageColor = false
}

function v8.init(p1) -- line: 29
	-- upvalues: Roact (copy)
	local v10, v11 = Roact.createBinding(Vector2.new(0, 0))

	p1.bubbleSize = v10
	p1.updateBubbleSize = v11
end
function v8.render(p2) -- line: 33
	-- upvalues: UIBlox (copy), Roact (copy), FitFrameOnAxis (copy), rect (copy), RoactFitComponents (copy)
	return UIBlox.Style.withStyle(function(p3) -- line: 34
		-- upvalues: p2 (copy), Roact (copy), FitFrameOnAxis (copy), rect (copy), RoactFitComponents (copy)
		local v14 = p2.props[Roact.Children] or {}
		local hasTail = p2.props.hasTail
		local isIncoming = p2.props.isIncoming
		local isPending = p2.props.isPending
		local v18 = if not isIncoming then if not isPending then p3.Theme.UIEmphasis else p3.Theme.UIMuted else p3.Theme.UIDefault
		local Color = v18.Color
		local Transparency = v18.Transparency

		if p2.props.overrideImageColor then
			Color = nil

			if not isPending then
				Transparency = nil
			end
		end

		local s1 = "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-self2.png"

		if hasTail then
			s1 = not isIncoming and "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-self.png" or "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble.png"
		end

		local v22 = isIncoming and UDim2.new(0, p2.TAIL_WIDTH, 0, 0) or UDim2.new(1, -p2.TAIL_WIDTH, 0, 0)
		local v23 = not isIncoming and "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-self-tip.png" or "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-tip.png"
		local v24 = isIncoming and UDim2.new(0, 0, 0, 0) or UDim2.new(1, 0, 0, 0)

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = p2.bubbleSize:map(function(p4) -- line: 69
				-- upvalues: p2 (copy)
				return UDim2.new(0, p4.X + p2.TAIL_WIDTH, 0, p4.Y)
			end),
			LayoutOrder = p2.props.LayoutOrder
		}, {
			bubble = Roact.createElement(FitFrameOnAxis, {
				AnchorPoint = isIncoming and Vector2.new(0, 0) or Vector2.new(1, 0),
				axis = FitFrameOnAxis.Axis.Both,
				BackgroundTransparency = 1,
				ImageColor3 = Color,
				ImageSet = {
					Image = s1,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = rect
				},
				ImageTransparency = Transparency,
				margin = RoactFitComponents.Rect.square(p2.props.padding),
				Position = v22,
				[Roact.Change.AbsoluteSize] = function(p5) -- line: 88
					-- upvalues: p2 (copy), Roact (copy)
					p2.updateBubbleSize(p5.AbsoluteSize)
					p2.props[Roact.Change.AbsoluteSize](p5)
				end
			}, v14),
			tail = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = isIncoming and Vector2.new(0, 0) or Vector2.new(1, 0),
				Size = UDim2.new(0, p2.TAIL_WIDTH, 0, p2.TAIL_WIDTH),
				ImageColor3 = Color,
				Position = v24,
				Image = v23,
				ImageTransparency = Transparency,
				Visible = hasTail
			})
		})
	end)
end

return v8
