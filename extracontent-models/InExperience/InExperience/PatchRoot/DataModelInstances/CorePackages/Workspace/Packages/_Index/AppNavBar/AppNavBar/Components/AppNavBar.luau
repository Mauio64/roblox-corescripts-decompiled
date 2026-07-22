local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Cryo = require(ParentParentParent.Cryo)
local UIBlox = require(ParentParentParent.UIBlox)
local useAppPolicy = require(ParentParentParent.UniversalAppPolicy).useAppPolicy
local useRoactService = require(ParentParentParent.RobloxAppHooks).useRoactService
local RoactServiceTags = require(ParentParentParent.RoactServiceTags)
local NavigationBar = UIBlox.App.Navigation.NavigationBar
local NavigationRailV2 = UIBlox.App.Navigation.NavigationRailV2
local NavigationBarAlignment = UIBlox.App.Navigation.Enum.NavigationBarAlignment
local NavigationRailAlignment = UIBlox.App.Navigation.Enum.NavigationRailAlignment
local Placement = require(ParentParent.Enum.Placement)
local AppNavItem = require(ParentParent.Components.AppNavItem)
local StudioCTAIcon = require(ParentParent.Components.StudioCTAIcon)
local Constants = require(ParentParent.Constants)
local VisibilityControl = require(ParentParent.VisibilityControl)
local getScrollAwayEnabled = require(ParentParent.getScrollAwayEnabled)
local AppNavTelemetry = require(ParentParent.Telemetry.AppNavTelemetry)
local EngineFeature = game:GetEngineFeature("WebViewRedesignEnabled")
local FFlagAddGamepadBumperNavigation = require(ParentParentParent.SharedFlags).FFlagAddGamepadBumperNavigation
local FFlagShrinkAppNavBar = require(ParentParentParent.SharedFlags).FFlagShrinkAppNavBar
local FFlagEnableFlyoutOnNavRail = require(ParentParentParent.SharedFlags).FFlagEnableFlyoutOnNavRail

local function addItems(t1: {[any]: any}, t2: {[any]: any}, t3: {[any]: any}, n1: number) -- line: 53
	-- upvalues: Cryo (copy)
	return Cryo.List.join(t1, t3, t2), n1 + #t1
end

local t4 = {
	selectedIndex = 1,
	isVisible = true,
	clipsDescendants = true
}

local function AppNavBar(t5: {[any]: any}) -- line: 70
	-- upvalues: Cryo (copy), t4 (copy), useAppPolicy (copy), useRoactService (copy), RoactServiceTags (copy), React (copy), StudioCTAIcon (copy), EngineFeature (copy), Constants (copy), FFlagEnableFlyoutOnNavRail (copy), AppNavItem (copy), FFlagShrinkAppNavBar (copy), getScrollAwayEnabled (copy), VisibilityControl (copy), AppNavTelemetry (copy), Placement (copy), NavigationBar (copy), NavigationBarAlignment (copy), NavigationRailV2 (copy), NavigationRailAlignment (copy), FFlagAddGamepadBumperNavigation (copy)
	local v32 = Cryo.Dictionary.join(t4, t5)
	local v33 = useAppPolicy(function(p1) -- line: 74
		return p1.getShowStudioCTA()
	end)
	local v34 = useRoactService(RoactServiceTags.AppEventIngestService)
	local v35 = useRoactService(RoactServiceTags.AppLinking)
	local v36 = React.useCallback(function(_: boolean, p2) -- line: 79
		-- upvalues: React (copy), StudioCTAIcon (copy), EngineFeature (copy), t5 (copy)
		return React.createElement(StudioCTAIcon, {
			controlState = p2,
			showTooltip = if not EngineFeature then nil else t5.showTooltip
		})
	end, { if not EngineFeature then nil else t5.showTooltip })
	local v37 = React.useCallback(function() -- line: 85
		-- upvalues: v34 (copy), Constants (copy), v32 (copy), v35 (copy)
		v34:setRBXEventStream(Constants.STUDIO_CTA_EVENT_CONTEXT, Constants.STUDIO_CTA_EVENT_NAME_OPEN)

		local v53 = v32.buildCreatorWebNavUrl({
			utm_content = "side_bar_blue_icon"
		})

		v35:openURL(v53)
	end, {
		v34,
		v35,
		v32.buildCreatorWebNavUrl
	})
	local u44, u45

	if FFlagEnableFlyoutOnNavRail then
		local t6 = {}
		local t7 = {}

		if v32.menuItem ~= nil then
			table.insert(t6, v32.menuItem)
		end

		if v33 then
			table.insert(t7, {
				isSecondary = true,
				renderIcon = v36,
				onActivated = v37
			})
		end

		local items = v32.items
		local selectedIndex = v32.selectedIndex
		local v42 = Cryo.List.join(t6, items, t7)
		local v43 = selectedIndex + #t6

		u44 = v42
		u45 = v43
	else
		u44 = v32.items
		u45 = v32.selectedIndex

		if v33 then
			u44 = Cryo.List.join(u44)
			table.insert(u44, {
				isSecondary = true,
				renderIcon = v36,
				onActivated = v37
			})
		end
	end

	local v46 = nil
	local v47 = React.useCallback(function(p3, b2: boolean) -- line: 127
		-- upvalues: React (copy), AppNavItem (copy), FFlagShrinkAppNavBar (copy), v32 (copy)
		return React.createElement(AppNavItem, {
			isCenterPositioned = true,
			hasLabel = true,
			item = p3,
			isChecked = b2,
			systemBarLabelTextSizeBinding = if not FFlagShrinkAppNavBar then v32.systemBarLabelTextSizeBinding else nil
		})
	end, { v32.systemBarLabelTextSizeBinding })
	local v48 = React.useCallback(function(p4, b3: boolean) -- line: 137
		-- upvalues: React (copy), AppNavItem (copy), FFlagShrinkAppNavBar (copy), v32 (copy)
		return React.createElement(AppNavItem, {
			isCenterPositioned = false,
			hasLabel = true,
			item = p4,
			isChecked = b3,
			systemBarLabelTextSizeBinding = if not FFlagShrinkAppNavBar then v32.systemBarLabelTextSizeBinding else nil
		})
	end, { v32.systemBarLabelTextSizeBinding })
	local v49 = nil

	if getScrollAwayEnabled() then
		v49 = VisibilityControl.getFooterBinding()
		React.useEffect(function() -- line: 150
			-- upvalues: VisibilityControl (copy), v32 (copy)
			VisibilityControl.setFooterVisible(v32.isVisible)
		end, { v32.isVisible })
	end

	React.useEffect(function() -- line: 155
		-- upvalues: FFlagEnableFlyoutOnNavRail (copy), u44 (ref), u45 (ref), v32 (copy), AppNavTelemetry (copy)
		local v58 = if not FFlagEnableFlyoutOnNavRail then v32.items[v32.selectedIndex] else u44[u45]

		if v58 ~= nil and v58.page ~= nil then
			AppNavTelemetry.logSwitchTabEnd(v58.page)
		end
	end, if not FFlagEnableFlyoutOnNavRail then {
		v32.items,
		v32.selectedIndex
	} else {
		u44,
		u45
	})
	React.useEffect(function() -- line: 176
		-- upvalues: AppNavTelemetry (copy), v32 (copy)
		AppNavTelemetry.logVisibilityEnd(v32.isVisible)
	end, { v32.isVisible })
	React.useEffect(function() -- line: 179
		-- upvalues: AppNavTelemetry (copy), v32 (copy)
		AppNavTelemetry.logPlacement(v32.placement)
	end, { v32.placement })

	if v32.placement == Placement.Bottom then
		v46 = React.createElement(NavigationBar, {
			animated = true,
			active = true,
			alignment = NavigationBarAlignment.EvenlyDistributed,
			items = u44,
			isVisible = v32.isVisible,
			size = v32.size,
			renderItem = v47,
			position = v32.position,
			selection = u45,
			clipsDescendants = v32.clipsDescendants,
			visibility = v49
		})
	elseif v32.placement == Placement.Left then
		v46 = React.createElement(NavigationRailV2, {
			animated = true,
			alignment = NavigationRailAlignment.Justified,
			items = u44,
			renderItem = v48,
			size = v32.size,
			isVisible = v32.isVisible,
			position = v32.position,
			selection = u45,
			clipsDescendants = v32.clipsDescendants,
			leadingComponent = if not FFlagAddGamepadBumperNavigation then nil else v32.leadingComponent,
			trailingComponent = if not FFlagAddGamepadBumperNavigation then nil else v32.trailingComponent
		})
	end

	return v46
end

return React.memo(AppNavBar)
