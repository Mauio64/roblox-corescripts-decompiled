local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Core = ParentParentParent.Core
local ParentParentParentParent = ParentParentParent.Parent
local Otter = require(ParentParentParentParent.Otter)
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local Cryo = require(ParentParentParentParent.Cryo)
local Foundation = require(ParentParentParentParent.Foundation)
local BadgeStates = require(ParentParent.Indicator.Enum.BadgeStates)
local IconSize = require(ParentParent.ImageSet.Enum.IconSize)
local getIconSize = require(ParentParent.ImageSet.getIconSize)
local BadgeVariant = require(ParentParent.Indicator.Enum.BadgeVariant)
local StatusIndicator = Foundation.StatusIndicator
local ControlState = require(Core.Control.Enum.ControlState)
local Interactable = require(Core.Control.Interactable)
local ImageSetComponent = require(Core.ImageSet.ImageSetComponent)
local validateImage = require(Core.ImageSet.Validator.validateImage)
local validateColorInfo = require(ParentParentParent.Core.Style.Validator.validateColorInfo)
local validateFontInfo = require(ParentParentParent.Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(ParentParentParent.Core.Style.Validator.validateTypographyInfo)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local divideTransparency = require(ParentParentParent.Utility.divideTransparency)
local CursorType = require(ParentParent.SelectionCursor.CursorType)
local useCursorByType = require(ParentParent.SelectionCursor.useCursorByType)
local GetTextSize = require(ParentParentParent.Core.Text.GetTextSize)
local migrateBadgeVariant = require(ParentParentParent.Utility.migrateBadgeVariant)
local uDim = UDim.new(0, 12)
local uDim2 = UDim.new(0, 8)
local t1 = {
	frequency = 6,
	dampingRatio = 1
}
local _ = {
	BACKGROUND = 1,
	HOVER_MASK = 2,
	ICON_AND_TITLE_CONTAINER = 3,
	BADGE_CONTAINER = 4,
	ROUNDED_CORNERS_MASK = 5
}
local _ = {
	ICON = 1,
	TITLE = 2
}
local v33 = Roact.Component:extend("MenuTile")

v33.defaultProps = {
	size = UDim2.fromScale(1, 1),
	styleProps = {}
}
v33.validateProps = t.strictInterface({
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

local function withProviders(p1, p2) -- line: 102
	-- upvalues: withStyle (copy)
	return withStyle(function(p3) -- line: 103
		-- upvalues: p1 (copy), p2 (copy)
		return p1(p3, nil, p2)
	end)
end
local function getStyleProps(p4, p5) -- line: 108
	-- upvalues: getIconSize (copy), IconSize (copy)
	local Theme = p5.Theme
	local p5Font = p5.Font
	local v42 = if not p4.iconSize then getIconSize(IconSize.Large) else getIconSize(p4.iconSize, p5)

	return {
		iconStyle = p4.iconStyle or Theme.IconDefault,
		iconSize = v42,
		titleStyle = p4.titleStyle or Theme.TextDefault,
		titleFont = p4.titleFont or p5Font.SubHeader1
	}
end

function v33.init(p6) -- line: 124
	-- upvalues: Roact (copy), Otter (copy)
	local v44, v45 = Roact.createBinding(1)

	p6.hoverTransparency = v44
	p6.updateHoverTransparency = v45
	p6.hoverTransparencyMotor = Otter.createSingleMotor(1)
	p6.hoverTransparencyMotor:onStep(p6.updateHoverTransparency)
	p6.hoverTransparencyMotor:onComplete(function(p7) -- line: 128
		-- upvalues: p6 (copy)
		if p7 == 1 then
			p6:setState({
				showHoverMask = false
			})
		end
	end)
	p6:setState({
		backgroundTransparency = 0,
		iconTransparency = 0,
		titleTransparency = 0,
		showHoverMask = false
	})
end
function v33.render(p8) -- line: 144
	-- upvalues: withProviders (copy), getStyleProps (copy), GetTextSize (copy), ControlState (copy), Otter (copy), t1 (copy), divideTransparency (copy), Roact (copy), Interactable (copy), uDim (copy), uDim2 (copy), ImageSetComponent (copy), StatusIndicator (copy), migrateBadgeVariant (copy)
	local backgroundTransparency = p8.state.backgroundTransparency
	local iconTransparency = p8.state.iconTransparency
	local titleTransparency = p8.state.titleTransparency
	local badgeValue = p8.props.badgeValue
	local icon = p8.props.icon
	local layoutOrder = p8.props.layoutOrder
	local onActivated = p8.props.onActivated
	local position = p8.props.position
	local size = p8.props.size
	local title = p8.props.title

	return withProviders(function(p9, _, p11) -- line: 157
		-- upvalues: getStyleProps (copy), p8 (copy), GetTextSize (copy), title (copy), ControlState (copy), Otter (copy), t1 (copy), divideTransparency (copy), Roact (copy), Interactable (copy), size (copy), position (copy), layoutOrder (copy), onActivated (copy), backgroundTransparency (copy), uDim (copy), uDim2 (copy), icon (copy), ImageSetComponent (copy), iconTransparency (copy), titleTransparency (copy), badgeValue (copy), StatusIndicator (copy), migrateBadgeVariant (copy)
		local Theme = p9.Theme
		local v66 = getStyleProps(p8.props.styleProps, p9)
		local BackgroundUIDefault = Theme.BackgroundUIDefault
		local BackgroundOnHover = Theme.BackgroundOnHover
		local iconStyle = v66.iconStyle
		local iconSize = v66.iconSize
		local titleStyle = v66.titleStyle
		local titleFont = v66.titleFont
		local v73 = if not titleFont.RelativeSize then titleFont.FontSize else titleFont.RelativeSize * p9.Font.BaseSize
		local Y = GetTextSize(title, v73, titleFont.Font, Vector2.new(100, v73)).Y

		return Roact.createElement(Interactable, {
			Size = size,
			Position = position,
			BackgroundTransparency = 1,
			SelectionImageObject = p11,
			LayoutOrder = layoutOrder,
			onStateChanged = function(_, p13) -- line: 178
				-- upvalues: ControlState (copy), p8 (copy), BackgroundUIDefault (copy), iconStyle (copy), titleStyle (copy), Otter (copy), BackgroundOnHover (copy), t1 (copy), divideTransparency (copy)
				if p13 == ControlState.Hover then
					p8:setState({
						showHoverMask = true,
						backgroundTransparency = BackgroundUIDefault.Transparency,
						iconTransparency = iconStyle.Transparency,
						titleTransparency = titleStyle.Transparency
					})
					p8.hoverTransparencyMotor:setGoal(Otter.spring(BackgroundOnHover.Transparency, t1))

					return
				end

				if p13 == ControlState.Default then
					p8:setState({
						backgroundTransparency = BackgroundUIDefault.Transparency,
						iconTransparency = iconStyle.Transparency,
						titleTransparency = titleStyle.Transparency
					})
					p8.hoverTransparencyMotor:setGoal(Otter.spring(1, t1))

					return
				end

				if p13 == ControlState.Pressed then
					p8:setState({
						showHoverMask = false,
						backgroundTransparency = divideTransparency(BackgroundUIDefault.Transparency, 2),
						iconTransparency = divideTransparency(iconStyle.Transparency, 2),
						titleTransparency = divideTransparency(titleStyle.Transparency, 2)
					})
					p8.hoverTransparencyMotor:setGoal(Otter.instant(1))
				end
			end,
			[Roact.Event.Activated] = onActivated
		}, {
			MenuTileFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = size
			}, {
				Background = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					ZIndex = 1,
					BackgroundColor3 = BackgroundUIDefault.Color,
					BackgroundTransparency = backgroundTransparency,
					Size = UDim2.fromScale(1, 1)
				}, {
					RoundedCornerUI = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 8)
					})
				}),
				HoverMask = p8.state.showHoverMask and Roact.createElement("Frame", {
					BorderSizePixel = 0,
					ZIndex = 2,
					BackgroundColor3 = BackgroundOnHover.Color,
					BackgroundTransparency = p8.hoverTransparency,
					Size = UDim2.fromScale(1, 1)
				}, {
					RoundedCornerUI = Roact.createElement("UICorner", {
						CornerRadius = UDim.new(0, 8)
					})
				}),
				IconAndTitleContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					ZIndex = 3,
					Size = UDim2.fromScale(1, 1)
				}, {
					IconAndTitleUIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = uDim,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					IconAndTitleUIPadding = Roact.createElement("UIPadding", {
						PaddingBottom = uDim2,
						PaddingLeft = uDim2,
						PaddingRight = uDim2,
						PaddingTop = uDim2 + UDim.new(0, Y)
					}),
					Icon = icon and Roact.createElement(ImageSetComponent.Label, {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Image = icon,
						ImageColor3 = iconStyle.Color,
						ImageTransparency = iconTransparency,
						Size = UDim2.fromOffset(iconSize, iconSize)
					}),
					Title = title and Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						TextWrapped = true,
						Font = titleFont.Font,
						Size = UDim2.new(1, 0, 0, Y * 2),
						Text = title,
						TextColor3 = titleStyle.Color,
						TextSize = v73,
						TextTransparency = titleTransparency,
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextYAlignment = Enum.TextYAlignment.Top
					})
				}),
				BadgeContainer = badgeValue and Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					ZIndex = 4,
					Size = UDim2.fromScale(1, 1)
				}, {
					BadgeUIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						Padding = uDim,
						VerticalAlignment = Enum.VerticalAlignment.Top
					}),
					BadgeUIPadding = Roact.createElement("UIPadding", {
						PaddingBottom = uDim2,
						PaddingLeft = uDim2,
						PaddingRight = uDim2,
						PaddingTop = uDim2
					}),
					Badge = Roact.createElement(StatusIndicator, {
						value = tonumber(badgeValue),
						max = if not tonumber(badgeValue) then nil else 99,
						variant = migrateBadgeVariant(p8.props.badgeVariant)
					})
				})
			})
		})
	end, p8.props.cursor)
end
function v33.willUnmount(p14) -- line: 310
	if p14.hoverTransparencyMotor then
		p14.hoverTransparencyMotor:destroy()
	end
end
function MenuTileFunctionalWrapper(p15) -- line: 315
	-- upvalues: useCursorByType (copy), CursorType (copy), Roact (copy), v33 (copy), Cryo (copy)
	local v59 = useCursorByType(CursorType.RoundedRect)

	return Roact.createElement(v33, Cryo.Dictionary.join(p15, {
		cursor = v59
	}))
end

return MenuTileFunctionalWrapper
