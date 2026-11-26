local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egx")
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local module2 = require("@luauforge/bundled/dPU")
local module3 = require("@luauforge/deferred/gRU")
local module4 = require("@luauforge/bundled/dVl")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local module6 = require("@luauforge/deferred/gLn")
local withStyle = UIBlox.Style.withStyle
require("@luauforge/bundled/dKT")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local module11 = require("@luauforge/bundled/gZJ")
local module12 = require("@luauforge/bundled/dPR")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2
local flushDeferredWidgetLoaded = AvatarExperienceAnalytics.flushDeferredWidgetLoaded

local fFlagAXLegacyIXPExposureLogging = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXLegacyIXPExposureLogging

local fFlagAXScrollTelemetryIntegration2 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXScrollTelemetryIntegration2

local module14 = require("@luauforge/deferred/hfL")
local module15 = require("@luauforge/bundled/hae")
local module16 = require("@luauforge/bundled/fwS")
local module17 = require("@luauforge/bundled/fwR")
local module18 = require("@luauforge/bundled/fAf")
local module19 = require("@luauforge/bundled/gZE")
local module20 = require("@luauforge/bundled/fAe")
local module21 = require("@luauforge/bundled/fCI")
local module22 = require("@luauforge/bundled/fIl")
local module23 = require("@luauforge/bundled/dWd")
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal

local module24 = require("@luauforge/bundled/gZQ")
local module25 = require("@luauforge/bundled/gZZ")
local module26 = require("@luauforge/deferred/gLl")
local module27 = require("@luauforge/deferred/gQx")
local module28 = require("@luauforge/bundled/fDf")
local module29 = require("@luauforge/bundled/dPN")
local getAXMarketplaceWidgetStore = AvatarExperienceCatalog.Stores.getAXMarketplaceWidgetStore
local module30 = require("@luauforge/bundled/dPN")
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers

local module31 = require("@luauforge/deferred/hgO")
local module32 = require("@luauforge/bundled/dWq")
local extended = Roact.PureComponent:extend("NavigationItemsView")
local module33 = require("@luauforge/bundled/fJs")
local fFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local axPrefetchMarketplaceIXP = module11.AXPrefetchMarketplaceIXP
local ixpServiceWrapper = require("@luauforge/bundled/fwW").IXPServiceWrapper

local module34 = require("@luauforge/bundled/gZB")

local module35 = require("@luauforge/bundled/haf")

local module36 = require("@luauforge/deferred/hgP")

local module37 = require("@luauforge/bundled/hag")

local module38 = require("@luauforge/deferred/hgQ")

local module39 = require("@luauforge/deferred/hgR")
local sduiWidgetTTITileLatencyContext = require("@luauforge/bundled/dTf").Context.SduiWidgetTTITileLatencyContext

local module40 = require("@luauforge/bundled/gZG")

local fFlagAXUnifiedMarketplaceResultsFetcher = AvatarExperienceFlags.FFlagAXUnifiedMarketplaceResultsFetcher
local fFlagAXSkipLegacyCatalogFetchWhenSduiServed = AvatarExperienceFlags.FFlagAXSkipLegacyCatalogFetchWhenSduiServed
local fFlagAXPrefetchOnlyWithinTTL = AvatarExperienceFlags.FFlagAXPrefetchOnlyWithinTTL
local fIntAXPrefetchTTL = AvatarExperienceFlags.FIntAXPrefetchTTL
local axRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local axCatalogRealTimeRecommendationsIXP = module11.AXCatalogRealTimeRecommendationsIXP
local defineFastInt = game:DefineFastInt("AXCatalogExitReEnterRefreshInterval", 60)

local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXPassScreenSizeToWidgetApi = AvatarExperienceFlags.FFlagAXPassScreenSizeToWidgetApi
local fFlagAXMarketplaceBreakpointEstimateFix = AvatarExperienceFlags.FFlagAXMarketplaceBreakpointEstimateFix

local fFlagAXDeferWidgetLoadedUntilMarketplaceEntered = AvatarExperienceFlags.FFlagAXDeferWidgetLoadedUntilMarketplaceEntered
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXSduiWidgetsTTITracking = AvatarExperienceFlags.FFlagAXSduiWidgetsTTITracking
local fFlagAXCatalogSpecialFeaturesFilter = AvatarExperienceFlags.FFlagAXCatalogSpecialFeaturesFilter
local userIsInExperiment = AvatarExperienceFlags.FFlagsAXPrefetchMarketplaceThumbnailsXP.UserIsInExperiment
local module41 = require("@luauforge/bundled/gLF")
local ttiPerformanceManager = module41.TTIPerformanceManager
local organicTTIMilestoneManager = module41.OrganicTTIMilestoneManager

local module42 = require("@luauforge/bundled/dSW")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module43 = require("@luauforge/bundled/hah")

local getShouldPageUseWidgetOnlyFetcher = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Utils.getShouldPageUseWidgetOnlyFetcher

local v5 = {
	[avatarScreen.AvatarEditor] = true,
	[avatarScreen.ProfilePictureEditorEmotes] = true,
	[avatarScreen.MySharedAvatars] = true,
	[avatarScreen.SearchLandingFocusedWidgetPage] = axRecentlyViewedSearchItemsIXPTest.isEnabled() and true or nil
}

local strictInterface = t.strictInterface
local v6 = {}
v6.defaultChildRef = t.optional(t.table)
v6.defaultFocusRef = t.optional(t.callback)
v6.NextSelectionUp = t.optional(t.table)
v6.NextSelectionRight = t.optional(t.table)
v6.multiTryOnBottomBarRef = t.optional(t.table)
v6.itemDetailsPeekViewRefs = t.table

v6.categoryId = t.string
v6.subcategoryId = t.optional(t.string)
v6.minPrice = t.number
v6.maxPrice = t.number
v6.selectedTopics = t.optional(t.table)
v6.catalogSort = t.string
v6.catalogSortAggregation = t.string
v6.searchParameters = t.optional(t.table)
v6.searchTime = t.optional(t.number)
v6.searchUuid = t.string
v6.categoryInfo = t.table
v6.creatorFilter = t.string
v6.salesTypeFilter = t.string
v6.unavailableItemFilter = t.string
v6.wearTimeFilter = t.optional(t.string)
local v7 = if fFlagAXCatalogSpecialFeaturesFilter then t.optional(t.table) else nil
v6.specialFeaturesFilter = v7
v6.widgetFetchTime = t.optional(t.number)
local v8 = if module33 then t.table else nil
v6.externalNavigationRequest = v8

local v9 = if axPrefetchMarketplaceIXP.isEnabled() then t.optional(t.boolean) else nil
v6.isRecentMarketplaceUser = v9
local v10 = if fFlagAXPassScreenSizeToWidgetApi then t.string else nil
v6.screenSize = v10
local v11 = if fFlagAXPassScreenSizeToWidgetApi then t.number else nil
v6.filterCount = v11

v6.setSearchType = t.callback
v6.setSearchParameters = t.callback
v6.dispatchSearch = t.callback
v6.fetchWidgetInfo = t.callback
v6.dispatchRemoveSearch = t.callback
v6.clearSelectedTopics = t.callback
v6.resetSortAndFilters = t.callback
v6.dispatchCatalogTilesLatencyStartTracker = t.callback

v6.pageObjectManager = t.optional(t.table)
v6.avatarRoute = avatarRoute.Interface
v6.namedRefs = t.table

v6.networking = t.callback
v6.catalogAnalytics = t.table

local v12 = if axPrefetchMarketplaceIXP.isEnabled() or fFlagAXUnifiedMarketplaceResultsFetcher then t.optional(t.boolean) else nil
v6.hasPrefetchedMarketplace = v12

local v13 = if axPrefetchMarketplaceIXP.isEnabled() or fFlagAXUnifiedMarketplaceResultsFetcher then t.optional(t.boolean) else nil
v6.isPrefetchingMarketplace = v13

local v14 = if axPrefetchMarketplaceIXP.isEnabled() or fFlagAXUnifiedMarketplaceResultsFetcher then t.optional(t.callback) else nil
v6.fetchMarketplace = v14

local v15 = if fFlagAXPrefetchOnlyWithinTTL then t.optional(t.number) else nil
v6.fetchedMarketplaceTimestamp = v15

local v16 = if fFlagAXMigrateAllTabToSduiDev then t.optional(t.boolean) else nil
v6.resultsAreSduiEnabled = v16
extended.validateProps = strictInterface(v6)

local function isCatalogPage(p2): boolean
	return p2.avatarRoute.opaque.name == avatarScreen.Catalog
end

local function isCatalogSearchPage(p2): boolean
	return p2.avatarRoute.opaque.name == avatarScreen.CatalogSearch
end

local fn = axCatalogRealTimeRecommendationsIXP.isEnabled() and function(p2): boolean
	if p2.avatarRoute.opaque.name ~= avatarScreen.Catalog then
		return false
	end

	local categoryInfo = p2.categoryInfo

	if categoryInfo then
		return categoryInfo.Id == module30.DefaultCatalogCategoryId
	end

	return false
end or nil

function extended:init()
	self.itemsListRef = self.props.namedRefs[avatarScreen.Catalog .. module6.ItemsList]
	self.scrollingFrameRef = Roact.createRef()
	self.navBarRef = Roact.createRef()
	self.backToTopSignal = signal.new()

	local v18 = if axPrefetchMarketplaceIXP.isEnabled() then self.props.isInitialPrefetch else nil
	local v19 = if axCatalogRealTimeRecommendationsIXP.isEnabled() then false else nil
	self:setState({
		restorePreviousChildFocus = true,
		isInitialPrefetch = v18,
		hasEnteredAvatarExperience = v19
	})

	if axCatalogRealTimeRecommendationsIXP.isEnabled() or fFlagAXMigrateAllTabToSduiDev then
		self.lastMarketplaceFetchTime = 0
	end

	if fFlagAXMarketplaceBreakpointEstimateFix then
		self.lastConsumedEstimateWriteId = getAXMarketplaceWidgetStore(false).getEstimateWriteId()
	end

	function self.dispatchInitialSearch()
		local dispatchSearch = self.props.dispatchSearch
		local setSearchParameters = self.props.setSearchParameters
		local categoryInfo = self.props.categoryInfo
		local searchUuid = self.props.searchUuid
		self.props.setSearchType(searchUuid, RobloxAppEnums.SearchTypes.Catalog)

		setSearchParameters(
			searchUuid,
			categoryInfo,
			self.props.catalogSort,
			self.props.catalogSortAggregation,
			self.props.minPrice,
			self.props.maxPrice,
			self.props.selectedTopics
		)

		return dispatchSearch(self.props.networking, searchUuid, categoryInfo)
	end

	function self.fetchWidgetInfo(p2, p3)
		local v20 = if p2 then module4.getContextForWidgetsById(self.props.avatarRoute.opaque.name, p2, p3) else nil

		return self.props.fetchWidgetInfo(self.props.networking, nil, v20)
	end

	if fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev then
		function self.initialSearch()
			if fFlagAXUnifiedMarketplaceResultsFetcher then
				self.props.fetchMarketplace()

				if axCatalogRealTimeRecommendationsIXP.isEnabled() or fFlagAXMigrateAllTabToSduiDev then
					self.lastMarketplaceFetchTime = os.time()
				end
			else
				self.dispatchInitialSearch()
			end
		end

		function self.retrySearch()
			if fFlagAXUnifiedMarketplaceResultsFetcher then
				self.props.fetchMarketplace(self.props.resultsAreSduiEnabled and {
					forceRefresh = true
				} or nil)

				if axCatalogRealTimeRecommendationsIXP.isEnabled() or fFlagAXMigrateAllTabToSduiDev then
					self.lastMarketplaceFetchTime = os.time()
				end
			else
				self.dispatchInitialSearch()
			end
		end
	end
end

if axPrefetchMarketplaceIXP.isEnabled() then
	function extended:hasPrefetchedMarketplace(): boolean
		local testVariable = module12.readTestVariable(axPrefetchMarketplaceIXP.EnabledForUser)
		local testVariable2 = module12.readTestVariable(axPrefetchMarketplaceIXP.UserIsInExperiment)

		if not self.props.isRecentMarketplaceUser then
			return false
		end

		sendAXCounterV2(module29.Counter.PrefetchMarketplace.enteredMarketplaceAndIsRecentUser)

		if not testVariable2 then
			return false
		end

		local v17 = not (fFlagAXPrefetchOnlyWithinTTL and self.props.fetchedMarketplaceTimestamp)
			or os.time() - self.props.fetchedMarketplaceTimestamp <= fIntAXPrefetchTTL

		if not v17 then
			return false
		end

		sendAXCounterV2(module29.Counter.PrefetchMarketplace.inExperimentAndIsRecentUserAndEnteredMarketplace)

		if fFlagAXLegacyIXPExposureLogging then
			if
				axPrefetchMarketplaceIXP.logExposureEnabled
				and axPrefetchMarketplaceIXP.logExposureEnabled()
			then
				module12.logExperimentExposure(axPrefetchMarketplaceIXP)
			end

			if userIsInExperiment then
				ixpServiceWrapper:LogFlagLinkedUserLayerExposure(appUserLayers.AvatarExperienceUAPerformance)
				sendAXCounterV2(module29.Counter.PrefetchMarketplace.inExperimentAndIsRecentUserAndEnteredMarketplaceThumbnails)
			end
		else
			module12.logExperimentExposure(axPrefetchMarketplaceIXP)
		end

		if testVariable and v17 then
			ttiPerformanceManager.Surface.Marketplace.Root.startTracking()
			self.props.dispatchCatalogTilesLatencyStartTracker(self.props.searchUuid)

			if axCatalogRealTimeRecommendationsIXP.isEnabled() or fFlagAXMigrateAllTabToSduiDev then
				self.lastMarketplaceFetchTime = os.time()
			end

			self:setState({ isInitialPrefetch = true })

			return true
		end

		return false
	end
end

function extended:didMount()
	if fFlagAXDeferWidgetLoadedUntilMarketplaceEntered then
		flushDeferredWidgetLoaded()
	end

	if axPrefetchMarketplaceIXP.isEnabled() and self:hasPrefetchedMarketplace() then
		return
	end

	if fFlagAXUnifiedMarketplaceResultsFetcher then
		self.props.fetchMarketplace()

		if axCatalogRealTimeRecommendationsIXP.isEnabled() or fFlagAXMigrateAllTabToSduiDev then
			self.lastMarketplaceFetchTime = os.time()
		end
	else
		self.dispatchInitialSearch()

		self.fetchWidgetInfo(self.props.categoryId, self.props.subcategoryId)
	end
end

function extended:searchResultsAreOld(p3, p4, p5): boolean
	local searchTime = if p5 then p5.searchTime else self.props.searchTime

	if p4.TimeToRefresh and p4.TimeToRefresh >= 0 and searchTime then
		return tick() - searchTime > p4.TimeToRefresh
	end

	return false
end

function extended:updateSearchParams(data)
	local categoryInfo = data.categoryInfo
	local searchUuid = data.searchUuid

	local dispatchSearch = self.props.dispatchSearch
	local setSearchParameters = self.props.setSearchParameters
	local fetchWidgetInfo = self.fetchWidgetInfo

	local v17 = data.categoryId ~= self.props.categoryId or data.subcategoryId ~= self.props.subcategoryId

	local v18 = data.wearTimeFilter ~= self.props.wearTimeFilter
	local v19

	if fFlagAXCatalogSpecialFeaturesFilter then
		v19 = data.specialFeaturesFilter ~= self.props.specialFeaturesFilter
	else
		v19 = false
	end

	if
		v17
		or data.catalogSort ~= self.props.catalogSort
		or data.catalogSortAggregation ~= self.props.catalogSortAggregation
		or data.minPrice ~= self.props.minPrice
		or data.maxPrice ~= self.props.maxPrice
		or data.selectedTopics ~= self.props.selectedTopics
		or data.creatorFilter ~= self.props.creatorFilter
		or data.salesTypeFilter ~= self.props.salesTypeFilter
		or data.unavailableItemFilter ~= self.props.unavailableItemFilter
		or v18
		or v19
	then
		if v17 then
			self.props.clearSelectedTopics()

			local searchParameter = self.props.searchParameters[searchUuid]

			if searchParameter == nil then
				local catalogSort = data.catalogSort
				local catalogSortAggregation = data.catalogSortAggregation
				local minPrice = data.minPrice
				local maxPrice = data.maxPrice
				local selectedTopics = data.selectedTopics
				local creatorFilter = data.creatorFilter
				local salesTypeFilter = data.salesTypeFilter
				local unavailableItemFilter = data.unavailableItemFilter
				local wearTimeFilter = data.wearTimeFilter

				local v20 = if fFlagAXCatalogSpecialFeaturesFilter then data.specialFeaturesFilter else nil
				setSearchParameters(
					searchUuid,
					categoryInfo,
					catalogSort,
					catalogSortAggregation,
					minPrice,
					maxPrice,
					selectedTopics,
					creatorFilter,
					salesTypeFilter,
					unavailableItemFilter,
					wearTimeFilter,
					v20
				)

				ttiPerformanceManager.Surface.Marketplace.Root.startTracking()

				if not (self.props.resultsAreSduiEnabled and fFlagAXSduiWidgetsTTITracking) then
					organicTTIMilestoneManager.L2.primaryDataStarted()
					organicTTIMilestoneManager.L3.networkFetch()
				end

				self.props.dispatchCatalogTilesLatencyStartTracker(searchUuid)

				if not (fFlagAXSkipLegacyCatalogFetchWhenSduiServed and data.resultsAreSduiEnabled) then
					dispatchSearch(self.props.networking, searchUuid, categoryInfo)

					fetchWidgetInfo(data.categoryId, data.subcategoryId)
				end
			else
				local v20 = self:searchResultsAreOld(searchUuid, categoryInfo, data)
					or (searchParameter.catalogSort and searchParameter.catalogSort ~= data.catalogSort or searchParameter.catalogSortAggregation and searchParameter.catalogSortAggregation ~= data.catalogSortAggregation or searchParameter.minPrice and searchParameter.minPrice ~= data.minPrice or searchParameter.maxPrice and searchParameter.maxPrice ~= data.maxPrice or searchParameter.selectedTopics and searchParameter.selectedTopics ~= data.selectedTopics or searchParameter.creatorFilter and searchParameter.creatorFilter ~= data.creatorFilter or searchParameter.salesTypeFilter and searchParameter.salesTypeFilter ~= data.salesTypeFilter)
					and true
					or searchParameter.unavailableItemFilter
					and searchParameter.unavailableItemFilter ~= data.unavailableItemFilter

				v20 = fFlagAXCatalogSpecialFeaturesFilter
					and table.concat(searchParameter.specialFeaturesFilter or {}, ",") ~= table.concat(data.specialFeaturesFilter or {}, ",")
					and true
					or v20
				local v21

				if fFlagAXPassScreenSizeToWidgetApi then
					v21 = getShouldPageUseWidgetOnlyFetcher(
						data.categoryInfo,
						data.filterCount,
						searchParameter and searchParameter.searchKeyword
					)
				end

				if fFlagAXPassScreenSizeToWidgetApi and v21 then
					v20 = false
				end

				if v20 then
					if self:searchResultsAreOld(searchUuid, categoryInfo, data) then
						self.props.catalogAnalytics.sendAXCounter(module29.Counter.CatalogRefresh.StaleResults)
					end

					self.props.pageObjectManager:storePageObject(searchUuid, nil)
					self.props.dispatchRemoveSearch(searchUuid)

					ttiPerformanceManager.Surface.Marketplace.Root.startTracking()

					if not (self.props.resultsAreSduiEnabled and fFlagAXSduiWidgetsTTITracking) then
						organicTTIMilestoneManager.L2.primaryDataStarted()
						organicTTIMilestoneManager.L3.networkFetch()
					end

					self.props.dispatchCatalogTilesLatencyStartTracker(searchUuid)

					local catalogSort = data.catalogSort
					local catalogSortAggregation = data.catalogSortAggregation
					local minPrice = data.minPrice
					local maxPrice = data.maxPrice
					local selectedTopics = data.selectedTopics
					local creatorFilter = data.creatorFilter
					local salesTypeFilter = data.salesTypeFilter
					local unavailableItemFilter = data.unavailableItemFilter
					local wearTimeFilter = data.wearTimeFilter

					local v22 = if fFlagAXCatalogSpecialFeaturesFilter then data.specialFeaturesFilter else nil
					setSearchParameters(
						searchUuid,
						categoryInfo,
						catalogSort,
						catalogSortAggregation,
						minPrice,
						maxPrice,
						selectedTopics,
						creatorFilter,
						salesTypeFilter,
						unavailableItemFilter,
						wearTimeFilter,
						v22
					)

					if not (fFlagAXSkipLegacyCatalogFetchWhenSduiServed and data.resultsAreSduiEnabled) then
						dispatchSearch(self.props.networking, searchUuid, categoryInfo)

						fetchWidgetInfo(data.categoryId, data.subcategoryId)
					end
				end
			end
		else
			self.props.pageObjectManager:storePageObject(searchUuid, nil)
			self.props.dispatchRemoveSearch(searchUuid)

			local catalogSort = data.catalogSort
			local catalogSortAggregation = data.catalogSortAggregation
			local minPrice = data.minPrice
			local maxPrice = data.maxPrice
			local selectedTopics = data.selectedTopics
			local creatorFilter = data.creatorFilter
			local salesTypeFilter = data.salesTypeFilter
			local unavailableItemFilter = data.unavailableItemFilter
			local wearTimeFilter = data.wearTimeFilter

			local v20 = if fFlagAXCatalogSpecialFeaturesFilter then data.specialFeaturesFilter else nil
			setSearchParameters(
				searchUuid,
				categoryInfo,
				catalogSort,
				catalogSortAggregation,
				minPrice,
				maxPrice,
				selectedTopics,
				creatorFilter,
				salesTypeFilter,
				unavailableItemFilter,
				wearTimeFilter,
				v20
			)

			dispatchSearch(self.props.networking, searchUuid, categoryInfo)
		end

		if self.scrollingFrameRef.current then
			self.scrollingFrameRef.current.CanvasPosition = Vector2.new()
		end
	end
end

function extended:willUpdate(p2)
	if
		self.props.avatarRoute.opaque.name == avatarScreen.Catalog
		and p2.avatarRoute.opaque.name ~= avatarScreen.Catalog
	then
		self.props.clearSelectedTopics()
		self.props.resetSortAndFilters()
	end

	if
		self.props.avatarRoute.opaque.name ~= avatarScreen.Catalog
		and p2.avatarRoute.opaque.name == avatarScreen.Catalog
	then
		self.props.clearSelectedTopics()
	end

	if module31 and p2.avatarRoute.opaque.name ~= avatarScreen.Catalog then
		return
	end

	self:updateSearchParams(p2)
end

function extended:renderWithStyle(p2)
	local theme = p2.Theme

	local defaultChildRef = self.props.defaultChildRef
	local nextSelectionUp = self.props.NextSelectionUp

	local createElement = Roact.createElement
	local frame = focusable.Frame
	local defaultChildRefsByRef = {
		BackgroundTransparency = theme.BackgroundDefault.Transparency or 1,
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Ref] = defaultChildRef,
		restorePreviousChildFocus = self.state.restorePreviousChildFocus,
		defaultChild = self.navBarRef,
		NextSelectionRight = self.props.NextSelectionRight
	}
	local v17 = {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0)
		}),
		ResultsList = 0
	}

	local createElement2 = Roact.createElement
	local v19 = {
		frameRef = self.itemsListRef,
		defaultFocusRef = self.props.defaultFocusRef,
		navBarRef = self.navBarRef,
		analyticsContext = module2.AnalyticsContext.Catalog,
		fromSearch = false,
		searchUuid = self.props.searchUuid,
		layoutOrder = 2,
		scrollingFrameRef = self.scrollingFrameRef,
		onRetry = 0,
		NextSelectionUp = 0,
		backToTopSignal = 0,
		multiTryOnBottomBarRef = 0,
		itemDetailsPeekViewRefs = 0,
		scrollPerformanceIntervalName = 0
	}
	local v20

	if fFlagAXMigrateAllTabToSduiDev then
		v20 = self.retrySearch
	else
		v20 = if fFlagAXCatalogCategoriesSDUI then self.initialSearch else self.dispatchInitialSearch
	end

	v19.onRetry = v20

	v19.NextSelectionUp = nextSelectionUp
	v19.backToTopSignal = self.backToTopSignal
	v19.multiTryOnBottomBarRef = self.props.multiTryOnBottomBarRef
	v19.itemDetailsPeekViewRefs = self.props.itemDetailsPeekViewRefs

	local v21 = if fFlagAXScrollTelemetryIntegration2 then module3.Catalog else nil
	v19.scrollPerformanceIntervalName = v21
	v17.ResultsList = createElement2(module14, v19)
	return createElement(frame, defaultChildRefsByRef, v17)
end

function extended:render()
	return withStyle(function(p2)
		return self:renderWithStyle(p2)
	end)
end

if axCatalogRealTimeRecommendationsIXP.isEnabled() then
	function extended:handleExitAndReEnterAvatarExperience(p2)
		local isVisible = self.props.avatarRoute.isVisible
		local isVisible2 = p2.avatarRoute.isVisible

		if isVisible and not self.state.hasEnteredAvatarExperience then
			self:setState({ hasEnteredAvatarExperience = true })
		end

		if
			isVisible
			and not isVisible2
			and self.state.hasEnteredAvatarExperience
			and fn(self.props)
			and fFlagAXUnifiedMarketplaceResultsFetcher
			and self.props.fetchMarketplace
		then
			local now = os.time()

			if defineFastInt <= now - self.lastMarketplaceFetchTime then
				if module12.readTestVariable(axCatalogRealTimeRecommendationsIXP.UserIsInExperiment) then
					if fFlagAXLegacyIXPExposureLogging then
						if
							axCatalogRealTimeRecommendationsIXP.logExposureEnabled
							and axCatalogRealTimeRecommendationsIXP.logExposureEnabled()
						then
							module12.logExperimentExposure(axCatalogRealTimeRecommendationsIXP)
						end
					else
						module12.logExperimentExposure(axCatalogRealTimeRecommendationsIXP)
					end
				end

				sendAXCounterV2(module29.Counter.FetchMarketplace.ExitAndReEnterRefreshCounter)

				if module12.readTestVariable(axCatalogRealTimeRecommendationsIXP.EnabledForUser) then
					sendAXCounterV2(module29.Counter.FetchMarketplace.ExitAndReEnterRefreshTreatment)
					self.props.fetchMarketplace(fFlagAXMigrateAllTabToSduiDev and self.props.resultsAreSduiEnabled and {
						forceRefresh = true
					} or nil)

					self.lastMarketplaceFetchTime = now
				end
			end
		end
	end
end

function extended:fetchMarketplaceUnlessScreenSizeAlreadyRequested()
	local v17 = getAXMarketplaceWidgetStore(false)

	if v17.wasScreenSizePublishedByEstimateWrite(self.lastConsumedEstimateWriteId, self.props.screenSize) then
		self.lastConsumedEstimateWriteId = v17.getEstimateWriteId()
	else
		self.props.fetchMarketplace()
	end
end

function extended:handlePrefetchMarketplaceStatusChange(p2)
	local v17

	if axPrefetchMarketplaceIXP.isEnabled() then
		v17 = module12.readTestVariable(axPrefetchMarketplaceIXP.EnabledForUser)
	end

	local v18 = if v17 then p2.isPrefetchingMarketplace and not p2.hasPrefetchedMarketplace else nil
	local v19

	if v17 then
		v19 = not (self.props.isPrefetchingMarketplace or self.props.hasPrefetchedMarketplace)
	end

	if v17 then
		if self.props.hasPrefetchedMarketplace and self.state.isInitialPrefetch then
			sendAXCounterV2(module29.Counter.PrefetchMarketplace.inTreatmentAndHasPrefetchedMarketplace)

			self:setState({ isInitialPrefetch = false })
		end

		if v18 and v19 and self.state.isInitialPrefetch then
			sendAXCounterV2(module29.Counter.PrefetchMarketplace.enteredMarketplaceButPrefetchFailed)

			if fFlagAXSkipLegacyCatalogFetchWhenSduiServed and self.props.resultsAreSduiEnabled then
				self.retrySearch()
			else
				self.dispatchInitialSearch()
				self.fetchWidgetInfo(self.props.categoryId, self.props.subcategoryId)
			end

			self:setState({ isInitialPrefetch = false })
		end
	end
end

function extended:didUpdate(data)
	local name = self.props.avatarRoute.current.name
	local name2 = data.avatarRoute.current.name

	if name == avatarScreen.Catalog then
		if not self.state.restorePreviousChildFocus then
			self:setState({ restorePreviousChildFocus = true })
		end
	elseif v5[name] and name2 == avatarScreen.Catalog and self.state.restorePreviousChildFocus then
		self:setState({ restorePreviousChildFocus = false })
	end

	if axCatalogRealTimeRecommendationsIXP.isEnabled() then
		self:handleExitAndReEnterAvatarExperience(data)
	end

	local v17

	if fFlagAXPassScreenSizeToWidgetApi and self.props.searchParameters then
		v17 = self.props.searchParameters[self.props.searchUuid]
	end

	local v18

	if fFlagAXPassScreenSizeToWidgetApi then
		v18 = getShouldPageUseWidgetOnlyFetcher(
			self.props.categoryInfo,
			self.props.filterCount,
			v17 and v17.searchKeyword
		)
	end

	if
		fFlagAXPassScreenSizeToWidgetApi
		and self.props.screenSize
		and data.screenSize
		and self.props.screenSize ~= data.screenSize
		and v18
	then
		if fFlagAXMarketplaceBreakpointEstimateFix then
			self:fetchMarketplaceUnlessScreenSizeAlreadyRequested()
		else
			self.props.fetchMarketplace()
		end
	end

	if
		data.avatarRoute.opaque.name == avatarScreen.CatalogSearch
		and self.props.avatarRoute.opaque.name == avatarScreen.Catalog
	then
		if module33 then
			if
				self.props.externalNavigationRequest == data.externalNavigationRequest
				and not module22.catalogDeepLinkExists(self.props.externalNavigationRequest)
			then
				self.props.resetSortAndFilters()
			end
		else
			self.props.resetSortAndFilters()
		end
	end

	if
		fFlagAXMigrateAllTabToSduiDev
		and self.props.resultsAreSduiEnabled
		and self.props.fetchMarketplace
	then
		local isVisible = self.props.avatarRoute.isVisible and data.avatarRoute.isVisible
		local v19 = not data.resultsAreSduiEnabled
		local v20 = self.props.avatarRoute.opaque.name == avatarScreen.Catalog

		if v20 then
			v20 = data.avatarRoute.opaque.name ~= avatarScreen.Catalog
		end

		if isVisible and (v19 or v20) then
			local now = os.time()

			if defineFastInt <= now - (self.lastMarketplaceFetchTime or 0) then
				self.props.fetchMarketplace({ forceRefresh = true })
				self.lastMarketplaceFetchTime = now
			end
		end
	end

	local showWidgets = self.props.categoryInfo and self.props.categoryInfo.ShowWidgets
	local showWidgets2 = data.categoryInfo and data.categoryInfo.ShowWidgets

	local v20 = name == avatarScreen.Catalog and name2 == avatarScreen.AvatarExperienceLandingPage

	if showWidgets and not showWidgets2 or v20 then
		if fFlagAXPassScreenSizeToWidgetApi and v18 then
			self.props.fetchMarketplace()
		elseif not (fFlagAXSkipLegacyCatalogFetchWhenSduiServed and self.props.resultsAreSduiEnabled) then
			self.fetchWidgetInfo(self.props.categoryId, self.props.subcategoryId)
		end
	end

	self:handlePrefetchMarketplaceStatusChange(data)
end

local function mapStateToProps(data, data2)
	local categoryId = data2.categoryId
	local subcategoryId = data2.subcategoryId

	local categoryInfo = data2.categoryInfo

	local subButton = data.AvatarExperience.AvatarEditor.Categories.subButton
	local subcategoryFilter

	if fFlagAXEditorSubcategoryFilters then
		subcategoryFilter = data.AvatarExperience.AvatarEditor.Categories.subcategoryFilter
	end

	local getSearchUuidAndAssetTypes = module21.getSearchUuidAndAssetTypes

	if not fFlagAXEditorSubcategoryFilters then
		subcategoryFilter = nil
	end

	local searchUuidAndAssetTypes, v17 = getSearchUuidAndAssetTypes(
		categoryInfo,
		subButton,
		subcategoryFilter
	)
	local isRecentMarketplaceUser

	if axPrefetchMarketplaceIXP.isEnabled() then
		isRecentMarketplaceUser = data.AvatarExperience.Catalog.Metadata.isRecentMarketplaceUser
	end

	local v18 = {
		categoryInfo = categoryInfo,
		categoryId = categoryId,
		subcategoryId = subcategoryId,
		minPrice = data.AvatarExperience.Catalog.SortAndFilters.PriceRange.minPrice,
		maxPrice = data.AvatarExperience.Catalog.SortAndFilters.PriceRange.maxPrice,
		selectedTopics = 0,
		catalogSort = 0,
		catalogSortAggregation = 0,
		creatorFilter = 0,
		salesTypeFilter = 0,
		unavailableItemFilter = 0,
		wearTimeFilter = 0,
		specialFeaturesFilter = 0,
		searchParameters = 0,
		searchTime = 0,
		searchUuid = 0,
		widgetFetchTime = 0,
		externalNavigationRequest = 0,
		isRecentMarketplaceUser = 0,
		filterCount = 0
	}
	local v19 = if categoryInfo ~= nil and not not categoryInfo.ShowTopics then data.AvatarExperience.Catalog.SortAndFilters.SelectedTopics else nil
	v18.selectedTopics = v19

	v18.catalogSort = data.AvatarExperience.Catalog.SortAndFilters.CatalogSort
	v18.catalogSortAggregation = data.AvatarExperience.Catalog.SortAndFilters.CatalogSortAggregation
	v18.creatorFilter = data.AvatarExperience.Catalog.SortAndFilters.CreatorFilter
	v18.salesTypeFilter = data.AvatarExperience.Catalog.SortAndFilters.SalesTypeFilter
	v18.unavailableItemFilter = data.AvatarExperience.Catalog.SortAndFilters.UnavailableItemFilter
	v18.wearTimeFilter = data.AvatarExperience.Catalog.SortAndFilters.WearTimeFilter

	local v20 = if fFlagAXCatalogSpecialFeaturesFilter then data.AvatarExperience.Catalog.SortAndFilters.SpecialFeaturesFilter else nil
	v18.specialFeaturesFilter = v20

	v18.searchParameters = data.SearchesParameters
	local v21 = if data.SearchTimes then data.SearchTimes[searchUuidAndAssetTypes] or nil else nil
	v18.searchTime = v21
	v18.searchUuid = searchUuidAndAssetTypes
	v18.widgetFetchTime = data.AvatarExperience.Common.Widgets.WidgetInfo.FetchTime

	local v22 = if module33 then data.AvatarExperience.ExternalNavigationRequest else nil
	v18.externalNavigationRequest = v22

	v18.isRecentMarketplaceUser = isRecentMarketplaceUser
	local v23 = if fFlagAXPassScreenSizeToWidgetApi then module43(data) else nil
	v18.filterCount = v23
	return v18
end

local function mapDispatchToProps(callback)
	return {
		setSearchType = function(p2, p3)
			return callback(module17(p2, p3))
		end,
		setSearchParameters = function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13)
			return callback(module16(p2, {
				categoryInfo = p3,
				catalogSort = p4,
				catalogSortAggregation = p5,
				minPrice = p6,
				maxPrice = p7,
				selectedTopics = p8,
				creatorFilter = p9,
				salesTypeFilter = p10,
				unavailableItemFilter = p11,
				wearTimeFilter = p12,
				specialFeaturesFilter = p13
			}))
		end,
		dispatchSearch = function(p2, p3, p4)
			return callback(module24(p2, {
				searchUuid = p3,
				categoryInfo = p4,
				recordSearchTime = true
			}))
		end,
		fetchWidgetInfo = function(p2, p3, p4)
			return callback(module25(p2, p3, p4))
		end,
		dispatchRemoveSearch = function(p2)
			callback(module15(p2))
		end,
		clearSelectedTopics = function()
			callback(module23())
		end,
		resetSortAndFilters = function()
			callback(module27())
		end,
		dispatchCatalogTilesLatencyStartTracker = function(p2)
			callback(module32.StartTracking(p2))
		end
	}
end

local v17 = module26((module20((module18(
	RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended),
	module19.Consumer,
	"pageObjectManager"
)))))

local v18 = roactServices.connect({ networking = module, catalogAnalytics = module28 })(v17)

local function NavigationItemsViewWrapper(p2)
	local v19

	if axPrefetchMarketplaceIXP.isEnabled() then
		v19 = module12.readTestVariable(axPrefetchMarketplaceIXP.EnabledForUser)
	end

	local v20

	if axPrefetchMarketplaceIXP.isEnabled() or fFlagAXUnifiedMarketplaceResultsFetcher then
		v20 = module34()
	end

	local clone = table.clone(p2)

	if (v19 or fFlagAXUnifiedMarketplaceResultsFetcher) and v20 then
		clone.hasPrefetchedMarketplace = v20.hasFetched
		clone.isPrefetchingMarketplace = v20.isFetching
		clone.fetchMarketplace = v20.fetchMarketplace

		local v21 = if fFlagAXPrefetchOnlyWithinTTL then v20.fetchedMarketplaceTimestamp else nil
		clone.fetchedMarketplaceTimestamp = v21
	end

	local v21 = nil

	if fFlagAXMigrateAllTabToSduiDev then
		module36()
		local v22, v23 = module40()
		local v24 = module35({
			categoryId = v22 or module30.DefaultCatalogCategoryId,
			subcategoryId = v23
		})

		local v25 = module37()

		if fFlagAXSduiWidgetsTTITracking then
			local searchUuid = v24.searchUuid

			local identifier = v24.identifier
			module38({
				searchUuid = searchUuid,
				resultsAreSduiEnabled = v25,
				identifier = identifier
			})

			v21 = module39({
				searchUuid = searchUuid,
				resultsAreSduiEnabled = v25,
				identifier = identifier
			})
		end

		clone.resultsAreSduiEnabled = v25

		if v25 then
			clone.hasPrefetchedMarketplace = v24.hasFetched
			clone.isPrefetchingMarketplace = v24.isFetching
			clone.fetchedMarketplaceTimestamp = v24.fetchedMarketplaceTimestamp
			clone.fetchMarketplace = v24.fetchMarketplace
		end
	end

	local catalogSelectionStore = module42.getCatalogSelectionStore()

	local v22 = useSignalState(catalogSelectionStore.selectedCategoryId)
	local v23 = useSignalState(catalogSelectionStore.selectedSubcategoryId)
	local v24 = useSignalState(catalogSelectionStore.selectedCategoryInfo)

	clone.categoryId = v22
	clone.subcategoryId = v23
	clone.categoryInfo = v24

	if fFlagAXPassScreenSizeToWidgetApi then
		local v25 = getAXMarketplaceWidgetStore(false)
		clone.screenSize = SignalsReact.useSignalState(v25.getDebouncedScreenSize)
	end

	if fFlagAXSduiWidgetsTTITracking then
		return Roact.createElement(sduiWidgetTTITileLatencyContext.Provider, {
			value = v21
		}, {
			NavigationItemsView = Roact.createElement(v18, clone)
		})
	end

	return Roact.createElement(v18, clone)
end

return NavigationItemsViewWrapper
