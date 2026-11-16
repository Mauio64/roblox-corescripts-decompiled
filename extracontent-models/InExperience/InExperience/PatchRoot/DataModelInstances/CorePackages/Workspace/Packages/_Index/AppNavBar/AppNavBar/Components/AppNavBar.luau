local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Cryo = require(parent2.Cryo)
local Foundation = require(parent2.Foundation)
local UIBlox = require(parent2.UIBlox)
local UniversalAppPolicy = require(parent2.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent2.RoactServiceTags)

local useTokens = Foundation.Hooks.useTokens
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

local NavigationBar = UIBlox.App.Navigation.NavigationBar
local NavigationRailV2 = UIBlox.App.Navigation.NavigationRailV2
local NavigationBarAlignment = UIBlox.App.Navigation.Enum.NavigationBarAlignment
local NavigationRailAlignment = UIBlox.App.Navigation.Enum.NavigationRailAlignment

local Placement = require(parent.Enum.Placement)
local AppNavItem = require(parent.Components.AppNavItem)
local StudioCTAIcon = require(parent.Components.StudioCTAIcon)
local Constants = require(parent.Constants)
local VisibilityControl = require(parent.VisibilityControl)
local getScrollAwayEnabled = require(parent.getScrollAwayEnabled)

local AppNavTelemetry = require(parent.Telemetry.AppNavTelemetry)
local engineFeature = game:GetEngineFeature("WebViewRedesignEnabled")
local SharedFlags = require(parent2.SharedFlags)
local FFlagAddGamepadBumperNavigation = SharedFlags.FFlagAddGamepadBumperNavigation
local SharedFlags2 = require(parent2.SharedFlags)
local FFlagShrinkAppNavBar = SharedFlags2.FFlagShrinkAppNavBar
local SharedFlags3 = require(parent2.SharedFlags)
local FFlagEnableFlyoutOnNavRail = SharedFlags3.FFlagEnableFlyoutOnNavRail
local SharedFlags4 = require(parent2.SharedFlags)
local FFlagEnableNavRailTooltipAndTruncation = SharedFlags4.FFlagEnableNavRailTooltipAndTruncation
local defineFastFlag = game:DefineFastFlag("AppNavBarGateFooterVisibleOnPlacement", false)

local defineFastFlag2 = game:DefineFastFlag("AppNavBarFooterVisibleWithoutScrollAway", false)

local function addItems(list, p, p2, p3: number)
	return Cryo.List.join(list, p2, p), p3 + #list
end

local v = { selectedIndex = 1, isVisible = true, clipsDescendants = true }

local function AppNavBar(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2

	if FFlagEnableNavRailTooltipAndTruncation then
		v2 = useTokens()
	end

	local v3 = useAppPolicy(function(p2)
		return p2.getShowStudioCTA()
	end)

	local v4 = useRoactService(RoactServiceTags.AppEventIngestService)
	local v5 = useRoactService(RoactServiceTags.AppLinking)
	local useCallback = React.useCallback
	local function fn(_: boolean, controlState)
		local createElement = React.createElement
		local showTooltip

		if engineFeature then
			showTooltip = p.showTooltip
		end

		return createElement(StudioCTAIcon, {
			controlState = controlState,
			showTooltip = showTooltip
		})
	end

	local v6

	if engineFeature then
		v6 = p.showTooltip
	end

	local renderIcon = useCallback(fn, { v6 })
	local onActivated = React.useCallback(function()
		v4:setRBXEventStream(Constants.STUDIO_CTA_EVENT_CONTEXT, Constants.STUDIO_CTA_EVENT_NAME_OPEN)

		v5:openURL((joined.buildCreatorWebNavUrl({ utm_content = "side_bar_blue_icon" })))
	end, { v4, v5, joined.buildCreatorWebNavUrl })
	local items2, selection

	if FFlagEnableFlyoutOnNavRail then
		local menuItems = {}
		local v7 = {}

		if joined.menuItem ~= nil then
			table.insert(menuItems, joined.menuItem)
		end

		if v3 then
			table.insert(v7, {
				isSecondary = true,
				renderIcon = renderIcon,
				onActivated = onActivated
			})
		end

		local items = joined.items
		local selectedIndex = joined.selectedIndex
		items2 = Cryo.List.join(menuItems, items, v7)
		selection = selectedIndex + #menuItems
	else
		items2 = joined.items
		selection = joined.selectedIndex

		if v3 then
			items2 = Cryo.List.join(items2)
			table.insert(items2, {
				isSecondary = true,
				renderIcon = renderIcon,
				onActivated = onActivated
			})
		end
	end

	local v7 = nil
	local renderItem = React.useCallback(function(p2, isChecked: boolean)
		local createElement = React.createElement
		local systemBarLabelTextSizeBinding

		if not FFlagShrinkAppNavBar then
			systemBarLabelTextSizeBinding = joined.systemBarLabelTextSizeBinding
		end

		return createElement(AppNavItem, {
			item = p2,
			isChecked = isChecked,
			isCenterPositioned = true,
			hasLabel = true,
			systemBarLabelTextSizeBinding = systemBarLabelTextSizeBinding,
			fillWidth = FFlagEnableNavRailTooltipAndTruncation and true or nil,
			enableTooltip = not FFlagEnableNavRailTooltipAndTruncation and nil
		})
	end, { joined.systemBarLabelTextSizeBinding })

	local renderItem2 = React.useCallback(function(p2, isChecked: boolean)
		local createElement = React.createElement
		local systemBarLabelTextSizeBinding

		if not FFlagShrinkAppNavBar then
			systemBarLabelTextSizeBinding = joined.systemBarLabelTextSizeBinding
		end

		local width

		if FFlagEnableNavRailTooltipAndTruncation then
			width = UDim.new(1, 0)
		end

		local enableTooltip

		if FFlagEnableNavRailTooltipAndTruncation then
			enableTooltip = p2.labelText ~= nil
		end

		local tooltipSide

		if FFlagEnableNavRailTooltipAndTruncation then
			tooltipSide = PopoverSide.Right
		end

		local tooltipAlign

		if FFlagEnableNavRailTooltipAndTruncation then
			tooltipAlign = PopoverAlign.Center
		end

		return createElement(AppNavItem, {
			item = p2,
			isChecked = isChecked,
			isCenterPositioned = false,
			hasLabel = true,
			systemBarLabelTextSizeBinding = systemBarLabelTextSizeBinding,
			width = width,
			enableTooltip = enableTooltip,
			tooltipSide = tooltipSide,
			tooltipAlign = tooltipAlign
		})
	end, { joined.systemBarLabelTextSizeBinding })
	local visibility

	if getScrollAwayEnabled() or defineFastFlag2 then
		visibility = VisibilityControl.getFooterBinding()
		local useEffect = React.useEffect
		local function fn2()
			local v8

			if defineFastFlag then
				v8 = joined.isVisible and joined.placement == Placement.Bottom
			else
				v8 = joined.isVisible
			end

			VisibilityControl.setFooterVisible(v8)
		end
		local isVisible = joined.isVisible
		local v8

		if defineFastFlag then
			v8 = joined.placement
		end

		useEffect(fn2, { isVisible, v8 })
	end

	local useEffect = React.useEffect
	local function fn2()
		local v8

		if FFlagEnableFlyoutOnNavRail then
			v8 = items2[selection]
		else
			v8 = joined.items[joined.selectedIndex]
		end

		if v8 ~= nil and v8.page ~= nil then
			AppNavTelemetry.logSwitchTabEnd(v8.page)
		end
	end

	local v8

	if FFlagEnableFlyoutOnNavRail then
		v8 = { items2, selection }
	else
		v8 = { joined.items, joined.selectedIndex }
	end

	useEffect(fn2, v8)

	React.useEffect(function()
		AppNavTelemetry.logVisibilityEnd(joined.isVisible)
	end, { joined.isVisible })
	React.useEffect(function()
		AppNavTelemetry.logPlacement(joined.placement)
	end, { joined.placement })

	if joined.placement == Placement.Bottom then
		local createElement = React.createElement
		local v9 = {
			alignment = NavigationBarAlignment.EvenlyDistributed,
			items = items2,
			isVisible = joined.isVisible,
			size = joined.size,
			renderItem = renderItem,
			position = joined.position,
			selection = selection,
			clipsDescendants = joined.clipsDescendants,
			animated = true,
			visibility = visibility,
			active = true,
			spacing = 0
		}
		local spacing

		if FFlagEnableNavRailTooltipAndTruncation then
			spacing = UDim.new(0, v2.Gap.Small)
		end

		v9.spacing = spacing
		return (createElement(NavigationBar, v9))
	elseif joined.placement == Placement.Left then
		local createElement = React.createElement
		local v9 = {
			alignment = NavigationRailAlignment.Justified,
			items = items2,
			renderItem = renderItem2,
			size = joined.size,
			animated = true,
			isVisible = joined.isVisible,
			position = joined.position,
			selection = selection,
			clipsDescendants = joined.clipsDescendants,
			leadingComponent = 0,
			trailingComponent = 0,
			spacing = 0
		}
		local leadingComponent

		if FFlagAddGamepadBumperNavigation then
			leadingComponent = joined.leadingComponent
		end

		v9.leadingComponent = leadingComponent
		local trailingComponent

		if FFlagAddGamepadBumperNavigation then
			trailingComponent = joined.trailingComponent
		end

		v9.trailingComponent = trailingComponent
		local spacing

		if FFlagEnableNavRailTooltipAndTruncation then
			spacing = UDim.new(0, v2.Gap.Small)
		end

		v9.spacing = spacing
		return (createElement(NavigationRailV2, v9))
	end

	return v7
end

return React.memo(AppNavBar)
