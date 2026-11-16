local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local parent = script.Parent
local parent2 = script.Parent.Parent
local parent3 = parent2.Parent.Parent

local Cryo = require(parent3.Cryo)
local Otter = require(parent3.Otter)
local Roact = require(parent3.Roact)
local t = require(parent3.t)
local RoactGamepad = require(parent3.RoactGamepad)

local Focusable = RoactGamepad.Focusable

local withStyle = require(parent3.UIBlox.Core.Style.withStyle)
local useCursorByType = require(parent2.SelectionCursor.useCursorByType)
local CursorType = require(parent2.SelectionCursor.CursorType)

local Images = require(parent3.UIBlox.App.ImageSet.Images)
local ScrollBarType = require(parent.Enum.ScrollBarType)
local ScrollBar = require(script.Parent.ScrollBar)

local v = { frequency = 3, dampingRatio = 1.5 }

local extended = Roact.Component:extend("VerticalScrollView")

extended.validateProps = t.strictInterface({
	size = t.optional(t.UDim2),
	position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.number),
	elasticBehavior = t.optional(t.EnumItem),
	canvasSizeY = t.optional(t.UDim),
	automaticSize = t.optional(t.enum(Enum.AutomaticSize)),
	useAutomaticCanvasSize = t.optional(t.boolean),
	isGamepadFocusable = t.optional(t.boolean),
	scrollingEnabled = t.optional(t.boolean),
	selectable = t.optional(t.boolean),
	[Roact.Change.CanvasPosition] = t.optional(t.callback),
	[Roact.Change.CanvasSize] = t.optional(t.callback),
	scrollingFrameRef = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	[Roact.Children] = t.optional(t.table),
	scrollBarType = t.optional(t.string),
	cursor = t.table
})

extended.defaultProps = {
	size = UDim2.new(1, 0, 1, 0),
	canvasSizeY = UDim.new(2, 0),
	automaticSize = Enum.AutomaticSize.None,
	useAutomaticCanvasSize = false,
	isGamepadFocusable = false,
	selectable = nil,
	scrollingEnabled = true,
	scrollBarType = ScrollBarType.Compact
}

function extended:init()
	self.parentFrameRef = Roact.createRef()
	self.mainCanvasRef = Roact.createRef()

	local binding, updateScroll = Roact.createBinding(0)
	self.scrollPosition = binding
	self.updateScroll = updateScroll
	local binding2, updateCanvasSize = Roact.createBinding(Vector2.new(0, 0))
	self.mainCanvasSize = binding2
	self.updateCanvasSize = updateCanvasSize

	self:setState({ scrollingWithTouch = false })

	local binding3, updateScrollBarImageTransparency = Roact.createBinding(1)
	self.scrollBarImageTransparency = binding3
	self.updateScrollBarImageTransparency = updateScrollBarImageTransparency
	self.scrollBarImageTransparencyMotor = Otter.createSingleMotor(0)
	self.scrollBarImageTransparencyMotor:onStep(self.updateScrollBarImageTransparency)

	self.lastTimeCanvasPositionChanged = tick()

	self.waitToHideSidebarConnection = nil
	function self.waitToHideSidebar()
		if tick() - self.lastTimeCanvasPositionChanged > 0.7 then
			self.scrollBarImageTransparencyMotor:setGoal(Otter.spring(1, v))
			self.disconnectWaitToHideSidebar()
		end
	end
	function self.disconnectWaitToHideSidebar()
		if self.waitToHideSidebarConnection then
			self.waitToHideSidebarConnection:Disconnect()
			self.waitToHideSidebarConnection = nil
		end
	end
	function self.inputBegan(_, p)
		if not self.props.scrollingEnabled then
			return
		end

		if p.UserInputType == Enum.UserInputType.MouseMovement then
			self.disconnectWaitToHideSidebar()
			self.scrollBarImageTransparencyMotor:setGoal(Otter.instant(0))
		end
	end
	function self.inputEnded(_, p)
		if not self.props.scrollingEnabled then
			return
		end

		if p.UserInputType == Enum.UserInputType.MouseMovement then
			self.disconnectWaitToHideSidebar()
			self.scrollBarImageTransparencyMotor:setGoal(Otter.instant(1))
		end
	end
	function self.canvasPosition(p)
		self.lastTimeCanvasPositionChanged = tick()

		if not self.waitToHideSidebarConnection and UserInputService:GetLastInputType() == Enum.UserInputType.Touch then
			self.scrollBarImageTransparencyMotor:setGoal(Otter.instant(0))
			self.waitToHideSidebarConnection = RunService.Heartbeat:Connect(self.waitToHideSidebar)
		end

		self.updateScroll(p.CanvasPosition.Y)

		if self.props[Roact.Change.CanvasPosition] then
			self.props[Roact.Change.CanvasPosition](p)
		end
	end

	function self.onGamepadFocused()
		self.scrollBarImageTransparencyMotor:setGoal(Otter.instant(0))
	end

	function self.onGamepadFocusLost()
		self.scrollBarImageTransparencyMotor:setGoal(Otter.instant(1))
	end

	function self.getMainCanvasPosition()
		return self.scrollPosition:map(function(p)
			return Vector2.new(0, p)
		end)
	end

	function self.onMainCanvasSizeChange(p)
		self.updateCanvasSize(p.AbsoluteCanvasSize)
	end

	function self.getMainCanvasSize()
		return self.mainCanvasSize:map(function(p)
			return UDim2.new(0, 2, 0, p.Y)
		end)
	end

	local binding4, updateViewSize = Roact.createBinding(Vector2.new(0, 0))
	self.viewSize = binding4
	self.updateViewSize = updateViewSize
	local binding5, updateMainCanvasPosition = Roact.createBinding(Vector2.new(0, 0))
	self.mainCanvasPosition = binding5
	self.updateMainCanvasPosition = updateMainCanvasPosition

	function self.onScrollBarDragging(p)
		self.updateMainCanvasPosition(Vector2.new(0, p))
	end

	function self.onViewSizeChange(p)
		self.updateViewSize(p.AbsoluteSize)
	end

	function self.onSelectionChanged(ancestor, p, _, instance)
		if not p and instance == nil then
			self.onGamepadFocusLost()
		elseif p or instance:IsDescendantOf(ancestor) then
			self.onGamepadFocused()
		else
			self.onGamepadFocusLost()
		end
	end
end

function extended:getScrollBarStyleProps(p, p2)
	local tokens = p.Tokens

	if p2 == ScrollBarType.Wide then
		return {
			userInteractionEnabled = true,
			width = tokens.Size.Size_400,
			handleWidth = tokens.Size.Size_200,
			paddingStartEnd = tokens.Size.Size_100,
			marginRight = 0
		}
	end

	if p2 == ScrollBarType.Gamepad then
		return {
			userInteractionEnabled = false,
			width = tokens.Size.Size_400,
			handleWidth = tokens.Size.Size_200,
			handleIcon = Images["icons/controls/keys/xboxRSVertical"],
			handleIconSize = tokens.Size.Size_900,
			handleIconColor = {
				Color = tokens.Color.Content.Emphasis.Color3,
				Transparency = tokens.Color.Content.Emphasis.Transparency
			},
			paddingStartEnd = tokens.Size.Size_600,
			marginRight = tokens.Size.Size_600
		}
	end

	return {
		userInteractionEnabled = false,
		width = tokens.Size.Size_300,
		handleWidth = tokens.Size.Size_50,
		paddingStartEnd = tokens.Size.Size_100,
		marginRight = 0
	}
end

function extended:renderScrollBar(p)
	local tokens = p.Tokens
	local scrollBarStyleProps = self:getScrollBarStyleProps(p, self.props.scrollBarType)

	return Roact.createElement(ScrollBar, {
		userInteractionEnabled = scrollBarStyleProps.userInteractionEnabled,
		width = scrollBarStyleProps.width,
		anchorPoint = Vector2.new(1, 0),
		position = UDim2.new(1, -scrollBarStyleProps.marginRight, 0, 0),
		zIndex = 2,
		transparency = self.scrollBarImageTransparency,
		backgroundColor = scrollBarStyleProps.backgroundColor,
		paddingStartEnd = scrollBarStyleProps.paddingStartEnd,
		handleWidth = scrollBarStyleProps.handleWidth,
		handleColor = {
			Color = tokens.Color.Shift.Shift_400.Color3,
			Transparency = tokens.Color.Shift.Shift_400.Transparency
		},
		handleCornerRadius = tokens.Radius.Circle,
		handleIcon = scrollBarStyleProps.handleIcon,
		handleIconColor = scrollBarStyleProps.handleIconColor,
		handleIconSize = scrollBarStyleProps.handleIconSize,
		onDragging = self.onScrollBarDragging,
		viewSize = self.viewSize,
		canvasSize = self.mainCanvasSize,
		canvasPosition = self.getMainCanvasPosition()
	})
end

function extended:renderWithProviders(p, _, selectionImageObject)
	local position = self.props.position
	local size = self.props.size
	local layoutOrder = self.props.layoutOrder
	local canvasSizeY = self.props.canvasSizeY
	local automaticSize = self.props.automaticSize
	local y = self.props.useAutomaticCanvasSize and Enum.AutomaticSize.Y or nil
	local isGamepadFocusable = self.props.isGamepadFocusable
	local scrollingEnabled = self.props.scrollingEnabled

	local createElement = Roact.createElement
	local parentFrameRefsByRef = {
		BackgroundTransparency = 1,
		Position = position,
		Size = size,
		AutomaticSize = automaticSize,
		LayoutOrder = layoutOrder,
		ClipsDescendants = true,
		[Roact.Ref] = self.parentFrameRef
	}

	local createElement2 = Roact.createElement
	local scrollingFrame = isGamepadFocusable and Focusable.ScrollingFrame or "ScrollingFrame"
	local v2 = {}
	v2.Active = false
	v2.AutomaticSize = automaticSize
	v2.BackgroundTransparency = 1
	v2.BorderSizePixel = 0
	v2.Size = UDim2.fromScale(1, 1)
	v2.ElasticBehavior = self.props.elasticBehavior

	v2.CanvasSize = UDim2.new(UDim.new(1, 0), canvasSizeY)
	v2.AutomaticCanvasSize = y
	v2.CanvasPosition = self.mainCanvasPosition
	v2.ScrollingEnabled = scrollingEnabled
	v2.ScrollingDirection = Enum.ScrollingDirection.Y
	v2.ScrollBarImageTransparency = 1
	v2.ScrollBarThickness = 0
	v2.Selectable = self.props.selectable
	v2.SelectionImageObject = selectionImageObject
	local onFocusGained

	if isGamepadFocusable then
		onFocusGained = self.onGamepadFocused or nil
	end

	v2.onFocusGained = onFocusGained
	local onFocusLost

	if isGamepadFocusable then
		onFocusLost = self.onGamepadFocusLost or nil
	end

	v2.onFocusLost = onFocusLost

	v2.NextSelectionLeft = self.props.NextSelectionLeft
	v2.NextSelectionRight = self.props.NextSelectionRight
	v2.NextSelectionUp = self.props.NextSelectionUp
	v2.NextSelectionDown = self.props.NextSelectionDown

	v2[Roact.Event.InputBegan] = self.inputBegan
	v2[Roact.Event.InputEnded] = self.inputEnded
	v2[Roact.Change.CanvasPosition] = self.canvasPosition
	v2[Roact.Change.AbsoluteCanvasSize] = self.onMainCanvasSizeChange
	v2[Roact.Change.CanvasSize] = self.props[Roact.Change.CanvasSize]

	v2[Roact.Ref] = self.props.scrollingFrameRef

	v2[Roact.Change.AbsoluteSize] = self.onViewSizeChange
	local selectionChanged = Roact.Event.SelectionChanged
	local v3

	if isGamepadFocusable then
		v3 = self.onSelectionChanged
	end

	v2[selectionChanged] = v3
	return createElement("Frame", parentFrameRefsByRef, {
		MainCanvas = createElement2(scrollingFrame, v2, self.props[Roact.Children]),
		ScrollBar = self:renderScrollBar(p)
	})
end

function extended:render()
	return withStyle(function(p)
		return self:renderWithProviders(p, nil, self.props.cursor)
	end)
end

function extended.willUnmount(p)
	p.disconnectWaitToHideSidebar()
end

return Roact.forwardRef(function(p, scrollingFrameRef)
	local cursor = useCursorByType(CursorType.RoundedRect)
	return Roact.createElement(
		extended,
		Cryo.Dictionary.join(p, { scrollingFrameRef = scrollingFrameRef, cursor = cursor })
	)
end)
