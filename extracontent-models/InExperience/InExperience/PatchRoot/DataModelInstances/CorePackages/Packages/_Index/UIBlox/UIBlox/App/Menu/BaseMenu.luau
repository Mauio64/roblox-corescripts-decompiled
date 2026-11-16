local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local RoactGamepad = require(parent3.RoactGamepad)
local Roact = require(parent3.Roact)
local React = require(parent3.React)
local Cryo = require(parent3.Cryo)
local t = require(parent3.t)
local withStyle = require(parent2.Core.Style.withStyle)
local useStyle = require(parent2.Core.Style.useStyle)
local validateColorInfo = require(parent2.Core.Style.Validator.validateColorInfo)
local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)

local validateButtonProps = require(script.Parent.validateButtonProps)

local VerticalScrollView = require(parent.Container.VerticalScrollView)
local Images = require(parent.ImageSet.Images)
local withSelectionCursorProvider = require(parent.SelectionImage.withSelectionCursorProvider)
local CursorKind = require(parent.SelectionImage.CursorKind)
local setDefault = require(parent2.Utility.setDefault)

local Cell = require(script.Parent.Cell)
local RoundedFrame = require(script.Parent.RoundedFrame)
local StyleDefaults = require(script.Parent.StyleDefaults)

local component_assetsdropshadow_17_8 = Images["component_assets/dropshadow_17_8"]

local extended = Roact.PureComponent:extend("BaseMenu")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = {
	width = UDim.new(1, 0),
	position = UDim2.new(0, 0, 0, 0),
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
	isRoactGamepadEnabled = true
}

function extended:init()
	self.gamepadRefs = self.props.isRoactGamepadEnabled and RoactGamepad.createRefCache() or {}
end

function extended:renderFixedHeightMenu(props, p, p2)
	local fixedListHeight = props.fixedListHeight
	local v = setDefault(props.borderCornerRadius, 8)
	local backgroundUIDefault = p.Theme.BackgroundUIDefault
	local v2 = setDefault(props.background, {
		Color = backgroundUIDefault.Color,
		Transparency = backgroundUIDefault.Transparency
	})

	return Roact.createElement("Frame", {
		AnchorPoint = props.anchorPoint,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(props.width.Scale, props.width.Offset, 0, fixedListHeight),
		Position = props.position
	}, {
		DropShadow = props.showDropShadow and Roact.createElement(ImageSetComponent.Label, {
			ZIndex = 2,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 16, 1, 16),
			Image = component_assetsdropshadow_17_8,
			ImageColor3 = p.Theme.DropShadow.Color,
			ImageTransparency = p.Theme.DropShadow.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(16, 16, 16, 16)
		}) or nil,
		ContentFrame = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundColor3 = v2.Color,
			BackgroundTransparency = v2.Transparency,
			ZIndex = 3
		}, {
			UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, v) }),
			ClippingFrame = Roact.createElement("Frame", {
				ZIndex = 4,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, -v * 2),
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				ClipsDescendants = true
			}, {
				ScrollingFrame = Roact.createElement(VerticalScrollView, {
					canvasSizeY = UDim.new(0, #props.buttonProps * props.elementHeight),
					selectable = false
				}, p2)
			})
		})
	})
end

function extended:render()
	local headerHeight = self.props.headerHeight
	local v = self.props.elementHeight * 7.5 + headerHeight
	local v2 = #self.props.buttonProps * self.props.elementHeight + headerHeight
	local v3

	if v <= v2 then
		v2 = v
		v3 = true
	else
		v3 = false
	end

	local maxHeight = self.props.maxHeight

	if maxHeight and maxHeight > 0 and maxHeight < v2 then
		v2 = (math.max(
			math.floor((maxHeight - self.props.elementHeight * 0.5 - headerHeight) / self.props.elementHeight),
			1
		) + 0.5) * self.props.elementHeight + headerHeight
		v3 = true
	end

	local v4 = {}

	for i, buttonProp in ipairs(self.props.buttonProps) do
		local join = Cryo.Dictionary.join
		local v5 = {
			elementHeight = self.props.elementHeight,
			hasRoundTop = 0,
			hasRoundBottom = 0,
			hasDivider = 0,
			layoutOrder = 0,
			inputBindingKey = 0,
			setButtonRef = 0,
			isElementBackgroundVisible = 0,
			borderCornerRadius = 0,
			background = 0
		}
		local hasRoundTop = self.props.topElementRounded

		if hasRoundTop then
			if i == 1 then
				hasRoundTop = not v3
			else
				hasRoundTop = false
			end
		end

		v5.hasRoundTop = hasRoundTop
		local hasRoundBottom = self.props.bottomElementRounded

		if hasRoundBottom then
			if i == #self.props.buttonProps then
				hasRoundBottom = not v3
			else
				hasRoundBottom = false
			end
		end

		v5.hasRoundBottom = hasRoundBottom
		local hasDivider

		if self.props.isElementDividerVisible then
			hasDivider = i < #self.props.buttonProps
		else
			hasDivider = false
		end

		v5.hasDivider = hasDivider
		v5.layoutOrder = i
		v5.inputBindingKey = Cryo.None
		local setButtonRef

		if i == 1 then
			setButtonRef = self.props.setFirstItemRef or nil
		end

		v5.setButtonRef = setButtonRef
		v5.isElementBackgroundVisible = self.props.isElementBackgroundVisible
		v5.borderCornerRadius = self.props.borderCornerRadius
		v5.background = self.props.background
		local v6 = join(buttonProp, v5)

		if not self.props.isRoactGamepadEnabled then
			self.gamepadRefs[i] = self.gamepadRefs[i] or Roact.createRef()
		end

		local cursorKind

		if v6.hasRoundBottom and v6.hasRoundTop then
			cursorKind = CursorKind.RoundedRectNoInset
		elseif v6.hasRoundBottom then
			cursorKind = CursorKind.BulletDown
		elseif v6.hasRoundTop then
			cursorKind = CursorKind.BulletUp
		else
			cursorKind = CursorKind.Square
		end

		local joined = Cryo.Dictionary.join(v6, {
			cursorKind = cursorKind,
			selectionOrder = self.props.selectionOrder
		})

		v4["cell " .. i] = withSelectionCursorProvider(function(callback)
			return Roact.createElement(
				not self.props.isRoactGamepadEnabled and "Frame" or RoactGamepad.Focusable.Frame,
				{
					Size = UDim2.new(self.props.width, UDim.new(0, self.props.elementHeight)),
					BackgroundTransparency = 1,
					LayoutOrder = i,
					[Roact.Ref] = self.gamepadRefs[i],
					NextSelectionUp = i > 1 and self.gamepadRefs[i - 1] or nil,
					NextSelectionDown = i < #self.props.buttonProps and self.gamepadRefs[i + 1] or nil,
					inputBindings = self.props.isRoactGamepadEnabled and {
						Activated = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, buttonProp.onActivated, {
							key = buttonProp.inputBindingKey
						})
					} or nil,
					SelectionImageObject = callback(cursorKind)
				},
				{
					Cell = Roact.createElement(Cell, joined)
				}
			)
		end)
	end

	v4.layout = Roact.createElement("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	return withStyle(function(p)
		local theme = p.Theme
		local backgroundUIDefault = theme.BackgroundUIDefault
		local background = setDefault(self.props.background, {
			Color = backgroundUIDefault.Color,
			Transparency = backgroundUIDefault.Transparency
		})

		local isElementBackgroundVisible = self.props.isElementBackgroundVisible
		local v5 = v3 and self.props.topElementRounded and isElementBackgroundVisible
		local v6 = v3 and self.props.bottomElementRounded and isElementBackgroundVisible
		local v7 = (v5 and 1 or 0) + (v6 and 1 or 0)

		local renderHeader = self.props.renderHeader
		local clipsDescendants = not v5 and renderHeader and true or false

		if self.props.fixedListHeight then
			return self:renderFixedHeightMenu(self.props, p, v4)
		end

		local createElement = Roact.createElement
		local v8 = {
			AnchorPoint = self.props.anchorPoint,
			BackgroundTransparency = 1,
			LayoutOrder = self.props.layoutOrder,
			Size = UDim2.new(self.props.width.Scale, self.props.width.Offset, 0, v2),
			Position = self.props.position
		}
		local v9 = {
			DropShadow = self.props.showDropShadow and Roact.createElement(ImageSetComponent.Label, {
				ZIndex = 2,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 16, 1, 16),
				Image = component_assetsdropshadow_17_8,
				ImageColor3 = p.Theme.DropShadow.Color,
				ImageTransparency = p.Theme.DropShadow.Transparency,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(16, 16, 16, 16)
			}) or nil,
			Background = 0,
			ClippingFrame = 0
		}
		local background2

		if v5 or v6 then
			local createElement2 = Roact.createElement
			local topCornerRadius

			if v5 then
				topCornerRadius = UDim.new(0, self.props.borderCornerRadius)
			end

			local bottomCornerRadius

			if v6 then
				bottomCornerRadius = UDim.new(0, self.props.borderCornerRadius)
			end

			background2 = createElement2(RoundedFrame, {
				zIndex = -1,
				background = background,
				topCornerRadius = topCornerRadius,
				bottomCornerRadius = bottomCornerRadius
			})
		end

		v9.Background = background2

		local createElement2 = Roact.createElement
		local v10 = {
			ZIndex = 3,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -(self.props.borderCornerRadius * v7)),
			Position = UDim2.fromScale(0, v5 and 0.5 or 0),
			AnchorPoint = Vector2.new(0, v5 and 0.5 or 0),
			ClipsDescendants = true
		}
		local headerFrame

		if clipsDescendants then
			headerFrame = Roact.createElement("Frame", {
				Selectable = false,
				Size = UDim2.new(1, 0, 0, headerHeight),
				Position = UDim2.fromOffset(0, 0),
				AnchorPoint = Vector2.new(0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, { Header = renderHeader() })
		end

		local createElement3 = Roact.createElement
		local setFrameRefsByRef = {
			[Roact.Ref] = self.props.setFrameRef,
			Selectable = false,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, v5 and -4 or 0, 1, not clipsDescendants and 0 or -headerHeight)
		}
		local position

		if clipsDescendants then
			position = UDim2.fromOffset(0, headerHeight)
		end

		setFrameRefsByRef.Position = position
		setFrameRefsByRef.BorderSizePixel = 0
		setFrameRefsByRef.ScrollBarThickness = v3 and 4 or 0
		setFrameRefsByRef.ScrollBarImageColor3 = theme.UIEmphasis.Color
		setFrameRefsByRef.ScrollBarImageTransparency = theme.UIEmphasis.Transparency
		setFrameRefsByRef.ScrollingDirection = Enum.ScrollingDirection.Y
		setFrameRefsByRef.CanvasSize = UDim2.new(1, 0, 0, #self.props.buttonProps * self.props.elementHeight)
		setFrameRefsByRef.ClipsDescendants = clipsDescendants
		v9.ClippingFrame = createElement2("Frame", v10, {
			HeaderFrame = headerFrame,
			ScrollingFrame = createElement3("ScrollingFrame", setFrameRefsByRef, v4)
		})
		return createElement("Frame", v8, v9)
	end)
end

local function BaseMenuFn(p)
	if p.enableTokenOverride then
		local v = useStyle()
		local values = {}

		for i, buttonProp in ipairs(p.buttonProps) do
			values[i] = Cryo.Dictionary.join(buttonProp, StyleDefaults.getCellDefaultTokens(v))
		end

		p = Cryo.Dictionary.join(p, StyleDefaults.getBaseMenuDefaultTokens(v), {
			buttonProps = values
		})
	end

	return React.createElement(extended, p)
end

return BaseMenuFn
