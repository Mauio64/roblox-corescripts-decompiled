local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local AppendSearchInCatalog = require(Modules.AvatarExperience.Catalog.Actions.AppendSearchInCatalog)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local SetSearchInCatalog = require(Modules.AvatarExperience.Catalog.Actions.SetSearchInCatalog)
local SetAssetInfoFromSortResults = require(Modules.AvatarExperience.Catalog.Actions.SetAssetInfoFromSortResults)
local SetBundleInfoFromSortResults = require(Modules.AvatarExperience.Catalog.Actions.SetBundleInfoFromSortResults)
local SetSearchTime = require(Modules.LuaApp.Actions.SetSearchTime)

require(Modules.AvatarExperience.Catalog.SearchTypes)

local FilterUtils = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterUtils)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Utils = require(Modules.AvatarExperience.Common.Utils)
local reportAvatarEventCounterNoAnalyticsArgument = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterNoAnalyticsArgument
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local GetFFlagEnableAvatarEditorServiceAPIErrorLogging = require(Modules.AvatarExperience.Flags.GetFFlagEnableAvatarEditorServiceAPIErrorLogging)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Api = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Api
local sendAXStat = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXStat
local FetchCatalogSearchForLooks = require(Modules.AvatarExperience.Catalog.Thunks.FetchCatalogSearchForLooks)
local OrganicTTIMilestoneManager = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance).OrganicTTIMilestoneManager

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

local CatalogSearchAXPages = Api.CatalogSearchAXPages

local function v24(p1, p2, p3, p4, p5: ((...any) -> ...any), s1: string) -- line: 58
	-- upvalues: FilterUtils (copy), Utils (copy), Constants (copy), AppendSearchInCatalog (copy), SetSearchInCatalog (copy), SetSearchTime (copy), SetAssetInfoFromSortResults (copy), SetBundleInfoFromSortResults (copy), OrganicTTIMilestoneManager (copy)
	local searchUuid = p1.searchUuid
	local searchKeyword = p1.searchKeyword
	local v35 = p2:getState().Search.SearchesInCatalog[searchUuid]

	if s1 ~= FilterUtils.selectSortAndFiltersKey(p2:getState()) then
		p5("Search with Uuid " .. searchUuid .. " has been terminated")
	end

	local CurrentPage = p3:GetCurrentPage()
	local v37 = Utils.tableToCamelCaseKeys(CurrentPage)
	local t1 = {}
	local t2 = {}
	local t3 = {
		items = {},
		keyword = searchKeyword,
		hasMoreEntries = not p3.IsFinished
	}

	for v41, v42 in v37 do
		if v42.itemType == Constants.ItemType.Asset then
			v42.assetType = Constants.AssetTypeIdStrings[v42.assetType]
			table.insert(t1, v42)
		elseif v42.itemType == Constants.ItemType.Bundle then
			v42.bundleType = Constants.BundleTypeIdStrings[v42.bundleType]
			table.insert(t2, v42)
		end

		t3.items[v41] = {
			id = tostring(v42.id),
			type = tostring(v42.itemType),
			productId = v42.productId
		}
	end

	if v35 then
		p2:dispatch(AppendSearchInCatalog(searchUuid, t3))
	else
		p2:dispatch(SetSearchInCatalog(searchUuid, t3))
	end

	if p1.recordSearchTime then
		p2:dispatch(SetSearchTime(searchUuid, tick()))
	end

	if #t1 > 0 then
		p2:dispatch(SetAssetInfoFromSortResults(t1))
	end

	if #t2 > 0 then
		p2:dispatch(SetBundleInfoFromSortResults(t2))
	end

	p4:storePageObject(searchUuid, p3)
	OrganicTTIMilestoneManager.L3.catalogApiSearchCompleted()
	OrganicTTIMilestoneManager.L2.primaryDataReady()
	p5()
end
local function fetchInitialPage(p6, p7, p8, _, p10: ((...any) -> ...any), p11: ((...any) -> ...any), s2: string, b1: boolean?, p12) -- line: 132
	-- upvalues: Utils (copy), Api (copy), GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), Logging (copy), CatalogSearchAXPages (copy), v24 (copy)
	local SortAndFilters = p7:getState().AvatarExperience.Catalog.SortAndFilters
	local v53 = Utils.getSearchParams(p6, SortAndFilters, b1)
	local v54 = Utils.getSearchParamsAsQueryParams(v53, p6.categoryInfo)
	local v55, _ = Api.getCatalogV2SearchItemDetails(p12, v54)

	v55:andThen(function(p13) -- line: 154
		-- upvalues: GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), Logging (copy), p11 (copy), CatalogSearchAXPages (copy), p12 (copy), v54 (copy), v24 (copy), p6 (copy), p7 (copy), p8 (copy), p10 (copy), s2 (copy)
		if not p13 or not p13.data then
			if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
				reportAvatarEventCounterNoAnalyticsArgument(Constants2.Counter.AvatarEditorServiceErrors.SearchCatalog)
			end

			Logging.warn("ApiFetchCatalogSearch V2 failure: CatalogV2SearchItemDetails is nil")
			p11({
				HttpError = Enum.HttpError.OK
			})

			return
		end

		local v69 = CatalogSearchAXPages.new(p12, v54, p13.data, p13.nextPageCursor)

		v24(p6, p7, v69, p8, p10, s2)
	end):catch(function(p14) -- line: 174
		-- upvalues: GetFFlagEnableAvatarEditorServiceAPIErrorLogging (copy), reportAvatarEventCounterNoAnalyticsArgument (copy), Constants2 (copy), Logging (copy), p11 (copy)
		if GetFFlagEnableAvatarEditorServiceAPIErrorLogging() then
			reportAvatarEventCounterNoAnalyticsArgument(Constants2.Counter.AvatarEditorServiceErrors.SearchCatalog)
		end

		Logging.warn("ApiFetchCatalogSearch V2 failure: " .. tostring(p14))
		p11({
			HttpError = Enum.HttpError.OK
		})
	end)
end
local function advancePage(p15, p16, p17, p18, p19: ((...any) -> ...any), p20: ((...any) -> ...any), s3: string) -- line: 185
	-- upvalues: v24 (copy), Logging (copy)
	local ok, result = pcall(function() -- line: 194
		-- upvalues: p15 (copy)
		p15:AdvanceToNextPageAsync()
	end)

	if ok then
		v24(p16, p17, p15, p18, p19, s3)

		return
	end

	Logging.warn("ApiFetchCatalogSearch failure: " .. result)
	p20({
		HttpError = Enum.HttpError.OK
	})
end

return function(p21, p22) -- line: 206
	-- upvalues: FilterUtils (copy), DeviceOrientationMode (copy), FetchCatalogSearchForLooks (copy), PerformFetch (copy), Utils (copy), Promise (copy), OrganicTTIMilestoneManager (copy), fetchInitialPage (copy), sendAXStat (copy), Constants2 (copy), advancePage (copy)
	return function(p23, p24) -- line: 207
		-- upvalues: p21 (copy), FilterUtils (copy), DeviceOrientationMode (copy), FetchCatalogSearchForLooks (copy), p22 (copy), PerformFetch (copy), Utils (copy), Promise (copy), OrganicTTIMilestoneManager (copy), fetchInitialPage (copy), sendAXStat (copy), Constants2 (copy), advancePage (copy)
		local pageObjectManager = p24.pageObjectManager
		local avatarEditorService = p24.avatarEditorService
		local searchUuid = p21.searchUuid
		local v76 = FilterUtils.selectSortAndFiltersKey(p23:getState())
		local elapsed = os.clock()
		local v78 = p23:getState().DeviceOrientation == DeviceOrientationMode.Portrait

		local function v79() -- line: 219
			-- upvalues: p23 (copy), FetchCatalogSearchForLooks (copy), p21 (copy), p22 (copy)
			return p23:dispatch(FetchCatalogSearchForLooks(p21, p22))
		end

		local v80 = p21 and p21.categoryInfo

		return PerformFetch.Single(Utils.getSearchKey(p23:getState(), searchUuid), function(p25) -- line: 225
			-- upvalues: v80 (copy), v79 (copy), pageObjectManager (copy), searchUuid (copy), Promise (copy), OrganicTTIMilestoneManager (copy), fetchInitialPage (copy), p21 (copy), avatarEditorService (copy), v76 (copy), v78 (copy), p22 (copy), elapsed (copy), sendAXStat (copy), Constants2 (copy), advancePage (copy)
			if v80 and v80.LooksWidgetContextForOrganicContent then
				assert(v79, "Function exists if AXAvatarsTabIXP.isEnabled() is enabled. Assert can be removed with AXAvatarsTabIXP.isEnabled()")

				return v79()
			end

			local v82 = pageObjectManager:getPageObject(searchUuid)

			if v82 and v82.IsFinished then
				return Promise.resolve()
			end

			OrganicTTIMilestoneManager.L3.catalogApiSearchStarted()

			return Promise.new(function(resolve, reject) -- line: 241
				-- upvalues: searchUuid (copy), v82 (copy), fetchInitialPage (copy), p21 (copy), p25 (copy), pageObjectManager (copy), avatarEditorService (copy), v76 (copy), v78 (copy), p22 (copy), elapsed (copy), sendAXStat (copy), Constants2 (copy), advancePage (copy)
				if not searchUuid then
					reject("Must have a searchUuid.")
				end

				if v82 == nil then
					fetchInitialPage(p21, p25, pageObjectManager, avatarEditorService, resolve, reject, v76, v78, p22)

					if elapsed then
						local v85 = (os.clock() - elapsed) * 1000

						sendAXStat({
							statName = Constants2.Counter.Latency.Network.ApiFetchCatalogSearch,
							deltaMs = v85
						})

						return
					end
				else
					advancePage(v82, p21, p25, pageObjectManager, resolve, reject, v76)
				end
			end)
		end)(p23)
	end
end
