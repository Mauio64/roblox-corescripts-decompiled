local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/ArgCheck")

local graphite = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style").Colors.Graphite

local extended = Roact.PureComponent:extend("WindowedListFrame")

function extended:init()
	self.state = { windowStart = 1, windowSize = 5, topPadding = 0 }

	function self.updateWindow(p2)
		local v5 = self.props.ButtonSizeY + 1

		local y = p2.AbsoluteSize.Y
		local y2 = p2.CanvasPosition.Y

		if y > 0 then
			local v6 = math.max(1, math.floor(y2 / v5) + 1)
			local v7 = math.floor(y / v5) + 2

			if v6 ~= self.state.windowStart or v7 ~= self.state.windowSize then
				self:setState({
					windowStart = v6,
					windowSize = v7,
					topPadding = v5 * (v6 - 1)
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

	local v5 = #list
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
			local v6 = i + i
			children[v6] = Roact.createElement(listButton, {
				Size = UDim2.new(1, 0, 0, props.props.ButtonSizeY),
				LayoutOrder = v6,
				Data = item,
				ListButtonProps = listButtonProps
			})

			local v7 = v6 + 1
			children[v7] = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = graphite,
				LayoutOrder = v7,
				BorderSizePixel = 0
			})
		end
	end

	return Roact.createElement("ScrollingFrame", {
		Position = UDim2.new(0, 0, 0, props.props.ScrollingFrameOffset),
		Size = UDim2.new(1, 8, 1, -props.props.ScrollingFrameOffset),
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = graphite,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, v5 * (props.props.ButtonSizeY + 1)),
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
