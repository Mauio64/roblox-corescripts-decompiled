local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/Foundation")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/UIBlox")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/UniversalAppPolicy").useAppPolicy
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/RoactServiceTags")

local useTokens = Foundation.Hooks.useTokens
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide

local navigationBar = UIBlox.App.Navigation.NavigationBar
local navigationRailV2 = UIBlox.App.Navigation.NavigationRailV2
local navigationBarAlignment = UIBlox.App.Navigation.Enum.NavigationBarAlignment
local navigationRailAlignment = UIBlox.App.Navigation.Enum.NavigationRailAlignment

local Placement = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Enum/Placement")
local AppNavItem = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Components/AppNavItem")
local StudioCTAIcon = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Components/StudioCTAIcon")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Constants")
local VisibilityControl = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/VisibilityControl")
local getScrollAwayEnabled = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/getScrollAwayEnabled")

local AppNavTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Telemetry/AppNavTelemetry")
local engineFeature = game:GetEngineFeature("WebViewRedesignEnabled")
local fFlagAddGamepadBumperNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/SharedFlags").FFlagAddGamepadBumperNavigation
local fFlagShrinkAppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/SharedFlags").FFlagShrinkAppNavBar
local fFlagEnableFlyoutOnNavRail = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/SharedFlags").FFlagEnableFlyoutOnNavRail
local fFlagEnableNavRailTooltipAndTruncation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/SharedFlags").FFlagEnableNavRailTooltipAndTruncation
local defineFastFlag = game:DefineFastFlag("AppNavBarGateFooterVisibleOnPlacement", false)

local defineFastFlag2 = game:DefineFastFlag("AppNavBarFooterVisibleWithoutScrollAway", false)

local function addItems(list, p2, p3, p4)
	return Cryo.List.join(list, p3, p2), p4 + #list
end

local v5 = { selectedIndex = 1, isVisible = true, clipsDescendants = true }

local function AppNavBar(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local v6 = if fFlagEnableNavRailTooltipAndTruncation then useTokens() else nil

	local v7 = useAppPolicy(function(p3)
		return p3.getShowStudioCTA()
	end)

	local v8 = useRoactService(RoactServiceTags.AppEventIngestService)
	local v9 = useRoactService(RoactServiceTags.AppLinking)
	local function fn(p3, p4)
		local createElement = React.createElement

		local v12 = if engineFeature then p2.showTooltip else nil
		return createElement(StudioCTAIcon, { controlState = p4, showTooltip = v12 })
	end

	local v12 = React.useCallback(fn, { if engineFeature then p2.showTooltip else nil })
	local v13 = React.useCallback(function()
		v8:setRBXEventStream(Constants.STUDIO_CTA_EVENT_CONTEXT, Constants.STUDIO_CTA_EVENT_NAME_OPEN)

		v9:openURL((joined.buildCreatorWebNavUrl({ utm_content = "side_bar_blue_icon" })))
	end, { v8, v9, joined.buildCreatorWebNavUrl })
	local v14, v15

	if fFlagEnableFlyoutOnNavRail then
		local menuItems = {}
		local v16 = {}

		if joined.menuItem ~= nil then
			table.insert(menuItems, joined.menuItem)
		end

		if v7 then
			table.insert(v16, {
				isSecondary = true,
				renderIcon = v12,
				onActivated = v13
			})
		end

		local items = joined.items
		local selectedIndex = joined.selectedIndex
		v14 = Cryo.List.join(menuItems, items, v16)
		v15 = selectedIndex + #menuItems
	else
		v14 = joined.items
		v15 = joined.selectedIndex

		if v7 then
			v14 = Cryo.List.join(v14)
			table.insert(v14, {
				isSecondary = true,
				renderIcon = v12,
				onActivated = v13
			})
		end
	end

	local v16 = nil
	local v17 = React.useCallback(function(p3, p4)
		local createElement = React.createElement

		local v20 = if not fFlagShrinkAppNavBar then joined.systemBarLabelTextSizeBinding else nil
		return createElement(AppNavItem, {
			item = p3,
			isChecked = p4,
			isCenterPositioned = true,
			hasLabel = true,
			systemBarLabelTextSizeBinding = v20,
			fillWidth = fFlagEnableNavRailTooltipAndTruncation and true or nil,
			enableTooltip = if fFlagEnableNavRailTooltipAndTruncation then false else nil
		})
	end, { joined.systemBarLabelTextSizeBinding })

	local v18 = React.useCallback(function(p3, p4)
		local createElement = React.createElement

		local v21 = if not fFlagShrinkAppNavBar then joined.systemBarLabelTextSizeBinding else nil
		local v22 = if fFlagEnableNavRailTooltipAndTruncation then UDim.new(1, 0) else nil
		local v23 = if fFlagEnableNavRailTooltipAndTruncation then p3.labelText ~= nil else nil
		local v24 = if fFlagEnableNavRailTooltipAndTruncation then popoverSide.Right else nil
		local v25 = if fFlagEnableNavRailTooltipAndTruncation then popoverAlign.Center else nil
		return createElement(AppNavItem, {
			item = p3,
			isChecked = p4,
			isCenterPositioned = false,
			hasLabel = true,
			systemBarLabelTextSizeBinding = v21,
			width = v22,
			enableTooltip = v23,
			tooltipSide = v24,
			tooltipAlign = v25
		})
	end, { joined.systemBarLabelTextSizeBinding })
	local v19

	if getScrollAwayEnabled() or defineFastFlag2 then
		v19 = VisibilityControl.getFooterBinding()
		local useEffect = React.useEffect
		local function fn2()
			local v20 = if defineFastFlag then joined.isVisible and joined.placement == Placement.Bottom else joined.isVisible
			VisibilityControl.setFooterVisible(v20)
		end
		local isVisible = joined.isVisible
		local v21 = if defineFastFlag then joined.placement else nil
		useEffect(fn2, { isVisible, v21 })
	end

	local useEffect = React.useEffect
	local function fn2()
		local v20 = if fFlagEnableFlyoutOnNavRail then v14[v15] else joined.items[joined.selectedIndex]

		if v20 ~= nil and v20.page ~= nil then
			AppNavTelemetry.logSwitchTabEnd(v20.page)
		end
	end

	local v20 = if fFlagEnableFlyoutOnNavRail then { v14, v15 } else { joined.items, joined.selectedIndex }
	useEffect(fn2, v20)

	React.useEffect(function()
		AppNavTelemetry.logVisibilityEnd(joined.isVisible)
	end, { joined.isVisible })
	React.useEffect(function()
		AppNavTelemetry.logPlacement(joined.placement)
	end, { joined.placement })

	if joined.placement == Placement.Bottom then
		local createElement = React.createElement
		local v22 = {
			alignment = navigationBarAlignment.EvenlyDistributed,
			items = v14,
			isVisible = joined.isVisible,
			size = joined.size,
			renderItem = v17,
			position = joined.position,
			selection = v15,
			clipsDescendants = joined.clipsDescendants,
			animated = true,
			visibility = v19,
			active = true,
			spacing = 0
		}

		local v23 = if fFlagEnableNavRailTooltipAndTruncation then UDim.new(0, v6.Gap.Small) else nil
		v22.spacing = v23
		v16 = createElement(navigationBar, v22)
	elseif joined.placement == Placement.Left then
		local createElement = React.createElement
		local v22 = {
			alignment = navigationRailAlignment.Justified,
			items = v14,
			renderItem = v18,
			size = joined.size,
			animated = true,
			isVisible = joined.isVisible,
			position = joined.position,
			selection = v15,
			clipsDescendants = joined.clipsDescendants,
			leadingComponent = 0,
			trailingComponent = 0,
			spacing = 0
		}
		local v23 = if fFlagAddGamepadBumperNavigation then joined.leadingComponent else nil
		v22.leadingComponent = v23
		local v24 = if fFlagAddGamepadBumperNavigation then joined.trailingComponent else nil
		v22.trailingComponent = v24
		local v25 = if fFlagEnableNavRailTooltipAndTruncation then UDim.new(0, v6.Gap.Small) else nil
		v22.spacing = v25
		v16 = createElement(navigationRailV2, v22)
	end

	return v16
end

return React.memo(AppNavBar)
