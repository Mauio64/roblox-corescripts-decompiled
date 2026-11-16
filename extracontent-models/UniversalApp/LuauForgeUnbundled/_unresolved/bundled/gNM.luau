local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local module = require("@luauforge/bundled/gNN")
local module2 = require("@luauforge/bundled/dMx")
local module3 = require("@luauforge/bundled/gNO")
local module4 = require("@luauforge/bundled/dMM")
local module5 = require("@luauforge/bundled/dMN")
local module6 = require("@luauforge/bundled/gNP")
require("@luauforge/bundled/dTN")
local module7 = require("@luauforge/bundled/fuL")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module8 = require("@luauforge/bundled/fuD")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")

local reportAvatarEventCounterNoAnalyticsArgument = AvatarExperienceAnalytics.reportAvatarEventCounterNoAnalyticsArgument
local reportAvatarEditorServiceCounter = AvatarExperienceAnalytics.reportAvatarEditorServiceCounter
local AVATAR_EDITOR_SERVICE_EVENTS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_EVENTS
local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = AvatarExperienceAnalytics.Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS
local fFlagAXAvatarEditorServiceTelemetryV2 = AvatarExperienceAnalytics.Flags.FFlagAXAvatarEditorServiceTelemetryV2

local fFlagAXDeprecateAvatarEditorServiceTelemetryV1 = AvatarExperienceAnalytics.Flags.FFlagAXDeprecateAvatarEditorServiceTelemetryV1
local module10 = require("@luauforge/bundled/dMx")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode

require("@luauforge/bundled/AH")
require("@luauforge/bundled/dHK")
local api = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Api

local fFlagAXCatalogSpecialFeaturesFilter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogSpecialFeaturesFilter

local sendAXStat = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXStat

local module11 = require("@luauforge/bundled/gNQ")

local organicTTIMilestoneManager = require("@luauforge/bundled/ggZ").OrganicTTIMilestoneManager

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local catalogSearchAXPages = api.CatalogSearchAXPages

local function fn(data, object, object2, object3, callback, p2)
	local searchUuid = data.searchUuid
	local searchKeyword = data.searchKeyword
	local v5 = object:getState().Search.SearchesInCatalog[searchUuid]

	if module7.selectSortAndFiltersKey(object:getState()) ~= p2 then
		callback("Search with Uuid " .. searchUuid .. " has been terminated")
	end

	local currentPage = object2:GetCurrentPage()
	local tableToCamelCaseKeys = module8.tableToCamelCaseKeys(currentPage)

	local v6 = {
		items = {},
		keyword = searchKeyword,
		hasMoreEntries = not object2.IsFinished
	}
	local tableToCamelCaseKeys2 = {}
	local tableToCamelCaseKeys3 = {}

	for k, tableToCamelCaseKey in tableToCamelCaseKeys do
		if tableToCamelCaseKey.itemType == module2.ItemType.Asset then
			tableToCamelCaseKey.assetType = module2.AssetTypeIdStrings[tableToCamelCaseKey.assetType]
			table.insert(tableToCamelCaseKeys2, tableToCamelCaseKey)
		elseif tableToCamelCaseKey.itemType == module2.ItemType.Bundle then
			tableToCamelCaseKey.bundleType = module2.BundleTypeIdStrings[tableToCamelCaseKey.bundleType]
			table.insert(tableToCamelCaseKeys3, tableToCamelCaseKey)
		end

		v6.items[k] = {
			id = tostring(tableToCamelCaseKey.id),
			type = tostring(tableToCamelCaseKey.itemType),
			productId = tableToCamelCaseKey.productId
		}
	end

	if v5 then
		object:dispatch(module(searchUuid, v6))
	else
		object:dispatch(module3(searchUuid, v6))
	end

	if data.recordSearchTime then
		object:dispatch(module6(searchUuid, tick()))
	end

	if #tableToCamelCaseKeys2 > 0 then
		object:dispatch(module4(tableToCamelCaseKeys2))
	end

	if #tableToCamelCaseKeys3 > 0 then
		object:dispatch(module5(tableToCamelCaseKeys3))
	end

	object3:storePageObject(searchUuid, object2)

	organicTTIMilestoneManager.L3.catalogApiSearchCompleted()
	organicTTIMilestoneManager.L2.primaryDataReady()

	callback()
end

local function fetchInitialPage(p2, object, pageObjectManager, avatarEditorService, p3, callback, sortAndFiltersKey, p4, p5)
	local sortAndFilters = object:getState().AvatarExperience.Catalog.SortAndFilters

	local searchParams = module8.getSearchParams(p2, sortAndFilters, p4)

	local searchParamsAsQueryParams = module8.getSearchParamsAsQueryParams(searchParams, p2.categoryInfo)

	if fFlagAXCatalogSpecialFeaturesFilter then
		searchParamsAsQueryParams = api.addSpecialFeaturesFilter(
			searchParamsAsQueryParams,
			sortAndFilters.SpecialFeaturesFilter
		)
	end

	if fFlagAXAvatarEditorServiceTelemetryV2 then
		reportAvatarEditorServiceCounter(
			AVATAR_EDITOR_SERVICE_EVENTS.SearchCatalog,
			AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Request
		)
	end

	local catalogV2SearchItemDetails, v5 = api.getCatalogV2SearchItemDetails(p5, searchParamsAsQueryParams)

	catalogV2SearchItemDetails:andThen(function(p6)
		if p6 and p6.data then
			if fFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					AVATAR_EDITOR_SERVICE_EVENTS.SearchCatalog,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Success
				)
			end

			fn(
				p2,
				object,
				catalogSearchAXPages.new(p5, searchParamsAsQueryParams, p6.data, p6.nextPageCursor),
				pageObjectManager,
				p3,
				sortAndFiltersKey
			)
		else
			if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
				reportAvatarEventCounterNoAnalyticsArgument(module10.Counter.AvatarEditorServiceErrors.SearchCatalog)
			end

			if fFlagAXAvatarEditorServiceTelemetryV2 then
				reportAvatarEditorServiceCounter(
					AVATAR_EDITOR_SERVICE_EVENTS.SearchCatalog,
					AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
					"CatalogV2SearchItemDetails is nil"
				)
			end

			logging.warn("ApiFetchCatalogSearch V2 failure: CatalogV2SearchItemDetails is nil")
			callback({ HttpError = Enum.HttpError.OK })
		end
	end):catch(function(p6)
		if not fFlagAXDeprecateAvatarEditorServiceTelemetryV1 then
			reportAvatarEventCounterNoAnalyticsArgument(module10.Counter.AvatarEditorServiceErrors.SearchCatalog)
		end

		if fFlagAXAvatarEditorServiceTelemetryV2 then
			local v6 = if typeof(p6) == "table" and typeof(p6.HttpError) == "EnumItem" then p6.HttpError else nil

			reportAvatarEditorServiceCounter(
				AVATAR_EDITOR_SERVICE_EVENTS.SearchCatalog,
				AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error,
				v6
			)
		end

		logging.warn("ApiFetchCatalogSearch V2 failure: " .. tostring(p6))
		callback({ HttpError = Enum.HttpError.OK })
	end)
end

local function advancePage(pageObject, p2, p3, pageObjectManager, p4, callback, sortAndFiltersKey)
	local success, result = pcall(function()
		pageObject:AdvanceToNextPageAsync()
	end)

	if success then
		fn(p2, p3, pageObject, pageObjectManager, p4, sortAndFiltersKey)
		return
	end

	logging.warn("ApiFetchCatalogSearch failure: " .. result)
	callback({ HttpError = Enum.HttpError.OK })
end

return function(p2, p3)
	return function(object, p4)
		local pageObjectManager = p4.pageObjectManager
		local avatarEditorService = p4.avatarEditorService
		local searchUuid = p2.searchUuid
		local sortAndFiltersKey = module7.selectSortAndFiltersKey(object:getState())
		local lastTime = os.clock()

		local v5 = object:getState().DeviceOrientation == deviceOrientationMode.Portrait

		local function fn2()
			return object:dispatch(module11(p2, p3))
		end

		local categoryInfo = p2 and p2.categoryInfo
		return performFetch.Single(module8.getSearchKey(object:getState(), searchUuid), function(p5)
			if categoryInfo and categoryInfo.LooksWidgetContextForOrganicContent then
				assert(
					fn2,
					"Function exists if AXAvatarsTabIXP.isEnabled() is enabled. Assert can be removed with AXAvatarsTabIXP.isEnabled()"
				)

				return fn2()
			end

			local pageObject = pageObjectManager:getPageObject(searchUuid)

			if pageObject and pageObject.IsFinished then
				return Promise.resolve()
			end

			organicTTIMilestoneManager.L3.catalogApiSearchStarted()

			return Promise.new(function(p6, callback)
				if not searchUuid then
					callback("Must have a searchUuid.")
				end

				if pageObject == nil then
					fetchInitialPage(
						p2,
						p5,
						pageObjectManager,
						avatarEditorService,
						p6,
						callback,
						sortAndFiltersKey,
						v5,
						p3
					)

					if lastTime then
						local v6 = (os.clock() - lastTime) * 1000
						sendAXStat({
							statName = module10.Counter.Latency.Network.ApiFetchCatalogSearch,
							deltaMs = v6
						})
					end
				else
					advancePage(pageObject, p2, p5, pageObjectManager, p6, callback, sortAndFiltersKey)
				end
			end)
		end)(object)
	end
end
