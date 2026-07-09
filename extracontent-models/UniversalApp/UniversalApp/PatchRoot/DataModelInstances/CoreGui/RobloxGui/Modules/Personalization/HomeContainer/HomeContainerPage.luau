local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

require(CorePackages.Packages.Dash)

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local View = Foundation.View
local Tabs = Foundation.Tabs
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState

require(CorePackages.Packages.Signals)

local Display = require(CorePackages.Workspace.Packages.Display)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization

require(CorePackages.Workspace.Packages.Navigation)

local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local usePageSideMargin = require(CorePackages.Workspace.Packages.CollectionViews).usePageSideMargin
local AppNotificationService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppNotificationService
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local Modules = CoreGui.RobloxGui.Modules
local PersonalizationTopBar = require(Modules.Personalization.PersonalizationTopBar)
local createHomeSubTabNavigator = require(script.Parent.createHomeSubTabNavigator)
local CompositionTags = require(CorePackages.Workspace.Packages.AppComposition).CompositionTags
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagAppIaHomeSubTabAnalytics = SharedFlags.FFlagAppIaHomeSubTabAnalytics
local FFlagAppIaStatusBar = SharedFlags.FFlagAppIaStatusBar
local FFlagLuaAppChartsStickyHeader = SharedFlags.FFlagLuaAppChartsStickyHeader
local FFlagLuaAppCompositionHome = SharedFlags.FFlagLuaAppCompositionHome
local FFlagLuaAppCompositionHomeHeaderFullBleed = SharedFlags.FFlagLuaAppCompositionHomeHeaderFullBleed
local v36 = game:DefineFastFlag("AppIaHomeSubTabFrame", false)
local v37 = game:DefineFastFlag("AppIaHomeSubTabUnderlineFix", false)
local v38 = game:DefineFastFlag("AppIaHomeSubTabScrollAwayFix", false) and v36
local v39 = game:DefineFastFlag("AppIaHomeSubTabScrollAwayFixDefaultHeight", false)
local v40 = createHomeSubTabNavigator()
local v41 = if not FFlagAppIaHomeSubTabAnalytics then nil else {
	[AppPage.Home] = Enum.AppShellActionType.TapHomePageTab,
	[AppPage.Games] = Enum.AppShellActionType.TapGamePageTab
}

local function v42(p1) -- line: 80
	-- upvalues: Display (copy)
	return Display.GetDisplayStore(p1).getTopBarHeight(p1)
end

local v43 = React.forwardRef(function(t1: {[any]: any}, p2) -- line: 84
	-- upvalues: useLocalization (copy), FFlagAppIaHomeSubTabAnalytics (copy), useRoactService (copy), AppNotificationService (copy), React (copy), v41 (copy), v37 (copy), AppPage (copy), useDesignTokens (copy), useSelector (copy), FormFactor (copy), FillBehavior (copy), FFlagLuaAppCompositionHome (copy), usePageSideMargin (copy), FFlagAppIaStatusBar (copy), v38 (copy), useSignalState (copy), v42 (copy), useTokens (copy), v39 (copy), FFlagLuaAppChartsStickyHeader (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), VisibilityControl (copy), v36 (copy), View (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), FFlagLuaAppCompositionHomeHeaderFullBleed (copy), CompositionTags (copy), PersonalizationTopBar (copy), Tabs (copy), InputSize (copy), v40 (copy)
	local v49 = useLocalization({
		Charts = "CommonUI.Features.Label.Charts",
		ForYou = "CommonUI.Features.Label.ForYou"
	})
	local v50 = if not FFlagAppIaHomeSubTabAnalytics then nil else useRoactService(AppNotificationService)
	local state = t1.navigation.state
	local routeName = state.routes[state.index].routeName
	local v53 = React.useCallback(function(p3) -- line: 94
		-- upvalues: FFlagAppIaHomeSubTabAnalytics (copy), routeName (copy), t1 (copy), v41 (copy), v50 (copy)
		if FFlagAppIaHomeSubTabAnalytics then
			if p3 == routeName then
				return
			end

			t1.navigation.navigate(p3)

			local v79 = v41[p3]

			if v79 then
				v50:ActionTaken(v79)

				return
			end
		else
			t1.navigation.navigate(p3)
		end
	end, {
		t1.navigation,
		if not FFlagAppIaHomeSubTabAnalytics then nil else v50
	})
	local v54 = if not v37 then {
		{
			id = AppPage.Home,
			text = v49.ForYou
		},
		{
			id = AppPage.Games,
			text = v49.Charts
		}
	} else React.useMemo(function() -- line: 111
		-- upvalues: AppPage (copy), v49 (copy)
		return {
			{
				id = AppPage.Home,
				text = v49.ForYou
			},
			{
				id = AppPage.Games,
				text = v49.Charts
			}
		}
	end, {
		v49.ForYou,
		v49.Charts
	})
	local v55 = useDesignTokens()
	local v56 = if useSelector(function(p4) -- line: 135
		return p4.FormFactor
	end) ~= FormFactor.COMPACT then FillBehavior.Fit else FillBehavior.Fill
	local v57 = nil

	if not FFlagLuaAppCompositionHome then
		v57 = usePageSideMargin()
	end

	local v58 = if not FFlagAppIaStatusBar then nil else useSelector(function(p5) -- line: 147
		return p5.TopBar.statusBarHeight
	end)
	local v59 = if not v38 then nil else useSignalState(v42)
	local u60 = nil
	local u61 = nil
	local v62 = nil
	local v63 = nil
	local u64 = nil
	local v65 = nil
	local v66 = nil
	local v67 = nil
	local v68 = nil

	if v38 then
		local v69 = useTokens()
		local v70 = not v39 and 0 or v69.Padding.Medium * 2 + v69.Size.Size_600
		local v71, v72 = React.useState(v70)

		v65 = React.useCallback(function(p6) -- line: 169
			-- upvalues: v72 (copy)
			if p6 then
				v72(p6.AbsoluteSize.Y)
			end
		end, {})
		u60 = v59 + v71

		local v73 = not FFlagAppIaStatusBar and 0 or v58

		v67 = v59 - v73

		if FFlagLuaAppChartsStickyHeader then
			local v74

			v63, v74 = React.useBinding(0)
			u64 = v74
		end

		React.useEffect(function() -- line: 180
			-- upvalues: u64 (ref), u60 (ref)
			if u64 then
				u64(u60)
			end
		end, { u60 })
		v66 = if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then UDim2.new(0, 0, 0, v59) else VisibilityControl.getHeaderBinding():map(function(n1: number) -- line: 186
			-- upvalues: v73 (copy), v59 (copy)
			return UDim2.new(0, 0, 0, v73 + n1 * (v59 - v73))
		end)
		v68 = VisibilityControl.getHeaderBinding():map(function(n2: number) -- line: 190
			-- upvalues: v73 (copy), v59 (copy), v71 (copy)
			return UDim2.new(0, 0, 0, v73 + n2 * (v59 - v73) + v71)
		end)
	elseif FFlagAppIaScrollAway then
		local v75, v76 = React.useState(0)

		u60 = v75
		u61 = v76

		if FFlagLuaAppChartsStickyHeader then
			local v77

			v63, v77 = React.useBinding(0)
			u64 = v77
		end

		v62 = React.useCallback(function(p7) -- line: 203
			-- upvalues: u61 (ref), FFlagLuaAppChartsStickyHeader (copy), u64 (ref)
			u61(p7.AbsoluteSize.Y)

			if FFlagLuaAppChartsStickyHeader then
				u64(p7.AbsoluteSize.Y)
			end
		end, {})
	end

	return React.createElement(if not v36 then View else "Frame", {
		BackgroundColor3 = if not v36 then nil else v55.LuaApps.App.Page.BackgroundColor,
		BackgroundTransparency = if not v36 then nil else v55.LuaApps.App.Page.BackgroundTransparency,
		BorderSizePixel = if not v36 then nil else 0,
		Size = if not v36 then nil else UDim2.fromScale(1, 1),
		backgroundStyle = if v36 then nil else {
			Color3 = v55.LuaApps.App.Page.BackgroundColor,
			Transparency = v55.LuaApps.App.Page.BackgroundTransparency
		},
		tag = if v36 then nil else {
			["size-full"] = true,
			col = not FFlagAppIaScrollAway
		},
		ref = p2
	}, {
		UIListLayout = if not v36 or FFlagAppIaScrollAway then nil else React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		HeaderFocusRoot = React.createElement(FocusNavigableSurfaceWrapper, {
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.HeaderView,
			frameProps = {
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = if not v36 then nil else -1,
				Size = UDim2.fromScale(1, 0),
				ZIndex = 2,
				[React.Tag] = if not FFlagLuaAppCompositionHomeHeaderFullBleed then if not FFlagLuaAppCompositionHome then nil else CompositionTags.ContentRegion.Header else nil
			}
		}, {
			StatusBarBackground = if not FFlagAppIaStatusBar then nil else React.createElement(if not v36 then View else "Frame", {
				ZIndex = 2,
				BackgroundColor3 = if not v36 then nil else v55.LuaApps.App.Page.BackgroundColor,
				BorderSizePixel = if not v36 then nil else 0,
				backgroundStyle = if v36 then nil else {
					Transparency = 0,
					Color3 = v55.LuaApps.App.Page.BackgroundColor
				},
				Size = UDim2.new(1, 0, 0, v58)
			}),
			HeaderBackground = if not v38 then nil else React.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 0,
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = v55.LuaApps.App.Page.BackgroundColor,
				Position = v68,
				Size = UDim2.new(1, 0, 0, u60)
			}),
			Header = React.createElement(if not v36 then View else "Frame", {
				AutomaticSize = if v38 or not v36 then nil else Enum.AutomaticSize.Y,
				BackgroundColor3 = if not v36 then nil else v55.LuaApps.App.Page.BackgroundColor,
				BackgroundTransparency = if not v38 then nil else 1,
				BorderSizePixel = if not v36 then nil else 0,
				Size = if not v38 then if not v36 then nil else UDim2.fromScale(1, 0) else UDim2.new(1, 0, 0, u60),
				[React.Change.AbsoluteSize] = if v38 or (not v36 or not FFlagAppIaScrollAway) then nil else v62,
				[React.Tag] = if not v36 or (not FFlagLuaAppCompositionHomeHeaderFullBleed or not FFlagLuaAppCompositionHome) then nil else CompositionTags.ContentRegion.Header,
				tag = if v36 then nil else (not FFlagLuaAppCompositionHomeHeaderFullBleed or not FFlagLuaAppCompositionHome) and "col size-full-0 auto-y" or `col size-full-0 auto-y { CompositionTags.ContentRegion.Header }`,
				backgroundStyle = if v36 then nil else {
					Transparency = 0,
					Color3 = v55.LuaApps.App.Page.BackgroundColor
				},
				onAbsoluteSizeChanged = if v36 or not FFlagAppIaScrollAway then nil else v62
			}, {
				UIListLayout = if v38 or not v36 then nil else React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				AppHeaderBar = React.createElement(if not v36 then View else "Frame", {
					LayoutOrder = 1,
					AutomaticSize = if v38 or not v36 then nil else Enum.AutomaticSize.Y,
					BackgroundTransparency = if not v36 then nil else 1,
					Position = if not v38 then nil else UDim2.fromScale(0, 0),
					Size = if not v38 then if not v36 then nil else UDim2.fromScale(1, 0) else UDim2.new(1, 0, 0, v59),
					tag = if v36 then nil else "size-full-0 auto-y"
				}, {
					PersonalizationTopBar = React.createElement(PersonalizationTopBar, {
						sideMarginOverride = if not FFlagLuaAppCompositionHome then nil else 0
					})
				}),
				SubTabs = React.createElement(if not v36 then View else "Frame", {
					AutomaticSize = if not v36 then nil else Enum.AutomaticSize.Y,
					BackgroundTransparency = if not v36 then nil else 1,
					Position = if not v38 then nil else v66,
					Size = if not v36 then nil else UDim2.fromScale(1, 0),
					tag = if v36 then nil else "size-full-0 auto-y",
					LayoutOrder = 2,
					ref = if not v38 then nil else v65,
					[React.Change.AbsoluteSize] = if not v38 then nil else v65
				}, {
					UIPadding = if FFlagLuaAppCompositionHome then nil else React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v57),
						PaddingRight = UDim.new(0, v57)
					}),
					Tabs = React.createElement(Tabs, {
						activeTabId = routeName,
						onActivated = v53,
						tabs = v54,
						size = InputSize.Medium,
						fillBehavior = v56
					})
				})
			})
		}),
		HomeSubTabNavigator = React.createElement(v40, {
			navigation = t1.navigation,
			screenProps = if not FFlagAppIaScrollAway then nil else {
				headerHeight = u60,
				headerHeightBinding = if not FFlagLuaAppChartsStickyHeader then nil else v63,
				scrollAwayHeight = if not v38 then nil else v67,
				subTabsBottomBinding = if not v38 then nil else v68
			}
		})
	})
end)

v43.router = v40.router

return v43
