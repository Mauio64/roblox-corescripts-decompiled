local parent = script:FindFirstAncestor("AuthCommon").Parent

local Roact = require(parent.Roact)
local ArgCheck = require(parent.ArgCheck)

local Style = require(parent.Style)
local Graphite = Style.Colors.Graphite

local extended = Roact.PureComponent:extend("WindowedListFrame")

function extended:init()
	self.state = { windowStart = 1, windowSize = 5, topPadding = 0 }

	function self.updateWindow(p)
		local v = self.props.ButtonSizeY + 1

		local y = p.AbsoluteSize.Y
		local y2 = p.CanvasPosition.Y

		if y > 0 then
			local windowStart = math.max(1, math.floor(y2 / v) + 1)
			local windowSize = math.floor(y / v) + 2

			if windowStart ~= self.state.windowStart or windowSize ~= self.state.windowSize then
				self:setState({
					windowStart = windowStart,
					windowSize = windowSize,
					topPadding = v * (windowStart - 1)
				})
			end
		end
	end
end

extended.defaultProps = {
	List = {},
	ButtonSizeY = 20,
	ScrollingFrameOffset = 0,
	ListButtonProps = {}
}

function extended.render(props)
	local listButton = props.props.ListButton
	local listButtonProps = props.props.ListButtonProps
	local list = props.props.List

	local v = #list
	local children = { Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}) }

	ArgCheck.isInTypes(listButton, { "function", "table" }, "ListButton prop in WindowedListFrame")

	if listButton then
		local windowStart = props.state.windowStart
		local windowSize = props.state.windowSize

		for i = windowStart, math.min(#list, windowStart + windowSize) do
			local item = list[i]
			local layoutOrder = i + i
			children[layoutOrder] = Roact.createElement(listButton, {
				Size = UDim2.new(1, 0, 0, props.props.ButtonSizeY),
				LayoutOrder = layoutOrder,
				Data = item,
				ListButtonProps = listButtonProps
			})

			layoutOrder += 1
			children[layoutOrder] = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = Graphite,
				LayoutOrder = layoutOrder,
				BorderSizePixel = 0
			})
		end
	end

	return Roact.createElement("ScrollingFrame", {
		Position = UDim2.new(0, 0, 0, props.props.ScrollingFrameOffset),
		Size = UDim2.new(1, 8, 1, -props.props.ScrollingFrameOffset),
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = Graphite,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, v * (props.props.ButtonSizeY + 1)),
		[Roact.Change.CanvasPosition] = props.updateWindow,
		[Roact.Change.AbsoluteSize] = props.updateWindow
	}, {
		ListHolder = Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, -8, 0, 1),
				Position = UDim2.new(0, 0, 0, props.state.topPadding),
				BackgroundTransparency = 1
			},
			children
		)
	})
end

return extended
