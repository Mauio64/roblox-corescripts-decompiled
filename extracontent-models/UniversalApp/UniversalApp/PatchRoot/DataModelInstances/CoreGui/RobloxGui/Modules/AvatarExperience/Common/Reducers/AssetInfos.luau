local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local AssetInfo = require(Modules.AvatarExperience.Common.Models.AssetInfo)
local SetRecommendedAssetsAction = require(Modules.AvatarExperience.Catalog.Actions.SetRecommendedAssetsAction)
local SetAssetInfoFromInventoryFetch = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAssetInfoFromInventoryFetch)
local SetAssetInfoFromOutfitDetails = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAssetInfoFromOutfitDetails)
local SetAssetInfoFromCatalogItemAction = require(Modules.AvatarExperience.Catalog.Actions.SetAssetInfoFromCatalogItemAction)
local SetAssetInfoFromBundleItemAction = require(Modules.AvatarExperience.Catalog.Actions.SetAssetInfoFromBundleItemAction)
local SetAssetInfoFromSortResults = require(Modules.AvatarExperience.Catalog.Actions.SetAssetInfoFromSortResults)
local SetBundleInfoFromSortResults = require(Modules.AvatarExperience.Catalog.Actions.SetBundleInfoFromSortResults)
local SetAssetInfoFromAvatarEditorRecommendedItemsV2 = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAssetInfoFromAvatarEditorRecommendedItemsV2)
local SetHydratedWidgetData = require(Modules.AvatarExperience.Catalog.Actions.SetHydratedWidgetData)
local AppendAssetResellersList = require(Modules.AvatarExperience.Catalog.Actions.AppendAssetResellersList)
local SetAssetResellersList = require(Modules.AvatarExperience.Catalog.Actions.SetAssetResellersList)
local SetAssetLowestPrice = require(Modules.AvatarExperience.Catalog.Actions.SetAssetLowestPrice)
local SetAssetResaleData = require(Modules.AvatarExperience.Catalog.Actions.SetAssetResaleData)
local SetAssetVersionData = require(Modules.AvatarExperience.Catalog.Actions.SetAssetVersionData)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local SetAssetOwned = require(Modules.AvatarExperience.Common.Actions.SetAssetOwned)
local GrantAsset = require(Modules.AvatarExperience.AvatarEditor.Actions.GrantAsset)
local UpdateAssetModerationStatus = require(Modules.AvatarExperience.AvatarEditor.Actions.UpdateAssetModerationStatus)
local OutfitInformationReceived = require(Modules.AvatarExperience.Common.Actions.OutfitInformationReceived)

require(Modules.AvatarExperience.Common.Types)

local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local AXCombineGetOutfitDispatchesIXP = require(Modules.AvatarExperience.Experiments.AXCombineGetOutfitDispatchesIXP)
local PurchaseItemsSuccess = AvatarExperienceCatalog.State.Actions.PurchaseItemsSuccess
local FetchAssetOrBundleInfoBatchedSuccess = AvatarExperienceCatalog.State.Actions.FetchAssetOrBundleInfoBatchedSuccess
local ReceivedRecentlyViewedItemsData = require(Modules.AvatarExperience.Catalog.Actions.ReceivedRecentlyViewedItemsData)
local AXRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local ReceivedAvatarData = require(Modules.AvatarExperience.AvatarEditor.Actions.ReceivedAvatarData)
local ClearReceivedCatalogData = require(Modules.AvatarExperience.Common.Actions.ClearReceivedCatalogData)
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local FFlagAXSubscriptionRefetchClearCatalogData = AvatarExperienceFlags.FFlagAXSubscriptionRefetchClearCatalogData
local FFlagAXSubscriptionRefetchEvictStores = AvatarExperienceFlags.FFlagAXSubscriptionRefetchEvictStores

return Rodux.createReducer({}, {
	[SetAssetInfoFromCatalogItemAction.name] = function(p1, p2) -- line: 63
		-- upvalues: ArgCheck (copy), AssetInfo (copy), Cryo (copy)
		ArgCheck.isType(p2.assetId, "string", "assetId must be a string.")
		ArgCheck.isType(p2.assetData, "table", "assetData must be a table.")

		local str = tostring(p2.assetId)
		local v45 = p1[str]
		local v46 = AssetInfo.fromGetCatalogItemData(p2.assetData, v45)

		return Cryo.Dictionary.join(p1, {
			[str] = v46
		})
	end,
	[SetAssetInfoFromBundleItemAction.name] = function(p3, p4) -- line: 76
		-- upvalues: ArgCheck (copy), AssetInfo (copy), Cryo (copy)
		ArgCheck.isType(p4.assets, "table", "assets data must be a table.")

		local t1 = {}

		for _, v51 in p4.assets do
			local str = tostring(v51.id)
			local v53 = p3[str]

			t1[str] = AssetInfo.fromBundleItemData(v51, v53)
		end

		return Cryo.Dictionary.join(p3, t1)
	end,
	[SetAssetInfoFromSortResults.name] = function(p5, p6) -- line: 90
		-- upvalues: ArgCheck (copy), AssetInfo (copy), Cryo (copy)
		ArgCheck.isType(p6.sortResults, "table", "sortResults must be a table.")

		local t2 = {}

		for _, v58 in p6.sortResults do
			local str = tostring(v58.id)
			local v60 = p5[str]

			t2[str] = AssetInfo.fromSortResults(v58, v60)
		end

		return Cryo.Dictionary.join(p5, t2)
	end,
	[SetBundleInfoFromSortResults.name] = function(p7, p8) -- line: 108
		-- upvalues: Constants (copy), AssetInfo (copy), Cryo (copy)
		local t3 = {}

		for _, v65 in p8.sortResults do
			if v65.bundledItems then
				for _, v67 in v65.bundledItems do
					if v67.type == Constants.ItemType.Asset then
						local str = tostring(v67.id)
						local v69 = p7[str]

						t3[str] = AssetInfo.fromBundledItems(v67, v69)
					end
				end
			end
		end

		return Cryo.Dictionary.join(p7, t3)
	end,
	[SetRecommendedAssetsAction.name] = function(p9, p10) -- line: 126
		-- upvalues: ArgCheck (copy), AssetInfo (copy), Constants (copy), Cryo (copy)
		ArgCheck.isType(p10.recommendedItems, "table", "recommendedItems must be a table.")

		local str = tostring(p10.assetId)
		local t4 = {}
		local t5 = {}

		for _, v76 in p10.recommendedItems do
			local str2 = tostring(v76.item.assetId)
			local v78 = p9[str2]
			local v79 = AssetInfo.fromGetRecommendedItemsData(v76, p10.assetTypeId, v78)
			local assetTypeId = p10.assetTypeId

			t4[str2] = v79
			table.insert(t5, {
				id = str2,
				type = Constants.ItemType.Asset,
				subType = assetTypeId
			})
		end

		local v81 = p9[str]

		t4[str] = AssetInfo.fromRecommendedItemSummaries(t5, v81)

		return Cryo.Dictionary.join(p9, t4)
	end,
	[SetAssetResaleData.name] = function(p11, p12) -- line: 165
		-- upvalues: ArgCheck (copy), AssetInfo (copy), Cryo (copy)
		ArgCheck.isType(p12.assetResaleData, "table", "assetResaleData must be a table.")

		local str = tostring(p12.assetId)
		local v85 = p11[str]
		local v86 = AssetInfo.fromResaleData(p12.assetResaleData, v85)

		return Cryo.Dictionary.join(p11, {
			[str] = v86
		})
	end,
	[SetAssetInfoFromInventoryFetch.name] = function(p13, p14) -- line: 177
		-- upvalues: ArgCheck (copy), AssetInfo (copy), Cryo (copy)
		ArgCheck.isType(p14.assets, "table", "assets must be a table.")

		local t6 = {}

		for _, v91 in p14.assets do
			local str = tostring(v91.assetId)
			local v93 = p13[str]

			t6[str] = AssetInfo.fromInventoryFetch(v91, v93)
		end

		return Cryo.Dictionary.join(p13, t6)
	end,
	[SetAssetInfoFromOutfitDetails.name] = function(p15, p16) -- line: 195
		-- upvalues: ArgCheck (copy), AssetInfo (copy), Cryo (copy)
		ArgCheck.isType(p16.assets, "table", "assets must be a table.")

		local t7 = {}

		for _, v98 in p16.assets do
			local str = tostring(v98.id)
			local v100 = p15[str]

			t7[str] = AssetInfo.fromOutfitDetails(v98, v100, p16.outfitModerationStatus)
		end

		return Cryo.Dictionary.join(p15, t7)
	end,
	[SetAssetResellersList.name] = function(p17, p18) -- line: 210
		-- upvalues: ArgCheck (copy), AssetInfo (copy), Cryo (copy)
		ArgCheck.isType(p18.assetId, "string", "assetId must be a sting.")
		ArgCheck.isType(p18.userAssetIds, "table", "userAssetIds must be a table.")

		local str = tostring(p18.assetId)
		local v104 = p17[str]
		local v105 = AssetInfo.fromGetResellers(p18.userAssetIds, v104)

		return Cryo.Dictionary.join(p17, {
			[str] = v105
		})
	end,
	[AppendAssetResellersList.name] = function(p19, p20) -- line: 222
		-- upvalues: ArgCheck (copy), AssetInfo (copy), Cryo (copy)
		ArgCheck.isType(p20.assetId, "string", "assetId must be a sting.")
		ArgCheck.isType(p20.userAssetIds, "table", "userAssetIds must be a table.")

		local str = tostring(p20.assetId)
		local v109 = if not p19[str] then AssetInfo.mock() else p19[str]
		local resellerUserAssetIds = v109.resellerUserAssetIds
		local v111 = if not resellerUserAssetIds then p20.userAssetIds else Cryo.List.join(resellerUserAssetIds, p20.userAssetIds)
		local v112 = AssetInfo.fromGetResellers(v111, v109)

		return Cryo.Dictionary.join(p19, {
			[str] = Cryo.Dictionary.join(v109, v112)
		})
	end,
	[SetAssetLowestPrice.name] = function(p21, p22) -- line: 244
		-- upvalues: ArgCheck (copy), AssetInfo (copy), Cryo (copy)
		ArgCheck.isType(p22.assetId, "string", "assetId must be a sting.")
		ArgCheck.isType(p22.priceInRobux, "number", "price must be a number.")

		local assetId = p22.assetId
		local priceInRobux = p22.priceInRobux
		local v117 = p21[assetId]
		local v118 = AssetInfo.fromLowestPrice(priceInRobux, v117)

		return Cryo.Dictionary.join(p21, {
			[assetId] = v118
		})
	end,
	[SetAssetInfoFromAvatarEditorRecommendedItemsV2.name] = function(p23, p24) -- line: 258
		-- upvalues: ArgCheck (copy), AssetInfo (copy), Cryo (copy)
		ArgCheck.isType(p24.assets, "table", "assets must be a table.")
		ArgCheck.isType(p24.assetTypeId, "string", "assetTypeId must be a string.")

		local assetTypeId = p24.assetTypeId
		local t8 = {}

		for _, v124 in p24.assets do
			local str = tostring(v124.id)
			local v126 = p23[str]

			t8[str] = AssetInfo.fromGetRecommendedItemsDataV2(v124, assetTypeId, v126)
		end

		return Cryo.Dictionary.join(p23, t8)
	end,
	[SetHydratedWidgetData.name] = function(p25, p26) -- line: 279
		-- upvalues: ArgCheck (copy), WidgetConstants (copy), AssetInfo (copy), Cryo (copy)
		ArgCheck.isType(p26.payload, "table", "payload must be a table.")

		if not p26.payload[WidgetConstants.ContentType.Asset] then
			return p25
		end

		local t9 = {}

		for _, v131 in p26.payload[WidgetConstants.ContentType.Asset] do
			local str = tostring(v131.id)
			local v133 = p25[str]
			local v134 = AssetInfo.fromHydrateWidgetInfo(v131, v133)

			t9[str] = Cryo.Dictionary.join(v134, v134)
		end

		return Cryo.Dictionary.join(p25, t9)
	end,
	[SetAssetOwned.name] = function(p27, p28) -- line: 299
		-- upvalues: ArgCheck (copy), AssetInfo (copy), Cryo (copy)
		ArgCheck.isType(p28.assetId, "string", "assetId must be a string.")
		ArgCheck.isType(p28.isOwned, "boolean", "isOwned must be a bool.")

		local str = tostring(p28.assetId)
		local v138 = p27[str]
		local v139 = AssetInfo.fromIsOwned(p28.isOwned, v138)

		return Cryo.Dictionary.join(p27, {
			[str] = v139
		})
	end,
	[GrantAsset.name] = function(p29, p30) -- line: 309
		-- upvalues: AssetInfo (copy), Cryo (copy)
		local str = tostring(p30.assetTypeId)
		local str3 = tostring(p30.assetId)
		local v144 = AssetInfo.fromAssetGrant(str3, str)
		local v145 = p29[str3]

		if v145 and v145.assetType then
			return p29
		end

		if v145 then
			v144 = Cryo.Dictionary.join(v145, v144)
		end

		return Cryo.Dictionary.join(p29, {
			[str3] = v144
		})
	end,
	[UpdateAssetModerationStatus.name] = function(p31, p32) -- line: 329
		-- upvalues: ArgCheck (copy), AssetInfo (copy), Cryo (copy)
		ArgCheck.isType(p32.assetId, "string", "assetId must be a string.")

		local str = tostring(p32.assetId)
		local v149 = p31[str]
		local n1 = 1

		if v149 and v149.updateCounter then
			n1 = v149.updateCounter + 1
		end

		local v151 = AssetInfo.fromModerationStatusUpdate(p32.moderationStatus, n1, str, p32.assetName, p32.universeId, v149)

		return Cryo.Dictionary.join(p31, {
			[str] = v151
		})
	end,
	[ReceivedAvatarData.name] = function(p33, p34) -- line: 349
		-- upvalues: AssetInfo (copy), Cryo (copy)
		local assets = p34.avatarData.assets

		if assets == nil then
			return p33
		end

		local t10 = {}

		for _, v157 in assets do
			local str = tostring(v157.id)
			local v159 = AssetInfo.fromReceivedAvatarData(v157)
			local v160 = p33[str]

			if not v160 then
				t10[str] = v159
			else
				t10[str] = Cryo.Dictionary.join(v159, v160)
			end
		end

		return Cryo.Dictionary.join(p33, t10)
	end,
	[SetAssetVersionData.name] = function(p35, p36) -- line: 386
		-- upvalues: ArgCheck (copy), AssetInfo (copy), Cryo (copy)
		ArgCheck.isType(p36.assetVersionData, "table", "assetVersionData must be a table.")

		local str = tostring(p36.assetId)
		local v164 = p35[str]
		local v165 = AssetInfo.fromVersionData(p36.assetVersionData, v164)

		return Cryo.Dictionary.join(p35, {
			[str] = v165
		})
	end,
	[OutfitInformationReceived.name] = if not AXCombineGetOutfitDispatchesIXP.isEnabled() then nil else function(p37, p38) -- line: 399
		-- upvalues: AssetInfo (copy)
		local v168 = table.clone(p37)

		for _, v170 in p38.outfits do
			local assetsToUpdate = v170.assetsToUpdate
			local outfitModerationStatus = v170.outfitModerationStatus

			if assetsToUpdate then
				for _, v174 in assetsToUpdate do
					local str = tostring(v174.id)

					v168[str] = AssetInfo.fromOutfitDetails(v174, p37[str], outfitModerationStatus)
				end
			end
		end

		return v168
	end,
	[ReceivedRecentlyViewedItemsData.name] = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() then nil else function(p39, p40) -- line: 419
		-- upvalues: AssetInfo (copy)
		local v178 = table.clone(p39)

		for _, v180 in p40.assetData or {} do
			local str = tostring(v180.id)
			local v182 = p39[str]

			v178[str] = AssetInfo.fromSortResults(v180, v182)
		end

		return v178
	end,
	[PurchaseItemsSuccess.name] = if not FFlagAXMISEnableMultiShopping then nil else function(p41, p42) -- line: 433
		-- upvalues: Cryo (copy)
		local v185 = p41 or {}
		local t11 = {}

		for _, v188 in p42.items do
			if v188.itemType == Enum.AvatarItemType.Asset.Name then
				local str = tostring(v188.itemId)
				local v190 = v185[str]

				if v190 then
					t11[str] = Cryo.Dictionary.join(v190, {
						isOwned = true
					})
				end
			end
		end

		return Cryo.Dictionary.join(v185, t11)
	end,
	[FetchAssetOrBundleInfoBatchedSuccess.name] = if not FFlagAXMISEnableMultiShopping and not FFlagAXInventoryDurablesExpiredFilter then nil else function(p43, p44) -- line: 456
		-- upvalues: AssetInfo (copy), Cryo (copy)
		local v193 = p43 or {}
		local hydratedAssets = p44.hydratedAssets
		local assetsInBundle = p44.assetsInBundle

		if #hydratedAssets > 0 then
			local t12 = {}

			for _, v198 in hydratedAssets do
				local str = tostring(v198.id)
				local v200 = v193[str]

				t12[str] = AssetInfo.fromGetCatalogItemData(v198, v200)
			end

			v193 = Cryo.Dictionary.join(v193, t12)
		end

		if #assetsInBundle > 0 then
			local t13 = {}

			for _, v203 in assetsInBundle do
				local str = tostring(v203.id)
				local v205 = v193[str]

				t13[str] = AssetInfo.fromBundleItemData(v203, v205)
			end

			v193 = Cryo.Dictionary.join(v193, t13)
		end

		return v193
	end,
	[ClearReceivedCatalogData.name] = if not FFlagAXSubscriptionRefetchClearCatalogData then nil else function(p45, _) -- line: 495
		-- upvalues: FFlagAXSubscriptionRefetchEvictStores (copy), Cryo (copy)
		if FFlagAXSubscriptionRefetchEvictStores then
			if next(p45) == nil then
				return p45
			end

			return {}
		end

		local t14 = {}

		for v209, v210 in p45 do
			if v210.receivedCatalogData then
				t14[v209] = Cryo.Dictionary.join(v210, {
					receivedCatalogData = false
				})
			end
		end

		if next(t14) == nil then
			return p45
		end

		return Cryo.Dictionary.join(p45, t14)
	end
})
