local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParent2 = ParentParentParent.Parent.Parent
local Roact = require(ParentParent2.Roact)
local t = require(ParentParent2.t)
local ArrowNav = require(ParentParent.HorizontalNav.ArrowNav)
local NavigationDirection = require(ParentParent.HorizontalNav.NavigationDirection)
local Images = require(ParentParentParent.ImageSet.Images)
local v9 = Images["icons/actions/cycleLeft"]
local v10 = Images["icons/actions/cycleRight"]
local v11 = Roact.PureComponent:extend("ArrowFrame")

v11.validateProps = t.strictInterface({
	ZIndex = t.optional(t.number),
	isVisibleLeft = t.optional(t.union(t.boolean, t.table)),
	isVisibleRight = t.optional(t.union(t.boolean, t.table)),
	onPressHoldInputBegan = t.optional(t.callback),
	onPressHoldInputEnded = t.optional(t.callback),
	defaultUseProps = t.optional(t.strictInterface({
		scrollingFrameRef = t.table,
		buttonRefs = t.optional(t.table),
		buttonWidth = t.optional(t.number),
		padOutsideEdges = t.optional(t.boolean),
		numButtons = t.optional(t.number),
		buttonPadding = t.number,
		updateCanvasPosition = t.callback
	}))
})
v11.defaultProps = {
	ZIndex = 1,
	isVisibleRight = true,
	isVisibleLeft = true
}

function v11.init(p1) -- line: 52
	p1.state = {
		isHovered = false
	}

	function p1.onMouseEnter() -- line: 57
		-- upvalues: p1 (copy)
		p1:setState({
			isHovered = true
		})
	end
	function p1.onMouseLeave() -- line: 63
		-- upvalues: p1 (copy)
		p1:setState({
			isHovered = false
		})
	end
end
function v11.render(p2) -- line: 70
	-- upvalues: Roact (copy), ArrowNav (copy), v9 (copy), NavigationDirection (copy), v10 (copy)
	local isVisibleLeft = p2.props.isVisibleLeft
	local isVisibleRight = p2.props.isVisibleRight
	local defaultUseProps = p2.props.defaultUseProps
	local onPressHoldInputBegan = p2.props.onPressHoldInputBegan
	local onPressHoldInputEnded = p2.props.onPressHoldInputEnded

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = p2.props.ZIndex,
		[Roact.Event.MouseEnter] = p2.onMouseEnter,
		[Roact.Event.MouseLeave] = p2.onMouseLeave
	}, {
		ArrowLeft = Roact.createElement(ArrowNav, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, -6, 0.5, 0),
			Image = v9,
			Visible = p2.state.isHovered and isVisibleLeft,
			navDirection = NavigationDirection.IsLeft,
			defaultUseProps = defaultUseProps,
			onPressHoldInputBegan = onPressHoldInputBegan,
			onPressHoldInputEnded = onPressHoldInputEnded
		}),
		ArrowRight = Roact.createElement(ArrowNav, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(1, -30, 0.5, 0),
			Image = v10,
			Visible = p2.state.isHovered and isVisibleRight,
			navDirection = NavigationDirection.IsRight,
			defaultUseProps = defaultUseProps,
			onPressHoldInputBegan = onPressHoldInputBegan,
			onPressHoldInputEnded = onPressHoldInputEnded
		})
	})
end

return v11
