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

local function addItems(t1: {[any]: any}, t2: {[any]: any}, t3: {[any]: any}, n1: number) -- line: 54
	-- upvalues: Cryo (copy)
	return Cryo.List.join(t1, t3, t2), n1 + #t1
end

local t4 = {
	selectedIndex = 1,
	isVisible = true,
	clipsDescendants = true
}

local function AppNavBar(t5: {[any]: any}) -- line: 71
	-- upvalues: Cryo (copy), t4 (copy), useAppPolicy (copy), useRoactService (copy), RoactServiceTags (copy), React (copy), StudioCTAIcon (copy), EngineFeature (copy), Constants (copy), FFlagEnableFlyoutOnNavRail (copy), AppNavItem (copy), FFlagShrinkAppNavBar (copy), getScrollAwayEnabled (copy), VisibilityControl (copy), v24 (copy), Placement (copy), AppNavTelemetry (copy), NavigationBar (copy), NavigationBarAlignment (copy), NavigationRailV2 (copy), NavigationRailAlignment (copy), FFlagAddGamepadBumperNavigation (copy)
	local v33 = Cryo.Dictionary.join(t4, t5)
	local v34 = useAppPolicy(function(p1) -- line: 75
		return p1.getShowStudioCTA()
	end)
	local v35 = useRoactService(RoactServiceTags.AppEventIngestService)
	local v36 = useRoactService(RoactServiceTags.AppLinking)
	local v37 = React.useCallback(function(_: boolean, p2) -- line: 80
		-- upvalues: React (copy), StudioCTAIcon (copy), EngineFeature (copy), t5 (copy)
		return React.createElement(StudioCTAIcon, {
			controlState = p2,
			showTooltip = if not EngineFeature then nil else t5.showTooltip
		})
	end, { if not EngineFeature then nil else t5.showTooltip })
	local v38 = React.useCallback(function() -- line: 86
		-- upvalues: v35 (copy), Constants (copy), v33 (copy), v36 (copy)
		v35:setRBXEventStream(Constants.STUDIO_CTA_EVENT_CONTEXT, Constants.STUDIO_CTA_EVENT_NAME_OPEN)

		local v54 = v33.buildCreatorWebNavUrl({
			utm_content = "side_bar_blue_icon"
		})

		v36:openURL(v54)
	end, {
		v35,
		v36,
		v33.buildCreatorWebNavUrl
	})
	local u45, u46

	if FFlagEnableFlyoutOnNavRail then
		local t6 = {}
		local t7 = {}

		if v33.menuItem ~= nil then
			table.insert(t6, v33.menuItem)
		end

		if v34 then
			table.insert(t7, {
				isSecondary = true,
				renderIcon = v37,
				onActivated = v38
			})
		end

		local items = v33.items
		local selectedIndex = v33.selectedIndex
		local v43 = Cryo.List.join(t6, items, t7)
		local v44 = selectedIndex + #t6

		u45 = v43
		u46 = v44
	else
		u45 = v33.items
		u46 = v33.selectedIndex

		if v34 then
			u45 = Cryo.List.join(u45)
			table.insert(u45, {
				isSecondary = true,
				renderIcon = v37,
				onActivated = v38
			})
		end
	end

	local v47 = nil
	local v48 = React.useCallback(function(p3, b2: boolean) -- line: 128
		-- upvalues: React (copy), AppNavItem (copy), FFlagShrinkAppNavBar (copy), v33 (copy)
		return React.createElement(AppNavItem, {
			isCenterPositioned = true,
			hasLabel = true,
			item = p3,
			isChecked = b2,
			systemBarLabelTextSizeBinding = if not FFlagShrinkAppNavBar then v33.systemBarLabelTextSizeBinding else nil
		})
	end, { v33.systemBarLabelTextSizeBinding })
	local v49 = React.useCallback(function(p4, b3: boolean) -- line: 138
		-- upvalues: React (copy), AppNavItem (copy), FFlagShrinkAppNavBar (copy), v33 (copy)
		return React.createElement(AppNavItem, {
			isCenterPositioned = false,
			hasLabel = true,
			item = p4,
			isChecked = b3,
			systemBarLabelTextSizeBinding = if not FFlagShrinkAppNavBar then v33.systemBarLabelTextSizeBinding else nil
		})
	end, { v33.systemBarLabelTextSizeBinding })
	local v50 = nil

	if getScrollAwayEnabled() then
		v50 = VisibilityControl.getFooterBinding()
		React.useEffect(function() -- line: 152
			-- upvalues: v24 (copy), v33 (copy), Placement (copy), VisibilityControl (copy)
			local v59 = if not v24 then v33.isVisible else v33.isVisible and v33.placement == Placement.Bottom

			VisibilityControl.setFooterVisible(v59)
		end, {
			v33.isVisible,
			if not v24 then nil else v33.placement
		})
	end

	React.useEffect(function() -- line: 162
		-- upvalues: FFlagEnableFlyoutOnNavRail (copy), u45 (ref), u46 (ref), v33 (copy), AppNavTelemetry (copy)
		local v60 = if not FFlagEnableFlyoutOnNavRail then v33.items[v33.selectedIndex] else u45[u46]

		if v60 ~= nil and v60.page ~= nil then
			AppNavTelemetry.logSwitchTabEnd(v60.page)
		end
	end, if not FFlagEnableFlyoutOnNavRail then {
		v33.items,
		v33.selectedIndex
	} else {
		u45,
		u46
	})
	React.useEffect(function() -- line: 183
		-- upvalues: AppNavTelemetry (copy), v33 (copy)
		AppNavTelemetry.logVisibilityEnd(v33.isVisible)
	end, { v33.isVisible })
	React.useEffect(function() -- line: 186
		-- upvalues: AppNavTelemetry (copy), v33 (copy)
		AppNavTelemetry.logPlacement(v33.placement)
	end, { v33.placement })

	if v33.placement == Placement.Bottom then
		v47 = React.createElement(NavigationBar, {
			animated = true,
			active = true,
			alignment = NavigationBarAlignment.EvenlyDistributed,
			items = u45,
			isVisible = v33.isVisible,
			size = v33.size,
			renderItem = v48,
			position = v33.position,
			selection = u46,
			clipsDescendants = v33.clipsDescendants,
			visibility = v50
		})
	elseif v33.placement == Placement.Left then
		v47 = React.createElement(NavigationRailV2, {
			animated = true,
			alignment = NavigationRailAlignment.Justified,
			items = u45,
			renderItem = v49,
			size = v33.size,
			isVisible = v33.isVisible,
			position = v33.position,
			selection = u46,
			clipsDescendants = v33.clipsDescendants,
			leadingComponent = if not FFlagAddGamepadBumperNavigation then nil else v33.leadingComponent,
			trailingComponent = if not FFlagAddGamepadBumperNavigation then nil else v33.trailingComponent
		})
	end

	return v47
end

return React.memo(AppNavBar)
