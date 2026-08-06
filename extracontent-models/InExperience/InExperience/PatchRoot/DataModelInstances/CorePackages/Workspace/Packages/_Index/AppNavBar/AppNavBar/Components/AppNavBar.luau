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
local v24 = game:DefineFastFlag("AppNavBarGateFooterVisibleOnPlacement", false)
local v25 = game:DefineFastFlag("AppNavBarFooterVisibleWithoutScrollAway", false)

local function addItems(t1: {[any]: any}, t2: {[any]: any}, t3: {[any]: any}, n1: number) -- line: 56
	-- upvalues: Cryo (copy)
	return Cryo.List.join(t1, t3, t2), n1 + #t1
end

local t4 = {
	selectedIndex = 1,
	isVisible = true,
	clipsDescendants = true
}

local function AppNavBar(t5: {[any]: any}) -- line: 73
	-- upvalues: Cryo (copy), t4 (copy), useAppPolicy (copy), useRoactService (copy), RoactServiceTags (copy), React (copy), StudioCTAIcon (copy), EngineFeature (copy), Constants (copy), FFlagEnableFlyoutOnNavRail (copy), AppNavItem (copy), FFlagShrinkAppNavBar (copy), getScrollAwayEnabled (copy), v25 (copy), VisibilityControl (copy), v24 (copy), Placement (copy), AppNavTelemetry (copy), NavigationBar (copy), NavigationBarAlignment (copy), NavigationRailV2 (copy), NavigationRailAlignment (copy), FFlagAddGamepadBumperNavigation (copy)
	local v34 = Cryo.Dictionary.join(t4, t5)
	local v35 = useAppPolicy(function(p1) -- line: 77
		return p1.getShowStudioCTA()
	end)
	local v36 = useRoactService(RoactServiceTags.AppEventIngestService)
	local v37 = useRoactService(RoactServiceTags.AppLinking)
	local v38 = React.useCallback(function(_: boolean, p2) -- line: 82
		-- upvalues: React (copy), StudioCTAIcon (copy), EngineFeature (copy), t5 (copy)
		return React.createElement(StudioCTAIcon, {
			controlState = p2,
			showTooltip = if not EngineFeature then nil else t5.showTooltip
		})
	end, { if not EngineFeature then nil else t5.showTooltip })
	local v39 = React.useCallback(function() -- line: 88
		-- upvalues: v36 (copy), Constants (copy), v34 (copy), v37 (copy)
		v36:setRBXEventStream(Constants.STUDIO_CTA_EVENT_CONTEXT, Constants.STUDIO_CTA_EVENT_NAME_OPEN)

		local v55 = v34.buildCreatorWebNavUrl({
			utm_content = "side_bar_blue_icon"
		})

		v37:openURL(v55)
	end, {
		v36,
		v37,
		v34.buildCreatorWebNavUrl
	})
	local u46, u47

	if FFlagEnableFlyoutOnNavRail then
		local t6 = {}
		local t7 = {}

		if v34.menuItem ~= nil then
			table.insert(t6, v34.menuItem)
		end

		if v35 then
			table.insert(t7, {
				isSecondary = true,
				renderIcon = v38,
				onActivated = v39
			})
		end

		local items = v34.items
		local selectedIndex = v34.selectedIndex
		local v44 = Cryo.List.join(t6, items, t7)
		local v45 = selectedIndex + #t6

		u46 = v44
		u47 = v45
	else
		u46 = v34.items
		u47 = v34.selectedIndex

		if v35 then
			u46 = Cryo.List.join(u46)
			table.insert(u46, {
				isSecondary = true,
				renderIcon = v38,
				onActivated = v39
			})
		end
	end

	local v48 = nil
	local v49 = React.useCallback(function(p3, b2: boolean) -- line: 130
		-- upvalues: React (copy), AppNavItem (copy), FFlagShrinkAppNavBar (copy), v34 (copy)
		return React.createElement(AppNavItem, {
			isCenterPositioned = true,
			hasLabel = true,
			item = p3,
			isChecked = b2,
			systemBarLabelTextSizeBinding = if not FFlagShrinkAppNavBar then v34.systemBarLabelTextSizeBinding else nil
		})
	end, { v34.systemBarLabelTextSizeBinding })
	local v50 = React.useCallback(function(p4, b3: boolean) -- line: 140
		-- upvalues: React (copy), AppNavItem (copy), FFlagShrinkAppNavBar (copy), v34 (copy)
		return React.createElement(AppNavItem, {
			isCenterPositioned = false,
			hasLabel = true,
			item = p4,
			isChecked = b3,
			systemBarLabelTextSizeBinding = if not FFlagShrinkAppNavBar then v34.systemBarLabelTextSizeBinding else nil
		})
	end, { v34.systemBarLabelTextSizeBinding })
	local v51 = nil

	if getScrollAwayEnabled() or v25 then
		v51 = VisibilityControl.getFooterBinding()
		React.useEffect(function() -- line: 154
			-- upvalues: v24 (copy), v34 (copy), Placement (copy), VisibilityControl (copy)
			local v60 = if not v24 then v34.isVisible else v34.isVisible and v34.placement == Placement.Bottom

			VisibilityControl.setFooterVisible(v60)
		end, {
			v34.isVisible,
			if not v24 then nil else v34.placement
		})
	end

	React.useEffect(function() -- line: 164
		-- upvalues: FFlagEnableFlyoutOnNavRail (copy), u46 (ref), u47 (ref), v34 (copy), AppNavTelemetry (copy)
		local v61 = if not FFlagEnableFlyoutOnNavRail then v34.items[v34.selectedIndex] else u46[u47]

		if v61 ~= nil and v61.page ~= nil then
			AppNavTelemetry.logSwitchTabEnd(v61.page)
		end
	end, if not FFlagEnableFlyoutOnNavRail then {
		v34.items,
		v34.selectedIndex
	} else {
		u46,
		u47
	})
	React.useEffect(function() -- line: 185
		-- upvalues: AppNavTelemetry (copy), v34 (copy)
		AppNavTelemetry.logVisibilityEnd(v34.isVisible)
	end, { v34.isVisible })
	React.useEffect(function() -- line: 188
		-- upvalues: AppNavTelemetry (copy), v34 (copy)
		AppNavTelemetry.logPlacement(v34.placement)
	end, { v34.placement })

	if v34.placement == Placement.Bottom then
		v48 = React.createElement(NavigationBar, {
			animated = true,
			active = true,
			alignment = NavigationBarAlignment.EvenlyDistributed,
			items = u46,
			isVisible = v34.isVisible,
			size = v34.size,
			renderItem = v49,
			position = v34.position,
			selection = u47,
			clipsDescendants = v34.clipsDescendants,
			visibility = v51
		})
	elseif v34.placement == Placement.Left then
		v48 = React.createElement(NavigationRailV2, {
			animated = true,
			alignment = NavigationRailAlignment.Justified,
			items = u46,
			renderItem = v50,
			size = v34.size,
			isVisible = v34.isVisible,
			position = v34.position,
			selection = u47,
			clipsDescendants = v34.clipsDescendants,
			leadingComponent = if not FFlagAddGamepadBumperNavigation then nil else v34.leadingComponent,
			trailingComponent = if not FFlagAddGamepadBumperNavigation then nil else v34.trailingComponent
		})
	end

	return v48
end

return React.memo(AppNavBar)
