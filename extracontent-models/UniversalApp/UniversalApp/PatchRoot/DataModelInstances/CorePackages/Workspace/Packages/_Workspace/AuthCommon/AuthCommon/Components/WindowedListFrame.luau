local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Roact = require(Parent.Roact)
local ArgCheck = require(Parent.ArgCheck)
local Graphite = require(Parent.Style).Colors.Graphite
local v5 = Roact.PureComponent:extend("WindowedListFrame")

function v5.init(p1) -- line: 17
	p1.state = {
		windowStart = 1,
		windowSize = 5,
		topPadding = 0
	}

	function p1.updateWindow(p2) -- line: 24
		-- upvalues: p1 (copy)
		local v20 = p1.props.ButtonSizeY + 1
		local AbsoluteSizeY = p2.AbsoluteSize.Y
		local CanvasPositionY = p2.CanvasPosition.Y

		if AbsoluteSizeY > 0 then
			local v23 = math.max(1, math.floor(CanvasPositionY / v20) + 1)
			local v24 = math.floor(AbsoluteSizeY / v20) + 2

			if v23 ~= p1.state.windowStart or v24 ~= p1.state.windowSize then
				p1:setState({
					windowStart = v23,
					windowSize = v24,
					topPadding = v20 * (v23 - 1)
				})
			end
		end
	end
end

v5.defaultProps = {
	ButtonSizeY = 20,
	ScrollingFrameOffset = 0,
	List = {},
	ListButtonProps = {}
}

function v5.render(p3) -- line: 52
	-- upvalues: Roact (copy), ArgCheck (copy), Graphite (copy)
	local ListButton = p3.props.ListButton
	local ListButtonProps = p3.props.ListButtonProps
	local List = p3.props.List
	local v11 = #List
	local t1 = { Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical
	}) }

	ArgCheck.isInTypes(ListButton, {
		"function",
		"table"
	}, "ListButton prop in WindowedListFrame")

	if ListButton then
		local windowStart = p3.state.windowStart
		local windowSize = p3.state.windowSize

		for i = windowStart, math.min(#List, windowStart + windowSize) do
			local v16 = List[i]
			local v17 = i + i

			t1[v17] = Roact.createElement(ListButton, {
				Size = UDim2.new(1, 0, 0, p3.props.ButtonSizeY),
				LayoutOrder = v17,
				Data = v16,
				ListButtonProps = ListButtonProps
			})

			local v18 = v17 + 1

			t1[v18] = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = Graphite,
				LayoutOrder = v18
			})
		end
	end

	return Roact.createElement("ScrollingFrame", {
		Position = UDim2.new(0, 0, 0, p3.props.ScrollingFrameOffset),
		Size = UDim2.new(1, 8, 1, -p3.props.ScrollingFrameOffset),
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = Graphite,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, v11 * (p3.props.ButtonSizeY + 1)),
		[Roact.Change.CanvasPosition] = p3.updateWindow,
		[Roact.Change.AbsoluteSize] = p3.updateWindow
	}, {
		ListHolder = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -8, 0, 1),
			Position = UDim2.new(0, 0, 0, p3.state.topPadding)
		}, t1)
	})
end

return v5
