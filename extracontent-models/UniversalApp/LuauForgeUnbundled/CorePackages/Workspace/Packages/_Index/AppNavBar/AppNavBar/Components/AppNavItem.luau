local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/Foundation")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/UIBlox")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/Localization")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/SharedFlags")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/Responsive")

local usePreferredInput = Responsive.usePreferredInput
local input = Responsive.Input

local useStyle = UIBlox.Core.Style.useStyle
local controlState = UIBlox.Core.Control.Enum.ControlState
local navigationTab = UIBlox.App.Navigation.NavigationTab
local navigationTabLayout = UIBlox.App.Navigation.Enum.NavigationTabLayout
local useLocalization = Localization.Hooks.useLocalization

local fFlagAppNavLabelScaling = SharedFlags.FFlagAppNavLabelScaling
local fFlagShrinkAppNavBar = SharedFlags.FFlagShrinkAppNavBar
local fFlagEnableNavRailTooltipAndTruncation = SharedFlags.FFlagEnableNavRailTooltipAndTruncation

local function arePropsEqual(data, data2)
	local v5 = Cryo.Dictionary.equals(data.item, data2.item)

	if v5 then
		if
			(fFlagShrinkAppNavBar or data.systemBarLabelTextSizeBinding == data2.systemBarLabelTextSizeBinding)
			and data.isChecked == data2.isChecked
			and data.isCenterPositioned == data2.isCenterPositioned
		then
			v5 = data.hasLabel == data2.hasLabel
		else
			v5 = false
		end
	end

	if not fFlagEnableNavRailTooltipAndTruncation then
		return v5
	end

	if v5 then
		if
			data.width == data2.width
			and data.fillWidth == data2.fillWidth
			and data.enableTooltip == data2.enableTooltip
			and data.tooltipSide == data2.tooltipSide
			and data.tooltipAlign == data2.tooltipAlign
		then
			v5 = data.tooltipOffset == data2.tooltipOffset
		else
			v5 = false
		end
	end

	return v5
end

local function AppNavItem(props)
	local tokens = useStyle().Tokens
	local v5 = useLocalization({ labelText = props.item.labelText })

	local state, setState = React.useState(controlState.Initialize)

	local v6 = if fFlagEnableNavRailTooltipAndTruncation then usePreferredInput() else nil

	local captionSmall = tokens.Typography.CaptionSmall
	local v7

	if not fFlagShrinkAppNavBar then
		v7 = props.systemBarLabelTextSizeBinding.default:getBinding()
	end

	if not fFlagShrinkAppNavBar then
		React.useEffect(function()
			if fFlagAppNavLabelScaling then
				props.systemBarLabelTextSizeBinding.default:setTextToMaxSize(
					v5.labelText or "",
					captionSmall.Font,
					Vector2.new(tokens.Size.Size_1200, tokens.Size.Size_1200),
					tokens.FontSize.FontSize_300
				)
			else
				props.systemBarLabelTextSizeBinding.default:getMinTextSize(
					v5.labelText or "",
					captionSmall.Font,
					Vector2.new(tokens.Size.Size_1200, tokens.Size.Size_1200)
				)
			end
		end, { v7, v5.labelText, tokens })
	end

	local v8 = fFlagEnableNavRailTooltipAndTruncation and v6 == input.Touch

	local createElement = React.createElement
	local v10 = {
		iconImage = props.item.iconImage,
		iconCheckedImage = props.item.iconCheckedImage,
		renderIcon = props.item.renderIcon and function(p2)
			return props.item.renderIcon(p2, state)
		end or nil,
		hasLabel = props.hasLabel,
		labelText = v5.labelText,
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

	local v11 = if fFlagShrinkAppNavBar then tokens.Typography.CaptionSmall else {
		Font = captionSmall.Font,
		FontSize = v7,
		LineHeight = captionSmall.LineHeight,
		LetterSpacing = captionSmall.LetterSpacing
	}
	v10.labelTypography = v11

	local v12 = if v8 then captionSmall.FontSize else nil
	v10.labelMaxTextSize = v12
	v10.isChecked = props.isChecked
	v10.badgeVariant = props.item.badgeVariant
	v10.badgeValue = props.item.badgeValue
	v10.layout = navigationTabLayout.Stacked
	local v13 = if props.isCenterPositioned then Vector2.new(0.5, 0.5) else nil
	v10.anchorPoint = v13
	local v14 = if props.isCenterPositioned then UDim2.fromScale(0.5, 0.5) else nil
	v10.position = v14
	v10.onActivated = props.item.onActivated
	v10.onStateChanged = props.item.renderIcon and function(p2, p3)
		setState(p3)
	end or nil

	local v15 = if fFlagEnableNavRailTooltipAndTruncation then props.width else nil
	v10.width = v15
	local v16 = if fFlagEnableNavRailTooltipAndTruncation then props.fillWidth else nil
	v10.fillWidth = v16
	local v17 = if fFlagEnableNavRailTooltipAndTruncation then props.enableTooltip else nil
	v10.enableTooltip = v17
	local v18 = if fFlagEnableNavRailTooltipAndTruncation then props.tooltipSide else nil
	v10.tooltipSide = v18
	local v19 = if fFlagEnableNavRailTooltipAndTruncation then props.tooltipAlign else nil
	v10.tooltipAlign = v19
	local v20 = if fFlagEnableNavRailTooltipAndTruncation then props.tooltipOffset else nil
	v10.tooltipOffset = v20
	return createElement(navigationTab, v10)
end

return React.memo(AppNavItem, arePropsEqual)
