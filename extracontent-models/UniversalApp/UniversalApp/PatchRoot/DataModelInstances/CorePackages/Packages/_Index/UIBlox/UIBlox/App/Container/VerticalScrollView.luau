local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local scriptParent = script.Parent
local ParentParent = script.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local Cryo = require(ParentParent2.Cryo)
local Otter = require(ParentParent2.Otter)
local Roact = require(ParentParent2.Roact)
local t = require(ParentParent2.t)
local Focusable = require(ParentParent2.RoactGamepad).Focusable
local withStyle = require(ParentParent2.UIBlox.Core.Style.withStyle)
local useCursorByType = require(ParentParent.SelectionCursor.useCursorByType)
local CursorType = require(ParentParent.SelectionCursor.CursorType)
local Images = require(ParentParent2.UIBlox.App.ImageSet.Images)
local ScrollBarType = require(scriptParent.Enum.ScrollBarType)
local ScrollBar = require(script.Parent.ScrollBar)
local t1 = {
	frequency = 3,
	dampingRatio = 1.5
}
local v18 = Roact.Component:extend("VerticalScrollView")

v18.validateProps = t.strictInterface({
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
v18.defaultProps = {
	useAutomaticCanvasSize = false,
	isGamepadFocusable = false,
	selectable = nil,
	scrollingEnabled = true,
	size = UDim2.new(1, 0, 1, 0),
	canvasSizeY = UDim.new(2, 0),
	automaticSize = Enum.AutomaticSize.None,
	scrollBarType = ScrollBarType.Compact
}

function v18.init(p1) -- line: 90
	-- upvalues: Roact (copy), Otter (copy), t1 (copy), UserInputService (copy), RunService (copy)
	p1.parentFrameRef = Roact.createRef()
	p1.mainCanvasRef = Roact.createRef()

	local v20, v21 = Roact.createBinding(0)

	p1.scrollPosition = v20
	p1.updateScroll = v21

	local v22, v23 = Roact.createBinding(Vector2.new(0, 0))

	p1.mainCanvasSize = v22
	p1.updateCanvasSize = v23
	p1:setState({
		scrollingWithTouch = false
	})

	local v24, v25 = Roact.createBinding(1)

	p1.scrollBarImageTransparency = v24
	p1.updateScrollBarImageTransparency = v25
	p1.scrollBarImageTransparencyMotor = Otter.createSingleMotor(0)
	p1.scrollBarImageTransparencyMotor:onStep(p1.updateScrollBarImageTransparency)
	p1.lastTimeCanvasPositionChanged = tick()
	p1.waitToHideSidebarConnection = nil

	function p1.waitToHideSidebar() -- line: 108
		-- upvalues: p1 (copy), Otter (copy), t1 (copy)
		if tick() - p1.lastTimeCanvasPositionChanged > 0.7 then
			p1.scrollBarImageTransparencyMotor:setGoal(Otter.spring(1, t1))
			p1.disconnectWaitToHideSidebar()
		end
	end
	function p1.disconnectWaitToHideSidebar() -- line: 116
		-- upvalues: p1 (copy)
		if p1.waitToHideSidebarConnection then
			p1.waitToHideSidebarConnection:Disconnect()
			p1.waitToHideSidebarConnection = nil
		end
	end
	function p1.inputBegan(_, p3) -- line: 122
		-- upvalues: p1 (copy), Otter (copy)
		if not p1.props.scrollingEnabled then
			return
		end

		if p3.UserInputType == Enum.UserInputType.MouseMovement then
			p1.disconnectWaitToHideSidebar()
			p1.scrollBarImageTransparencyMotor:setGoal(Otter.instant(0))
		end
	end
	function p1.inputEnded(_, p5) -- line: 132
		-- upvalues: p1 (copy), Otter (copy)
		if not p1.props.scrollingEnabled then
			return
		end

		if p5.UserInputType == Enum.UserInputType.MouseMovement then
			p1.disconnectWaitToHideSidebar()
			p1.scrollBarImageTransparencyMotor:setGoal(Otter.instant(1))
		end
	end
	function p1.canvasPosition(p6) -- line: 142
		-- upvalues: p1 (copy), UserInputService (copy), Otter (copy), RunService (copy), Roact (copy)
		p1.lastTimeCanvasPositionChanged = tick()

		if not p1.waitToHideSidebarConnection and UserInputService:GetLastInputType() == Enum.UserInputType.Touch then
			p1.scrollBarImageTransparencyMotor:setGoal(Otter.instant(0))
			p1.waitToHideSidebarConnection = RunService.Heartbeat:Connect(p1.waitToHideSidebar)
		end

		p1.updateScroll(p6.CanvasPosition.Y)

		if p1.props[Roact.Change.CanvasPosition] then
			p1.props[Roact.Change.CanvasPosition](p6)
		end
	end
	function p1.onGamepadFocused() -- line: 156
		-- upvalues: p1 (copy), Otter (copy)
		p1.scrollBarImageTransparencyMotor:setGoal(Otter.instant(0))
	end
	function p1.onGamepadFocusLost() -- line: 160
		-- upvalues: p1 (copy), Otter (copy)
		p1.scrollBarImageTransparencyMotor:setGoal(Otter.instant(1))
	end
	function p1.getMainCanvasPosition() -- line: 164
		-- upvalues: p1 (copy)
		return p1.scrollPosition:map(function(p7) -- line: 165
			return Vector2.new(0, p7)
		end)
	end
	function p1.onMainCanvasSizeChange(p8) -- line: 170
		-- upvalues: p1 (copy)
		p1.updateCanvasSize(p8.AbsoluteCanvasSize)
	end
	function p1.getMainCanvasSize() -- line: 174
		-- upvalues: p1 (copy)
		return p1.mainCanvasSize:map(function(p9) -- line: 175
			return UDim2.new(0, 2, 0, p9.Y)
		end)
	end

	local v26, v27 = Roact.createBinding(Vector2.new(0, 0))

	p1.viewSize = v26
	p1.updateViewSize = v27

	local v28, v29 = Roact.createBinding(Vector2.new(0, 0))

	p1.mainCanvasPosition = v28
	p1.updateMainCanvasPosition = v29

	function p1.onScrollBarDragging(p10) -- line: 183
		-- upvalues: p1 (copy)
		p1.updateMainCanvasPosition(Vector2.new(0, p10))
	end
	function p1.onViewSizeChange(p11) -- line: 187
		-- upvalues: p1 (copy)
		p1.updateViewSize(p11.AbsoluteSize)
	end
	function p1.onSelectionChanged(p12, p13, _, p15) -- line: 191
		-- upvalues: p1 (copy)
		if not p13 and p15 == nil then
			p1.onGamepadFocusLost()

			return
		end

		if p13 or p15:IsDescendantOf(p12) then
			p1.onGamepadFocused()

			return
		end

		p1.onGamepadFocusLost()
	end
end
function v18.getScrollBarStyleProps(_, p17, p18) -- line: 205
	-- upvalues: ScrollBarType (copy), Images (copy)
	local Tokens = p17.Tokens

	if p18 == ScrollBarType.Wide then
		return {
			userInteractionEnabled = true,
			marginRight = 0,
			width = Tokens.Global.Size_200,
			handleWidth = Tokens.Global.Size_100,
			paddingStartEnd = Tokens.Global.Space_50
		}
	end

	if p18 == ScrollBarType.Gamepad then
		return {
			userInteractionEnabled = false,
			width = Tokens.Global.Space_200,
			handleWidth = Tokens.Global.Space_100,
			handleIcon = Images["icons/controls/keys/xboxRSVertical"],
			handleIconSize = Tokens.Semantic.Icon.Size.Medium,
			handleIconColor = {
				Color = Tokens.Semantic.Color.Icon.Emphasis.Color3,
				Transparency = Tokens.Semantic.Color.Icon.Emphasis.Transparency
			},
			paddingStartEnd = Tokens.Global.Space_300,
			marginRight = Tokens.Global.Space_300
		}
	end

	return {
		userInteractionEnabled = false,
		marginRight = 0,
		width = Tokens.Global.Space_150,
		handleWidth = Tokens.Global.Size_25,
		paddingStartEnd = Tokens.Global.Space_50
	}
end
function v18.renderScrollBar(p19, p20) -- line: 242
	-- upvalues: Roact (copy), ScrollBar (copy)
	local Tokens = p20.Tokens
	local v37 = p19:getScrollBarStyleProps(p20, p19.props.scrollBarType)

	return Roact.createElement(ScrollBar, {
		zIndex = 2,
		userInteractionEnabled = v37.userInteractionEnabled,
		width = v37.width,
		anchorPoint = Vector2.new(1, 0),
		position = UDim2.new(1, -v37.marginRight, 0, 0),
		transparency = p19.scrollBarImageTransparency,
		backgroundColor = v37.backgroundColor,
		paddingStartEnd = v37.paddingStartEnd,
		handleWidth = v37.handleWidth,
		handleColor = {
			Color = Tokens.Semantic.Color.Ui.Emphasis.Color3,
			Transparency = Tokens.Semantic.Color.Ui.Emphasis.Transparency
		},
		handleCornerRadius = Tokens.Semantic.Radius.Circle,
		handleIcon = v37.handleIcon,
		handleIconColor = v37.handleIconColor,
		handleIconSize = v37.handleIconSize,
		onDragging = p19.onScrollBarDragging,
		viewSize = p19.viewSize,
		canvasSize = p19.mainCanvasSize,
		canvasPosition = p19.getMainCanvasPosition()
	})
end
function v18.renderWithProviders(p21, p22, _, p24) -- line: 274
	-- upvalues: Roact (copy), Focusable (copy)
	local position = p21.props.position
	local size = p21.props.size
	local layoutOrder = p21.props.layoutOrder
	local canvasSizeY = p21.props.canvasSizeY
	local automaticSize = p21.props.automaticSize
	local v47 = p21.props.useAutomaticCanvasSize and Enum.AutomaticSize.Y or nil
	local isGamepadFocusable = p21.props.isGamepadFocusable
	local scrollingEnabled = p21.props.scrollingEnabled

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = position,
		Size = size,
		AutomaticSize = automaticSize,
		LayoutOrder = layoutOrder,
		ClipsDescendants = true,
		[Roact.Ref] = p21.parentFrameRef
	}, {
		MainCanvas = Roact.createElement(isGamepadFocusable and Focusable.ScrollingFrame or "ScrollingFrame", {
			Active = false,
			AutomaticSize = automaticSize,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			ElasticBehavior = p21.props.elasticBehavior,
			CanvasSize = UDim2.new(UDim.new(1, 0), canvasSizeY),
			AutomaticCanvasSize = v47,
			CanvasPosition = p21.mainCanvasPosition,
			ScrollingEnabled = scrollingEnabled,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarImageTransparency = 1,
			ScrollBarThickness = 0,
			Selectable = p21.props.selectable,
			SelectionImageObject = p24,
			onFocusGained = isGamepadFocusable and p21.onGamepadFocused or nil,
			onFocusLost = isGamepadFocusable and p21.onGamepadFocusLost or nil,
			NextSelectionLeft = p21.props.NextSelectionLeft,
			NextSelectionRight = p21.props.NextSelectionRight,
			NextSelectionUp = p21.props.NextSelectionUp,
			NextSelectionDown = p21.props.NextSelectionDown,
			[Roact.Event.InputBegan] = p21.inputBegan,
			[Roact.Event.InputEnded] = p21.inputEnded,
			[Roact.Change.CanvasPosition] = p21.canvasPosition,
			[Roact.Change.AbsoluteCanvasSize] = p21.onMainCanvasSizeChange,
			[Roact.Change.CanvasSize] = p21.props[Roact.Change.CanvasSize],
			[Roact.Ref] = p21.props.scrollingFrameRef,
			[Roact.Change.AbsoluteSize] = p21.onViewSizeChange,
			[Roact.Event.SelectionChanged] = if not isGamepadFocusable then nil else p21.onSelectionChanged
		}, p21.props[Roact.Children]),
		ScrollBar = p21:renderScrollBar(p22)
	})
end
function v18.render(p25) -- line: 345
	-- upvalues: withStyle (copy)
	return withStyle(function(p26) -- line: 346
		-- upvalues: p25 (copy)
		return p25:renderWithProviders(p26, nil, p25.props.cursor)
	end)
end
function v18.willUnmount(p27) -- line: 351
	p27.disconnectWaitToHideSidebar()
end

return Roact.forwardRef(function(p28, p29) -- line: 355
	-- upvalues: useCursorByType (copy), CursorType (copy), Roact (copy), v18 (copy), Cryo (copy)
	local v54 = useCursorByType(CursorType.RoundedRect)

	return Roact.createElement(v18, Cryo.Dictionary.join(p28, {
		scrollingFrameRef = p29,
		cursor = v54
	}))
end)
