local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local getTestId = require(CorePackages.Workspace.Packages.RoactUtils).getTestId
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local AppNotificationService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppNotificationService
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local OmniFeedPageSection = require(CorePackages.Workspace.Packages.DiscoveryTypes).OmniFeedConstants.OmniFeedPageSection
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Divider = Foundation.Divider
local EnumsOrientation = Foundation.Enums.Orientation
local ServerDrivenUi = require(CorePackages.Workspace.Packages.ServerDrivenUi)
local useCollectionLayoutConfig = require(CorePackages.Workspace.Packages.CollectionViews).useCollectionLayoutConfig
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local PersonalizationTopBar = require(Modules.Personalization.PersonalizationTopBar)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local GamesOmniFeed = require(Modules.Personalization.Games.GamesOmniFeed)
local useLogSduiChartsExposure = require(Modules.Personalization.Games.useLogSduiChartsExposure)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local OmniFeedView = require(Modules.Personalization.OmniFeed.FeedViews.OmniFeedView)
local FlyoutSidePanelIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).FlyoutSidePanelIXP
local Sources = require(CorePackages.Workspace.Packages.SocialLuaAnalytics).Analytics.Enums.Sources
local CompositionTags = require(CorePackages.Workspace.Packages.AppComposition).CompositionTags
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local FFlagLuaAppEnableChartsPageProfileLink = SharedFlags.FFlagLuaAppEnableChartsPageProfileLink
local FFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow
local FFlagLuaAppChartsStickyHeader = SharedFlags.FFlagLuaAppChartsStickyHeader
local FFlagLuaAppCompositionCharts = SharedFlags.FFlagLuaAppCompositionCharts
local FFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local FFlagLuaAppChartsResetFetchingStatusOnFilterChange = SharedFlags.FFlagLuaAppChartsResetFetchingStatusOnFilterChange
local FFlagLuaAppLogChartsAppPageExposure = SharedFlags.FFlagLuaAppLogChartsAppPageExposure
local v40 = if not FFlagLuaAppChartsStickyHeader then nil else AppPage.Games
local v41 = if not FFlagLuaAppChartsStickyHeader then nil else "HEADER_GAMESFEEDITEM_IMPRESSIONS"
local v42 = if not FFlagLuaAppChartsStickyHeader then nil else {}
local useTTINavigationTracking = require(CorePackages.Workspace.Packages.TTINavigationTracking).useTTINavigationTracking

local function v44(t1: {[any]: any}) -- line: 63
	-- upvalues: FFlagLuaAppLogChartsAppPageExposure (copy), useLogSduiChartsExposure (copy), SharedFlags (copy), useTTINavigationTracking (copy), useAppPolicy (copy), FFlagLuaAppEnableChartsPageProfileLink (copy), useLocalization (copy), useRoactService (copy), AppNotificationService (copy), useSelector (copy), useStyle (copy), FFlagLuaAppChartsStickyHeader (copy), useTokens (copy), FFlagAppIaScrollAway (copy), React (copy), FFlagLuaAppChartsResetFetchingStatusOnFilterChange (copy), RetrievalStatus (copy), v40 (copy), v42 (copy), OmniFeedPageSection (copy), FFlagLuaAppLayoutParamsInContext (copy), useCollectionLayoutConfig (copy), ServerDrivenUi (copy), FFlagAppIaHomeSubTab (copy), FlyoutSidePanelIXP (copy), AppNavBar (copy), VisibilityControl (copy), GamesOmniFeed (copy), PersonalizationTopBar (copy), FFlagLuaAppCompositionCharts (copy), CompositionTags (copy), Sources (copy), Divider (copy), EnumsOrientation (copy), OmniFeedView (copy), v41 (copy), TopBar (copy), FFlagLuaAppAddTestIdsForArrow (copy), getTestId (copy)
	if FFlagLuaAppLogChartsAppPageExposure then
		useLogSduiChartsExposure()
	end

	if SharedFlags.FFlagLuaAppNavigationTTITracking then
		useTTINavigationTracking("NavigateTo_Games")
	end

	local v46 = useAppPolicy(function(p1) -- line: 72
		return p1.getGamesPageCreationCenterTitle()
	end)
	local v47 = if not FFlagLuaAppEnableChartsPageProfileLink then nil else useAppPolicy(function(p2) -- line: 79
		return p2.useGridPageLayout()
	end)
	local v48 = useLocalization({
		creationCenter = "CommonUI.Features.Label.CreationCenter",
		chartsTitle = "CommonUI.Features.Label.Charts"
	})
	local creationCenter = v48.creationCenter
	local v50 = useRoactService(AppNotificationService)
	local v51 = useSelector(function(p3) -- line: 91
		return p3.Startup.GamesPageDataStatus
	end)
	local Theme = useStyle().Theme
	local BackgroundDefaultColor = Theme.BackgroundDefault.Color
	local BackgroundDefaultTransparency = Theme.BackgroundDefault.Transparency
	local v55 = if not FFlagLuaAppChartsStickyHeader then nil else useTokens()
	local v56 = if not FFlagLuaAppChartsStickyHeader and not FFlagAppIaScrollAway then nil else useSelector(function(p4) -- line: 102
		return p4.TopBar.topBarHeight
	end)

	React.useEffect(function() -- line: 107
		-- upvalues: FFlagLuaAppChartsResetFetchingStatusOnFilterChange (copy), v51 (copy), RetrievalStatus (copy), v50 (copy)
		if ((if not FFlagLuaAppChartsResetFetchingStatusOnFilterChange then v51 else v51.status)) == RetrievalStatus.Done then
			v50:ActionEnabled(Enum.AppShellActionType.GamePageLoaded)
		end
	end, {
		if not FFlagLuaAppChartsResetFetchingStatusOnFilterChange then v51 else v51.status,
		v50
	})

	local v57 = if not v46 then v48.chartsTitle else creationCenter
	local v58 = nil
	local v59 = nil
	local u60 = nil
	local v61 = nil
	local v62 = nil
	local u63 = nil
	local v64 = nil

	if FFlagLuaAppChartsStickyHeader then
		local v65 = useSelector(function(p5) -- line: 134
			-- upvalues: v40 (copy)
			return p5.Personalization.OrderedOmniItems[v40]
		end)

		v58 = v65 and v65.allItems or v42
		v59 = v58 and (#v58 > 0 and v58[1].pageSection == OmniFeedPageSection.Header)

		local v66

		v66, v61 = React.useState(nil)
		u60 = v66

		local v67

		v62, v67 = React.useState(0)
		u63 = v67
		React.useEffect(function() -- line: 145
			-- upvalues: u60 (ref), u63 (ref)
			if not u60 then
				return
			end

			u63(u60.AbsoluteSize.Y)

			local connection = u60:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 151
				-- upvalues: u63 (ref), u60 (ref)
				u63(u60.AbsoluteSize.Y)
			end)

			return function() -- line: 155
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, { u60 })

		local v68 = if not FFlagLuaAppLayoutParamsInContext then nil else useCollectionLayoutConfig(u60)

		v64 = ServerDrivenUi.useSduiContextFromRoduxAndProcessConfigs(v40, if not FFlagLuaAppLayoutParamsInContext then nil else v68, `{ v40 }_Header`)
	end

	local v69 = if not FFlagAppIaHomeSubTab or (not FlyoutSidePanelIXP.isHomeSubTabEnabled() or not FFlagAppIaScrollAway) then if not AppNavBar.getScrollAwayEnabled() then nil else v56 else if not t1.screenProps then nil else t1.screenProps.headerHeight
	local v70 = if not FFlagLuaAppChartsStickyHeader then nil else React.useMemo(function() -- line: 177
		-- upvalues: t1 (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), VisibilityControl (copy), v56 (copy)
		if t1.screenProps and t1.screenProps.headerHeightBinding then
			return t1.screenProps.headerHeightBinding:map(function(p6) -- line: 180
				return UDim2.fromOffset(0, p6)
			end)
		end

		if FFlagAppIaScrollAway and AppNavBar.getScrollAwayEnabled() then
			return VisibilityControl.getHeaderBinding():map(function(n1: number) -- line: 185
				-- upvalues: v56 (copy)
				local v82 = n1 * v56

				return UDim2.fromOffset(0, v82)
			end)
		end

		return UDim2.fromOffset(0, v56)
	end, {
		t1.screenProps and t1.screenProps.headerHeightBinding,
		v56
	})
	local v71 = if not FFlagAppIaScrollAway then React.createElement(GamesOmniFeed, if not FFlagLuaAppChartsStickyHeader then nil else {
		topPadding = if not v59 then nil else v55.Gap.Medium
	}) else React.createElement(GamesOmniFeed, {
		canvasTopPadding = if not FFlagLuaAppChartsStickyHeader then v69 else (v69 or 0) + v62,
		topPadding = if not FFlagLuaAppChartsStickyHeader or not v59 then nil else v55.Gap.Medium
	})
	local t2 = {
		TopBar = if not FFlagAppIaHomeSubTab or not FlyoutSidePanelIXP.isHomeSubTabEnabled() then React.createElement(PersonalizationTopBar, {
			tag = if not FFlagLuaAppCompositionCharts then nil else CompositionTags.ContentRegion.Header,
			titleText = v57,
			useGridPageLayout = if not FFlagLuaAppEnableChartsPageProfileLink then nil else v47,
			profileSource = if not FFlagLuaAppEnableChartsPageProfileLink then nil else Sources.ChartsPageSelfWidget,
			sideMarginOverride = if not FFlagLuaAppCompositionCharts then nil else 0,
			zIndexOverride = if not FFlagLuaAppChartsStickyHeader then nil else 3
		}) else nil,
		HeaderContent = if not FFlagLuaAppChartsStickyHeader or not v59 then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			ref = v61,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = v70
		}, {
			Divider = if not FFlagLuaAppCompositionCharts then React.createElement(Divider, {
				ZIndex = 2,
				orientation = EnumsOrientation.Horizontal,
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1)
			}) else React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.fromScale(0.5, 1),
				AnchorPoint = Vector2.new(0.5, 1),
				ZIndex = 2,
				[React.Tag] = CompositionTags.ContentRegion.Header
			}, {
				Line = React.createElement(Divider, {
					orientation = EnumsOrientation.Horizontal
				})
			}),
			OmniFeedView = React.createElement(OmniFeedView, {
				analyticsContext = "GamesOmniFeed",
				pageContext = v40,
				omniFeedPageSection = OmniFeedPageSection.Header,
				omniFeedItems = v58,
				impressionsTag = v41,
				sduiContext = v64,
				topPadding = v55.Gap.Medium,
				bottomPadding = v55.Gap.Medium,
				appCompositionEnabled = not not FFlagLuaAppCompositionCharts or nil,
				contentTag = if not FFlagLuaAppCompositionCharts then nil else CompositionTags.ContentRegion.Header
			})
		}),
		Content = React.createElement(if not FFlagAppIaHomeSubTab or not FlyoutSidePanelIXP.isHomeSubTabEnabled() then TopBar.PageContent else TopBar.PageWrapper, {
			BackgroundColor3 = BackgroundDefaultColor,
			BackgroundTransparency = BackgroundDefaultTransparency,
			ZIndex = if not FFlagLuaAppChartsStickyHeader then nil else 1
		}, {
			GamesOmniFeed = v71
		})
	}

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = BackgroundDefaultColor,
		BackgroundTransparency = BackgroundDefaultTransparency,
		BorderSizePixel = 0,
		[React.Tag] = if not FFlagLuaAppAddTestIdsForArrow then nil else getTestId("page-discover")
	}, t2)
end

return function(t3: {[any]: any}) -- line: 292
	-- upvalues: React (copy), v44 (copy)
	return React.createElement(v44, t3)
end
