local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local Roact = require(parent3.Roact)
local Cryo = require(parent3.Cryo)
local RoactGamepad = require(parent3.RoactGamepad)
local t = require(parent3.t)
local withStyle = require(parent2.Core.Style.withStyle)

local SpringAnimatedItem = require(parent2.Utility.SpringAnimatedItem)
local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)
local Images = require(parent2.App.ImageSet.Images)
local GenericTextLabel = require(parent2.Core.Text.GenericTextLabel.GenericTextLabel)
local ExpandableTextUtils = require(parent2.Core.Text.ExpandableText.ExpandableTextUtils)

local withSelectionCursorProvider = require(parent.SelectionImage.withSelectionCursorProvider)
local CursorType = require(parent.SelectionCursor.CursorType)
local useCursorByType = require(parent.SelectionCursor.useCursorByType)

local v = 30

local v2 = 5
local udim = UDim2.new(0, 36, 0, 36)
local udim2 = UDim2.new(1, 0, 0, 36)

local gradientgradient_0_100 = Images["gradient/gradient_0_100"]
local truncate_arrowsactions_truncationExpand = Images["truncate_arrows/actions_truncationExpand"]
local truncate_arrowsactions_truncationCollapse = Images["truncate_arrows/actions_truncationCollapse"]

local springOptions = { dampingRatio = 1, frequency = 3.5 }

local springOptions2 = { dampingRatio = 1, frequency = 3.5 }

local wrapped = SpringAnimatedItem.wrap(ImageSetComponent.Label)
local extended = Roact.PureComponent:extend("ExpandableTextArea")

extended.validateProps = t.strictInterface({
	Text = t.optional(t.string),
	Position = t.optional(t.UDim2),
	compactNumberOfLines = t.optional(t.number),
	LayoutOrder = t.optional(t.number),
	width = t.optional(t.UDim),
	padding = t.optional(t.Vector2),
	onClick = t.optional(t.callback),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	frameRef = t.optional(t.table),
	gradientColor = t.optional(t.Color3),
	selectionCursor = t.table,
	isRoactGamepadEnabled = t.optional(t.boolean)
})

extended.defaultProps = { compactNumberOfLines = 2, Text = "", isRoactGamepadEnabled = true }

function extended:init()
	self.state = { isExpanded = false, frameWidth = 0 }

	function self.onClick()
		self:setState(function(p)
			return {
				isExpanded = not p.isExpanded
			}
		end)

		if self.props.onClick then
			self.props.onClick(self.state.isExpanded)
		end
	end

	self.ref = Roact.createRef()
	self.layoutRef = Roact.createRef()
end

function extended:getRef()
	return self.props.frameRef or self.ref
end

function extended:applyFit(p)
	local ref = self:getRef()

	if not ref.current then
		return
	end

	local current = ref.current
	local v3 = p + v + v2
	local width = self.props.width

	if width then
		current.Size = UDim2.new(width.Scale, width.Offset, 0, v3)
	else
		current.Size = UDim2.new(1, 0, 0, v3)
	end
end

function extended:didMount()
	self.isMounted = true
	local current = self.layoutRef.current

	if current then
		self:applyFit(current.AbsoluteContentSize.y)
	end
end

function extended:willUnmount()
	self.isMounted = false
end

function extended:render()
	local text = self.props.Text
	local position = self.props.Position
	local compactNumberOfLines = self.props.compactNumberOfLines
	local layoutOrder = self.props.LayoutOrder
	local width = self.props.width
	local padding = self.props.padding
	local gradientColor = self.props.gradientColor
	local ref = self:getRef()

	v = padding and padding.Y or 30
	v2 = padding and padding.X or 5

	return withStyle(function(p)
		return withSelectionCursorProvider(function(_)
			local theme = p.Theme
			local font = p.Font
			local textSize = font.BaseSize * font.Body.RelativeSize
			local expandableTextHeights, v3 = ExpandableTextUtils.getExpandableTextHeights(
				font,
				self.state.frameWidth,
				text,
				compactNumberOfLines
			)

			local udim3 = UDim2.new(1, 0, 0, v3 + v2)
			local udim4 = UDim2.new(1, 0, 0, expandableTextHeights + v2)
			local buttonContainer = v3 < expandableTextHeights
			local v4 = not buttonContainer or self.state.isExpanded
			local size = v4 and udim4 or udim3
			local v5 = not (self.props.isRoactGamepadEnabled and buttonContainer) and "Frame"
				or RoactGamepad.Focusable.Frame

			local createElement = Roact.createElement
			local v6 = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = layoutOrder,
				Position = position,
				Size = width and UDim2.new(width.Scale, width.Offset, 0, 0) or UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				SelectionImageObject = self.props.selectionCursor,
				[Roact.Ref] = ref,
				[Roact.Change.AbsoluteSize] = function(p2)
					if self.state.frameWidth ~= p2.AbsoluteSize.X then
						self:setState({ frameWidth = p2.AbsoluteSize.X })
					end
				end,
				NextSelectionUp = self.props.NextSelectionUp,
				NextSelectionDown = self.props.NextSelectionDown,
				NextSelectionLeft = self.props.NextSelectionLeft,
				NextSelectionRight = self.props.NextSelectionRight,
				inputBindings = self.props.isRoactGamepadEnabled and buttonContainer and {
					Activated = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, self.onClick)
				} or nil
			}

			local children = {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 10),
					[Roact.Change.AbsoluteContentSize] = function(p2)
						self:applyFit(p2.AbsoluteContentSize.y)
					end,
					[Roact.Ref] = self.layoutRef
				}),
				UIPadding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, v) }),
				ExpandableContainer = Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
					animatedValues = { height = size.Y.Offset },
					mapValuesToProps = function(p2)
						return {
							Size = UDim2.new(1, 0, size.Y.Scale, p2.height)
						}
					end,
					regularProps = {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						ClipsDescendants = true,
						Size = size,
						LayoutOrder = 0
					},
					springOptions = springOptions
				}, {
					DescriptionText = Roact.createElement(GenericTextLabel, {
						colorStyle = theme.TextDefault,
						fontStyle = font.Body,
						Size = size,
						Text = text,
						TextSize = textSize,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true,
						BackgroundTransparency = 1
					}),
					Gradient = buttonContainer and Roact.createElement(wrapped, {
						animatedValues = {
							height = v4 and 0 or 30
						},
						mapValuesToProps = function(p2)
							return { Size = UDim2.new(1, 0, 0, p2.height) }
						end,
						regularProps = {
							Size = UDim2.new(1, 0, 0, 30),
							Position = UDim2.new(0, 0, 1, 0),
							AnchorPoint = Vector2.new(0, 1),
							BackgroundTransparency = 1,
							Image = gradientgradient_0_100,
							ImageColor3 = gradientColor or theme.BackgroundDefault.Color
						},
						springOptions = springOptions2
					})
				}),
				ButtonContainer = 0
			}

			if buttonContainer then
				buttonContainer = Roact.createElement(
					"Frame",
					{
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 10),
						LayoutOrder = 1
					},
					{
						PressableButton = Roact.createElement("TextButton", {
							Position = UDim2.new(0, 0, 0, -24),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = udim2,
							Text = "",
							[Roact.Event.Activated] = self.onClick
						}, {
							DownArrow = Roact.createElement(ImageSetComponent.Label, {
								AnchorPoint = Vector2.new(0.5, 0),
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Position = UDim2.new(0.5, 0, 0, 0),
								Image = size == udim4 and truncate_arrowsactions_truncationCollapse or truncate_arrowsactions_truncationExpand,
								ImageColor3 = theme.IconEmphasis.Color,
								ImageTransparency = theme.IconEmphasis.Transparency,
								Size = udim
							})
						})
					}
				)
			end

			children.ButtonContainer = buttonContainer
			return createElement(v5, v6, children)
		end)
	end)
end

return Roact.forwardRef(function(p, frameRef)
	local selectionCursor = useCursorByType(CursorType.RoundedRect)
	local joined = Cryo.Dictionary.join(p, { selectionCursor = selectionCursor })

	return Roact.createElement(extended, Cryo.Dictionary.join(joined, { frameRef = frameRef }))
end)
