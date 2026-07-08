local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Parent = script:FindFirstAncestor("AppBlox").Parent
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local Otter = require(Parent.Otter)
local Cryo = require(Parent.Cryo)
local t = require(Parent.t)
local ArgCheck = require(Parent.ArgCheck)
local AppCarousel = require(script.Parent.AppCarousel)
local ScrollButton = require(script.Parent.ScrollButton)
local Images = UIBlox.App.ImageSet.Images
local FFlagAXScrollingCarouselWidgetIndexBugfix = require(Parent.SharedFlags).FFlagAXScrollingCarouselWidgetIndexBugfix
local v13 = game:DefineFastFlag("AXFixScrollingCarouselShowRightButton", false)
local v14 = Images["icons/actions/cycleLeft"]
local v15 = Images["icons/actions/cycleRight"]
local t1 = {
	frequency = 2,
	dampingRatio = 0.9,
	restingPositionLimit = 0.5,
	restingVelocityLimit = 0.1
}
local v17 = Roact.PureComponent:extend("ScrollingAppCarousel")

v17.defaultProps = {
	carouselMargin = 0
}
v17.validateProps = t.strictInterface({
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

function v17.getScrollState(p1, p2, p3) -- line: 78
	local v21 = p1 + p2

	return {
		maxNumOfItemsVisible = math.floor((p3 + p2) / v21)
	}
end
function v17.handleMouseEvent(p4, p5, p6) -- line: 87
	if p5.UserInputType == Enum.UserInputType.MouseMovement then
		p4:setState({
			hoveringCarousel = p6
		})
	end
end
function v17.handleScroll(p7, p8) -- line: 95
	if p7.state.animationActive then
		return
	end

	local index = p7.props.index
	local maxNumOfItemsVisible = p7.state.maxNumOfItemsVisible

	p7:scrollToIndex(index, index + (p8 and maxNumOfItemsVisible or -maxNumOfItemsVisible))
end
function v17.handleResize(p9, p10) -- line: 106
	-- upvalues: Cryo (copy)
	if p9._isMounted then
		local carouselMargin = p9.props.carouselMargin
		local v32 = p10.AbsoluteSize.X - 2 * carouselMargin

		p9:setState(Cryo.Dictionary.join({
			absoluteWidth = p10.AbsoluteSize.X,
			carouselWidth = v32
		}, p9.getScrollState(p9.props.itemWidth, p9.props.itemPadding, v32)))
	end
end
function v17.scrollToIndex(p11, p12, p13) -- line: 117
	-- upvalues: ArgCheck (copy), UserGameSettings (copy), Otter (copy), t1 (copy)
	ArgCheck.assert(not p11.props.isScrollingDisabled, "scrolling should be disabled")

	local itemCount = p11.props.itemCount
	local v37 = p11.props.itemWidth + p11.props.itemPadding
	local v38 = math.max(math.min(p13, itemCount - p11.state.maxNumOfItemsVisible + 1), 1)
	local v39 = (p12 - 1) * v37
	local v40 = (v38 - 1) * v37

	p11:destroyMotor()
	p11:createMotor(v39)

	if UserGameSettings.ReducedMotion then
		p11.carouselMotor:setGoal(Otter.instant(v40))

		return
	end

	p11.carouselMotor:setGoal(Otter.spring(v40, t1))
end
function v17.createMotor(p14, p15) -- line: 139
	-- upvalues: Otter (copy)
	p14.carouselMotor = Otter.createSingleMotor(p15)
	p14.carouselMotor:onStep(function(p16) -- line: 141
		-- upvalues: p14 (copy)
		p14:setState({
			animationActive = true,
			canvasPosition = Vector2.new(p16, 0)
		})
	end)
	p14.carouselMotor:onComplete(function() -- line: 147
		-- upvalues: p14 (copy)
		p14:destroyMotor()
		p14:setState({
			animationActive = false
		})
	end)
end
function v17.destroyMotor(p17) -- line: 155
	if p17.carouselMotor then
		p17.carouselMotor:destroy()
		p17.carouselMotor = nil
	end
end
function v17.init(p18) -- line: 162
	-- upvalues: Roact (copy)
	p18:setState({
		carouselWidth = 0,
		hoveringCarousel = false,
		animationActive = false,
		maxNumOfItemsVisible = 0,
		absoluteWidth = 0,
		canvasPosition = Vector2.new(0, 0)
	})
	p18.carouselMotor = nil

	function p18.onMouseEnter(_, p20) -- line: 174
		-- upvalues: p18 (copy)
		if p18._isMounted then
			p18:handleMouseEvent(p20, true)
		end
	end
	function p18.onMouseLeave(_, p22) -- line: 180
		-- upvalues: p18 (copy)
		if p18._isMounted then
			p18:handleMouseEvent(p22, false)
		end
	end

	p18.frameRef = Roact.createRef()

	function p18.onResize(p23) -- line: 188
		-- upvalues: p18 (copy)
		if p18._isMounted then
			p18:handleResize(p23)

			if p18.props.onResize then
				p18.props.onResize(p23)
			end
		end
	end
	function p18.scrollLeft() -- line: 197
		-- upvalues: p18 (copy)
		if p18._isMounted then
			p18:handleScroll(false)
		end
	end
	function p18.scrollRight() -- line: 203
		-- upvalues: p18 (copy)
		if p18._isMounted then
			p18:handleScroll(true)
		end
	end
end
function v17.getDerivedStateFromProps(p24, p25) -- line: 210
	-- upvalues: Cryo (copy), v17 (copy)
	local v47 = math.max(0, p25.absoluteWidth - 2 * p24.carouselMargin)

	return Cryo.Dictionary.join({
		carouselWidth = v47
	}, v17.getScrollState(p24.itemWidth, p24.itemPadding, v47))
end
function v17.didMount(p26) -- line: 217
	p26._isMounted = true
	p26:handleResize((p26.frameRef:getValue()))
end
function v17.didUpdate(p27, p28, p29) -- line: 223
	local v52 = p27.props.itemCount < p28.itemCount
	local v53 = p27.props.itemWidth ~= p28.itemWidth
	local v54 = p27.props.itemPadding ~= p28.itemPadding
	local v55 = p27.state.maxNumOfItemsVisible ~= p29.maxNumOfItemsVisible

	if not p27.props.isScrollingDisabled and (v52 or (v53 or (v54 or v55))) then
		p27:scrollToIndex(p27.props.index, p28.index)
	end
end
function v17.willUnmount(p30) -- line: 235
	p30._isMounted = false
	p30:destroyMotor()
end
function v17.render(p31) -- line: 240
	-- upvalues: v13 (copy), FFlagAXScrollingCarouselWidgetIndexBugfix (copy), Roact (copy), ScrollButton (copy), v14 (copy), v15 (copy), AppCarousel (copy)
	local carouselMargin = p31.props.carouselMargin
	local carouselHeight = p31.props.carouselHeight
	local v60 = nil
	local v61 = nil

	if p31.state.hoveringCarousel then
		local isScrollingDisabled = p31.props.isScrollingDisabled
		local v63 = p31.props.index > 1 and not isScrollingDisabled
		local v64 = if not v13 then if not FFlagAXScrollingCarouselWidgetIndexBugfix then p31.props.index + p31.state.maxNumOfItemsVisible <= p31.props.itemCount and not isScrollingDisabled else p31.props.index + p31.state.maxNumOfItemsVisible < p31.props.itemCount else ((if not FFlagAXScrollingCarouselWidgetIndexBugfix then p31.props.index + p31.state.maxNumOfItemsVisible <= p31.props.itemCount else p31.props.index + p31.state.maxNumOfItemsVisible < p31.props.itemCount)) and not isScrollingDisabled

		if v63 then
			v60 = Roact.createElement(ScrollButton, {
				icon = v14,
				callback = p31.scrollLeft
			})
		end

		if v64 then
			v61 = Roact.createElement(ScrollButton, {
				icon = v15,
				callback = p31.scrollRight
			})
		end
	end

	local v65 = if not p31.props.styleProps or not p31.props.styleProps.leftPosition then UDim2.fromScale(0, 0) else UDim2.new(0, p31.props.styleProps.leftPosition, 0, 0)
	local v66 = if not p31.props.styleProps or not p31.props.styleProps.rightPosition then UDim2.fromScale(1, 0) else UDim2.new(1, p31.props.styleProps.rightPosition, 0, 0)

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, carouselMargin, 0, carouselHeight),
		AutomaticSize = if not p31.props.shouldExpandToFitContentHeight then nil else Enum.AutomaticSize.Y,
		Position = UDim2.fromOffset(-carouselMargin, 0),
		BackgroundTransparency = 1,
		[Roact.Event.InputBegan] = p31.onMouseEnter,
		[Roact.Event.InputEnded] = p31.onMouseLeave,
		[Roact.Change.AbsoluteSize] = p31.onResize,
		[Roact.Ref] = p31.frameRef
	}, {
		LeftMargin = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Position = v65,
			AnchorPoint = Vector2.new(0, 0),
			Size = UDim2.new(0, carouselMargin, 1, 0)
		}, {
			ScrollLeftButton = v60
		}),
		Carousel = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -2 * carouselMargin, 1, 0),
			AutomaticSize = if not p31.props.shouldExpandToFitContentHeight then nil else Enum.AutomaticSize.Y,
			Position = UDim2.fromOffset(carouselMargin, 0)
		}, {
			InnerCarouselContent = Roact.createElement(AppCarousel, {
				carouselHeight = carouselHeight,
				canvasWidth = p31.props.canvasWidth,
				items = p31.props.items,
				onChangeCanvasPosition = p31.props.onChangeCanvasPosition,
				onRefCallback = p31.props.onRefCallback,
				canvasPosition = p31.state.canvasPosition,
				scrollingAnimationActive = not not p31.props.isScrollingDisabled or p31.state.animationActive,
				shouldExpandToFitContentHeight = p31.props.shouldExpandToFitContentHeight
			})
		}),
		RightMargin = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Position = v66,
			AnchorPoint = Vector2.new(1, 0),
			Size = UDim2.new(0, carouselMargin, 1, 0)
		}, {
			ScrollRightButton = v61
		})
	})
end

return v17
