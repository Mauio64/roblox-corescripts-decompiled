local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local core = parent2.Core
local parent3 = parent2.Parent

local Otter = require(parent3.Otter)
local Roact = require(parent3.Roact)
local t = require(parent3.t)
local Cryo = require(parent3.Cryo)
local Foundation = require(parent3.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local BadgeStates = require(parent.Indicator.Enum.BadgeStates)
local IconSize = require(parent.ImageSet.Enum.IconSize)
local getIconSize = require(parent.ImageSet.getIconSize)
local BadgeVariant = require(parent.Indicator.Enum.BadgeVariant)
local StatusIndicator = Foundation.StatusIndicator

local ControlState = require(core.Control.Enum.ControlState)
local Interactable = require(core.Control.Interactable)
local ImageSetComponent = require(core.ImageSet.ImageSetComponent)
local validateImage = require(core.ImageSet.Validator.validateImage)
local validateColorInfo = require(parent2.Core.Style.Validator.validateColorInfo)
local validateFontInfo = require(parent2.Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(parent2.Core.Style.Validator.validateTypographyInfo)

local withStyle = require(parent2.Core.Style.withStyle)
local divideTransparency = require(parent2.Utility.divideTransparency)
local CursorType = require(parent.SelectionCursor.CursorType)
local useCursorByType = require(parent.SelectionCursor.useCursorByType)
local GetTextSize = require(parent2.Core.Text.GetTextSize)

local migrateBadgeVariant = require(parent2.Utility.migrateBadgeVariant)

local udim = UDim.new(0, 12)
local udim2 = UDim.new(0, 8)

local v = { frequency = 6, dampingRatio = 1 }

local _ = {
	BACKGROUND = 1,
	HOVER_MASK = 2,
	ICON_AND_TITLE_CONTAINER = 3,
	BADGE_CONTAINER = 4,
	ROUNDED_CORNERS_MASK = 5
}

local _ = { ICON = 1, TITLE = 2 }

local extended = Roact.Component:extend("MenuTile")

extended.defaultProps = { size = UDim2.fromScale(1, 1), styleProps = {} }

extended.validateProps = t.strictInterface({
	size = t.optional(t.UDim2),
	position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.number),
	cursor = t.table,
	badgeValue = t.optional(t.union(t.string, t.number, BadgeStates.isEnumValue)),
	badgeVariant = t.optional(BadgeVariant.isEnumValue),
	icon = t.optional(validateImage),
	title = t.string,
	onActivated = t.callback,
	styleProps = t.optional(t.strictInterface({
		iconStyle = t.optional(validateColorInfo),
		iconSize = t.optional(IconSize.isEnumValue),
		titleStyle = t.optional(validateColorInfo),
		titleFont = t.optional(t.union(validateFontInfo, validateTypographyInfo))
	}))
})

local function withProviders(fn, cursor)
	return withStyle(function(p)
		return fn(p, nil, cursor)
	end)
end

local function getStyleProps(styleProps, p)
	local theme = p.Theme
	local font = p.Font
	local iconSize

	if styleProps.iconSize then
		iconSize = getIconSize(styleProps.iconSize, p)
	else
		iconSize = getIconSize(IconSize.Large)
	end

	return {
		iconStyle = styleProps.iconStyle or theme.IconDefault,
		iconSize = iconSize,
		titleStyle = styleProps.titleStyle or theme.TextDefault,
		titleFont = styleProps.titleFont or font.SubHeader1
	}
end

function extended:init()
	local binding, updateHoverTransparency = Roact.createBinding(1)
	self.hoverTransparency = binding
	self.updateHoverTransparency = updateHoverTransparency
	self.hoverTransparencyMotor = Otter.createSingleMotor(1)
	self.hoverTransparencyMotor:onStep(self.updateHoverTransparency)
	self.hoverTransparencyMotor:onComplete(function(p)
		if p == 1 then
			self:setState({ showHoverMask = false })
		end
	end)

	self:setState({
		backgroundTransparency = 0,
		iconTransparency = 0,
		titleTransparency = 0,
		showHoverMask = false
	})
end

function extended.render(object)
	local backgroundTransparency = object.state.backgroundTransparency
	local iconTransparency = object.state.iconTransparency
	local titleTransparency = object.state.titleTransparency

	local badgeValue = object.props.badgeValue
	local icon = object.props.icon
	local layoutOrder = object.props.layoutOrder
	local onActivated = object.props.onActivated
	local position = object.props.position
	local size = object.props.size
	local title = object.props.title

	return withProviders(function(p, _, selectionImageObject)
		local theme = p.Theme

		local styleProps = getStyleProps(object.props.styleProps, p)

		local backgroundUIDefault = theme.BackgroundUIDefault
		local backgroundOnHover = theme.BackgroundOnHover

		local iconStyle = styleProps.iconStyle
		local iconSize = styleProps.iconSize

		local titleStyle = styleProps.titleStyle
		local titleFont = styleProps.titleFont
		local textSize

		if titleFont.RelativeSize then
			textSize = titleFont.RelativeSize * p.Font.BaseSize
		else
			textSize = titleFont.FontSize
		end

		local y = GetTextSize(title, textSize, titleFont.Font, Vector2.new(100, textSize)).Y

		local function onStateChanged(_, p2)
			if p2 == ControlState.Hover then
				object:setState({
					backgroundTransparency = backgroundUIDefault.Transparency,
					iconTransparency = iconStyle.Transparency,
					titleTransparency = titleStyle.Transparency,
					showHoverMask = true
				})

				object.hoverTransparencyMotor:setGoal(Otter.spring(backgroundOnHover.Transparency, v))
			elseif p2 == ControlState.Default then
				object:setState({
					backgroundTransparency = backgroundUIDefault.Transparency,
					iconTransparency = iconStyle.Transparency,
					titleTransparency = titleStyle.Transparency
				})

				object.hoverTransparencyMotor:setGoal(Otter.spring(1, v))
			elseif p2 == ControlState.Pressed then
				object:setState({
					backgroundTransparency = divideTransparency(backgroundUIDefault.Transparency, 2),
					iconTransparency = divideTransparency(iconStyle.Transparency, 2),
					titleTransparency = divideTransparency(titleStyle.Transparency, 2),
					showHoverMask = false
				})

				object.hoverTransparencyMotor:setGoal(Otter.instant(1))
			end
		end

		return Roact.createElement(Interactable, {
			Size = size,
			Position = position,
			BackgroundTransparency = 1,
			SelectionImageObject = selectionImageObject,
			LayoutOrder = layoutOrder,
			onStateChanged = onStateChanged,
			[Roact.Event.Activated] = onActivated
		}, {
			MenuTileFrame = Roact.createElement("Frame", { BackgroundTransparency = 1, Size = size }, {
				Background = Roact.createElement("Frame", {
					BackgroundColor3 = backgroundUIDefault.Color,
					BackgroundTransparency = backgroundTransparency,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 1
				}, {
					RoundedCornerUI = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 8)
					})
				}),
				HoverMask = object.state.showHoverMask and Roact.createElement("Frame", {
					BackgroundColor3 = backgroundOnHover.Color,
					BackgroundTransparency = object.hoverTransparency,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 2
				}, {
					RoundedCornerUI = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 8)
					})
				}),
				IconAndTitleContainer = Roact.createElement(
					"Frame",
					{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 3 },
					{
						IconAndTitleUIListLayout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = udim,
							VerticalAlignment = Enum.VerticalAlignment.Center
						}),
						IconAndTitleUIPadding = Roact.createElement("UIPadding", {
							PaddingBottom = udim2,
							PaddingLeft = udim2,
							PaddingRight = udim2,
							PaddingTop = udim2 + UDim.new(0, y)
						}),
						Icon = icon and Roact.createElement(ImageSetComponent.Label, {
							BackgroundTransparency = 1,
							Image = icon,
							ImageColor3 = iconStyle.Color,
							ImageTransparency = iconTransparency,
							LayoutOrder = 1,
							Size = UDim2.fromOffset(iconSize, iconSize)
						}),
						Title = title and Roact.createElement("TextLabel", {
							BackgroundTransparency = 1,
							FontFace = normalizeFontFace(titleFont.Font),
							LayoutOrder = 2,
							Size = UDim2.new(1, 0, 0, y * 2),
							Text = title,
							TextColor3 = titleStyle.Color,
							TextSize = textSize,
							TextTransparency = titleTransparency,
							TextTruncate = Enum.TextTruncate.AtEnd,
							TextWrapped = true,
							TextYAlignment = Enum.TextYAlignment.Top
						})
					}
				),
				BadgeContainer = badgeValue and Roact.createElement(
					"Frame",
					{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 4 },
					{
						BadgeUIListLayout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Right,
							Padding = udim,
							VerticalAlignment = Enum.VerticalAlignment.Top
						}),
						BadgeUIPadding = Roact.createElement("UIPadding", {
							PaddingBottom = udim2,
							PaddingLeft = udim2,
							PaddingRight = udim2,
							PaddingTop = udim2
						}),
						Badge = Roact.createElement(StatusIndicator, {
							value = tonumber(badgeValue),
							max = tonumber(badgeValue) and 99 or nil,
							variant = migrateBadgeVariant(object.props.badgeVariant)
						})
					}
				)
			})
		})
	end, object.props.cursor)
end

function extended.willUnmount(p)
	if p.hoverTransparencyMotor then
		p.hoverTransparencyMotor:destroy()
	end
end
function MenuTileFunctionalWrapper(p)
	local cursor = useCursorByType(CursorType.RoundedRect)

	return Roact.createElement(extended, Cryo.Dictionary.join(p, { cursor = cursor }))
end

return MenuTileFunctionalWrapper
