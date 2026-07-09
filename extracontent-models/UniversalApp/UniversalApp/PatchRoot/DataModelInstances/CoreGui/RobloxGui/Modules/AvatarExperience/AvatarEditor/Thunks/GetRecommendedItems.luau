local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local SetRecommendedItemsV2 = require(Modules.AvatarExperience.AvatarEditor.Actions.SetRecommendedItemsV2)
local SetAssetInfoFromAvatarEditorRecommendedItemsV2 = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAssetInfoFromAvatarEditorRecommendedItemsV2)
local SetBundleInfoFromAvatarEditorRecommendedItemsV2 = require(Modules.AvatarExperience.AvatarEditor.Actions.SetBundleInfoFromAvatarEditorRecommendedItemsV2)
local WebApi = require(Modules.AvatarExperience.AvatarEditor.Http.WebApi)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)

require(Modules.LuaApp.Types.RoduxTypes)

local SetAssetInfoFromSortResults = require(Modules.AvatarExperience.Catalog.Actions.SetAssetInfoFromSortResults)
local SetBundleInfoFromSortResults = require(Modules.AvatarExperience.Catalog.Actions.SetBundleInfoFromSortResults)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local GetFFlagAXEnableRecommendationTypeAllInCustomize = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableRecommendationTypeAllInCustomize)
local v18 = game:DefineFastInt("AXRecommendedNoOfAllItems", 12)
local AXEditorRecommendationCarousel = require(Modules.AvatarExperience.Experiments.AXEditorRecommendationCarousel)
local v20 = game:DefineFastInt("AXYouMayAlsoLikeCarouselNoOfItems", 25)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local WebApi2 = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local SetHydratedWidgetData = require(Modules.AvatarExperience.Catalog.Actions.SetHydratedWidgetData)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local ReducerUtils = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Utils.ReducerUtils
local FFlagAXAvatarTabLooksYouMayAlsoLike = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAvatarTabLooksYouMayAlsoLike

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local function keyMapper(p1) -- line: 42
	-- upvalues: Constants (copy)
	return Constants.RecommendedItemsKey .. tostring(p1)
end
local function fetchRecommendedItems(p2, p3, s1: string?, s2: string, p4: ((...any) -> ...any), p5: ((...any) -> ...any)) -- line: 46
	-- upvalues: v18 (copy), Constants (copy), SetAssetInfoFromSortResults (copy), SetBundleInfoFromSortResults (copy), SetRecommendedItemsV2 (copy), Logging (copy)
	local catalogSearchParams = CatalogSearchParams.new()

	catalogSearchParams.SalesTypeFilter = Enum.SalesTypeFilter.All
	catalogSearchParams.SortType = Enum.CatalogSortType.Relevance
	catalogSearchParams.CategoryFilter = Enum.CatalogCategoryFilter.Recommended
	catalogSearchParams.IncludeOffSale = false
	catalogSearchParams.SortAggregation = Enum.CatalogSortAggregation.AllTime
	catalogSearchParams.Limit = 120

	local ok, result = pcall(function() -- line: 62
		-- upvalues: p3 (copy), catalogSearchParams (copy)
		if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
			return p3:SearchCatalogAsync(catalogSearchParams)
		end

		return p3:SearchCatalog(catalogSearchParams)
	end)

	if ok then
		local CurrentPage = result:GetCurrentPage()
		local v41 = v18
		local t1 = {}
		local t2 = {}
		local t3 = {}

		for v45, v46 in CurrentPage do
			if v45 < v41 + 1 then
				if v46.ItemType == Constants.ItemType.Asset then
					table.insert(t1, v46)
				elseif v46.ItemType == Constants.ItemType.Bundle then
					table.insert(t2, v46)
				end

				table.insert(t3, {
					itemType = v46.ItemType,
					id = v46.Id
				})
			end
		end

		p2:dispatch(SetAssetInfoFromSortResults(t1))
		p2:dispatch(SetBundleInfoFromSortResults(t2))
		p2:dispatch(SetRecommendedItemsV2(t3, s1, s2))
		p4(result)

		return
	end

	Logging.warn("GetRecommendedItems failure: " .. tostring(result))
	p5({
		HttpError = Enum.HttpError.OK
	})
end
local function fetchRecommendedLooks(p6, p7: ((...any) -> ...any), s3: string, s4: string, s5: string, n1: number?) -- line: 102
	-- upvalues: AvatarExperienceCatalog (copy), SetRecommendedItemsV2 (copy), Promise (copy), WebApi2 (copy), WidgetConstants (copy), Constants (copy), SetHydratedWidgetData (copy), Logging (copy)
	local v53, _ = AvatarExperienceCatalog.Api.getLooksFromWidgetListInfo(p7, s5, nil, nil, "editor-tab:avatars")

	return v53:andThen(function(p8) -- line: 113
		-- upvalues: p6 (copy), SetRecommendedItemsV2 (copy), s3 (copy), s4 (copy), Promise (copy), WebApi2 (copy), p7 (copy), WidgetConstants (copy), n1 (copy), Constants (copy), SetHydratedWidgetData (copy), Logging (copy)
		local v59 = p8 and p8.widgets or {}
		local t4 = {}

		for _, v62 in v59 do
			t4 = v62.content or {}

			break
		end

		if #t4 == 0 then
			p6:dispatch(SetRecommendedItemsV2({}, s3, s4))

			return Promise.resolve({})
		end

		return WebApi2.HydrateWidgetContent(p7, t4):andThen(function(p9) -- line: 126
			-- upvalues: p6 (copy), SetRecommendedItemsV2 (copy), s3 (copy), s4 (copy), Promise (copy), WidgetConstants (copy), n1 (copy), Constants (copy), t4 (ref), SetHydratedWidgetData (copy)
			local v75 = p9 and (p9.responseBody and p9.responseBody.hydratedContent)

			if not v75 then
				p6:dispatch(SetRecommendedItemsV2({}, s3, s4))

				return Promise.resolve({})
			end

			local Look = WidgetConstants.ContentType.Look
			local t5 = {
				[Look] = {}
			}

			for _, v79 in v75 do
				local type = v79.type

				if type then
					if not t5[type] then
						t5[type] = {}
					end

					t5[type][tostring(v79.id)] = v79
				end
			end

			local v81 = n1 or Constants.NumRecommendedItems
			local t6 = {}

			for _, v84 in t4 do
				local str = tostring(v84.id)

				if t5[Look][str] and v81 > #t6 then
					table.insert(t6, {
						id = str,
						itemType = Constants.ItemType.Look
					})
				end
			end

			p6:dispatch(SetHydratedWidgetData(t5))
			p6:dispatch(SetRecommendedItemsV2(t6, s3, s4))

			return Promise.resolve(t6)
		end, function(p10) -- line: 164
			-- upvalues: Logging (copy), Promise (copy)
			Logging.warn("GetRecommendedItems looks hydration failure: " .. tostring(p10))

			return Promise.reject({
				HttpError = Enum.HttpError.OK
			})
		end)
	end, function(p11) -- line: 168
		-- upvalues: Logging (copy), Promise (copy)
		Logging.warn("GetRecommendedItems looks widget failure: " .. tostring(p11))

		return Promise.reject({
			HttpError = Enum.HttpError.OK
		})
	end)
end

return function(p12, p13, s6: string) -- line: 174
	-- upvalues: ArgCheck (copy), AXEditorRecommendationCarousel (copy), IxpUtils (copy), Constants2 (copy), Constants (copy), FFlagAXAvatarTabLooksYouMayAlsoLike (copy), GetFFlagAXEnableRecommendationTypeAllInCustomize (copy), ReducerUtils (copy), PerformFetch (copy), v20 (copy), fetchRecommendedLooks (copy), HttpService (copy), Promise (copy), fetchRecommendedItems (copy), WebApi (copy), SetAssetInfoFromAvatarEditorRecommendedItemsV2 (copy), SetBundleInfoFromAvatarEditorRecommendedItemsV2 (copy), SetRecommendedItemsV2 (copy), Logging (copy)
	return function(p14, p15) -- line: 175
		-- upvalues: ArgCheck (copy), p12 (copy), p13 (copy), s6 (copy), AXEditorRecommendationCarousel (copy), IxpUtils (copy), Constants2 (copy), Constants (copy), FFlagAXAvatarTabLooksYouMayAlsoLike (copy), GetFFlagAXEnableRecommendationTypeAllInCustomize (copy), ReducerUtils (copy), PerformFetch (copy), v20 (copy), fetchRecommendedLooks (copy), HttpService (copy), Promise (copy), fetchRecommendedItems (copy), WebApi (copy), SetAssetInfoFromAvatarEditorRecommendedItemsV2 (copy), SetBundleInfoFromAvatarEditorRecommendedItemsV2 (copy), SetRecommendedItemsV2 (copy), Logging (copy)
		ArgCheck.isType(p12, "function", "GetRecommendedItems thunk expects networkImpl")
		ArgCheck.isTypeOrNil(p13, "string", "GetRecommendedItems thunk expects assetTypeIdString")
		ArgCheck.isType(s6, "string", "GetRecommendedItems thunk expects recommendationsType")

		local v66 = if not AXEditorRecommendationCarousel.isEnabled() then nil else IxpUtils.readTestVariable(AXEditorRecommendationCarousel.EnableAvatarEditorRecommendationCarousel)

		if not s6 or s6 == Constants2.RecommendationsType.None then
			return nil
		end

		local u67 = p13
		local u68 = p13
		local u69 = true

		if s6 ~= Constants2.RecommendationsType.Asset then
			u67 = s6
			u69 = false

			if s6 == Constants2.RecommendationsType.BodyParts then
				u68 = Constants.BundleTypeIdStrings.BodyParts
			elseif s6 == Constants2.RecommendationsType.AvatarAnimations then
				u68 = Constants.BundleTypeIdStrings.Animations
			elseif s6 == Constants2.RecommendationsType.Shoes then
				u68 = Constants.BundleTypeIdStrings.Shoes
			elseif s6 == Constants2.RecommendationsType.DynamicHeads then
				u68 = Constants.BundleTypeIdStrings.DynamicHead
			end
		end

		if FFlagAXAvatarTabLooksYouMayAlsoLike and GetFFlagAXEnableRecommendationTypeAllInCustomize() and s6 == Constants2.RecommendationsType.AvatarLooks then
			local v70 = ReducerUtils.generateRecommendedItemsKey(u67, s6)

			return PerformFetch.Single(Constants.RecommendedItemsKey .. tostring(v70), function(p16) -- line: 214
				-- upvalues: v66 (copy), v20 (copy), fetchRecommendedLooks (copy), p12 (copy), u67 (ref), s6 (copy), HttpService (copy)
				local v88 = nil

				if v66 then
					v88 = v20
				end

				return fetchRecommendedLooks(p16, p12, u67, s6, HttpService:GenerateGUID(false), v88)
			end)(p14)
		end

		if GetFFlagAXEnableRecommendationTypeAllInCustomize() and s6 == Constants2.RecommendationsType.All then
			local avatarEditorService = p15.avatarEditorService

			return Promise.new(function(resolve, reject) -- line: 237
				-- upvalues: PerformFetch (copy), u67 (ref), Constants (copy), fetchRecommendedItems (copy), avatarEditorService (copy), s6 (copy), p14 (copy)
				local Single = PerformFetch.Single
				local v92 = u67

				return Single(Constants.RecommendedItemsKey .. tostring(v92), function(p17) -- line: 238
					-- upvalues: fetchRecommendedItems (copy), avatarEditorService (copy), u67 (ref), s6 (copy), resolve (copy), reject (copy)
					return fetchRecommendedItems(p17, avatarEditorService, u67, s6, resolve, reject)
				end)(p14)
			end)
		end

		local Single = PerformFetch.Single
		local v73 = u67

		return Single(Constants.RecommendedItemsKey .. tostring(v73), function(p18) -- line: 244
			-- upvalues: v66 (copy), v20 (copy), WebApi (copy), p12 (copy), u68 (ref), u69 (ref), SetAssetInfoFromAvatarEditorRecommendedItemsV2 (copy), p13 (copy), SetBundleInfoFromAvatarEditorRecommendedItemsV2 (copy), GetFFlagAXEnableRecommendationTypeAllInCustomize (copy), SetRecommendedItemsV2 (copy), u67 (ref), s6 (copy), Promise (copy), Logging (copy)
			local v94 = nil

			if v66 then
				v94 = v20
			end

			return WebApi.GetRecommendations(p12, u68, u69, v94):andThen(function(p19) -- line: 251
				-- upvalues: u69 (ref), p18 (copy), SetAssetInfoFromAvatarEditorRecommendedItemsV2 (copy), p13 (copy), SetBundleInfoFromAvatarEditorRecommendedItemsV2 (copy), GetFFlagAXEnableRecommendationTypeAllInCustomize (copy), SetRecommendedItemsV2 (copy), u67 (ref), s6 (copy), Promise (copy), Logging (copy), u68 (ref)
				local v97 = p19 and (p19.responseBody and p19.responseBody.data)

				if v97 then
					if u69 then
						p18:dispatch(SetAssetInfoFromAvatarEditorRecommendedItemsV2(v97, p13))
					else
						p18:dispatch(SetBundleInfoFromAvatarEditorRecommendedItemsV2(v97))
					end

					if GetFFlagAXEnableRecommendationTypeAllInCustomize() then
						p18:dispatch(SetRecommendedItemsV2(v97, u67, s6))
					else
						p18:dispatch(SetRecommendedItemsV2(v97, u67))
					end

					return Promise.resolve(v97)
				end

				Logging.warn("Response from GetRecommendations with recommendationId of " .. tostring(u68) .. " is malformed!")

				return Promise.reject({
					HttpError = Enum.HttpError.OK
				})
			end)
		end)(p14)
	end
end
