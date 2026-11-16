local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roactFitComponents = dependencies.RoactFitComponents
local fitFrameOnAxis = roactFitComponents.FitFrameOnAxis
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox

local rect = Rect.new(10, 10, 11, 11)

local extended = roact.PureComponent:extend("ChatBubbleContainer")
extended.TAIL_WIDTH = 6

extended.defaultProps = {
	isIncoming = false,
	hasTail = false,
	padding = 12,
	LayoutOrder = 0,
	isPending = false,
	[roact.Change.AbsoluteSize] = function() end,
	overrideImageColor = false
}

function extended:init()
	local binding, updateBubbleSize = roact.createBinding(Vector2.new(0, 0))
	self.bubbleSize = binding
	self.updateBubbleSize = updateBubbleSize
end

function extended.render(data)
	return uiBlox.Style.withStyle(function(p)
		local v = data.props[roact.Children] or {}
		local hasTail = data.props.hasTail
		local isIncoming = data.props.isIncoming
		local isPending = data.props.isPending
		local v2

		if isIncoming then
			v2 = p.Theme.UIDefault
		elseif isPending then
			v2 = p.Theme.UIMuted
		else
			v2 = p.Theme.UIEmphasis
		end

		local color = v2.Color
		local transparency = v2.Transparency

		if data.props.overrideImageColor then
			color = nil

			if not isPending then
				transparency = nil
			end
		end

		local udim = isIncoming and UDim2.new(0, data.TAIL_WIDTH, 0, 0) or UDim2.new(1, -data.TAIL_WIDTH, 0, 0)

		local udim2 = isIncoming and UDim2.new(0, 0, 0, 0) or UDim2.new(1, 0, 0, 0)

		return roact.createElement("Frame", {
			Size = data.bubbleSize:map(function(p2)
				return UDim2.new(0, p2.X + data.TAIL_WIDTH, 0, p2.Y)
			end),
			LayoutOrder = data.props.LayoutOrder,
			BackgroundTransparency = 1
		}, {
			bubble = roact.createElement(fitFrameOnAxis, {
				AnchorPoint = isIncoming and Vector2.new(0, 0) or Vector2.new(1, 0),
				axis = fitFrameOnAxis.Axis.Both,
				BackgroundTransparency = 1,
				ImageColor3 = color,
				ImageSet = {
					Image = hasTail and (isIncoming and "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble.png" or "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-self.png") or "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-self2.png",
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = rect
				},
				ImageTransparency = transparency,
				margin = roactFitComponents.Rect.square(data.props.padding),
				Position = udim,
				[roact.Change.AbsoluteSize] = function(p2)
					data.updateBubbleSize(p2.AbsoluteSize)
					data.props[roact.Change.AbsoluteSize](p2)
				end
			}, v),
			tail = roact.createElement("ImageLabel", {
				AnchorPoint = isIncoming and Vector2.new(0, 0) or Vector2.new(1, 0),
				Size = UDim2.new(0, data.TAIL_WIDTH, 0, data.TAIL_WIDTH),
				BackgroundTransparency = 1,
				ImageColor3 = color,
				Position = udim2,
				Image = isIncoming and "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-tip.png" or "rbxasset://textures/ui/LuaChat/9-slice/chat-bubble-self-tip.png",
				ImageTransparency = transparency,
				Visible = hasTail
			})
		})
	end)
end

return extended
