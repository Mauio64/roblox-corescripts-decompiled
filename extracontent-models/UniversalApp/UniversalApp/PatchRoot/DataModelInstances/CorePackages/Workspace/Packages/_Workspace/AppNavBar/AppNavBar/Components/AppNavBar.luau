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
local t1 = {
	selectedIndex = 1,
	isVisible = true,
	clipsDescendants = true
}

local function AppNavBar(t2: {[any]: any}) -- line: 57
	-- upvalues: Cryo (copy), t1 (copy), useAppPolicy (copy), useRoactService (copy), RoactServiceTags (copy), React (copy), StudioCTAIcon (copy), EngineFeature (copy), Constants (copy), AppNavItem (copy), FFlagShrinkAppNavBar (copy), getScrollAwayEnabled (copy), VisibilityControl (copy), AppNavTelemetry (copy), Placement (copy), NavigationBar (copy), NavigationBarAlignment (copy), NavigationRailV2 (copy), NavigationRailAlignment (copy), FFlagAddGamepadBumperNavigation (copy)
	local v26 = Cryo.Dictionary.join(t1, t2)
	local items = v26.items
	local v28 = useAppPolicy(function(p1) -- line: 62
		return p1.getShowStudioCTA()
	end)
	local v29 = useRoactService(RoactServiceTags.AppEventIngestService)
	local v30 = useRoactService(RoactServiceTags.AppLinking)
	local v31 = React.useCallback(function(_: boolean, p2) -- line: 67
		-- upvalues: React (copy), StudioCTAIcon (copy), EngineFeature (copy), t2 (copy)
		return React.createElement(StudioCTAIcon, {
			controlState = p2,
			showTooltip = if not EngineFeature then nil else t2.showTooltip
		})
	end, { if not EngineFeature then nil else t2.showTooltip })
	local v32 = React.useCallback(function() -- line: 73
		-- upvalues: v29 (copy), Constants (copy), v26 (copy), v30 (copy)
		v29:setRBXEventStream(Constants.STUDIO_CTA_EVENT_CONTEXT, Constants.STUDIO_CTA_EVENT_NAME_OPEN)

		local v40 = v26.buildCreatorWebNavUrl({
			utm_content = "side_bar_blue_icon"
		})

		v30:openURL(v40)
	end, {
		v29,
		v30,
		v26.buildCreatorWebNavUrl
	})

	if v28 then
		items = Cryo.List.join(items)
		table.insert(items, {
			isSecondary = true,
			renderIcon = v31,
			onActivated = v32
		})
	end

	local v33 = nil
	local v34 = React.useCallback(function(p3, b2: boolean) -- line: 91
		-- upvalues: React (copy), AppNavItem (copy), FFlagShrinkAppNavBar (copy), v26 (copy)
		return React.createElement(AppNavItem, {
			isCenterPositioned = true,
			hasLabel = true,
			item = p3,
			isChecked = b2,
			systemBarLabelTextSizeBinding = if not FFlagShrinkAppNavBar then v26.systemBarLabelTextSizeBinding else nil
		})
	end, { v26.systemBarLabelTextSizeBinding })
	local v35 = React.useCallback(function(p4, b3: boolean) -- line: 101
		-- upvalues: React (copy), AppNavItem (copy), FFlagShrinkAppNavBar (copy), v26 (copy)
		return React.createElement(AppNavItem, {
			isCenterPositioned = false,
			hasLabel = true,
			item = p4,
			isChecked = b3,
			systemBarLabelTextSizeBinding = if not FFlagShrinkAppNavBar then v26.systemBarLabelTextSizeBinding else nil
		})
	end, { v26.systemBarLabelTextSizeBinding })
	local v36 = nil

	if getScrollAwayEnabled() then
		v36 = VisibilityControl.getFooterBinding()
		React.useEffect(function() -- line: 114
			-- upvalues: VisibilityControl (copy), v26 (copy)
			VisibilityControl.setFooterVisible(v26.isVisible)
		end, { v26.isVisible })
	end

	React.useEffect(function() -- line: 118
		-- upvalues: v26 (copy), AppNavTelemetry (copy)
		local v45 = v26.items[v26.selectedIndex]

		if v45 ~= nil and v45.page ~= nil then
			AppNavTelemetry.logSwitchTabEnd(v45.page)
		end
	end, {
		v26.items,
		v26.selectedIndex
	})
	React.useEffect(function() -- line: 124
		-- upvalues: AppNavTelemetry (copy), v26 (copy)
		AppNavTelemetry.logVisibilityEnd(v26.isVisible)
	end, { v26.isVisible })
	React.useEffect(function() -- line: 127
		-- upvalues: AppNavTelemetry (copy), v26 (copy)
		AppNavTelemetry.logPlacement(v26.placement)
	end, { v26.placement })

	if v26.placement == Placement.Bottom then
		return (React.createElement(NavigationBar, {
			animated = true,
			active = true,
			alignment = NavigationBarAlignment.EvenlyDistributed,
			items = items,
			isVisible = v26.isVisible,
			size = v26.size,
			renderItem = v34,
			position = v26.position,
			selection = v26.selectedIndex,
			clipsDescendants = v26.clipsDescendants,
			visibility = v36
		}))
	end

	if v26.placement == Placement.Left then
		v33 = React.createElement(NavigationRailV2, {
			animated = true,
			alignment = NavigationRailAlignment.Justified,
			items = items,
			renderItem = v35,
			size = v26.size,
			isVisible = v26.isVisible,
			position = v26.position,
			selection = v26.selectedIndex,
			clipsDescendants = v26.clipsDescendants,
			leadingComponent = if not FFlagAddGamepadBumperNavigation then nil else v26.leadingComponent,
			trailingComponent = if not FFlagAddGamepadBumperNavigation then nil else v26.trailingComponent
		})
	end

	return v33
end

return React.memo(AppNavBar)
