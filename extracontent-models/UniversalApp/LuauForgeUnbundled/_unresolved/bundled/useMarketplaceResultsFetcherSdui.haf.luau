local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Promise = require(CorePackages.Packages.Promise)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useStore = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useStore

local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
require("@luauforge/bundled/dPt")

local module = require("@luauforge/bundled/gZC")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module2 = require("@luauforge/bundled/gZF")

local module3 = require("@luauforge/bundled/fCe")

local module4 = require("@luauforge/bundled/dSW")

local module5 = require("@luauforge/bundled/dPN")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2
local sendAXStat = AvatarExperienceAnalytics.sendAXStat
local logWidgetLoaded = AvatarExperienceAnalytics.logWidgetLoaded
local getUnifiedLoggingSurface = AvatarExperienceAnalytics.Utils.getUnifiedLoggingSurface

local module7 = require("@luauforge/bundled/gZU")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXPrefetchOnlyWithinTTL = AvatarExperienceFlags.FFlagAXPrefetchOnlyWithinTTL
local fFlagAXMarketplaceBreakpointEstimateFix = AvatarExperienceFlags.FFlagAXMarketplaceBreakpointEstimateFix
local fFlagAXSduiWidgetsTTITracking = AvatarExperienceFlags.FFlagAXSduiWidgetsTTITracking
local fFlagAXUnifiedEventCounters = AvatarExperienceFlags.FFlagAXUnifiedEventCounters
local fIntAXPrefetchWidgetHydrationRowsPortrait = AvatarExperienceFlags.FIntAXPrefetchWidgetHydrationRowsPortrait
local fIntAXPrefetchWidgetHydrationRowsLandscape = AvatarExperienceFlags.FIntAXPrefetchWidgetHydrationRowsLandscape
local fFlagAXSduiPageVariantRequestId = AvatarExperienceFlags.FFlagAXSduiPageVariantRequestId
local fFlagAXSduiPublishRequestIdWithResponse = AvatarExperienceFlags.FFlagAXSduiPublishRequestIdWithResponse
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads
local module9 = require("@luauforge/bundled/gJS")
local module10 = require("@luauforge/bundled/gLF")
local widgetsPercievedTTIManager = module10.WidgetsPercievedTTIManager
local organicTTIMilestoneManager = module10.OrganicTTIMilestoneManager
local ttiPerformanceManager = module10.TTIPerformanceManager

local module11 = require("@luauforge/bundled/dWq")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

local fetchCatalogPage = AvatarExperienceCatalog.Sdui.fetchCatalogPage
local getCatalogConfigKey = AvatarExperienceCatalog.Sdui.getCatalogConfigKey
local getCatalogPageIdentifier = AvatarExperienceCatalog.Sdui.getCatalogPageIdentifier
local buildOrderedWidgetsFromCatalogPage = AvatarExperienceCatalog.Sdui.buildOrderedWidgetsFromCatalogPage
local getAXMarketplaceWidgetStore = AvatarExperienceCatalog.Stores.getAXMarketplaceWidgetStore
local getCatalogPageRequestIdStore = AvatarExperienceCatalog.Stores.getCatalogPageRequestIdStore

local module13 = require("@luauforge/bundled/dXB")

local sduiLoadTimer = module13.SduiLoadTimer
local getSduiApiStore = module13.getSduiApiStore
local module14 = require("@luauforge/bundled/dQf")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")

local hydrateCatalogSortEntities = AvatarExperienceCatalog.Sdui.hydrateCatalogSortEntities

local function makeSelectSearchTimes(p2)
	return function(p3)
		if typeof(p3.SearchTimes) == "table" and p2 then
			return p3.SearchTimes[p2]
		end

		return nil
	end
end

local function useMarketplaceResultsFetcherSdui(p2)
	local v5 = useDispatch()
	local v6 = useRoactService(roactNetworking)
	local v7 = useStore()

	local fetchMarketplaceStore = module.getFetchMarketplaceStore(false)
	local v8 = useSignalState(fetchMarketplaceStore.getFetchingMarketplace)
	local v9 = useSignalState(fetchMarketplaceStore.getFetchedMarketplace)
	local v10

	if fFlagAXPrefetchOnlyWithinTTL then
		v10 = useSignalState(fetchMarketplaceStore.getFetchedMarketplaceTimestamp)
	end

	local setFetchingMarketplaceInProgress = fetchMarketplaceStore.setFetchingMarketplaceInProgress
	local setFetchedMarketplaceCompleted = fetchMarketplaceStore.setFetchedMarketplaceCompleted
	local setFetchingMarketplaceErrorOccured = fetchMarketplaceStore.setFetchingMarketplaceErrorOccured
	local setFetchingMarketplaceProcessed = fetchMarketplaceStore.setFetchingMarketplaceProcessed

	local v11 = module2()

	local categoryId = p2.categoryId
	local subcategoryId = p2.subcategoryId

	local v12 = useSignalState(module4.getCatalogCategoriesStore().getCategoriesMap)
	local categoryInfoById = module3.getCategoryInfoById(v12, categoryId, subcategoryId)
	local v13 = categoryInfoById == nil
	local v14 = categoryInfoById or v11

	React.useEffect(function()
		if v13 then
			sendAXCounterV2(module5.Counter.Errors.FetcherCategoryInfoMissing)
		end
	end, { v13, categoryId, subcategoryId })

	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)

	local searchUuid = v14.SearchUuid
	local widgetContext = v14.WidgetContext
	local timeToRefresh = v14.TimeToRefresh
	local v16 = useSelector((React.useCallback(function(p3)
		if typeof(p3.SearchTimes) == "table" and searchUuid then
			return p3.SearchTimes[searchUuid]
		end

		return nil
	end, { searchUuid })))
	local v17, v18

	if fFlagAXSduiWidgetsTTITracking then
		v17 = getCatalogPageIdentifier(widgetContext or "")

		local ref3 = React.useRef(nil)

		v18 = React.useCallback(function(current)
			if current == nil or current == "" or ref3.current == current then
				return
			end

			ref3.current = current
			ttiPerformanceManager.Surface.Marketplace.Root.startTracking()
			v5(module11.StartTracking(current))
		end, { v5 })

		React.useEffect(function()
			if not v18 then
				return
			end

			v18(searchUuid)
		end, { searchUuid, v18 })
	else
		v18 = nil
	end

	local v19 = React.useCallback(function(p3)
		if fFlagAXMarketplaceBreakpointEstimateFix then
			getAXMarketplaceWidgetStore(false).refreshEstimate()
		end

		local debouncedScreenSize = getAXMarketplaceWidgetStore(false).getDebouncedScreenSize(false)

		local loadTimer = sduiLoadTimer.createLoadTimer(avatarScreen.Catalog)
		local v20 = widgetContext or ""

		local catalogPageIdentifier = getCatalogPageIdentifier(v20)
		local catalogPageRequestIdStore = getCatalogPageRequestIdStore(false)
		local v21

		if fFlagAXSduiPublishRequestIdWithResponse and p3 then
			v21 = not getSduiApiStore().isInFlight(getCatalogConfigKey(v20, debouncedScreenSize))

			if v21 then
				catalogPageRequestIdStore.beginPageVariantRefresh(
					catalogPageIdentifier,
					debouncedScreenSize
				)
			end
		else
			v21 = false
		end

		if p3 and not fFlagAXSduiPublishRequestIdWithResponse then
			if fFlagAXSduiPageVariantRequestId then
				catalogPageRequestIdStore.resetPageVariantRequestId(
					catalogPageIdentifier,
					debouncedScreenSize
				)
			else
				catalogPageRequestIdStore.resetPageRequestId(catalogPageIdentifier)
			end
		end

		local v22

		if fFlagAXSduiPublishRequestIdWithResponse then
			v22 = catalogPageRequestIdStore.getPageVariantRequestIdToSend(
				catalogPageIdentifier,
				debouncedScreenSize
			)
		elseif fFlagAXSduiPageVariantRequestId then
			v22 = catalogPageRequestIdStore.getOrCreatePageVariantRequestId(
				catalogPageIdentifier,
				debouncedScreenSize
			)
		else
			v22 = catalogPageRequestIdStore.getOrCreatePageRequestId(catalogPageIdentifier)
		end

		local lastTime = os.clock()

		local v23 = fetchCatalogPage(
			{ requestId = v22, context = v20, screenSize = debouncedScreenSize },
			loadTimer,
			p3 and { forceRefresh = true } or nil
		)

		if typeof(v23) == "table" and typeof(v23.andThen) == "function" then
			return v23:andThen(function()
				if fFlagAXSduiPublishRequestIdWithResponse and v21 then
					catalogPageRequestIdStore.commitPageVariantRequestId(
						catalogPageIdentifier,
						debouncedScreenSize,
						v22
					)
				end

				if fFlagAXSduiWidgetsTTITracking then
					widgetsPercievedTTIManager.L3.responseReceived()
				end

				sendAXStat({
					statName = module5.Counter.Latency.Network.FetchWidgetInfo,
					deltaMs = (os.clock() - lastTime) * 1000
				})

				local orderedWidgetsFromCatalogPage = buildOrderedWidgetsFromCatalogPage(
					getCatalogConfigKey(v20, debouncedScreenSize),
					catalogPageIdentifier
				)

				local v24 = {}

				for k, v25 in orderedWidgetsFromCatalogPage do
					local kind = v25.type

					if kind ~= nil then
						table.insert(
							v24,
							fFlagAXUnifiedEventStrictPayloads and {
								id = v25.id,
								type = kind,
								tagId = v25.tagId,
								content = v25.content
							} or v25
						)
					end
				end

				if #v24 > 0 then
					local v26 = if fFlagAXSduiPublishRequestIdWithResponse then catalogPageRequestIdStore.getPageVariantRequestId(
						catalogPageIdentifier,
						debouncedScreenSize
					) or v22 else v22
					logWidgetLoaded(v24, v26, fFlagAXUnifiedEventCounters and function()
						return getUnifiedLoggingSurface(v7:getState().AvatarExperience.AvatarScene.AvatarRoute)
					end or nil)
				end

				local v25

				if module9((v7:getState())) then
					v25 = fIntAXPrefetchWidgetHydrationRowsPortrait
				else
					v25 = fIntAXPrefetchWidgetHydrationRowsLandscape
				end

				if fFlagAXSduiWidgetsTTITracking then
					widgetsPercievedTTIManager.L3.requestFetchHydratedWidgets()
				end

				hydrateCatalogSortEntities(v5, v6, module14, GetExperienceSourceLanguage, v25)
			end, function(p4)
				if fFlagAXSduiPublishRequestIdWithResponse and v21 then
					catalogPageRequestIdStore.discardPageVariantRequestId(
						catalogPageIdentifier,
						debouncedScreenSize,
						v22
					)
				end

				setFetchingMarketplaceErrorOccured()
				return Promise.reject(p4)
			end)
		end

		return Promise.resolve()
	end, { widgetContext, v7, v5, v6, setFetchingMarketplaceErrorOccured })

	local v20 = React.useCallback(function(current)
		if v13 then
			ref.current = true
			ref2.current = current
		else
			if fFlagAXSduiWidgetsTTITracking then
				widgetsPercievedTTIManager.L2.primaryDataStarted()
			end

			setFetchingMarketplaceInProgress()

			if v18 then
				v18(searchUuid)
			end

			local v21 = not (current == nil) and current.forceRefresh == true
			local v22 = not v21

			if v22 then
				if v16 == nil or timeToRefresh == nil or not (timeToRefresh >= 0) then
					v22 = false
				else
					v22 = timeToRefresh < tick() - v16
				end
			end

			if v22 then
				sendAXCounterV2(module5.Counter.CatalogRefresh.StaleResults)
			end

			v5(module7(searchUuid, tick()))

			if fFlagAXSduiWidgetsTTITracking then
				widgetsPercievedTTIManager.L3.networkFetch()
			end

			local v24 = { v19(v21 or v22) }

			Promise.all(v24):andThen(function()
				if not fFlagAXSduiWidgetsTTITracking then
					widgetsPercievedTTIManager.L2.dataProcessingStarted()
					organicTTIMilestoneManager.L2.dataProcessingStarted()
				end

				setFetchedMarketplaceCompleted()

				if not fFlagAXSduiWidgetsTTITracking then
					widgetsPercievedTTIManager.L2.dataProcessingCompleted()
					organicTTIMilestoneManager.L2.dataProcessingCompleted()
				end
			end):catch(function(p3)
				local success, result = pcall(function()
					return (string.sub(tostring(p3), 1, 100))
				end)

				sendAXCounterV2(module5.Counter.Catalog.Errors.FetchMarketplaceSduiError, {
					error = not success and "unknown" or result
				})
			end)

			Promise.allSettled(v24):finally(function()
				if fFlagAXSduiWidgetsTTITracking then
					widgetsPercievedTTIManager.L2.dataProcessingStarted()
				end

				if setFetchingMarketplaceProcessed then
					setFetchingMarketplaceProcessed()
				end

				if fFlagAXSduiWidgetsTTITracking then
					widgetsPercievedTTIManager.L2.dataProcessingCompleted()
				end
			end)

			if not fFlagAXSduiWidgetsTTITracking then
				widgetsPercievedTTIManager.L3.networkFetch()
				organicTTIMilestoneManager.L3.networkFetch()
			end
		end
	end, {
		searchUuid,
		v16,
		timeToRefresh,
		setFetchingMarketplaceInProgress,
		setFetchedMarketplaceCompleted,
		setFetchingMarketplaceProcessed,
		v5,
		v19,
		v18,
		v13
	})

	React.useEffect(function()
		if not v13 and ref.current then
			local current = ref2.current
			ref.current = false
			ref2.current = nil
			v20(current)
		end
	end, { v13, v20 })

	local v21 = {
		fetchMarketplace = v20,
		hasFetched = v9,
		isFetching = v8,
		fetchedMarketplaceTimestamp = nil,
		searchUuid = nil,
		identifier = nil
	}

	if not fFlagAXPrefetchOnlyWithinTTL then
		v10 = nil
	end

	v21.fetchedMarketplaceTimestamp = v10
	v21.searchUuid = if not v13 then searchUuid else nil

	if v13 then
		v17 = nil
	end

	v21.identifier = v17
	return v21
end

return useMarketplaceResultsFetcherSdui
