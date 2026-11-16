local UserGameSettings = UserSettings():GetService("UserGameSettings")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Roact")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")
local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Otter")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/t")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/ArgCheck")

local AppCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/ScrollingAppCarousel/AppCarousel")
local ScrollButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/ScrollingAppCarousel/ScrollButton")
local images = UIBlox.App.ImageSet.Images

local defineFastFlag = game:DefineFastFlag("AXFixScrollingCarouselShowRightButton", false)

local iconsactionscycleLeft = images["icons/actions/cycleLeft"]
local iconsactionscycleRight = images["icons/actions/cycleRight"]

local v5 = {
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

function extended.getScrollState(p2, p3, p4)
	local v6 = p2 + p3
	return {
		maxNumOfItemsVisible = math.floor((p4 + p3) / v6)
	}
end

function extended:handleMouseEvent(p2, p3)
	if p2.UserInputType == Enum.UserInputType.MouseMovement then
		self:setState({ hoveringCarousel = p3 })
	end
end

function extended:handleScroll(p2)
	if self.state.animationActive then
		return
	end

	local index = self.props.index
	local maxNumOfItemsVisible = self.state.maxNumOfItemsVisible
	self:scrollToIndex(index, index + (p2 and maxNumOfItemsVisible or -maxNumOfItemsVisible))
end

function extended:handleResize(p2)
	if self._isMounted then
		local carouselMargin = self.props.carouselMargin
		local v6 = p2.AbsoluteSize.X - 2 * carouselMargin
		self:setState(Cryo.Dictionary.join(
			{ absoluteWidth = p2.AbsoluteSize.X, carouselWidth = v6 },
			self.getScrollState(self.props.itemWidth, self.props.itemPadding, v6)
		))
	end
end

function extended:scrollToIndex(p2, p3)
	ArgCheck.assert(not self.props.isScrollingDisabled, "scrolling should be disabled")

	local itemCount = self.props.itemCount
	local v6 = self.props.itemWidth + self.props.itemPadding
	local v7 = math.max(math.min(p3, itemCount - self.state.maxNumOfItemsVisible + 1), 1)

	local v8 = (p2 - 1) * v6
	local v9 = (v7 - 1) * v6

	self:destroyMotor()
	self:createMotor(v8)

	if UserGameSettings.ReducedMotion then
		self.carouselMotor:setGoal(Otter.instant(v9))
	else
		self.carouselMotor:setGoal(Otter.spring(v9, v5))
	end
end

function extended:createMotor(p2)
	self.carouselMotor = Otter.createSingleMotor(p2)
	self.carouselMotor:onStep(function(p3)
		self:setState({ animationActive = true, canvasPosition = Vector2.new(p3, 0) })
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

	function self.onMouseEnter(p2, p3)
		if self._isMounted then
			self:handleMouseEvent(p3, true)
		end
	end

	function self.onMouseLeave(p2, p3)
		if self._isMounted then
			self:handleMouseEvent(p3, false)
		end
	end

	self.frameRef = Roact.createRef()

	function self.onResize(p2)
		if self._isMounted then
			self:handleResize(p2)

			if self.props.onResize then
				self.props.onResize(p2)
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

function extended.getDerivedStateFromProps(data, p2)
	local v6 = math.max(0, p2.absoluteWidth - 2 * data.carouselMargin)
	return Cryo.Dictionary.join(
		{ carouselWidth = v6 },
		extended.getScrollState(data.itemWidth, data.itemPadding, v6)
	)
end

function extended:didMount()
	self._isMounted = true
	self:handleResize((self.frameRef:getValue()))
end

function extended:didUpdate(data, p2)
	local v6 = self.props.itemCount < data.itemCount
	local v7 = self.props.itemWidth ~= data.itemWidth
	local v8 = self.props.itemPadding ~= data.itemPadding
	local v9 = self.state.maxNumOfItemsVisible ~= p2.maxNumOfItemsVisible

	if not self.props.isScrollingDisabled and (v6 or v7 or v8 or v9) then
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

	local v6 = nil
	local v7 = nil

	if props.state.hoveringCarousel then
		local isScrollingDisabled = props.props.isScrollingDisabled
		local v8 = props.props.index > 1 and not isScrollingDisabled
		local v9

		if defineFastFlag then
			v9 = props.props.index + props.state.maxNumOfItemsVisible < props.props.itemCount
				and not isScrollingDisabled
		else
			v9 = props.props.index + props.state.maxNumOfItemsVisible < props.props.itemCount
		end

		if v8 then
			v6 = Roact.createElement(ScrollButton, {
				icon = iconsactionscycleLeft,
				callback = props.scrollLeft
			})
		end

		if v9 then
			v7 = Roact.createElement(ScrollButton, {
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
	local v9 = {
		["Size"] = nil,
		["Size"] = nil,
		["Size"] = nil,
		["Size"] = nil,
		Size = UDim2.new(1, carouselMargin, 0, carouselHeight)
	}
	local v10 = if props.props.shouldExpandToFitContentHeight then Enum.AutomaticSize.Y else nil
	v9.AutomaticSize = v10
	v9.Position = UDim2.fromOffset(-carouselMargin, 0)
	v9.BackgroundTransparency = 1
	v9[Roact.Event.InputBegan] = props.onMouseEnter
	v9[Roact.Event.InputEnded] = props.onMouseLeave
	v9[Roact.Change.AbsoluteSize] = props.onResize
	v9[Roact.Ref] = props.frameRef
	local children = {
		LeftMargin = Roact.createElement("Frame", {
			Position = udim,
			AnchorPoint = Vector2.new(0, 0),
			Size = UDim2.new(0, carouselMargin, 1, 0),
			BackgroundTransparency = 1,
			ZIndex = 2
		}, { ScrollLeftButton = v6 }),
		Carousel = 0,
		RightMargin = 0
	}

	local createElement2 = Roact.createElement
	local v12 = {
		Size = UDim2.new(1, -2 * carouselMargin, 1, 0),
		AutomaticSize = 0,
		Position = 0,
		BackgroundTransparency = 1
	}
	local v13 = if props.props.shouldExpandToFitContentHeight then Enum.AutomaticSize.Y else nil
	v12.AutomaticSize = v13
	v12.Position = UDim2.fromOffset(carouselMargin, 0)
	children.Carousel = createElement2("Frame", v12, {
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
	}, { ScrollRightButton = v7 })
	return createElement("Frame", v9, children)
end

return extended
