local UserGameSettings = UserSettings():GetService("UserGameSettings")
local parent = script:FindFirstAncestor("AppBlox").Parent
local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local Otter = require(parent.Otter)
local Cryo = require(parent.Cryo)
local t = require(parent.t)
local ArgCheck = require(parent.ArgCheck)

local AppCarousel = require(script.Parent.AppCarousel)
local ScrollButton = require(script.Parent.ScrollButton)
local Images = UIBlox.App.ImageSet.Images

local defineFastFlag = game:DefineFastFlag("AXFixScrollingCarouselShowRightButton", false)

local iconsactionscycleLeft = Images["icons/actions/cycleLeft"]
local iconsactionscycleRight = Images["icons/actions/cycleRight"]

local v = {
	frequency = 2,
	dampingRatio = 0.9,
	restingPositionLimit = 0.5,
	restingVelocityLimit = 0.1
}

local extended = Roact.PureComponent:extend("ScrollingAppCarousel")

extended.defaultProps = { carouselMargin = 0 }

extended.validateProps = t.strictInterface({
	items = t.table,
	index = t.numberMin(1),
	itemCount = t.number,
	itemWidth = t.numberMin(1),
	itemPadding = t.number,
	carouselMargin = t.number,
	carouselHeight = t.number,
	canvasWidth = t.number,
	styleProps = t.optional(t.table),
	isScrollingDisabled = t.optional(t.boolean),
	onChangeCanvasPosition = t.callback,
	onRefCallback = t.optional(t.callback),
	shouldExpandToFitContentHeight = t.optional(t.boolean)
})

function extended.getScrollState(p, p2, p3)
	local v2 = p + p2
	return {
		maxNumOfItemsVisible = math.floor((p3 + p2) / v2)
	}
end

function extended:handleMouseEvent(p, hoveringCarousel)
	if p.UserInputType == Enum.UserInputType.MouseMovement then
		self:setState({ hoveringCarousel = hoveringCarousel })
	end
end

function extended:handleScroll(p)
	if self.state.animationActive then
		return
	end

	local index = self.props.index
	local maxNumOfItemsVisible = self.state.maxNumOfItemsVisible
	self:scrollToIndex(index, index + (p and maxNumOfItemsVisible or -maxNumOfItemsVisible))
end

function extended:handleResize(p)
	if self._isMounted then
		local carouselMargin = self.props.carouselMargin
		local carouselWidth = p.AbsoluteSize.X - 2 * carouselMargin
		self:setState(Cryo.Dictionary.join(
			{ absoluteWidth = p.AbsoluteSize.X, carouselWidth = carouselWidth },
			self.getScrollState(self.props.itemWidth, self.props.itemPadding, carouselWidth)
		))
	end
end

function extended:scrollToIndex(p, p2)
	ArgCheck.assert(not self.props.isScrollingDisabled, "scrolling should be disabled")

	local itemCount = self.props.itemCount
	local v2 = self.props.itemWidth + self.props.itemPadding
	local v3 = math.max(math.min(p2, itemCount - self.state.maxNumOfItemsVisible + 1), 1)

	local v4 = (p - 1) * v2
	local v5 = (v3 - 1) * v2

	self:destroyMotor()
	self:createMotor(v4)

	if UserGameSettings.ReducedMotion then
		self.carouselMotor:setGoal(Otter.instant(v5))
	else
		self.carouselMotor:setGoal(Otter.spring(v5, v))
	end
end

function extended:createMotor(p)
	self.carouselMotor = Otter.createSingleMotor(p)
	self.carouselMotor:onStep(function(p2)
		self:setState({ animationActive = true, canvasPosition = Vector2.new(p2, 0) })
	end)
	self.carouselMotor:onComplete(function()
		self:destroyMotor()
		self:setState({ animationActive = false })
	end)
end

function extended:destroyMotor()
	if self.carouselMotor then
		self.carouselMotor:destroy()
		self.carouselMotor = nil
	end
end

function extended:init()
	self:setState({
		carouselWidth = 0,
		hoveringCarousel = false,
		animationActive = false,
		canvasPosition = Vector2.new(0, 0),
		maxNumOfItemsVisible = 0,
		absoluteWidth = 0
	})

	self.carouselMotor = nil

	function self.onMouseEnter(_, p)
		if self._isMounted then
			self:handleMouseEvent(p, true)
		end
	end

	function self.onMouseLeave(_, p)
		if self._isMounted then
			self:handleMouseEvent(p, false)
		end
	end

	self.frameRef = Roact.createRef()

	function self.onResize(p)
		if self._isMounted then
			self:handleResize(p)

			if self.props.onResize then
				self.props.onResize(p)
			end
		end
	end

	function self.scrollLeft()
		if self._isMounted then
			self:handleScroll(false)
		end
	end

	function self.scrollRight()
		if self._isMounted then
			self:handleScroll(true)
		end
	end
end

function extended.getDerivedStateFromProps(data, p)
	local carouselWidth = math.max(0, p.absoluteWidth - 2 * data.carouselMargin)
	return Cryo.Dictionary.join(
		{ carouselWidth = carouselWidth },
		extended.getScrollState(data.itemWidth, data.itemPadding, carouselWidth)
	)
end

function extended:didMount()
	self._isMounted = true
	self:handleResize((self.frameRef:getValue()))
end

function extended:didUpdate(data, p)
	local v2 = self.props.itemCount < data.itemCount
	local v3 = self.props.itemWidth ~= data.itemWidth
	local v4 = self.props.itemPadding ~= data.itemPadding
	local v5 = self.state.maxNumOfItemsVisible ~= p.maxNumOfItemsVisible

	if not self.props.isScrollingDisabled and (v2 or v3 or v4 or v5) then
		self:scrollToIndex(self.props.index, data.index)
	end
end

function extended:willUnmount()
	self._isMounted = false
	self:destroyMotor()
end

function extended.render(props)
	local carouselMargin = props.props.carouselMargin
	local carouselHeight = props.props.carouselHeight

	local scrollLeftButton = nil
	local scrollRightButton = nil

	if props.state.hoveringCarousel then
		local isScrollingDisabled = props.props.isScrollingDisabled
		local v2

		if props.props.index > 1 then
			v2 = not isScrollingDisabled
		else
			v2 = false
		end

		local v3

		if defineFastFlag then
			v3 = props.props.index + props.state.maxNumOfItemsVisible < props.props.itemCount
				and not isScrollingDisabled
		else
			v3 = props.props.index + props.state.maxNumOfItemsVisible < props.props.itemCount
		end

		if v2 then
			scrollLeftButton = Roact.createElement(ScrollButton, {
				icon = iconsactionscycleLeft,
				callback = props.scrollLeft
			})
		end

		if v3 then
			scrollRightButton = Roact.createElement(ScrollButton, {
				icon = iconsactionscycleRight,
				callback = props.scrollRight
			})
		end
	end

	local udim

	if props.props.styleProps and props.props.styleProps.leftPosition then
		udim = UDim2.new(0, props.props.styleProps.leftPosition, 0, 0)
	else
		udim = UDim2.fromScale(0, 0)
	end

	local udim2

	if props.props.styleProps and props.props.styleProps.rightPosition then
		udim2 = UDim2.new(1, props.props.styleProps.rightPosition, 0, 0)
	else
		udim2 = UDim2.fromScale(1, 0)
	end

	local createElement = Roact.createElement
	local v2 = {
		["Size"] = nil,
		["Size"] = nil,
		["Size"] = nil,
		["Size"] = nil,
		Size = UDim2.new(1, carouselMargin, 0, carouselHeight)
	}
	local automaticSize

	if props.props.shouldExpandToFitContentHeight then
		automaticSize = Enum.AutomaticSize.Y
	end

	v2.AutomaticSize = automaticSize
	v2.Position = UDim2.fromOffset(-carouselMargin, 0)
	v2.BackgroundTransparency = 1
	v2[Roact.Event.InputBegan] = props.onMouseEnter
	v2[Roact.Event.InputEnded] = props.onMouseLeave
	v2[Roact.Change.AbsoluteSize] = props.onResize
	v2[Roact.Ref] = props.frameRef
	local children = {
		LeftMargin = Roact.createElement("Frame", {
			Position = udim,
			AnchorPoint = Vector2.new(0, 0),
			Size = UDim2.new(0, carouselMargin, 1, 0),
			BackgroundTransparency = 1,
			ZIndex = 2
		}, { ScrollLeftButton = scrollLeftButton }),
		Carousel = 0,
		RightMargin = 0
	}

	local createElement2 = Roact.createElement
	local v3 = {
		Size = UDim2.new(1, -2 * carouselMargin, 1, 0),
		AutomaticSize = 0,
		Position = 0,
		BackgroundTransparency = 1
	}
	local automaticSize2

	if props.props.shouldExpandToFitContentHeight then
		automaticSize2 = Enum.AutomaticSize.Y
	end

	v3.AutomaticSize = automaticSize2
	v3.Position = UDim2.fromOffset(carouselMargin, 0)
	children.Carousel = createElement2("Frame", v3, {
		InnerCarouselContent = Roact.createElement(AppCarousel, {
			carouselHeight = carouselHeight,
			canvasWidth = props.props.canvasWidth,
			items = props.props.items,
			onChangeCanvasPosition = props.props.onChangeCanvasPosition,
			onRefCallback = props.props.onRefCallback,
			canvasPosition = props.state.canvasPosition,
			scrollingAnimationActive = props.props.isScrollingDisabled and true or props.state.animationActive,
			shouldExpandToFitContentHeight = props.props.shouldExpandToFitContentHeight
		})
	})

	children.RightMargin = Roact.createElement("Frame", {
		Position = udim2,
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.new(0, carouselMargin, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 2
	}, { ScrollRightButton = scrollRightButton })
	return createElement("Frame", v2, children)
end

return extended
