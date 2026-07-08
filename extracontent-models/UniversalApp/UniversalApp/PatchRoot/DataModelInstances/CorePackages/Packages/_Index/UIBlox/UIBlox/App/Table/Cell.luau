local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Core = ParentParentParent.Core
local ParentParentParentParent = ParentParentParent.Parent
local Cryo = require(ParentParentParentParent.Cryo)
local t = require(ParentParentParentParent.t)
local Roact = require(ParentParentParentParent.Roact)
local enumerate = require(ParentParentParentParent.enumerate)
local bindingValidator = require(Core.Utility.bindingValidator)
local withStyle = require(Core.Style.withStyle)
local withSelectionCursorProvider = require(ParentParent.SelectionImage.withSelectionCursorProvider)
local useCursorByType = require(ParentParent.SelectionCursor.useCursorByType)
local Interactable = require(Core.Control.Interactable)
local ControlState = require(Core.Control.Enum.ControlState)
local CursorType = require(ParentParent.SelectionCursor.CursorType)
local v16 = Roact.PureComponent:extend("Cell")

v16.debugProps = enumerate("debugProps", { "controlState" })
v16.validateProps = t.strictInterface({
	head = t.table,
	tail = t.optional(t.table),
	background = t.optional(t.table),
	layoutOrder = t.optional(t.union(t.integer, bindingValidator(t.number))),
	size = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	horizontalPadding = t.optional(t.number),
	selectable = t.optional(t.boolean),
	layoutWraps = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	userInteractionEnabled = t.optional(t.boolean),
	onStateChanged = t.optional(t.callback),
	onActivated = t.optional(t.callback),
	onTouchTapped = t.optional(t.callback),
	[v16.debugProps.controlState] = t.optional(ControlState.isEnumValue),
	[Roact.Change.AbsolutePosition] = t.optional(t.callback),
	[Roact.Ref] = t.optional(t.union(t.callback, t.table)),
	forwardRef = t.optional(t.union(t.callback, t.table)),
	selectionCursor = t.optional(t.any)
})
v16.defaultProps = {
	isDisabled = false,
	userInteractionEnabled = true,
	horizontalPadding = 24
}

function v16.init(p1) -- line: 79
	-- upvalues: ControlState (copy)
	p1:setState({
		controlState = ControlState.Initialize
	})
	p1.stateStyleMap = {
		[ControlState.Default] = "BackgroundDefault",
		[ControlState.Hover] = "BackgroundOnHover",
		[ControlState.Pressed] = "BackgroundOnPress"
	}

	function p1.getBackgroundStyle(p2, p3) -- line: 90
		-- upvalues: p1 (copy), ControlState (copy)
		local v40 = p1.stateStyleMap[p2] or p1.stateStyleMap[ControlState.Default]
		local t1 = {
			Color = p3.Theme[v40].Color,
			Transparency = p3.Theme[v40].Transparency
		}

		if p2 == ControlState.Disabled then
			t1.Transparency = 1
		end

		return t1
	end
	function p1.onStateChanged(p4, p5) -- line: 106
		-- upvalues: p1 (copy)
		p1:setState({
			controlState = p5
		})

		if p1.props.onStateChanged then
			p1.props.onStateChanged(p4, p5)
		end
	end
end
function v16.render(p6) -- line: 116
	-- upvalues: withStyle (copy), withSelectionCursorProvider (copy)
	return withStyle(function(p7) -- line: 117
		-- upvalues: withSelectionCursorProvider (copy), p6 (copy)
		return withSelectionCursorProvider(function(p8) -- line: 118
			-- upvalues: p6 (copy), p7 (copy)
			return p6:renderWithProviders(p7, p8)
		end)
	end)
end
function v16.renderWithProviders(p9, p10, _) -- line: 124
	-- upvalues: v16 (copy), Roact (copy), Interactable (copy), ControlState (copy)
	local anchorPoint = p9.props.anchorPoint
	local layoutOrder = p9.props.layoutOrder
	local position = p9.props.position
	local v25 = p9.props.size or UDim2.fromScale(1, 1)
	local head = p9.props.head
	local tail = p9.props.tail
	local background = p9.props.background
	local isDisabled = p9.props.isDisabled
	local v30 = if not p9.props.onActivated then p9.props.onActivated else function(...) -- line: 139
		-- upvalues: p9 (copy)
		if p9.props.tail and p9.props.userInteractionEnabled and p9.props.onActivated then
			p9.props.onActivated(...)
		end
	end
	local onTouchTapped = p9.props.onTouchTapped
	local v32 = p9.props[v16.debugProps.controlState] or p9.state.controlState
	local v33 = p9.getBackgroundStyle(v32, p10)

	return Roact.createElement(Interactable, {
		AnchorPoint = anchorPoint,
		LayoutOrder = layoutOrder,
		Position = position,
		Size = v25,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Selectable = p9.props.selectable,
		SelectionImageObject = p9.props.selectionCursor,
		isDisabled = isDisabled,
		onStateChanged = p9.onStateChanged,
		[Roact.Event.Activated] = v30,
		[Roact.Event.TouchTap] = onTouchTapped,
		[Roact.Change.AbsolutePosition] = p9.props[Roact.Change.AbsolutePosition],
		[Roact.Ref] = p9.props.forwardRef
	}, {
		CellBackground = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = -1,
			Size = v25,
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Background = background or Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = v33.Color,
				BackgroundTransparency = v33.Transparency
			}),
			CellContent = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
					Wraps = p9.props.layoutWraps
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, p9.props.horizontalPadding),
					PaddingRight = UDim.new(0, p9.props.horizontalPadding)
				}),
				CellHead = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.fromScale(0, 0.5),
					AutomaticSize = Enum.AutomaticSize.XY
				}, {
					Head = head
				}),
				CellTail = tail and Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.fromScale(1, 0.5),
					AutomaticSize = Enum.AutomaticSize.XY
				}, {
					Tail = tail
				}) or nil
			})
		}),
		DisabledMask = v32 == ControlState.Disabled and Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 0.5,
			ZIndex = 100,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v33.Color
		}) or nil
	})
end

return Roact.forwardRef(function(p12, p13) -- line: 233
	-- upvalues: useCursorByType (copy), CursorType (copy), Cryo (copy), Roact (copy), v16 (copy)
	local v36 = useCursorByType(CursorType.RoundedRectNoInset)
	local v37 = Cryo.Dictionary.join({
		selectionCursor = v36
	}, p12)

	return Roact.createElement(v16, Cryo.Dictionary.join(v37, {
		forwardRef = p13
	}))
end)
