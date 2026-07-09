local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local Modules = CoreGui.RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Dash = require(CorePackages.Packages.Dash)

require(CorePackages.Workspace.Packages.Http)
require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local ShareLinksNetworking = require(CorePackages.Workspace.Packages.ShareLinksNetworking)
local FFlagQRCodeItemRedemptionEnabled = require(Modules.AvatarExperience.Flags.FFlagQRCodeItemRedemptionEnabled)
local FFlagAXCatalogMakeupSupport = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCatalogMakeupSupport
local v14 = string.format("https://develop.%s", Url.DOMAIN)
local t4 = {
	FetchSponsoredItems = function(p1, s1: string?, n1: number?) -- line: 61
		-- upvalues: Url (copy)
		local v19 = string.format("%sv1/catalog/sponsored-items?model.placementLocation=AvatarShop", Url.CATALOG_URL)

		if s1 then
			v19 ..= "&model.catalogCategoryType=" .. s1
		end

		if n1 then
			v19 ..= "&model.count=" .. tostring(n1)
		end

		return p1(v19, "GET")
	end,
	FetchWidgets = function(p2, s2: string?, s3: string?) -- line: 75
		-- upvalues: Url (copy)
		local v23 = Url:makeQueryString({
			requestId = s2,
			context = s3
		})

		return p2(string.format("%smarketplace-widgets/v1/widgets?%s", Url.APIS_URL, v23), "GET")
	end,
	FetchWidgetsSearch = function(p3, s4: string?, s5: string) -- line: 85
		-- upvalues: Url (copy)
		local v27 = Url:makeQueryString({
			query = s5,
			requestId = s4
		})

		return p3(string.format("%smarketplace-widgets/v1/widgets/search?%s", Url.APIS_URL, v27), "GET")
	end,
	HydrateWidgetContent = function(p4, t1: {[any]: any}) -- line: 95
		-- upvalues: Url (copy), HttpService (copy)
		return p4(string.format("%smarketplace-widgets/v1/widgets/hydrate", Url.APIS_URL), "POST", {
			postBody = HttpService:JSONEncode({
				Content = t1
			})
		})
	end,
	TrackSponsoredItemClick = function(p5, s6: string) -- line: 105
		-- upvalues: Url (copy), HttpService (copy)
		return p5(string.format("%sv2/tracking/click", Url.AD_CONFIGURATION_URL), "POST", {
			postBody = HttpService:JSONEncode({
				campaignTargetType = "Asset",
				placementLocation = "AvatarShop",
				encryptedAdTrackingData = s6
			})
		})
	end,
	FetchItemDetail = function(p6, s7: string, s8: string) -- line: 117
		-- upvalues: Url (copy)
		local v35 = Url:makeQueryString({
			itemType = s8
		})

		return p6(string.format("%sv1/catalog/items/%s/details?%s", Url.CATALOG_URL, tostring(s7), v35), "GET")
	end,
	FetchItemDetails = function(p7, t2: {[any]: any}) -- line: 125
		-- upvalues: Url (copy), HttpService (copy)
		return p7(string.format("%sv1/catalog/items/details", Url.CATALOG_URL), "POST", {
			postBody = HttpService:JSONEncode({
				items = t2
			})
		})
	end,
	FetchCollectibleItemDetails = function(p8, t3: {[any]: any}) -- line: 133
		-- upvalues: Url (copy), HttpService (copy)
		return p8(string.format("%smarketplace-items/v1/items/details", Url.APIS_URL), "POST", {
			postBody = HttpService:JSONEncode({
				itemIds = t3
			})
		})
	end,
	PurchaseProduct = function(p9, p10, p11, p12, p13) -- line: 141
		-- upvalues: ArgCheck (copy), Url (copy), HttpService (copy), CatalogConstants (copy)
		ArgCheck.isType(p10, "string", "CatalogWebApi.PurchaseProduct: productId")
		ArgCheck.isNonNegativeNumber(p11, "CatalogWebApi.PurchaseProduct: expectedPrice")
		ArgCheck.isType(p12, "string", "CatalogWebApi.PurchaseProduct: expectedSellerId")

		return p9(string.format("%sv1/purchases/products/%s", Url.ECONOMY_URL, p10), "POST", {
			postBody = HttpService:JSONEncode({
				expectedCurrency = CatalogConstants.ExpectedCurrencyRobux,
				expectedPrice = tostring(p11),
				expectedSellerId = tostring(p12),
				userAssetId = p13
			})
		})
	end,
	PurchaseCollectibleItem = function(p14, p15, p16, p17, p18, p19, p20, p21, p22) -- line: 163
		-- upvalues: Url (copy), HttpService (copy), CatalogConstants (copy)
		return p14(string.format("%smarketplace-sales/v1/item/%s/purchase-item", Url.APIS_URL, p15), "POST", {
			postBody = HttpService:JSONEncode({
				expectedCurrency = CatalogConstants.ExpectedCurrencyRobux,
				expectedPrice = tostring(p17),
				expectedSellerId = tostring(p18),
				expectedPurchaserId = p20,
				expectedPurchaserType = CatalogConstants.CreatorType.User,
				expectedSellerType = p19,
				collectibleProductId = p16,
				idempotencyKey = p21,
				rentalOptionDays = p22
			})
		})
	end,
	PurchaseCollectibleItemResale = function(p23, p24, p25, p26, p27, p28, p29, p30, p31) -- line: 189
		-- upvalues: Url (copy), HttpService (copy), CatalogConstants (copy)
		return p23(string.format("%smarketplace-sales/v1/item/%s/purchase-resale", Url.APIS_URL, p24), "POST", {
			postBody = HttpService:JSONEncode({
				expectedCurrency = CatalogConstants.ExpectedCurrencyRobux,
				expectedPrice = tostring(p27),
				expectedSellerId = tostring(p28),
				expectedPurchaserId = p30,
				expectedPurchaserType = CatalogConstants.CreatorType.User,
				expectedSellerType = p29,
				collectibleProductId = p26,
				collectibleItemInstanceId = p25,
				idempotencyKey = p31
			})
		})
	end
}

if FFlagQRCodeItemRedemptionEnabled then
	function t4.RedeemQRCodeItem(p32, p33) -- line: 216
		-- upvalues: ArgCheck (copy), Url (copy)
		ArgCheck.isType(p33, "string", "CatalogWebApi.RedeemQRCodeItem: assetId")

		return p32(string.format("%sv2/qr-code-auto-redeem/%s", Url.ECONOMY_URL, p33), "POST", {
			postBody = ""
		})
	end
end

function t4.FetchSellPageData(p34, p35, p36) -- line: 223
	-- upvalues: Url (copy)
	return p34(string.format("%s/v1/assets/%s/users/%s/resellable-copies", Url.ECONOMY_URL, p35, p36), "GET")
end
function t4.FetchCollectibleResellableInstances(p37, s9: string, s10: string) -- line: 228
	-- upvalues: Url (copy), CatalogConstants (copy)
	local v71 = Url:makeQueryString({
		cursor = "",
		ownerId = s10,
		ownerType = CatalogConstants.CreatorType.User,
		limit = CatalogConstants.MaxOwnedCopiesPerPage
	})

	return p37(string.format("%smarketplace-sales/v1/item/%s/resellable-instances?%s", Url.APIS_URL, s9, v71), "GET")
end
function t4.FetchAssetResellers(p38, p39, p40, _) -- line: 246
	-- upvalues: Url (copy), CatalogConstants (copy)
	local v76 = Url:makeQueryString({
		cursor = p40,
		limit = CatalogConstants.MaxResellersPerPage
	})

	return p38(string.format("%s/v1/assets/%s/resellers?%s", Url.ECONOMY_URL, p39, v76), "GET")
end
function t4.FetchAssetResaleData(p42, p43) -- line: 255
	-- upvalues: Url (copy)
	return p42(string.format("%s/v1/assets/%s/resale-data", Url.ECONOMY_URL, p43), "GET")
end
function t4.FetchCollectibleResaleData(p44, p45) -- line: 260
	-- upvalues: Url (copy)
	return p44(string.format("%smarketplace-sales/v1/item/%s/resale-data", Url.APIS_URL, p45), "GET")
end
function t4.GetCollectibleResellers(p46, p47, p48, p49) -- line: 265
	-- upvalues: Url (copy)
	local v85 = Url:makeQueryString({
		cursor = p48,
		limit = p49
	})

	return p46(string.format("%smarketplace-sales/v1/item/%s/resellers?%s", Url.APIS_URL, p47, v85), "GET")
end
function t4.RemoveCurrentlySellingAsset(p50, p51, p52) -- line: 274
	-- upvalues: HttpService (copy), Url (copy)
	local json = HttpService:JSONEncode({
		price = ""
	})

	return p50(string.format("%s/v1/assets/%s/resellable-copies/%s", Url.ECONOMY_URL, p51, p52), "PATCH", {
		postBody = json
	})
end
function t4.RemoveAvailableToSell(p53, p54, p55, p56) -- line: 282
	-- upvalues: HttpService (copy), Url (copy)
	local json = HttpService:JSONEncode({
		price = p56
	})

	return p53(string.format("%s/v1/assets/%s/resellable-copies/%s", Url.ECONOMY_URL, p54, p55), "PATCH", {
		postBody = json
	})
end
function t4.UpdateCollectibleInstanceResaleState(p57, s11: string, s12: string, s13: string, n2: number?, b1: boolean, n3: number) -- line: 290
	-- upvalues: Url (copy), HttpService (copy), CatalogConstants (copy)
	return p57(string.format("%smarketplace-sales/v1/item/%s/instance/%s/resale", Url.APIS_URL, s11, s12), "PATCH", {
		postBody = HttpService:JSONEncode({
			price = n2,
			isOnSale = b1,
			sellerId = n3,
			sellerType = CatalogConstants.CreatorType.User,
			collectibleProductId = s13
		})
	})
end
function t4.GetMarketplaceFee(p58) -- line: 317
	-- upvalues: Url (copy)
	return p58(string.format("%s/v1/resale-tax-rate", Url.ECONOMY_URL), "GET")
end
function t4.GetCollectibleMarketplaceResaleParameters(p59, s14: string) -- line: 322
	-- upvalues: Url (copy)
	return p59(string.format("%smarketplace-sales/v1/item/%s/get-resale-parameters", Url.APIS_URL, s14), "GET")
end
function t4.ReportItem(p60, p61, p62, p63) -- line: 330
	-- upvalues: HttpService (copy), HttpRbxApiService (copy)
	local t5 = {
		reportingItemTypeName = p60,
		reportingItemId = p61,
		reportCategoryId = p62,
		comment = p63
	}
	local json = HttpService:JSONEncode(t5)

	if json then
		local ok, result = pcall(function() -- line: 340
			-- upvalues: HttpRbxApiService (copy), json (copy)
			return HttpRbxApiService:PostAsync("moderation/reportabuse", json, Enum.ThrottlingPriority.Default, Enum.HttpContentType.ApplicationJson)
		end)

		if ok then
			return result
		end
	end

	return nil
end
function t4.ReportItemV2(s15: string, s16: string, s17: string, s18: string, s19: string, s20: string, s21: string, s22: string, s23: string) -- line: 360
	-- upvalues: HttpService (copy), Url (copy), HttpRbxApiService (copy)
	local t6 = {
		tags = {
			ENTRY_POINT = {
				valueList = {{
					data = s20
				}}
			},
			SUBMITTER_USER_ID = {
				valueList = {{
					data = s15
				}}
			},
			REPORT_TARGET_USER_ID = {
				valueList = {{
					data = s17
				}}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {{
					data = s22
				}}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {{
					data = s21
				}}
			},
			REPORTER_COMMENT = {
				valueList = {{
					data = s23
				}}
			},
			REPORT_TARGET_ASSET_ID = {
				valueList = {{
					data = s16
				}}
			},
			REPORT_TARGET_ASSET_NAME = {
				valueList = {{
					data = s18
				}}
			},
			REPORT_TARGET_ASSET_DESCRIPTION = {
				valueList = {{
					data = s19
				}}
			}
		}
	}
	local json = HttpService:JSONEncode(t6)
	local v124 = Url.APIS_URL .. "abuse-reporting/v2/abuse-report"

	if json then
		local ok, result = pcall(function() -- line: 424
			-- upvalues: HttpRbxApiService (copy), v124 (copy), json (copy)
			return HttpRbxApiService:PostAsyncFullUrl(v124, json, Enum.ThrottlingPriority.Default, Enum.HttpContentType.ApplicationJson)
		end)

		if ok then
			return result
		end
	end

	return nil
end
function t4.AbuseReport(p64, t7: {[any]: any}) -- line: 445
	-- upvalues: HttpService (copy), Url (copy)
	local t8 = {
		tags = {}
	}

	for v130, v131 in t7 do
		local v132 = v131

		if typeof(v132) ~= "table" then
			v132 = { v132 }
		end

		local t9 = {}

		for _, v135 in v132 do
			table.insert(t9, {
				data = v135
			})
		end

		t8.tags[v130] = {
			valueList = t9
		}
	end

	local json = HttpService:JSONEncode(t8)

	return p64(Url.APIS_URL .. "abuse-reporting/v2/abuse-report", "POST", {
		postBody = json
	})
end
function t4.AbuseReportBundle(p65, n4: number, n5: number, s24: string, n6: number) -- line: 498
	-- upvalues: Url (copy), HttpService (copy)
	return p65(Url.APIS_URL .. "abuse-reporting/v1/safety-event", "POST", {
		postBody = HttpService:JSONEncode({
			safetyEvent = {
				eventTime = n6,
				idempotencyKey = "ugc_bundle/" .. tostring(n5) .. "/" .. tostring(n4),
				tags = {
					SUBMITTER_USER_ID = {
						valueList = {{
							data = tostring(n4)
						}}
					},
					REPORTED_ABUSE_VECTOR = {
						valueList = {{
							data = "ugc_bundle"
						}}
					},
					UGC_BUNDLE_ID = {
						valueList = {{
							data = tostring(n5)
						}}
					},
					ENTRY_POINT = {
						valueList = {{
							data = s24
						}}
					},
					REPORTED_ABUSE_CATEGORY = {
						valueList = {{
							data = "ABUSE_CATEGORY_OTHER"
						}}
					},
					REPORTER_COMMENT = {
						valueList = {{
							data = ""
						}}
					}
				}
			}
		})
	})
end
function t4.GetTopics(p66, t10: {[any]: any}, s25: string?) -- line: 550
	-- upvalues: Url (copy), HttpService (copy), CatalogConstants (copy)
	return p66(string.format("%sv1/topic/get-topics", Url.CATALOG_URL), "POST", {
		postBody = HttpService:JSONEncode({
			selectTopics = t10,
			inputQuery = s25,
			maxResult = CatalogConstants.MaxTopics
		})
	})
end
function t4.GetInitialTopics(p67, t11: {[any]: any}) -- line: 563
	-- upvalues: Url (copy), CatalogConstants (copy), Dash (copy), HttpService (copy)
	local v147 = string.format("%sv1/topic/get-topics", Url.CATALOG_URL)

	if #t11 > CatalogConstants.MaxItemsInTopicsRequest then
		t11 = Dash.slice(t11, 1, CatalogConstants.MaxItemsInTopicsRequest)
	end

	return p67(v147, "POST", {
		postBody = HttpService:JSONEncode({
			items = t11,
			maxResult = CatalogConstants.MaxTopics
		})
	})
end
function t4.GetCatalogMetadata(p68) -- line: 581
	-- upvalues: Url (copy)
	return p68(string.format("%s/v1/catalog/metadata", Url.CATALOG_URL), "GET")
end
function t4.FetchAssetVersionData(p69, p70) -- line: 592
	-- upvalues: v14 (copy)
	return p69(string.format("%sv1/assets/%s/saved-versions", v14, p70), "GET")
end
function t4.GetLookDetails(p71, s26: string) -- line: 597
	-- upvalues: Url (copy)
	return p71(string.format("%slook-api/v1/looks/%s", Url.APIS_URL, s26), "GET")
end
function t4.HasFavoritedLook(p72, s27: string) -- line: 602
	-- upvalues: Url (copy)
	return p72(string.format("%slook-api/v1/looks/%s/favorite", Url.APIS_URL, s27), "GET")
end

if FFlagAXCatalogMakeupSupport then
	function t4.FavoriteLookV2(p73, s28: string, s29: string?) -- line: 608
		-- upvalues: Url (copy), HttpService (copy)
		return p73(string.format("%slook-api/v1/looks/favorite/create", Url.APIS_URL), "POST", {
			postBody = HttpService:JSONEncode({
				id = s28,
				lookType = s29 or ""
			})
		})
	end
else
	function t4.FavoriteLook(p74, s30: string) -- line: 618
		-- upvalues: Url (copy), HttpService (copy)
		return p74(string.format("%slook-api/v1/looks/favorite/create", Url.APIS_URL), "POST", {
			postBody = HttpService:JSONEncode({
				lookType = "Avatar",
				id = s30
			})
		})
	end
end

if FFlagAXCatalogMakeupSupport then
	function t4.UnfavoriteLookV2(p75, s31: string, s32: string?) -- line: 630
		-- upvalues: Url (copy), HttpService (copy)
		return p75(string.format("%slook-api/v1/looks/favorite/delete", Url.APIS_URL), "POST", {
			postBody = HttpService:JSONEncode({
				id = s31,
				lookType = s32 or ""
			})
		})
	end
else
	function t4.UnfavoriteLook(p76, s33: string) -- line: 640
		-- upvalues: Url (copy), HttpService (copy)
		return p76(string.format("%slook-api/v1/looks/favorite/delete", Url.APIS_URL), "POST", {
			postBody = HttpService:JSONEncode({
				lookType = "Avatar",
				id = s33
			})
		})
	end
end

function t4.GetLookDetailsV2(p77, s34: string) -- line: 651
	-- upvalues: Url (copy)
	return p77(string.format("%slook-api/v2/looks/%s", Url.APIS_URL, s34), "GET")
end
function t4.DeleteLook(p78, s35: string) -- line: 656
	-- upvalues: Url (copy)
	return p78(string.format("%slook-api/v1/looks/%s", Url.APIS_URL, s35), "DELETE")
end
function t4.PurchaseLook(p79, s36: string, s37: string, n7: number, n8: number, t12: {[any]: any}) -- line: 661
	-- upvalues: Url (copy), HttpService (copy)
	return p79(string.format("%slook-api/v1/looks/%s/purchase", Url.APIS_URL, s36), "POST", {
		postBody = HttpService:JSONEncode({
			lookId = s36,
			idempotencyKey = s37,
			expectedPrice = n7,
			salesLocationId = n8,
			excludedItems = t12
		})
	})
end
function t4.PurchaseLookV2(p80, s38: string, s39: string, n9: number, n10: number, t13: {[any]: any}, t14: {[any]: any}, t15: {[any]: any}?) -- line: 681
	-- upvalues: Url (copy), HttpService (copy)
	return p80(string.format("%slook-api/v2/looks/%s/purchase", Url.APIS_URL, s38), "POST", {
		postBody = HttpService:JSONEncode({
			lookId = s38,
			idempotencyKey = s39,
			expectedPrice = n9,
			salesLocationId = n10,
			excludedAssets = t13,
			excludedBundles = t14,
			timedOptions = t15
		})
	})
end
function t4.GetOrGenerateShortShareLink(s40: string, s41: string) -- line: 705
	-- upvalues: LuaSocialLibrariesDeps (copy), ShareLinksNetworking (copy)
	local v185 = LuaSocialLibrariesDeps.httpRequest.config({
		maxWaitTime = 3,
		requestFunction = LuaSocialLibrariesDeps.httpRequest.requestFunctions.HttpRbxApi,
		maxRetryCount = game:DefineFastInt("CatalogWebApiHttpRetryCount", 2)
	})
	local v186 = LuaSocialLibrariesDeps.RoduxNetworking.config({
		keyPath = "AvatarExperience",
		networkImpl = v185
	})

	return ShareLinksNetworking.config({
		useMockedResponse = false,
		roduxNetworking = v186
	}).GetOrGenerateLink.API({
		linkType = "AvatarItemDetails",
		itemId = s40,
		itemType = s41
	})
end

return t4
