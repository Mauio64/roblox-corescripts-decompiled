local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)
local ArrowNav = require(parent.HorizontalNav.ArrowNav)
local NavigationDirection = require(parent.HorizontalNav.NavigationDirection)
local Images = require(parent2.ImageSet.Images)

local iconsactionscycleLeft = Images["icons/actions/cycleLeft"]
local iconsactionscycleRight = Images["icons/actions/cycleRight"]

local extended = Roact.PureComponent:extend("ArrowFrame")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = { ZIndex = 1, isVisibleRight = true, isVisibleLeft = true }

function extended:init()
	self.state = { isHovered = false }

	function self.onMouseEnter()
		self:setState({ isHovered = true })
	end

	function self.onMouseLeave()
		self:setState({ isHovered = false })
	end
end

function extended.render(props)
	local isVisibleLeft = props.props.isVisibleLeft
	local isVisibleRight = props.props.isVisibleRight
	local defaultUseProps = props.props.defaultUseProps
	local onPressHoldInputBegan = props.props.onPressHoldInputBegan
	local onPressHoldInputEnded = props.props.onPressHoldInputEnded

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = props.props.ZIndex,
		[Roact.Event.MouseEnter] = props.onMouseEnter,
		[Roact.Event.MouseLeave] = props.onMouseLeave
	}, {
		ArrowLeft = Roact.createElement(ArrowNav, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, -6, 0.5, 0),
			Image = iconsactionscycleLeft,
			Visible = props.state.isHovered and isVisibleLeft,
			navDirection = NavigationDirection.IsLeft,
			defaultUseProps = defaultUseProps,
			onPressHoldInputBegan = onPressHoldInputBegan,
			onPressHoldInputEnded = onPressHoldInputEnded
		}),
		ArrowRight = Roact.createElement(ArrowNav, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(1, -30, 0.5, 0),
			Image = iconsactionscycleRight,
			Visible = props.state.isHovered and isVisibleRight,
			navDirection = NavigationDirection.IsRight,
			defaultUseProps = defaultUseProps,
			onPressHoldInputBegan = onPressHoldInputBegan,
			onPressHoldInputEnded = onPressHoldInputEnded
		})
	})
end

return extended
