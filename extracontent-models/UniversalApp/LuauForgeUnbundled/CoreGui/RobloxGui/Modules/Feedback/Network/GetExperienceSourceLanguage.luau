local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")

local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")
local module2 = require("@luauforge/bundled/dwM")
local module3 = require("@luauforge/bundled/dME")
local Dash = require(CorePackages.Packages.Dash)
require("@game/CorePackages/Workspace/Packages/Http")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local NetworkingShareLinks = require("@game/CorePackages/Workspace/Packages/NetworkingShareLinks")

local module5 = require("@luauforge/bundled/dRT")

local fFlagAXCatalogMakeupSupport = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogMakeupSupport

local v5 = string.format("https://develop.%s", Url.DOMAIN)

local v6 = {}

function v6.FetchSponsoredItems(callback, p2, p3)
	local v7 = string.format(
		"%sv1/catalog/sponsored-items?model.placementLocation=AvatarShop",
		Url.CATALOG_URL
	)

	if p2 then
		v7 ..= "&model.catalogCategoryType=" .. p2
	end

	if p3 then
		v7 ..= "&model.count=" .. tostring(p3)
	end

	return callback(v7, "GET")
end

function v6.FetchWidgets(callback, p2, p3)
	local queryString = Url:makeQueryString({ requestId = p2, context = p3 })

	return callback(
		string.format("%smarketplace-widgets/v1/widgets?%s", Url.APIS_URL, queryString),
		"GET"
	)
end

function v6.FetchWidgetsSearch(callback, p2, p3)
	local queryString = Url:makeQueryString({ query = p3, requestId = p2 })

	return callback(
		string.format("%smarketplace-widgets/v1/widgets/search?%s", Url.APIS_URL, queryString),
		"GET"
	)
end

function v6.HydrateWidgetContent(callback, p2)
	return callback(string.format("%smarketplace-widgets/v1/widgets/hydrate", Url.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({ Content = p2 })
	})
end

function v6.FetchItemDetail(callback, p2, p3)
	local queryString = Url:makeQueryString({ itemType = p3 })

	return callback(
		string.format("%sv1/catalog/items/%s/details?%s", Url.CATALOG_URL, tostring(p2), queryString),
		"GET"
	)
end

function v6.FetchItemDetails(callback, p2)
	return callback(string.format("%sv1/catalog/items/details", Url.CATALOG_URL), "POST", {
		postBody = HttpService:JSONEncode({ items = p2 })
	})
end

function v6.FetchCollectibleItemDetails(callback, p2)
	return callback(string.format("%smarketplace-items/v1/items/details", Url.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({ itemIds = p2 })
	})
end

function v6.PurchaseProduct(callback, p2, p3, p4, p5)
	module2.isType(p2, "string", "CatalogWebApi.PurchaseProduct: productId")
	module2.isNonNegativeNumber(p3, "CatalogWebApi.PurchaseProduct: expectedPrice")
	module2.isType(p4, "string", "CatalogWebApi.PurchaseProduct: expectedSellerId")

	return callback(string.format("%sv1/purchases/products/%s", Url.ECONOMY_URL, p2), "POST", {
		postBody = HttpService:JSONEncode({
			expectedCurrency = module3.ExpectedCurrencyRobux,
			expectedPrice = tostring(p3),
			expectedSellerId = tostring(p4),
			userAssetId = p5
		})
	})
end

function v6.PurchaseCollectibleItem(callback, p2, p3, p4, p5, p6, p7, p8, p9)
	return callback(
		string.format("%smarketplace-sales/v1/item/%s/purchase-item", Url.APIS_URL, p2),
		"POST",
		{
			postBody = HttpService:JSONEncode({
				expectedCurrency = module3.ExpectedCurrencyRobux,
				expectedPrice = tostring(p4),
				expectedSellerId = tostring(p5),
				expectedPurchaserId = p7,
				expectedPurchaserType = module3.CreatorType.User,
				expectedSellerType = p6,
				collectibleProductId = p3,
				idempotencyKey = p8,
				rentalOptionDays = p9
			})
		}
	)
end

function v6.PurchaseCollectibleItemResale(callback, p2, p3, p4, p5, p6, p7, p8, p9)
	return callback(
		string.format("%smarketplace-sales/v1/item/%s/purchase-resale", Url.APIS_URL, p2),
		"POST",
		{
			postBody = HttpService:JSONEncode({
				expectedCurrency = module3.ExpectedCurrencyRobux,
				expectedPrice = tostring(p5),
				expectedSellerId = tostring(p6),
				expectedPurchaserId = p8,
				expectedPurchaserType = module3.CreatorType.User,
				expectedSellerType = p7,
				collectibleProductId = p4,
				collectibleItemInstanceId = p3,
				idempotencyKey = p9
			})
		}
	)
end

if module5 then
	function v6.RedeemQRCodeItem(callback, p2)
		module2.isType(p2, "string", "CatalogWebApi.RedeemQRCodeItem: assetId")
		return callback(string.format("%sv2/qr-code-auto-redeem/%s", Url.ECONOMY_URL, p2), "POST", {
			postBody = ""
		})
	end
end

function v6.FetchSellPageData(callback, p2, p3)
	return callback(
		string.format("%s/v1/assets/%s/users/%s/resellable-copies", Url.ECONOMY_URL, p2, p3),
		"GET"
	)
end

function v6.FetchCollectibleResellableInstances(callback, p2, p3)
	local queryString = Url:makeQueryString({
		ownerId = p3,
		ownerType = module3.CreatorType.User,
		cursor = "",
		limit = module3.MaxOwnedCopiesPerPage
	})

	return callback(
		string.format(
			"%smarketplace-sales/v1/item/%s/resellable-instances?%s",
			Url.APIS_URL,
			p2,
			queryString
		),
		"GET"
	)
end

function v6.FetchAssetResellers(callback, p2, p3, p4)
	local queryString = Url:makeQueryString({
		cursor = p3,
		limit = module3.MaxResellersPerPage
	})

	return callback(
		string.format("%s/v1/assets/%s/resellers?%s", Url.ECONOMY_URL, p2, queryString),
		"GET"
	)
end

function v6.FetchAssetResaleData(callback, p2)
	return callback(string.format("%s/v1/assets/%s/resale-data", Url.ECONOMY_URL, p2), "GET")
end

function v6.FetchCollectibleResaleData(callback, p2)
	return callback(string.format("%smarketplace-sales/v1/item/%s/resale-data", Url.APIS_URL, p2), "GET")
end

function v6.GetCollectibleResellers(callback, p2, p3, p4)
	local queryString = Url:makeQueryString({ cursor = p3, limit = p4 })

	return callback(
		string.format("%smarketplace-sales/v1/item/%s/resellers?%s", Url.APIS_URL, p2, queryString),
		"GET"
	)
end

function v6.RemoveCurrentlySellingAsset(callback, p2, p3)
	local jsonEncode = HttpService:JSONEncode({ price = "" })

	return callback(
		string.format("%s/v1/assets/%s/resellable-copies/%s", Url.ECONOMY_URL, p2, p3),
		"PATCH",
		{ postBody = jsonEncode }
	)
end

function v6.RemoveAvailableToSell(callback, p2, p3, p4)
	local jsonEncode = HttpService:JSONEncode({ price = p4 })

	return callback(
		string.format("%s/v1/assets/%s/resellable-copies/%s", Url.ECONOMY_URL, p2, p3),
		"PATCH",
		{ postBody = jsonEncode }
	)
end

function v6.UpdateCollectibleInstanceResaleState(callback, p2, p3, p4, p5, p6, p7)
	return callback(
		string.format("%smarketplace-sales/v1/item/%s/instance/%s/resale", Url.APIS_URL, p2, p3),
		"PATCH",
		{
			postBody = HttpService:JSONEncode({
				price = p5,
				isOnSale = p6,
				sellerId = p7,
				sellerType = module3.CreatorType.User,
				collectibleProductId = p4
			})
		}
	)
end

function v6.GetMarketplaceFee(callback)
	return callback(string.format("%s/v1/resale-tax-rate", Url.ECONOMY_URL), "GET")
end

function v6.GetCollectibleMarketplaceResaleParameters(callback, p2)
	return callback(
		string.format("%smarketplace-sales/v1/item/%s/get-resale-parameters", Url.APIS_URL, p2),
		"GET"
	)
end

function v6.ReportItem(p2, p3, p4, p5)
	local jsonEncode = HttpService:JSONEncode({
		reportingItemTypeName = p2,
		reportingItemId = p3,
		reportCategoryId = p4,
		comment = p5
	})

	if jsonEncode then
		local success, result = pcall(function()
			return HttpRbxApiService:PostAsync(
				"moderation/reportabuse",
				jsonEncode,
				Enum.ThrottlingPriority.Default,
				Enum.HttpContentType.ApplicationJson
			)
		end)

		if success then
			return result
		end
	end

	return nil
end

function v6.ReportItemV2(p2, p3, p4, p5, p6, p7, p8, p9, p10)
	local jsonEncode = HttpService:JSONEncode({
		tags = {
			ENTRY_POINT = {
				valueList = {
					{ data = p7 }
				}
			},
			SUBMITTER_USER_ID = {
				valueList = {
					{ data = p2 }
				}
			},
			REPORT_TARGET_USER_ID = {
				valueList = {
					{ data = p4 }
				}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {
					{ data = p9 }
				}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {
					{ data = p8 }
				}
			},
			REPORTER_COMMENT = {
				valueList = {
					{ data = p10 }
				}
			},
			REPORT_TARGET_ASSET_ID = {
				valueList = {
					{ data = p3 }
				}
			},
			REPORT_TARGET_ASSET_NAME = {
				valueList = {
					{ data = p5 }
				}
			},
			REPORT_TARGET_ASSET_DESCRIPTION = {
				valueList = {
					{ data = p6 }
				}
			}
		}
	})
	local v7 = Url.APIS_URL .. "abuse-reporting/v2/abuse-report"

	if jsonEncode then
		local success, result = pcall(function()
			return HttpRbxApiService:PostAsyncFullUrl(
				v7,
				jsonEncode,
				Enum.ThrottlingPriority.Default,
				Enum.HttpContentType.ApplicationJson
			)
		end)

		if success then
			return result
		end
	end

	return nil
end

function v6.AbuseReport(callback, items)
	local v7 = { tags = {} }

	for k, item in items do
		local v8 = {}

		for k2, v9 in typeof(item) ~= "table" and { item } or item do
			table.insert(v8, { data = v9 })
		end

		v7.tags[k] = { valueList = v8 }
	end

	local jsonEncode = HttpService:JSONEncode(v7)
	return callback(Url.APIS_URL .. "abuse-reporting/v2/abuse-report", "POST", {
		postBody = jsonEncode
	})
end

function v6.AbuseReportBundle(callback, p2, p3, p4, p5)
	return callback(Url.APIS_URL .. "abuse-reporting/v1/safety-event", "POST", {
		postBody = HttpService:JSONEncode({
			safetyEvent = {
				eventTime = p5,
				idempotencyKey = "ugc_bundle/" .. tostring(p3) .. "/" .. tostring(p2),
				tags = {
					SUBMITTER_USER_ID = {
						valueList = {
							{ data = tostring(p2) }
						}
					},
					REPORTED_ABUSE_VECTOR = {
						valueList = {
							{ data = "ugc_bundle" }
						}
					},
					UGC_BUNDLE_ID = {
						valueList = {
							{ data = tostring(p3) }
						}
					},
					ENTRY_POINT = {
						valueList = {
							{ data = p4 }
						}
					},
					REPORTED_ABUSE_CATEGORY = {
						valueList = {
							{ data = "ABUSE_CATEGORY_OTHER" }
						}
					},
					REPORTER_COMMENT = {
						valueList = {
							{ data = "" }
						}
					}
				}
			}
		})
	})
end

function v6.GetTopics(callback, p2, p3)
	return callback(string.format("%sv1/topic/get-topics", Url.CATALOG_URL), "POST", {
		postBody = HttpService:JSONEncode({
			selectTopics = p2,
			inputQuery = p3,
			maxResult = module3.MaxTopics
		})
	})
end

function v6.GetInitialTopics(callback, list)
	local v7 = string.format("%sv1/topic/get-topics", Url.CATALOG_URL)

	if #list > module3.MaxItemsInTopicsRequest then
		list = Dash.slice(list, 1, module3.MaxItemsInTopicsRequest)
	end

	return callback(v7, "POST", {
		postBody = HttpService:JSONEncode({
			items = list,
			maxResult = module3.MaxTopics
		})
	})
end

function v6.GetCatalogMetadata(callback)
	return callback(string.format("%s/v1/catalog/metadata", Url.CATALOG_URL), "GET")
end

function v6.FetchAssetVersionData(callback, p2)
	return callback(string.format("%sv1/assets/%s/saved-versions", v5, p2), "GET")
end

function v6.GetLookDetails(callback, p2)
	return callback(string.format("%slook-api/v1/looks/%s", Url.APIS_URL, p2), "GET")
end

function v6.HasFavoritedLook(callback, p2)
	return callback(string.format("%slook-api/v1/looks/%s/favorite", Url.APIS_URL, p2), "GET")
end

if fFlagAXCatalogMakeupSupport then
	function v6.FavoriteLookV2(callback, p2, value)
		return callback(string.format("%slook-api/v1/looks/favorite/create", Url.APIS_URL), "POST", {
			postBody = HttpService:JSONEncode({
				id = p2,
				lookType = value or ""
			})
		})
	end
else
	function v6.FavoriteLook(callback, p2)
		return callback(string.format("%slook-api/v1/looks/favorite/create", Url.APIS_URL), "POST", {
			postBody = HttpService:JSONEncode({ id = p2, lookType = "Avatar" })
		})
	end
end

if fFlagAXCatalogMakeupSupport then
	function v6.UnfavoriteLookV2(callback, p2, value)
		return callback(string.format("%slook-api/v1/looks/favorite/delete", Url.APIS_URL), "POST", {
			postBody = HttpService:JSONEncode({
				id = p2,
				lookType = value or ""
			})
		})
	end
else
	function v6.UnfavoriteLook(callback, p2)
		return callback(string.format("%slook-api/v1/looks/favorite/delete", Url.APIS_URL), "POST", {
			postBody = HttpService:JSONEncode({ id = p2, lookType = "Avatar" })
		})
	end
end

function v6.GetLookDetailsV2(callback, p2)
	return callback(string.format("%slook-api/v2/looks/%s", Url.APIS_URL, p2), "GET")
end

function v6.DeleteLook(callback, p2)
	return callback(string.format("%slook-api/v1/looks/%s", Url.APIS_URL, p2), "DELETE")
end

function v6.PurchaseLook(callback, p2, p3, p4, p5, p6)
	return callback(string.format("%slook-api/v1/looks/%s/purchase", Url.APIS_URL, p2), "POST", {
		postBody = HttpService:JSONEncode({
			lookId = p2,
			idempotencyKey = p3,
			expectedPrice = p4,
			salesLocationId = p5,
			excludedItems = p6
		})
	})
end

function v6.PurchaseLookV2(callback, p2, p3, p4, p5, p6, p7, p8)
	return callback(string.format("%slook-api/v2/looks/%s/purchase", Url.APIS_URL, p2), "POST", {
		postBody = HttpService:JSONEncode({
			lookId = p2,
			idempotencyKey = p3,
			expectedPrice = p4,
			salesLocationId = p5,
			excludedAssets = p6,
			excludedBundles = p7,
			timedOptions = p8
		})
	})
end

function v6.GetOrGenerateShortShareLink(p2, p3)
	local config = LuaSocialLibrariesDeps.httpRequest.config({
		requestFunction = LuaSocialLibrariesDeps.httpRequest.requestFunctions.HttpRbxApi,
		maxWaitTime = 3,
		maxRetryCount = game:DefineFastInt("CatalogWebApiHttpRetryCount", 2)
	})

	local config2 = LuaSocialLibrariesDeps.RoduxNetworking.config({
		keyPath = "AvatarExperience",
		networkImpl = config
	})

	return NetworkingShareLinks.config({ roduxNetworking = config2, useMockedResponse = false }).GetOrGenerateLink.API({
		linkType = "AvatarItemDetails",
		itemId = p2,
		itemType = p3
	})
end

return v6
