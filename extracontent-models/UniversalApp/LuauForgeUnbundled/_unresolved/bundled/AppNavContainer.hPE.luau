local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local reactProfiler = require("@game/CorePackages/Workspace/Packages/RoactUtils").Profiling.ReactProfiler

local module2 = require("@luauforge/bundled/dHu")
local useNavBarPlacement = module2.useNavBarPlacement
local useNavBarSize = module2.useNavBarSize
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local compositionStyleSheet = require("@luauforge/bundled/gns").CompositionStyleSheet
local module3 = require("@luauforge/bundled/edJ")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local shouldUseDeviceSafeInsets = require("@luauforge/bundled/dUd").shouldUseDeviceSafeInsets
local fFlagFixNavigationInsetsOnHiddenTabBar = SharedFlags.FFlagFixNavigationInsetsOnHiddenTabBar
local fFlagFixAppNavContainerShortcutBarHeight = SharedFlags.FFlagFixAppNavContainerShortcutBarHeight
local fFlagEnableStickyShortcutBarOnAllPlatforms = SharedFlags.FFlagEnableStickyShortcutBarOnAllPlatforms

local appShortcutBarStatusListener = require("@luauforge/bundled/eev").AppShortcutBarStatusListener
local hooks = require("@luauforge/bundled/eev").Hooks
local getShortcutBarStatusStore

if fFlagEnableStickyShortcutBarOnAllPlatforms then
	getShortcutBarStatusStore = require("@luauforge/bundled/eev").GetShortcutBarStatusStore
else
	getShortcutBarStatusStore = nil
end

local appShortcutBarContainer

if fFlagEnableStickyShortcutBarOnAllPlatforms then
	appShortcutBarContainer = require("@luauforge/bundled/eev").AppShortcutBarContainer
else
	appShortcutBarContainer = nil
end

local appShortcutBarContext

if fFlagEnableStickyShortcutBarOnAllPlatforms then
	appShortcutBarContext = require("@luauforge/bundled/eev").AppShortcutBarContext
else
	appShortcutBarContext = nil
end

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local function AppNavContainer(props)
	local v5 = React.useCallback(function(p2)
		local mainCollectionLayoutStore = module3.getMainCollectionLayoutStore(false)

		if mainCollectionLayoutStore.setDefaultContentRegionWidth then
			mainCollectionLayoutStore.setDefaultContentRegionWidth(p2.AbsoluteSize.X)
		end
	end, {})
	local v6, v7

	if fFlagFixAppNavContainerShortcutBarHeight then
		local v8 = hooks.useAppShortcutBarHeight()
		local v9 = hooks.useShortcutBarVisible()
		v6, v7 = React.useBinding(not v9 and 0 or v8)
	else
		v6, v7 = React.useBinding(0)
	end

	local v8 = React.useMemo(function()
		return v6:map(function(p2)
			return UDim2.new(1, 0, 1, -p2)
		end)
	end, { v6 })

	local v9 = not fFlagEnableStickyShortcutBarOnAllPlatforms and 0
		or useSignalState(getShortcutBarStatusStore(false).getShortcutBarReservedHeight)

	local v10 = useAppPolicy(function(p2)
		return p2.getStickyShortcutBarEnabled()
	end)
	local v11, v12

	if fFlagEnableStickyShortcutBarOnAllPlatforms or shouldUseDeviceSafeInsets then
		local v13 = useNavBarPlacement()
		v11 = useNavBarSize()

		if v13 == module2.Placement.Left then
			v12 = not fFlagFixNavigationInsetsOnHiddenTabBar or props.isTabBarVisible == true
		else
			v12 = false
		end
	else
		v12 = false
		v11 = 0
	end

	local createElement = React.createElement

	local v15 = {
		CompositionStyleSheet = React.createElement(compositionStyleSheet),
		ResponsiveContainerFrame = React.createElement(Responsive.ResponsiveContainerFrame),
		NavigatorView = 0,
		ShortcutBar = 0,
		ShortcutBarStatusListener = 0
	}
	local createElement2 = React.createElement
	local v17 = {
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0)
	}

	if fFlagEnableStickyShortcutBarOnAllPlatforms then
		v8 = UDim2.new(1, 0, 1, -v9)
	elseif not v10 then
		v8 = UDim2.new(1, 0, 1, 0)
	end

	v17.Size = v8

	v17.ZIndex = 1
	v17[React.Change.AbsoluteSize] = v5
	v15.NavigatorView = createElement2("Frame", v17, props.children)

	local v18 = if fFlagEnableStickyShortcutBarOnAllPlatforms then React.createElement(
		"Frame",
		{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 2 },
		{
			ShortcutBarContext = React.createElement(appShortcutBarContext.Provider, {}, {
				ShortcutBar = React.createElement(appShortcutBarContainer, {
					isLeftNavVisible = v12,
					currentPage = props.currentPage
				})
			})
		}
	) else nil
	v15.ShortcutBar = v18

	local v19 = if not (fFlagEnableStickyShortcutBarOnAllPlatforms or not v10) then React.createElement(appShortcutBarStatusListener, {
		onHeightChanged = v7
	}) else nil
	v15.ShortcutBarStatusListener = v19
	local element = createElement(reactProfiler, { id = "AppNavContainer" }, v15)

	if not shouldUseDeviceSafeInsets then
		return element
	end

	local udim = if v12 then UDim2.new(0, v11, 0, 0) else UDim2.new(0, 0, 0, 0)
	local v20 = if v12 then UDim2.new(1, -v11, 1, 0) else UDim2.new(1, 0, 1, 0)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = udim,
		Size = v20
	}, {
		Inner = element
	})
end

return AppNavContainer
