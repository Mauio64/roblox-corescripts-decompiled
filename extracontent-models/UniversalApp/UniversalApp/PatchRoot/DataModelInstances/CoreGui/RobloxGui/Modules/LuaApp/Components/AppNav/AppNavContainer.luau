local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local ReactProfiler = require(CorePackages.Workspace.Packages.RoactUtils).Profiling.ReactProfiler
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local useNavBarSize = AppNavBar.useNavBarSize
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local CompositionStyleSheet = require(CorePackages.Workspace.Packages.AppComposition).CompositionStyleSheet
local CollectionViews = require(CorePackages.Workspace.Packages.CollectionViews)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaAppEnableStickyShortcutBar = SharedFlags.FFlagLuaAppEnableStickyShortcutBar
local GetFFlagLuaAppFixStudioNotchSupport = require(Modules.LuaApp.Flags.GetFFlagLuaAppFixStudioNotchSupport)
local v15 = SharedFlags.FFlagLuaAppUseDeviceSafeInsetsForAppContainer and GetFFlagLuaAppFixStudioNotchSupport()
local FFlagFixNavigationInsetsOnHiddenTabBar = SharedFlags.FFlagFixNavigationInsetsOnHiddenTabBar
local FFlagGuacStickyShortcutBarEnabled = SharedFlags.FFlagGuacStickyShortcutBarEnabled
local v18 = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled then nil else require(CorePackages.Workspace.Packages.AppShortcutBar).AppShortcutBarStatusListener

local function AppNavContainer(t1: {[any]: any}) -- line: 36
	-- upvalues: React (copy), CollectionViews (copy), FFlagLuaAppEnableStickyShortcutBar (copy), FFlagGuacStickyShortcutBarEnabled (copy), useAppPolicy (copy), ReactProfiler (copy), CompositionStyleSheet (copy), Responsive (copy), v18 (copy), v15 (copy), useNavBarPlacement (copy), useNavBarSize (copy), AppNavBar (copy), FFlagFixNavigationInsetsOnHiddenTabBar (copy)
	local v21 = React.useCallback(function(p1) -- line: 37
		-- upvalues: CollectionViews (copy)
		local v34 = CollectionViews.getMainCollectionLayoutStore(false)

		if v34.setDefaultContentRegionWidth then
			v34.setDefaultContentRegionWidth(p1.AbsoluteSize.X)
		end
	end, {})
	local u22 = nil
	local v23 = nil
	local v24 = nil

	if FFlagLuaAppEnableStickyShortcutBar or FFlagGuacStickyShortcutBarEnabled then
		local v25

		v25, v23 = React.useBinding(0)
		u22 = v25
		v24 = React.useMemo(function() -- line: 48
			-- upvalues: u22 (ref)
			return u22:map(function(p2) -- line: 49
				return UDim2.new(1, 0, 1, -p2)
			end)
		end, { u22 })
	end

	local v26 = if not FFlagGuacStickyShortcutBarEnabled then nil else useAppPolicy(function(p3) -- line: 56
		return p3.getStickyShortcutBarEnabled()
	end)
	local v27 = React.createElement(ReactProfiler, {
		id = "AppNavContainer"
	}, {
		CompositionStyleSheet = React.createElement(CompositionStyleSheet),
		ResponsiveContainerFrame = React.createElement(Responsive.ResponsiveContainerFrame),
		NavigatorView = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, 0),
			Size = if not FFlagLuaAppEnableStickyShortcutBar and (not FFlagGuacStickyShortcutBarEnabled or not v26) then UDim2.new(1, 0, 1, 0) else v24,
			ZIndex = 1,
			[React.Change.AbsoluteSize] = v21
		}, t1.children),
		ShortcutBarStatusListener = if not FFlagLuaAppEnableStickyShortcutBar and (not FFlagGuacStickyShortcutBarEnabled or not v26) then nil else React.createElement(v18, {
			onHeightChanged = v23
		})
	})

	if v15 then
		local v28 = useNavBarPlacement()
		local v29 = useNavBarSize()
		local v30 = v28 == AppNavBar.Placement.Left
		local v31 = if not v30 or not (not FFlagFixNavigationInsetsOnHiddenTabBar or t1.isTabBarVisible) then UDim2.new(0, 0, 0, 0) else UDim2.new(0, v29, 0, 0)
		local v32 = if not v30 or not (not FFlagFixNavigationInsetsOnHiddenTabBar or t1.isTabBarVisible) then UDim2.new(1, 0, 1, 0) else UDim2.new(1, -v29, 1, 0)

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = v31,
			Size = v32
		}, {
			Inner = v27
		})
	end

	return v27
end

return AppNavContainer
