local HttpService = game:GetService("HttpService")

local CorePackages = game:GetService("CorePackages")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Promise = require(CorePackages.Packages.Promise)

local module = require("@luauforge/bundled/dwM")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module2 = require("@luauforge/bundled/dPc")

local module3 = require("@luauforge/bundled/dMO")

local SetBundles = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Actions/SetBundles")
local module5 = require("@luauforge/bundled/fwg")
local module6 = require("@luauforge/bundled/dMx")
local recommendationsType = require("@luauforge/bundled/dMd").Enums.RecommendationsType
require("@luauforge/bundled/AH")

local module7 = require("@luauforge/bundled/dMM")
local module8 = require("@luauforge/bundled/dMN")
local module9 = require("@luauforge/bundled/dMB")

local module10 = require("@luauforge/bundled/dOs")
local defineFastInt = game:DefineFastInt("AXRecommendedNoOfAllItems", 12)
local module11 = require("@luauforge/deferred/gQi")

local defineFastInt2 = game:DefineFastInt("AXYouMayAlsoLikeCarouselNoOfItems", 25)

local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local module14 = require("@luauforge/bundled/dMP")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local reducerUtils = require("@luauforge/bundled/dHL").Utils.ReducerUtils
local fFlagAXAvatarTabLooksYouMayAlsoLike = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarTabLooksYouMayAlsoLike

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local function keyMapper(p2)
	return module6.RecommendedItemsKey .. tostring(p2)
end

local function fetchRecommendedItems(object, avatarEditorService, p2, p3, callback, callback2)
	local catalogSearchParams = CatalogSearchParams.new()
	catalogSearchParams.SalesTypeFilter = Enum.SalesTypeFilter.All
	catalogSearchParams.SortType = Enum.CatalogSortType.Relevance
	catalogSearchParams.CategoryFilter = Enum.CatalogCategoryFilter.Recommended
	catalogSearchParams.IncludeOffSale = false
	catalogSearchParams.SortAggregation = Enum.CatalogSortAggregation.AllTime
	catalogSearchParams.Limit = 120

	local success, result = pcall(function()
		return avatarEditorService:SearchCatalogAsync(catalogSearchParams)
	end)

	if success then
		local currentPage = result:GetCurrentPage()
		local v5 = defineFastInt
		local v6 = {}

		local v7 = {}
		local v8 = {}

		for k, v9 in currentPage do
			if not (k < v5 + 1) then
				continue
			end

			if v9.ItemType == module6.ItemType.Asset then
				table.insert(v6, v9)
			elseif v9.ItemType == module6.ItemType.Bundle then
				table.insert(v8, v9)
			end

			table.insert(v7, { itemType = v9.ItemType, id = v9.Id })
		end

		object:dispatch(module7(v6))
		object:dispatch(module8(v8))
		object:dispatch(module2(v7, p2, p3))
		callback(result)
	else
		logging.warn("GetRecommendedItems failure: " .. tostring(result))
		callback2({ HttpError = Enum.HttpError.OK })
	end
end

local function fetchRecommendedLooks(object, p2, p3, p4, p5, p6)
	local looksFromWidgetListInfo, v5 = AvatarExperienceCatalog.Api.getLooksFromWidgetListInfo(
		p2,
		p5,
		nil,
		nil,
		"editor-tab:avatars"
	)

	return looksFromWidgetListInfo:andThen(function(p7)
		local v6 = {}

		for k, v8 in p7 and p7.widgets or {} do
			v6 = v8.content or {}
			break
		end

		if #v6 ~= 0 then
			return GetExperienceSourceLanguage.HydrateWidgetContent(p2, v6):andThen(function(p8)
				local hydratedContent = p8 and p8.responseBody and p8.responseBody.hydratedContent

				if not hydratedContent then
					object:dispatch(module2({}, p3, p4))
					return Promise.resolve({})
				end

				local look = widgetConstants.ContentType.Look
				local v8 = { [look] = {} }

				for k, v9 in hydratedContent do
					local kind = v9.type

					if not kind then
						continue
					end

					if not v8[kind] then
						v8[kind] = {}
					end

					v8[kind][tostring(v9.id)] = v9
				end

				local v9 = p6 or module6.NumRecommendedItems
				local v10 = {}

				for k, v11 in v6 do
					local id = tostring(v11.id)

					if v8[look][id] and #v10 < v9 then
						table.insert(v10, { id = id, itemType = module6.ItemType.Look })
					end
				end

				object:dispatch(module14(v8))
				object:dispatch(module2(v10, p3, p4))
				return Promise.resolve(v10)
			end, function(p8)
				logging.warn("GetRecommendedItems looks hydration failure: " .. tostring(p8))
				return Promise.reject({ HttpError = Enum.HttpError.OK })
			end)
		end

		object:dispatch(module2({}, p3, p4))
		return Promise.resolve({})
	end, function(p7)
		logging.warn("GetRecommendedItems looks widget failure: " .. tostring(p7))
		return Promise.reject({ HttpError = Enum.HttpError.OK })
	end)
end

return function(p2, p3, p4)
	return function(p5, p6)
		module.isType(p2, "function", "GetRecommendedItems thunk expects networkImpl")
		module.isTypeOrNil(p3, "string", "GetRecommendedItems thunk expects assetTypeIdString")
		module.isType(p4, "string", "GetRecommendedItems thunk expects recommendationsType")
		local v5

		if module11.isEnabled() then
			v5 = module9.readTestVariable(module11.EnableAvatarEditorRecommendationCarousel)
		else
			v5 = nil
		end

		if not p4 or p4 == recommendationsType.None then
			return nil
		end

		local v6 = p3
		local v7 = p3
		local flag

		if p4 == recommendationsType.Asset then
			flag = true
		else
			v6 = p4
			flag = false

			if p4 == recommendationsType.BodyParts then
				v7 = module6.BundleTypeIdStrings.BodyParts
			elseif p4 == recommendationsType.AvatarAnimations then
				v7 = module6.BundleTypeIdStrings.Animations
			elseif p4 == recommendationsType.Shoes then
				v7 = module6.BundleTypeIdStrings.Shoes
			elseif p4 == recommendationsType.DynamicHeads then
				v7 = module6.BundleTypeIdStrings.DynamicHead
			end
		end

		if fFlagAXAvatarTabLooksYouMayAlsoLike and module10() and p4 == recommendationsType.AvatarLooks then
			local recommendedItemsKey = reducerUtils.generateRecommendedItemsKey(v6, p4)
			return performFetch.Single(
				module6.RecommendedItemsKey .. tostring(recommendedItemsKey),
				function(p7)
					return fetchRecommendedLooks(
						p7,
						p2,
						v6,
						p4,
						HttpService:GenerateGUID(false),
						if v5 then defineFastInt2 else nil
					)
				end
			)(p5)
		end

		if module10() and p4 == recommendationsType.All then
			local avatarEditorService = p6.avatarEditorService

			return Promise.new(function(p7, p8)
				return performFetch.Single(module6.RecommendedItemsKey .. tostring(v6), function(p9)
					return fetchRecommendedItems(p9, avatarEditorService, v6, p4, p7, p8)
				end)(p5)
			end)
		end

		return performFetch.Single(module6.RecommendedItemsKey .. tostring(v6), function(object)
			local v8 = if v5 then defineFastInt2 else nil
			return module5.GetRecommendations(p2, v7, flag, v8):andThen(function(p7)
				local data = p7 and p7.responseBody and p7.responseBody.data

				if not data then
					logging.warn("Response from GetRecommendations with recommendationId of " .. tostring(v7) .. " is malformed!")

					return Promise.reject({ HttpError = Enum.HttpError.OK })
				end

				if flag then
					object:dispatch(module3(data, p3))
				else
					object:dispatch(SetBundles(data))
				end

				if module10() then
					object:dispatch(module2(data, v6, p4))
				else
					object:dispatch(module2(data, v6))
				end

				return Promise.resolve(data)
			end)
		end)(p5)
	end
end
