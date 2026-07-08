local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local RoactGamepad = require(ParentParentParentParent.RoactGamepad)
local Roact = require(ParentParentParentParent.Roact)
local React = require(ParentParentParentParent.React)
local Cryo = require(ParentParentParentParent.Cryo)
local t = require(ParentParentParentParent.t)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local useStyle = require(ParentParentParent.Core.Style.useStyle)
local validateColorInfo = require(ParentParentParent.Core.Style.Validator.validateColorInfo)
local ImageSetComponent = require(ParentParentParent.Core.ImageSet.ImageSetComponent)
local validateButtonProps = require(script.Parent.validateButtonProps)
local VerticalScrollView = require(ParentParent.Container.VerticalScrollView)
local Images = require(ParentParent.ImageSet.Images)
local withSelectionCursorProvider = require(ParentParent.SelectionImage.withSelectionCursorProvider)
local CursorKind = require(ParentParent.SelectionImage.CursorKind)
local setDefault = require(ParentParentParent.Utility.setDefault)
local Cell = require(script.Parent.Cell)
local RoundedFrame = require(script.Parent.RoundedFrame)
local StyleDefaults = require(script.Parent.StyleDefaults)
local v22 = Images["component_assets/dropshadow_17_8"]
local v23 = Roact.PureComponent:extend("BaseMenu")

v23.validateProps = t.strictInterface({
	buttonProps = validateButtonProps,
	width = t.optional(t.UDim),
	position = t.optional(t.union(t.UDim2, t.table)),
	anchorPoint = t.optional(t.Vector2),
	layoutOrder = t.optional(t.number),
	topElementRounded = t.optional(t.boolean),
	bottomElementRounded = t.optional(t.boolean),
	setFirstItemRef = t.optional(t.union(t.callback, t.table)),
	setFrameRef = t.optional(t.union(t.callback, t.table)),
	stayOnActivated = t.optional(t.boolean),
	maxHeight = t.optional(t.number),
	showDropShadow = t.optional(t.boolean),
	fixedListHeight = t.optional(t.number),
	isElementBackgroundVisible = t.optional(t.boolean),
	isElementDividerVisible = t.optional(t.boolean),
	elementHeight = t.optional(t.number),
	borderCornerRadius = t.optional(t.integer),
	background = t.optional(validateColorInfo),
	enableTokenOverride = t.optional(t.boolean),
	renderHeader = t.optional(t.callback),
	headerHeight = t.optional(t.number),
	selectionOrder = t.optional(t.number),
	isRoactGamepadEnabled = t.optional(t.boolean)
})
v23.defaultProps = {
	topElementRounded = true,
	bottomElementRounded = true,
	showDropShadow = false,
	fixedListHeight = nil,
	isElementBackgroundVisible = true,
	isElementDividerVisible = true,
	elementHeight = 56,
	borderCornerRadius = 4,
	enableTokenOverride = true,
	headerHeight = 0,
	isRoactGamepadEnabled = true,
	width = UDim.new(1, 0),
	position = UDim2.new(0, 0, 0, 0)
}

function v23.init(p1) -- line: 98
	-- upvalues: RoactGamepad (copy)
	p1.gamepadRefs = p1.props.isRoactGamepadEnabled and RoactGamepad.createRefCache() or {}
end
function v23.renderFixedHeightMenu(_, p3, p4, p5) -- line: 102
	-- upvalues: setDefault (copy), Roact (copy), ImageSetComponent (copy), v22 (copy), VerticalScrollView (copy)
	local fixedListHeight = p3.fixedListHeight
	local v31 = setDefault(p3.borderCornerRadius, 8)
	local BackgroundUIDefault = p4.Theme.BackgroundUIDefault
	local v33 = setDefault(p3.background, {
		Color = BackgroundUIDefault.Color,
		Transparency = BackgroundUIDefault.Transparency
	})

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = p3.anchorPoint,
		LayoutOrder = p3.layoutOrder,
		Size = UDim2.new(p3.width.Scale, p3.width.Offset, 0, fixedListHeight),
		Position = p3.position
	}, {
		DropShadow = p3.showDropShadow and Roact.createElement(ImageSetComponent.Label, {
			ZIndex = 2,
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 16, 1, 16),
			Image = v22,
			ImageColor3 = p4.Theme.DropShadow.Color,
			ImageTransparency = p4.Theme.DropShadow.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(16, 16, 16, 16)
		}) or nil,
		ContentFrame = Roact.createElement("Frame", {
			ZIndex = 3,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundColor3 = v33.Color,
			BackgroundTransparency = v33.Transparency
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, v31)
			}),
			ClippingFrame = Roact.createElement("Frame", {
				ZIndex = 4,
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Size = UDim2.new(1, 0, 1, -v31 * 2),
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5)
			}, {
				ScrollingFrame = Roact.createElement(VerticalScrollView, {
					selectable = false,
					canvasSizeY = UDim.new(0, #p3.buttonProps * p3.elementHeight)
				}, p5)
			})
		})
	})
end
function v23.render(p6) -- line: 157
	-- upvalues: Cryo (copy), Roact (copy), CursorKind (copy), withSelectionCursorProvider (copy), RoactGamepad (copy), Cell (copy), withStyle (copy), setDefault (copy), ImageSetComponent (copy), v22 (copy), RoundedFrame (copy)
	local headerHeight = p6.props.headerHeight
	local v36 = p6.props.elementHeight * 7.5 + headerHeight
	local u37 = #p6.props.buttonProps * p6.props.elementHeight + headerHeight
	local u38 = false

	if v36 <= u37 then
		u37 = v36
		u38 = true
	end

	local maxHeight = p6.props.maxHeight

	if maxHeight and maxHeight > 0 and maxHeight < u37 then
		u37 = (math.max(math.floor((maxHeight - p6.props.elementHeight * 0.5 - headerHeight) / p6.props.elementHeight), 1) + 0.5) * p6.props.elementHeight + headerHeight
		u38 = true
	end

	local t1 = {}

	for i, v in ipairs(p6.props.buttonProps) do
		local v43 = Cryo.Dictionary.join(v, {
			elementHeight = p6.props.elementHeight,
			hasRoundTop = p6.props.topElementRounded and (i == 1 and not u38),
			hasRoundBottom = p6.props.bottomElementRounded and (i == #p6.props.buttonProps and not u38),
			hasDivider = not not p6.props.isElementDividerVisible and i < #p6.props.buttonProps,
			layoutOrder = i,
			inputBindingKey = Cryo.None,
			setButtonRef = i == 1 and p6.props.setFirstItemRef or nil,
			isElementBackgroundVisible = p6.props.isElementBackgroundVisible,
			borderCornerRadius = p6.props.borderCornerRadius,
			background = p6.props.background
		})

		if not p6.props.isRoactGamepadEnabled then
			p6.gamepadRefs[i] = p6.gamepadRefs[i] or Roact.createRef()
		end

		local u44 = if not v43.hasRoundBottom or not v43.hasRoundTop then if not v43.hasRoundBottom then if not v43.hasRoundTop then CursorKind.Square else CursorKind.BulletUp else CursorKind.BulletDown else CursorKind.RoundedRectNoInset
		local u45 = Cryo.Dictionary.join(v43, {
			cursorKind = u44,
			selectionOrder = p6.props.selectionOrder
		})

		t1["cell " .. i] = withSelectionCursorProvider(function(p7) -- line: 212
			-- upvalues: Roact (copy), p6 (copy), RoactGamepad (copy), i (copy), v (copy), u44 (ref), Cell (copy), u45 (ref)
			return Roact.createElement(not p6.props.isRoactGamepadEnabled and "Frame" or RoactGamepad.Focusable.Frame, {
				Size = UDim2.new(p6.props.width, UDim.new(0, p6.props.elementHeight)),
				BackgroundTransparency = 1,
				LayoutOrder = i,
				[Roact.Ref] = p6.gamepadRefs[i],
				NextSelectionUp = i > 1 and p6.gamepadRefs[i - 1] or nil,
				NextSelectionDown = i < #p6.props.buttonProps and p6.gamepadRefs[i + 1] or nil,
				inputBindings = if not p6.props.isRoactGamepadEnabled then nil else {
					Activated = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, v.onActivated, {
						key = v.inputBindingKey
					})
				},
				SelectionImageObject = p7(u44)
			}, {
				Cell = Roact.createElement(Cell, u45)
			})
		end)
	end

	t1.layout = Roact.createElement("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	return withStyle(function(p8) -- line: 245
		-- upvalues: setDefault (copy), p6 (copy), u38 (ref), t1 (copy), Roact (copy), u37 (ref), ImageSetComponent (copy), v22 (copy), RoundedFrame (copy), headerHeight (copy)
		local Theme = p8.Theme
		local BackgroundUIDefault = Theme.BackgroundUIDefault
		local v55 = setDefault(p6.props.background, {
			Color = BackgroundUIDefault.Color,
			Transparency = BackgroundUIDefault.Transparency
		})
		local isElementBackgroundVisible = p6.props.isElementBackgroundVisible
		local v57 = u38 and (p6.props.topElementRounded and isElementBackgroundVisible)
		local v58 = u38 and (p6.props.bottomElementRounded and isElementBackgroundVisible)
		local v59 = (not v57 and 0 or 1) + (not v58 and 0 or 1)
		local renderHeader = p6.props.renderHeader
		local v61 = not v57 and not not renderHeader

		if p6.props.fixedListHeight then
			return p6:renderFixedHeightMenu(p6.props, p8, t1)
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = p6.props.anchorPoint,
			LayoutOrder = p6.props.layoutOrder,
			Size = UDim2.new(p6.props.width.Scale, p6.props.width.Offset, 0, u37),
			Position = p6.props.position
		}, {
			DropShadow = p6.props.showDropShadow and Roact.createElement(ImageSetComponent.Label, {
				ZIndex = 2,
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 16, 1, 16),
				Image = v22,
				ImageColor3 = p8.Theme.DropShadow.Color,
				ImageTransparency = p8.Theme.DropShadow.Transparency,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(16, 16, 16, 16)
			}) or nil,
			Background = if not v57 and not v58 then nil else Roact.createElement(RoundedFrame, {
				zIndex = -1,
				background = v55,
				topCornerRadius = if not v57 then nil else UDim.new(0, p6.props.borderCornerRadius),
				bottomCornerRadius = if not v58 then nil else UDim.new(0, p6.props.borderCornerRadius)
			}),
			ClippingFrame = Roact.createElement("Frame", {
				ZIndex = 3,
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Size = UDim2.new(1, 0, 1, -(p6.props.borderCornerRadius * v59)),
				Position = UDim2.fromScale(0, not v57 and 0 or 0.5),
				AnchorPoint = Vector2.new(0, not v57 and 0 or 0.5)
			}, {
				HeaderFrame = if not v61 then nil else Roact.createElement("Frame", {
					Selectable = false,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, headerHeight),
					Position = UDim2.fromOffset(0, 0),
					AnchorPoint = Vector2.new(0, 0)
				}, {
					Header = renderHeader()
				}),
				ScrollingFrame = Roact.createElement("ScrollingFrame", {
					[Roact.Ref] = p6.props.setFrameRef,
					Selectable = false,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, not v57 and 0 or -4, 1, not v61 and 0 or -headerHeight),
					Position = if not v61 then nil else UDim2.fromOffset(0, headerHeight),
					BorderSizePixel = 0,
					ScrollBarThickness = not u38 and 0 or 4,
					ScrollBarImageColor3 = Theme.UIEmphasis.Color,
					ScrollBarImageTransparency = Theme.UIEmphasis.Transparency,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					CanvasSize = UDim2.new(1, 0, 0, #p6.props.buttonProps * p6.props.elementHeight),
					ClipsDescendants = v61
				}, t1)
			})
		})
	end)
end

local function BaseMenuFn(p9) -- line: 341
	-- upvalues: useStyle (copy), Cryo (copy), StyleDefaults (copy), React (copy), v23 (copy)
	if p9.enableTokenOverride then
		local v47 = useStyle()
		local t2 = {}

		for i, v in ipairs(p9.buttonProps) do
			t2[i] = Cryo.Dictionary.join(v, StyleDefaults.getCellDefaultTokens(v47))
		end

		p9 = Cryo.Dictionary.join(p9, StyleDefaults.getBaseMenuDefaultTokens(v47), {
			buttonProps = t2
		})
	end

	return React.createElement(v23, p9)
end

return BaseMenuFn
