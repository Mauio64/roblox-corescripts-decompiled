local parent = script.Parent.Parent.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
require(parent.Foundation)
local UIBlox = require(parent.UIBlox)
local Localization = require(parent.Localization)
local SharedFlags = require(parent.SharedFlags)
local Responsive = require(parent.Responsive)

local usePreferredInput = Responsive.usePreferredInput
local Input = Responsive.Input

local useStyle = UIBlox.Core.Style.useStyle
local ControlState = UIBlox.Core.Control.Enum.ControlState
local NavigationTab = UIBlox.App.Navigation.NavigationTab
local NavigationTabLayout = UIBlox.App.Navigation.Enum.NavigationTabLayout
local useLocalization = Localization.Hooks.useLocalization

local FFlagAppNavLabelScaling = SharedFlags.FFlagAppNavLabelScaling
local FFlagShrinkAppNavBar = SharedFlags.FFlagShrinkAppNavBar
local FFlagEnableNavRailTooltipAndTruncation = SharedFlags.FFlagEnableNavRailTooltipAndTruncation

local function arePropsEqual(data, data2)
	local v = Cryo.Dictionary.equals(data.item, data2.item)

	if v then
		if
			(FFlagShrinkAppNavBar or data.systemBarLabelTextSizeBinding == data2.systemBarLabelTextSizeBinding)
			and data.isChecked == data2.isChecked
			and data.isCenterPositioned == data2.isCenterPositioned
		then
			v = data.hasLabel == data2.hasLabel
		else
			v = false
		end
	end

	if not FFlagEnableNavRailTooltipAndTruncation then
		return v
	end

	if v then
		if
			data.width == data2.width
			and data.fillWidth == data2.fillWidth
			and data.enableTooltip == data2.enableTooltip
			and data.tooltipSide == data2.tooltipSide
			and data.tooltipAlign == data2.tooltipAlign
		then
			return data.tooltipOffset == data2.tooltipOffset
		end

		return false
	end

	return v
end

local function AppNavItem(props)
	local tokens = useStyle().Tokens
	local v = useLocalization({ labelText = props.item.labelText })

	local state, setState = React.useState(ControlState.Initialize)
	local v2

	if FFlagEnableNavRailTooltipAndTruncation then
		v2 = usePreferredInput()
	end

	local captionSmall = tokens.Typography.CaptionSmall
	local fontSize

	if not FFlagShrinkAppNavBar then
		fontSize = props.systemBarLabelTextSizeBinding.default:getBinding()
	end

	if not FFlagShrinkAppNavBar then
		React.useEffect(function()
			if FFlagAppNavLabelScaling then
				props.systemBarLabelTextSizeBinding.default:setTextToMaxSize(
					v.labelText or "",
					captionSmall.Font,
					Vector2.new(tokens.Size.Size_1200, tokens.Size.Size_1200),
					tokens.FontSize.FontSize_300
				)
			else
				props.systemBarLabelTextSizeBinding.default:getMinTextSize(
					v.labelText or "",
					captionSmall.Font,
					Vector2.new(tokens.Size.Size_1200, tokens.Size.Size_1200)
				)
			end
		end, { fontSize, v.labelText, tokens })
	end

	local v3 = FFlagEnableNavRailTooltipAndTruncation and v2 == Input.Touch

	local createElement = React.createElement
	local v4 = {
		iconImage = props.item.iconImage,
		iconCheckedImage = props.item.iconCheckedImage,
		renderIcon = props.item.renderIcon and function(flag: boolean)
			return props.item.renderIcon(flag, state)
		end or nil,
		hasLabel = props.hasLabel,
		labelText = v.labelText,
		labelTypography = 0,
		labelMaxTextSize = 0,
		isChecked = 0,
		badgeVariant = 0,
		badgeValue = 0,
		layout = 0,
		anchorPoint = 0,
		position = 0,
		onActivated = 0,
		onStateChanged = 0,
		width = 0,
		fillWidth = 0,
		enableTooltip = 0,
		tooltipSide = 0,
		tooltipAlign = 0,
		tooltipOffset = 0
	}
	local labelTypography

	if FFlagShrinkAppNavBar then
		labelTypography = tokens.Typography.CaptionSmall
	else
		labelTypography = {
			Font = captionSmall.Font,
			FontSize = fontSize,
			LineHeight = captionSmall.LineHeight,
			LetterSpacing = captionSmall.LetterSpacing
		}
	end

	v4.labelTypography = labelTypography
	local labelMaxTextSize

	if v3 then
		labelMaxTextSize = captionSmall.FontSize
	end

	v4.labelMaxTextSize = labelMaxTextSize
	v4.isChecked = props.isChecked
	v4.badgeVariant = props.item.badgeVariant
	v4.badgeValue = props.item.badgeValue
	v4.layout = NavigationTabLayout.Stacked
	local anchorPoint

	if props.isCenterPositioned then
		anchorPoint = Vector2.new(0.5, 0.5)
	end

	v4.anchorPoint = anchorPoint
	local position

	if props.isCenterPositioned then
		position = UDim2.fromScale(0.5, 0.5)
	end

	v4.position = position
	v4.onActivated = props.item.onActivated
	v4.onStateChanged = props.item.renderIcon and function(_, p)
		setState(p)
	end or nil
	local width

	if FFlagEnableNavRailTooltipAndTruncation then
		width = props.width
	end

	v4.width = width
	local fillWidth

	if FFlagEnableNavRailTooltipAndTruncation then
		fillWidth = props.fillWidth
	end

	v4.fillWidth = fillWidth
	local enableTooltip

	if FFlagEnableNavRailTooltipAndTruncation then
		enableTooltip = props.enableTooltip
	end

	v4.enableTooltip = enableTooltip
	local tooltipSide

	if FFlagEnableNavRailTooltipAndTruncation then
		tooltipSide = props.tooltipSide
	end

	v4.tooltipSide = tooltipSide
	local tooltipAlign

	if FFlagEnableNavRailTooltipAndTruncation then
		tooltipAlign = props.tooltipAlign
	end

	v4.tooltipAlign = tooltipAlign
	local tooltipOffset

	if FFlagEnableNavRailTooltipAndTruncation then
		tooltipOffset = props.tooltipOffset
	end

	v4.tooltipOffset = tooltipOffset
	return createElement(NavigationTab, v4)
end

return React.memo(AppNavItem, arePropsEqual)
