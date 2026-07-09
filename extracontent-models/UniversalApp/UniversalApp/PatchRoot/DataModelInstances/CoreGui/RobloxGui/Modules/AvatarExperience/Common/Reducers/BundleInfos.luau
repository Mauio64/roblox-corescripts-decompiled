local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local BundleInfo = require(Modules.AvatarExperience.Common.Models.BundleInfo)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local SetRecommendedBundlesAction = require(Modules.AvatarExperience.Catalog.Actions.SetRecommendedBundlesAction)
local SetBundleInfoFromCatalogItemAction = require(Modules.AvatarExperience.Catalog.Actions.SetBundleInfoFromCatalogItemAction)
local SetBundleInfoFromSortResults = require(Modules.AvatarExperience.Catalog.Actions.SetBundleInfoFromSortResults)
local SetBundleInfoFromAvatarEditorRecommendedItemsV2 = require(Modules.AvatarExperience.AvatarEditor.Actions.SetBundleInfoFromAvatarEditorRecommendedItemsV2)
local SetHydratedWidgetData = require(Modules.AvatarExperience.Catalog.Actions.SetHydratedWidgetData)
local SetBundleOwned = require(Modules.AvatarExperience.Common.Actions.SetBundleOwned)
local PurchaseItemsSuccess = AvatarExperienceCatalog.State.Actions.PurchaseItemsSuccess
local FetchAssetOrBundleInfoBatchedSuccess = AvatarExperienceCatalog.State.Actions.FetchAssetOrBundleInfoBatchedSuccess
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants

require(Modules.AvatarExperience.Common.Types)

local ReceivedRecentlyViewedItemsData = require(Modules.AvatarExperience.Catalog.Actions.ReceivedRecentlyViewedItemsData)
local AXRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local ClearReceivedCatalogData = require(Modules.AvatarExperience.Common.Actions.ClearReceivedCatalogData)
local FFlagAXSubscriptionRefetchClearCatalogData = AvatarExperienceFlags.FFlagAXSubscriptionRefetchClearCatalogData
local FFlagAXSubscriptionRefetchEvictStores = AvatarExperienceFlags.FFlagAXSubscriptionRefetchEvictStores

return Rodux.createReducer({}, {
	[SetBundleInfoFromCatalogItemAction.name] = function(p1, p2) -- line: 46
		-- upvalues: ArgCheck (copy), BundleInfo (copy), Cryo (copy)
		ArgCheck.isType(p2.bundleId, "string", "bundleId must be a string.")
		ArgCheck.isType(p2.bundleData, "table", "bundleData must be a table.")

		local str = tostring(p2.bundleId)
		local v30 = p1[str]
		local v31 = BundleInfo.fromGetCatalogItemData(p2.bundleData, v30)

		return Cryo.Dictionary.join(p1, {
			[str] = v31
		})
	end,
	[SetBundleInfoFromAvatarEditorRecommendedItemsV2.name] = function(p3, p4) -- line: 58
		-- upvalues: ArgCheck (copy), BundleInfo (copy), Cryo (copy)
		ArgCheck.isType(p4.bundles, "table", "bundles must be a table.")

		local t1 = {}

		for _, v36 in p4.bundles do
			local str = tostring(v36.id)
			local v38 = p3[str]

			t1[str] = BundleInfo.fromGetRecommendedItemsDataV2(v36, v38)
		end

		return Cryo.Dictionary.join(p3, t1)
	end,
	[SetHydratedWidgetData.name] = function(p5, p6) -- line: 74
		-- upvalues: ArgCheck (copy), WidgetConstants (copy), BundleInfo (copy), Cryo (copy)
		ArgCheck.isType(p6.payload, "table", "payload must be a table.")

		if not p6.payload[WidgetConstants.ContentType.Bundle] then
			return p5
		end

		local t2 = {}

		for _, v43 in p6.payload[WidgetConstants.ContentType.Bundle] do
			local str = tostring(v43.id)
			local v45 = p5[str]

			t2[str] = BundleInfo.fromHydrateWidgetInfo(v43, v45)
		end

		return Cryo.Dictionary.join(p5, t2)
	end,
	[SetBundleInfoFromSortResults.name] = function(p7, p8) -- line: 91
		-- upvalues: ArgCheck (copy), BundleInfo (copy), Cryo (copy)
		ArgCheck.isType(p8.sortResults, "table", "sortResults must be a table.")

		local t3 = {}

		for _, v50 in p8.sortResults do
			local str = tostring(v50.id)
			local v52 = p7[str]

			t3[str] = BundleInfo.fromSortResults(v50, v52)
		end

		return Cryo.Dictionary.join(p7, t3)
	end,
	[SetRecommendedBundlesAction.name] = function(p9, p10) -- line: 108
		-- upvalues: ArgCheck (copy), BundleInfo (copy), Constants (copy), Cryo (copy)
		ArgCheck.isType(p10.bundleId, "string", "bundleId must be a string.")
		ArgCheck.isType(p10.recommendedItems, "table", "recommendedItems must be a table.")

		local str = tostring(p10.bundleId)
		local t4 = {}
		local t5 = {}

		for _, v59 in p10.recommendedItems do
			local str2 = tostring(v59.id)
			local v61 = p9[str2]

			t4[str2] = BundleInfo.fromGetRecommendedItemsDataV2(v59, v61)
			t5[#t5 + 1] = {
				id = str2,
				type = Constants.ItemType.Bundle,
				subType = tostring(v59.bundleType)
			}
		end

		local v62 = p9[str]

		t4[str] = BundleInfo.fromRecommendedItemSummaries(t5, v62)

		return Cryo.Dictionary.join(p9, t4)
	end,
	[SetBundleOwned.name] = function(p11, p12) -- line: 137
		-- upvalues: ArgCheck (copy), BundleInfo (copy), Cryo (copy)
		ArgCheck.isType(p12.bundleId, "string", "bundleId must be a string.")
		ArgCheck.isType(p12.isOwned, "boolean", "isOwned must be a bool.")

		local str = tostring(p12.bundleId)
		local v66 = p11[str]
		local v67 = BundleInfo.fromIsOwned(p12.isOwned, v66)

		return Cryo.Dictionary.join(p11, {
			[str] = v67
		})
	end,
	[ReceivedRecentlyViewedItemsData.name] = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() then nil else function(p13, p14) -- line: 148
		-- upvalues: BundleInfo (copy)
		local v70 = table.clone(p13)

		for _, v72 in p14.bundleData or {} do
			local str = tostring(v72.id)
			local v74 = p13[str]

			v70[str] = BundleInfo.fromSortResults(v72, v74)
		end

		return v70
	end,
	[PurchaseItemsSuccess.name] = if not FFlagAXMISEnableMultiShopping then nil else function(p15, p16) -- line: 162
		-- upvalues: Cryo (copy)
		local v77 = p15 or {}
		local t6 = {}

		for _, v80 in p16.items do
			if v80.itemType == Enum.AvatarItemType.Bundle.Name then
				local str = tostring(v80.itemId)
				local v82 = v77[str]

				if v82 then
					t6[str] = Cryo.Dictionary.join(v82, {
						isOwned = true
					})
				end
			end
		end

		return Cryo.Dictionary.join(v77, t6)
	end,
	[FetchAssetOrBundleInfoBatchedSuccess.name] = if not FFlagAXMISEnableMultiShopping then nil else function(p17, p18) -- line: 184
		-- upvalues: BundleInfo (copy), Cryo (copy)
		local v85 = p17 or {}
		local t7 = {}

		for _, v88 in p18.hydratedBundles do
			local str = tostring(v88.id)
			local v90 = v85[str]

			t7[str] = BundleInfo.fromGetCatalogItemData(v88, v90)
		end

		return Cryo.Dictionary.join(v85, t7)
	end,
	[ClearReceivedCatalogData.name] = if not FFlagAXSubscriptionRefetchClearCatalogData then nil else function(p19, _) -- line: 204
		-- upvalues: FFlagAXSubscriptionRefetchEvictStores (copy), Cryo (copy)
		if FFlagAXSubscriptionRefetchEvictStores then
			if next(p19) == nil then
				return p19
			end

			return {}
		end

		local t8 = {}

		for v94, v95 in p19 do
			if v95.receivedCatalogData then
				t8[v94] = Cryo.Dictionary.join(v95, {
					receivedCatalogData = false
				})
			end
		end

		if next(t8) == nil then
			return p19
		end

		return Cryo.Dictionary.join(p19, t8)
	end
})
