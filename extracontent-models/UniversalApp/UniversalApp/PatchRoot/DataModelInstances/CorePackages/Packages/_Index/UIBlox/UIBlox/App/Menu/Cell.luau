local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)
local withStyle = require(parent.Core.Style.withStyle)
local validateColorInfo = require(parent.Core.Style.Validator.validateColorInfo)
local withSelectionCursorProvider = require(parent.App.SelectionImage.withSelectionCursorProvider)
local CursorKind = require(parent.App.SelectionImage.CursorKind)
require(parent.App.Style.StyleTypes)
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object

local ImageSetComponent = require(parent2.UIBlox.Core.ImageSet.ImageSetComponent)
local Images = require(parent2.UIBlox.App.ImageSet.Images)
local GenericTextLabel = require(parent.Core.Text.GenericTextLabel.GenericTextLabel)
local divideTransparency = require(parent.Utility.divideTransparency)
local validateFontInfo = require(parent2.UIBlox.Core.Style.Validator.validateFontInfo)

local ControlState = require(parent2.UIBlox.Core.Control.Enum.ControlState)

local KeyLabel = require(script.Parent.KeyLabel.KeyLabel)
local RoundedFrame = require(script.Parent.RoundedFrame)

local Interactable = require(parent.Core.Control.Interactable)

local component_assetscircle_17 = Images["component_assets/circle_17"]

local extended = Roact.PureComponent:extend("Cell")

extended.validateProps = t.strictInterface({
	icon = t.optional(t.union(t.table, t.string)),
	text = t.string,
	onActivated = t.callback,
	keyCodeLabel = t.optional(t.union(
		t.enum(Enum.KeyCode),
		t.strictInterface({ key = t.enum(Enum.KeyCode), axis = t.optional(t.string) })
	)),
	selected = t.optional(t.boolean),
	iconColorOverride = t.optional(t.Color3),
	textColorOverride = t.optional(t.Color3),
	elementHeight = t.integer,
	hasRoundTop = t.boolean,
	hasRoundBottom = t.boolean,
	hasDivider = t.boolean,
	disabled = t.optional(t.boolean),
	stayOnActivated = t.optional(t.boolean),
	renderRightSideGadget = t.optional(t.callback),
	rightSideGadgetSize = t.optional(t.Vector2),
	leftPaddingOffset = t.optional(t.number),
	layoutOrder = t.integer,
	setButtonRef = t.optional(t.union(t.callback, t.table)),
	cursorKind = t.optional(CursorKind.isEnumValue),
	isElementBackgroundVisible = t.optional(t.boolean),
	dividerOffset = t.optional(t.number),
	dividerSize = t.optional(t.number),
	fontStyle = t.optional(t.union(t.string, validateFontInfo)),
	iconSize = t.optional(t.integer),
	selectedIconSize = t.optional(t.integer),
	iconPaddingLeft = t.optional(t.integer),
	textPadding = t.optional(t.strictInterface({ left = t.integer, right = t.integer })),
	selectedIconPaddingRight = t.optional(t.integer),
	keyLabelPaddingRight = t.optional(t.integer),
	textOnlyPadding = t.optional(t.integer),
	borderCornerRadius = t.optional(t.integer),
	background = t.optional(validateColorInfo),
	selectionOrder = t.optional(t.number),
	selectionCursor = t.optional(t.table)
})

extended.defaultProps = {
	selected = false,
	disabled = false,
	rightSideGadgetSize = nil,
	leftPaddingOffset = 0,
	isElementBackgroundVisible = true,
	dividerOffset = 0,
	dividerSize = 1,
	iconSize = 36,
	selectedIconSize = 16,
	iconPaddingLeft = 12,
	textPadding = { left = 12, right = 12 },
	selectedIconPaddingRight = 24,
	textOnlyPadding = 24,
	keyLabelPaddingRight = 16,
	borderCornerRadius = 4
}

function extended:init()
	self.state = { controlState = ControlState.Default, keyLabelWidth = 0 }

	function self.keyLabelSizeChanged(p)
		self:setState({ keyLabelWidth = p.AbsoluteSize.X })
	end

	function self.setControlState(controlState)
		self:setState({ controlState = controlState })
	end

	function self.onStateChanged(_, p)
		self.setControlState(p)
	end
end

function extended:getImageProperties()
	local imageRectSize = component_assetscircle_17.ImageRectSize
	local imageRectOffset = component_assetscircle_17.ImageRectOffset

	local v = 8 * Images.ImagesResolutionScale
	local v2 = 8 * Images.ImagesResolutionScale
	local rect = Rect.new(v, v2, imageRectSize.x - v, imageRectSize.y - v2)

	local x = imageRectSize.X
	local v3 = math.floor(x / 2)

	if self.props.hasRoundTop and self.props.hasRoundBottom then
		return imageRectSize, imageRectOffset, rect
	end

	if self.props.hasRoundTop then
		return Vector2.new(x, v3), imageRectOffset, (Rect.new(v3 - 1, v3 - 1, v3 + 1, v3))
	end

	if self.props.hasRoundBottom then
		return Vector2.new(x, v3), imageRectOffset + Vector2.new(0, v3), (Rect.new(v3 - 1, 0, v3 + 1, 1))
	end

	return Vector2.new(1, 1), imageRectOffset + Vector2.new(v3, v3), (Rect.new(0, 0, 0, 0))
end

function extended:renderRoundedBackground(zIndex: number, background)
	local udim = UDim.new(0, self.props.borderCornerRadius)
	local createElement = Roact.createElement
	local topCornerRadius

	if self.props.hasRoundTop then
		topCornerRadius = udim
	end

	if not self.props.hasRoundBottom then
		udim = nil
	end

	return createElement(RoundedFrame, {
		zIndex = zIndex,
		background = background,
		topCornerRadius = topCornerRadius,
		bottomCornerRadius = udim
	})
end

function extended:renderWithSelectionCursor(_)
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font
		local settings = props.Settings

		local v = self.props.textOnlyPadding

		if self.props.icon then
			v = self.props.iconPaddingLeft
		end

		local v2 = v + self.props.leftPaddingOffset
		local v3 = 0

		if self.props.keyCodeLabel then
			v3 = self.props.keyLabelPaddingRight
		elseif self.props.selected then
			v3 = self.props.selectedIconPaddingRight
		end

		local v4 = { Color = Color3.new(1, 1, 1), Transparency = 1 }

		if self.state.controlState == ControlState.Pressed then
			v4 = theme.BackgroundOnPress
		elseif self.state.controlState == ControlState.Hover then
			v4 = theme.BackgroundOnHover
		end

		local imageProperties, imageRectOffset, sliceCenter = self:getImageProperties()

		local v5 = 0
		local flag = true
		local v6

		if self.props.rightSideGadgetSize == nil then
			if self.props.icon then
				v2 = self.props.iconPaddingLeft
				v5 = self.props.iconPaddingLeft + self.props.iconSize
				flag = false
			end

			if self.props.selected then
				v5 = v5 + self.props.selectedIconSize + self.props.selectedIconPaddingRight
				flag = false
			end

			if self.props.keyCodeLabel then
				v5 = v5 + self.props.keyLabelPaddingRight + self.state.keyLabelWidth
				flag = false
			end

			if flag then
				v6 = v5 + self.props.textOnlyPadding * 2
			else
				v6 = v5 + self.props.textPadding.left + self.props.textPadding.right
			end
		else
			v6 = self.props.rightSideGadgetSize.X + self.props.iconPaddingLeft + self.props.iconSize + self.props.textPadding.left
		end

		local textEmphasis = theme.TextEmphasis
		local v7 = self.props.textColorOverride
			and {
				Color = self.props.textColorOverride,
				Transparency = theme.TextEmphasis.Transparency
			}
			or textEmphasis

		local colorStyle = (self.state.controlState == ControlState.Pressed or self.props.disabled)
			and {
				Color = v7.Color,
				Transparency = divideTransparency(theme.TextEmphasis.Transparency, 2)
			}
			or v7

		local backgroundUIDefault = theme.BackgroundUIDefault
		local v8 = Object.assign(
			{},
			{ Color = backgroundUIDefault.Color, Transparency = backgroundUIDefault.Transparency },
			self.props.background
		)
		v8.Transparency *= settings.PreferredTransparency
		local background

		if self.props.isElementBackgroundVisible then
			background = self:renderRoundedBackground(-1, v8)
		end

		local children = {
			Background = background,
			Divider = Roact.createElement("Frame", {
				BackgroundColor3 = theme.Divider.Color,
				BackgroundTransparency = theme.Divider.Transparency,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -self.props.dividerOffset, 0, self.props.dividerSize),
				Position = UDim2.new(0, self.props.dividerOffset, 1, 0),
				AnchorPoint = Vector2.new(0, 1),
				Visible = self.props.hasDivider
			}),
			StateOverlay = self:renderRoundedBackground(2, v4),
			LeftAlignedContent = Roact.createElement(
				"Frame",
				{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
				{
					Layout = Roact.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, self.props.textPadding.left)
					}),
					LeftPadding = Roact.createElement("UIPadding", { PaddingLeft = UDim.new(0, v2) }),
					Icon = self.props.icon and Roact.createElement(ImageSetComponent.Label, {
						Image = self.props.icon,
						Size = UDim2.fromOffset(self.props.iconSize, self.props.iconSize),
						BackgroundTransparency = 1,
						ImageColor3 = self.props.iconColorOverride or theme.IconEmphasis.Color,
						ImageTransparency = divideTransparency(
							theme.IconEmphasis.Transparency,
							self.props.disabled and 2 or 1
						),
						LayoutOrder = 1
					}),
					Text = Roact.createElement(GenericTextLabel, {
						fontStyle = self.props.fontStyle or font.Header2,
						colorStyle = colorStyle,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -v6, 1, 0),
						Text = self.props.text,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = false,
						LayoutOrder = 2
					})
				}
			),
			RightAlignedContent = 0
		}

		local createElement = Roact.createElement
		local v9 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }
		local v10 = {
			Layout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, self.props.textPadding.right)
			}),
			RightPadding = Roact.createElement("UIPadding", { PaddingRight = UDim.new(0, v3) }),
			RightSideContent = 0
		}

		local rightSideContent = self.props.renderRightSideGadget
			and self.props.rightSideGadgetSize
			and Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 3,
					Size = UDim2.fromOffset(self.props.rightSideGadgetSize.X, self.props.rightSideGadgetSize.Y)
				},
				self.props.renderRightSideGadget()
			)

		if not rightSideContent then
			local createFragment = Roact.createFragment
			local keyLabel = self.props.keyCodeLabel

			if keyLabel then
				keyLabel = Roact.createElement(KeyLabel, {
					keyCode = self.props.keyCodeLabel,
					LayoutOrder = 2,
					[Roact.Change.AbsoluteSize] = self.keyLabelSizeChanged
				})
			end

			rightSideContent = createFragment({
				KeyLabel = keyLabel,
				SelectedIcon = Roact.createElement(ImageSetComponent.Label, {
					Image = Images["icons/status/success_small"],
					Size = UDim2.fromOffset(self.props.selectedIconSize, self.props.selectedIconSize),
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					ImageColor3 = theme.IconEmphasis.Color,
					ImageTransparency = theme.IconEmphasis.Transparency,
					Visible = self.props.selected
				})
			})
		end

		v10.RightSideContent = rightSideContent
		children.RightAlignedContent = createElement("Frame", v9, v10)

		return Roact.createElement(Interactable, {
			Size = UDim2.new(1, 0, 0, self.props.elementHeight),
			BackgroundTransparency = 1,
			Image = nil,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = sliceCenter,
			ImageRectSize = imageProperties,
			ImageRectOffset = imageRectOffset,
			SliceScale = 1 / Images.ImagesResolutionScale,
			ImageTransparency = 1,
			ImageColor3 = v8.Color,
			AutoButtonColor = false,
			LayoutOrder = self.props.layoutOrder,
			BorderSizePixel = 0,
			[Roact.Ref] = self.props.setButtonRef,
			SelectionImageObject = self.props.selectionCursor,
			SelectionOrder = self.props.selectionOrder,
			onStateChanged = self.onStateChanged,
			[Roact.Event.Activated] = self.props.onActivated,
			isDisabled = self.props.disabled
		}, children)
	end)
end

function extended:render()
	return withSelectionCursorProvider(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

return extended
