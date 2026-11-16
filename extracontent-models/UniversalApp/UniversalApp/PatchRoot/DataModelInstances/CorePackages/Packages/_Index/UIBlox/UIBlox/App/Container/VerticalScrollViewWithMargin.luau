local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Cryo = require(parent3.Cryo)
local Otter = require(parent3.Otter)
local Roact = require(parent3.Roact)
local t = require(parent3.t)
local RoactGamepad = require(parent3.RoactGamepad)

local Focusable = RoactGamepad.Focusable

local withStyle = require(parent3.UIBlox.Core.Style.withStyle)
local useCursorByType = require(parent.SelectionCursor.useCursorByType)
local CursorType = require(parent.SelectionCursor.CursorType)

local getPageMargin = require(parent2.App.Container.getPageMargin)

local udim = UDim.new(0, 0)

local v = { frequency = 3, dampingRatio = 1.5 }

local extended = Roact.Component:extend("VerticalScrollView")

extended.validateProps = t.strictInterface({
	size = t.optional(t.UDim2),
	position = t.optional(t.UDim2),
	elasticBehavior = t.optional(t.EnumItem),
	canvasSizeY = t.optional(t.UDim),
	useAutomaticCanvasSize = t.optional(t.boolean),
	paddingHorizontal = t.optional(t.number),
	paddingTop = t.optional(t.number),
	isGamepadFocusable = t.optional(t.boolean),
	Selectable = t.optional(t.boolean),
	[Roact.Change.CanvasPosition] = t.optional(t.callback),
	[Roact.Change.CanvasSize] = t.optional(t.callback),
	scrollingFrameRef = t.optional(t.table),
	onSelectionChanged = t.optional(t.callback),
	CanvasPosition = t.optional(t.union(t.table, t.Vector2)),
	ScrollingEnabled = t.optional(t.boolean),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	cursor = t.table,
	[Roact.Children] = t.optional(t.table)
})

extended.defaultProps = {
	size = UDim2.new(1, 0, 1, 0),
	canvasSizeY = UDim.new(2, 0),
	useAutomaticCanvasSize = false,
	isGamepadFocusable = false,
	Selectable = true
}

function extended:init()
	self:setState({ scrollBarThickness = 0, scrollingWithTouch = false })

	local binding, updateScrollBarImageTransparency = Roact.createBinding(0)
	self.scrollBarImageTransparency = binding
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
		if p.UserInputType == Enum.UserInputType.MouseMovement then
			self.disconnectWaitToHideSidebar()
			self:setState({ scrollBarThickness = 8 })

			self.scrollBarImageTransparencyMotor:setGoal(Otter.instant(0))
		end
	end
	function self.inputEnded(_, p)
		if p.UserInputType == Enum.UserInputType.MouseMovement then
			self.disconnectWaitToHideSidebar()
			self.scrollBarImageTransparencyMotor:setGoal(Otter.instant(1))
		end
	end
	function self.canvasPosition(p)
		self.lastTimeCanvasPositionChanged = tick()

		if not self.waitToHideSidebarConnection and UserInputService:GetLastInputType() == Enum.UserInputType.Touch then
			self.scrollBarImageTransparencyMotor:setGoal(Otter.instant(0))
			self:setState({ scrollBarThickness = 2 })

			self.waitToHideSidebarConnection = RunService.Heartbeat:Connect(self.waitToHideSidebar)
		end

		if self.props[Roact.Change.CanvasPosition] then
			self.props[Roact.Change.CanvasPosition](p)
		end
	end

	function self.onGamepadFocused()
		self.scrollBarImageTransparencyMotor:setGoal(Otter.instant(0))
		self:setState({ scrollBarThickness = 2 })
	end

	function self.onGamepadFocusLost()
		self.scrollBarImageTransparencyMotor:setGoal(Otter.instant(1))
	end

	self.parentFrameRef = Roact.createRef()
	local binding2, updatePaddingBinding = Roact.createBinding(0)
	self.paddingBinding = binding2
	self.updatePaddingBinding = updatePaddingBinding

	function self.getPadding(value)
		local v2 = value or 0

		if not self.props.paddingHorizontal then
			return self.paddingBinding:map(function(p)
				return UDim.new(0, getPageMargin(p) - v2)
			end)
		end

		local v3 = math.max(0, self.props.paddingHorizontal - v2)
		return UDim.new(0, v3)
	end
end

function extended:renderWithProviders(p, _, selectionImageObject)
	local theme = p.Theme

	local canvasSizeY = self.props.canvasSizeY
	local v2 = self.props[Roact.Children] or {}
	local position = self.props.position
	local size = self.props.size

	local isGamepadFocusable = self.props.isGamepadFocusable

	local scrollBarThickness = self.state.scrollBarThickness

	local join = Cryo.Dictionary.join
	local createElement = Roact.createElement
	local paddingTop

	if self.props.paddingTop ~= nil then
		paddingTop = UDim.new(0, self.props.paddingTop)
	end

	local v3 = join({
		scrollingFrameInnerMargin = createElement("UIPadding", {
			PaddingTop = paddingTop,
			PaddingLeft = self.getPadding(),
			PaddingRight = self.getPadding(4)
		})
	}, v2)

	local createElement2 = Roact.createElement
	local v4 = {
		BackgroundTransparency = 1,
		Position = position,
		Size = size,
		[Roact.Change.AbsoluteSize] = function(p2)
			self.updatePaddingBinding(p2.AbsoluteSize.X)
		end,
		[Roact.Ref] = self.parentFrameRef
	}
	local v5 = {
		scrollingFrameOuterMargins = Roact.createElement("UIPadding", {
			PaddingRight = UDim.new(0, 4)
		}),
		scrollingFrame = 0
	}

	local createElement3 = Roact.createElement
	local scrollingFrame = isGamepadFocusable and Focusable.ScrollingFrame or "ScrollingFrame"
	local v6 = {}
	v6.Active = true
	v6.BackgroundTransparency = 1
	v6.BorderSizePixel = 0
	v6.Size = UDim2.fromScale(1, 1)
	v6.ElasticBehavior = self.props.elasticBehavior

	v6.CanvasSize = UDim2.new(udim, canvasSizeY)
	v6.AutomaticCanvasSize = self.props.useAutomaticCanvasSize and Enum.AutomaticSize.Y or nil
	v6.ScrollBarImageColor3 = theme.UIEmphasis.Color
	v6.ScrollBarImageTransparency = self.scrollBarImageTransparency
	v6.ScrollBarThickness = scrollBarThickness
	v6.ScrollingDirection = Enum.ScrollingDirection.Y
	v6.ScrollingEnabled = self.props.ScrollingEnabled
	v6.CanvasPosition = self.props.CanvasPosition
	v6.SelectionImageObject = selectionImageObject
	local onFocusGained

	if isGamepadFocusable then
		onFocusGained = self.onGamepadFocused or nil
	end

	v6.onFocusGained = onFocusGained
	local onFocusLost

	if isGamepadFocusable then
		onFocusLost = self.onGamepadFocusLost or nil
	end

	v6.onFocusLost = onFocusLost

	v6.Selectable = self.props.Selectable

	v6.NextSelectionLeft = self.props.NextSelectionLeft
	v6.NextSelectionRight = self.props.NextSelectionRight
	v6.NextSelectionUp = self.props.NextSelectionUp
	v6.NextSelectionDown = self.props.NextSelectionDown

	v6[Roact.Event.InputBegan] = self.inputBegan
	v6[Roact.Event.InputEnded] = self.inputEnded
	v6[Roact.Change.CanvasPosition] = self.canvasPosition
	v6[Roact.Change.CanvasSize] = self.props[Roact.Change.CanvasSize]
	v6[Roact.Event.SelectionChanged] = self.props.onSelectionChanged
	v6[Roact.Ref] = self.props.scrollingFrameRef
	v5.scrollingFrame = createElement3(scrollingFrame, v6, v3)
	return createElement2("Frame", v4, v5)
end

function extended:render()
	return withStyle(function(p)
		return self:renderWithProviders(p, nil, self.props.cursor)
	end)
end

function extended.didMount(p)
	local value = p.parentFrameRef:getValue()

	if value then
		p.updatePaddingBinding(value.AbsoluteSize.X)
	end
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
