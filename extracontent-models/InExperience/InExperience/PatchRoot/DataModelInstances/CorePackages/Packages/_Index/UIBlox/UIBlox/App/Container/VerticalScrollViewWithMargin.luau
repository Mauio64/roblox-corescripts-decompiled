local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Cryo = require(ParentParentParentParent.Cryo)
local Otter = require(ParentParentParentParent.Otter)
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local Focusable = require(ParentParentParentParent.RoactGamepad).Focusable
local withStyle = require(ParentParentParentParent.UIBlox.Core.Style.withStyle)
local useCursorByType = require(ParentParent.SelectionCursor.useCursorByType)
local CursorType = require(ParentParent.SelectionCursor.CursorType)
local getPageMargin = require(ParentParentParent.App.Container.getPageMargin)
local uDim = UDim.new(0, 0)
local t1 = {
	frequency = 3,
	dampingRatio = 1.5
}
local v17 = Roact.Component:extend("VerticalScrollView")

v17.validateProps = t.strictInterface({
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
v17.defaultProps = {
	useAutomaticCanvasSize = false,
	isGamepadFocusable = false,
	Selectable = true,
	size = UDim2.new(1, 0, 1, 0),
	canvasSizeY = UDim.new(2, 0)
}

function v17.init(p1) -- line: 92
	-- upvalues: Roact (copy), Otter (copy), t1 (copy), UserInputService (copy), RunService (copy), getPageMargin (copy)
	p1:setState({
		scrollBarThickness = 0,
		scrollingWithTouch = false
	})

	local v19, v20 = Roact.createBinding(0)

	p1.scrollBarImageTransparency = v19
	p1.updateScrollBarImageTransparency = v20
	p1.scrollBarImageTransparencyMotor = Otter.createSingleMotor(0)
	p1.scrollBarImageTransparencyMotor:onStep(p1.updateScrollBarImageTransparency)
	p1.lastTimeCanvasPositionChanged = tick()
	p1.waitToHideSidebarConnection = nil

	function p1.waitToHideSidebar() -- line: 105
		-- upvalues: p1 (copy), Otter (copy), t1 (copy)
		if tick() - p1.lastTimeCanvasPositionChanged > 0.7 then
			p1.scrollBarImageTransparencyMotor:setGoal(Otter.spring(1, t1))
			p1.disconnectWaitToHideSidebar()
		end
	end
	function p1.disconnectWaitToHideSidebar() -- line: 113
		-- upvalues: p1 (copy)
		if p1.waitToHideSidebarConnection then
			p1.waitToHideSidebarConnection:Disconnect()
			p1.waitToHideSidebarConnection = nil
		end
	end
	function p1.inputBegan(_, p3) -- line: 119
		-- upvalues: p1 (copy), Otter (copy)
		if p3.UserInputType == Enum.UserInputType.MouseMovement then
			p1.disconnectWaitToHideSidebar()
			p1:setState({
				scrollBarThickness = 8
			})
			p1.scrollBarImageTransparencyMotor:setGoal(Otter.instant(0))
		end
	end
	function p1.inputEnded(_, p5) -- line: 128
		-- upvalues: p1 (copy), Otter (copy)
		if p5.UserInputType == Enum.UserInputType.MouseMovement then
			p1.disconnectWaitToHideSidebar()
			p1.scrollBarImageTransparencyMotor:setGoal(Otter.instant(1))
		end
	end
	function p1.canvasPosition(p6) -- line: 134
		-- upvalues: p1 (copy), UserInputService (copy), Otter (copy), RunService (copy), Roact (copy)
		p1.lastTimeCanvasPositionChanged = tick()

		if not p1.waitToHideSidebarConnection and UserInputService:GetLastInputType() == Enum.UserInputType.Touch then
			p1.scrollBarImageTransparencyMotor:setGoal(Otter.instant(0))
			p1:setState({
				scrollBarThickness = 2
			})
			p1.waitToHideSidebarConnection = RunService.Heartbeat:Connect(p1.waitToHideSidebar)
		end

		if p1.props[Roact.Change.CanvasPosition] then
			p1.props[Roact.Change.CanvasPosition](p6)
		end
	end
	function p1.onGamepadFocused() -- line: 149
		-- upvalues: p1 (copy), Otter (copy)
		p1.scrollBarImageTransparencyMotor:setGoal(Otter.instant(0))
		p1:setState({
			scrollBarThickness = 2
		})
	end
	function p1.onGamepadFocusLost() -- line: 156
		-- upvalues: p1 (copy), Otter (copy)
		p1.scrollBarImageTransparencyMotor:setGoal(Otter.instant(1))
	end

	p1.parentFrameRef = Roact.createRef()

	local v21, v22 = Roact.createBinding(0)

	p1.paddingBinding = v21
	p1.updatePaddingBinding = v22

	function p1.getPadding(p7) -- line: 163
		-- upvalues: p1 (copy), getPageMargin (copy)
		local u48 = p7 or 0

		if p1.props.paddingHorizontal then
			local v49 = math.max(0, p1.props.paddingHorizontal - u48)

			return UDim.new(0, v49)
		end

		return p1.paddingBinding:map(function(p8) -- line: 169
			-- upvalues: getPageMargin (copy), u48 (ref)
			return UDim.new(0, getPageMargin(p8) - u48)
		end)
	end
end
function v17.renderWithProviders(p9, p10, _, p12) -- line: 176
	-- upvalues: Roact (copy), Cryo (copy), Focusable (copy), uDim (copy)
	local Theme = p10.Theme
	local canvasSizeY = p9.props.canvasSizeY
	local v29 = p9.props[Roact.Children] or {}
	local position = p9.props.position
	local size = p9.props.size
	local isGamepadFocusable = p9.props.isGamepadFocusable
	local scrollBarThickness = p9.state.scrollBarThickness
	local v34 = Cryo.Dictionary.join({
		scrollingFrameInnerMargin = Roact.createElement("UIPadding", {
			PaddingTop = if p9.props.paddingTop == nil then nil else UDim.new(0, p9.props.paddingTop),
			PaddingLeft = p9.getPadding(),
			PaddingRight = p9.getPadding(4)
		})
	}, v29)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = position,
		Size = size,
		[Roact.Change.AbsoluteSize] = function(p13) -- line: 200
			-- upvalues: p9 (copy)
			p9.updatePaddingBinding(p13.AbsoluteSize.X)
		end,
		[Roact.Ref] = p9.parentFrameRef
	}, {
		scrollingFrameOuterMargins = Roact.createElement("UIPadding", {
			PaddingRight = UDim.new(0, 4)
		}),
		scrollingFrame = Roact.createElement(isGamepadFocusable and Focusable.ScrollingFrame or "ScrollingFrame", {
			Active = true,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			ElasticBehavior = p9.props.elasticBehavior,
			CanvasSize = UDim2.new(uDim, canvasSizeY),
			AutomaticCanvasSize = p9.props.useAutomaticCanvasSize and Enum.AutomaticSize.Y or nil,
			ScrollBarImageColor3 = Theme.UIEmphasis.Color,
			ScrollBarImageTransparency = p9.scrollBarImageTransparency,
			ScrollBarThickness = scrollBarThickness,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollingEnabled = p9.props.ScrollingEnabled,
			CanvasPosition = p9.props.CanvasPosition,
			SelectionImageObject = p12,
			onFocusGained = isGamepadFocusable and p9.onGamepadFocused or nil,
			onFocusLost = isGamepadFocusable and p9.onGamepadFocusLost or nil,
			Selectable = p9.props.Selectable,
			NextSelectionLeft = p9.props.NextSelectionLeft,
			NextSelectionRight = p9.props.NextSelectionRight,
			NextSelectionUp = p9.props.NextSelectionUp,
			NextSelectionDown = p9.props.NextSelectionDown,
			[Roact.Event.InputBegan] = p9.inputBegan,
			[Roact.Event.InputEnded] = p9.inputEnded,
			[Roact.Change.CanvasPosition] = p9.canvasPosition,
			[Roact.Change.CanvasSize] = p9.props[Roact.Change.CanvasSize],
			[Roact.Event.SelectionChanged] = p9.props.onSelectionChanged,
			[Roact.Ref] = p9.props.scrollingFrameRef
		}, v34)
	})
end
function v17.render(p14) -- line: 251
	-- upvalues: withStyle (copy)
	return withStyle(function(p15) -- line: 252
		-- upvalues: p14 (copy)
		return p14:renderWithProviders(p15, nil, p14.props.cursor)
	end)
end
function v17.didMount(p16) -- line: 257
	local v37 = p16.parentFrameRef:getValue()

	if v37 then
		p16.updatePaddingBinding(v37.AbsoluteSize.X)
	end
end
function v17.willUnmount(p17) -- line: 264
	p17.disconnectWaitToHideSidebar()
end

return Roact.forwardRef(function(p18, p19) -- line: 268
	-- upvalues: useCursorByType (copy), CursorType (copy), Roact (copy), v17 (copy), Cryo (copy)
	local v41 = useCursorByType(CursorType.RoundedRect)

	return Roact.createElement(v17, Cryo.Dictionary.join(p18, {
		scrollingFrameRef = p19,
		cursor = v41
	}))
end)
