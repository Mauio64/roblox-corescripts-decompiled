local Parent = script:FindFirstAncestor("AppChat").Parent
local RoactFitComponents = require(Parent.LuaSocialLibrariesDeps).RoactFitComponents
local Roact = require(Parent.Roact)
local v4 = Roact.PureComponent:extend("ThreeSectionBar")

v4.Rect = RoactFitComponents.Rect
v4.defaultProps = {
	marginLeft = v4.Rect.square(0),
	marginRight = v4.Rect.square(0),
	contentPaddingLeft = UDim.new(0, 0),
	contentPaddingRight = UDim.new(0, 0),
	height = UDim.new(0, 0)
}

function v4.init(p1) -- line: 23
	-- upvalues: Roact (copy)
	local v6, v7 = Roact.createBinding(0)

	p1.leftWidth = v6
	p1.updateLeftWidth = v7

	local v8, v9 = Roact.createBinding(0)

	p1.rightWidth = v8
	p1.updateRightWidth = v9

	local v10, v11 = Roact.createBinding(0)

	p1.fullWidth = v10
	p1.updateFullWidth = v11
end
function v4.render(p2) -- line: 30
	-- upvalues: Roact (copy), RoactFitComponents (copy)
	return Roact.createElement("Frame", {
		Size = UDim2.new(UDim.new(1, 0), p2.props.height),
		LayoutOrder = p2.props.LayoutOrder,
		[Roact.Change.AbsoluteSize] = function(p3) -- line: 35
			-- upvalues: p2 (copy)
			p2.updateFullWidth(p3.AbsoluteSize.X)
		end
	}, {
		leftFrame = Roact.createElement(RoactFitComponents.FitFrameHorizontal, {
			Transparency = 1,
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.fromScale(0, 0),
			minimumSize = UDim.new(0, 0),
			height = UDim.new(1, 0),
			FillDirection = Enum.FillDirection.Horizontal,
			contentPadding = p2.props.contentPaddingLeft,
			margin = p2.props.marginLeft,
			[Roact.Change.AbsoluteSize] = function(p4) -- line: 49
				-- upvalues: p2 (copy)
				p2.updateLeftWidth(p4.AbsoluteSize.X)
			end
		}, {
			leftContent = p2.props.renderLeft(p2.props)
		}),
		centerFrame = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = Roact.joinBindings({
				p2.leftWidth,
				p2.rightWidth,
				p2.fullWidth
			}):map(function(p5) -- line: 60
				local v16 = p5[1]
				local v17 = p5[2]
				local v18 = p5[3]
				local v19 = math.max(v16, v17)
				local Magnitude = (Vector2.new(v18 / 2, 0) - Vector2.new(v19, 0)).Magnitude

				return UDim2.new(0, Magnitude * 2, 1, 0)
			end)
		}, {
			["$layout"] = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			centerContent = p2.props.renderCenter(p2.props)
		}),
		rightFrame = Roact.createElement(RoactFitComponents.FitFrameHorizontal, {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			minimumSize = UDim.new(0, 0),
			height = UDim.new(1, 0),
			FillDirection = Enum.FillDirection.Horizontal,
			contentPadding = p2.props.contentPaddingRight,
			margin = p2.props.marginRight,
			[Roact.Change.AbsoluteSize] = function(p6) -- line: 89
				-- upvalues: p2 (copy)
				p2.updateRightWidth(p6.AbsoluteSize.X)
			end
		}, {
			rightContent = p2.props.renderRight(p2.props)
		})
	})
end

return v4
