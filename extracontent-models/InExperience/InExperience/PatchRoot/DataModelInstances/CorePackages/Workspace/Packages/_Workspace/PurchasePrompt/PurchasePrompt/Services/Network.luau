local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local MarketplaceService = game:GetService("MarketplaceService")
local InsertService = game:GetService("InsertService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CreatorStoreService = game:GetService("CreatorStoreService")
local UrlBuilder = require(PurchasePromptParent.PurchasePromptDeps).UrlBuilder.UrlBuilder
local Promise = require(PurchasePrompt.Promise)
local PremiumProduct = require(PurchasePrompt.Models.PremiumProduct)

require(PurchasePrompt.types)

local debugLog = require(PurchasePrompt.Utils.debugLog)
local serializeTable = require(PurchasePrompt.Utils.serializeTable)
local isGenericChallengeResponse = require(PurchasePrompt.Utils.isGenericChallengeResponse)
local EngineFeature = game:GetEngineFeature("EnablePlayerOwnsBundleApi")
local EngineFeature2 = game:GetEngineFeature("EnableDevSubscriptionPurchaseWithRobux")
local GetFFlagEnablePromptPurchaseRequestedV2 = require(PurchasePrompt.Flags.GetFFlagEnablePromptPurchaseRequestedV2)
local GetFFlagEnablePromptPurchaseRequestedV2Take2 = require(PurchasePrompt.Flags.GetFFlagEnablePromptPurchaseRequestedV2Take2)
local GetFFlagEnableCreatorStorePurchasingCutover = require(PurchasePrompt.Flags.GetFFlagEnableCreatorStorePurchasingCutover)
local FFlagEnableUnifiedProductPurchaseFlow = require(PurchasePromptParent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(PurchasePromptParent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell = require(PurchasePrompt.Flags.FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell)
local SharedFlags = require(PurchasePromptParent.SharedFlags)
local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local FFlagEnablePurchasePayloadInExperienceShop = SharedFlags.FFlagEnablePurchasePayloadInExperienceShop
local FFlagRefreshPriceOnRetryAfterUpsell = require(PurchasePrompt.Flags.FFlagRefreshPriceOnRetryAfterUpsell)
local FFlagPurchasePromptCartPricingEnabled = require(PurchasePrompt.Flags.FFlagPurchasePromptCartPricingEnabled)
local v29 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
local v30 = string.gsub(v29, "http:", "https:")

string.gsub(v30, "https://www", "https://api")

local v31 = string.gsub(v30, "https://www", "https://apis")
local v32 = string.gsub(v30, "https://www", "https://games")
local v33 = string.gsub(v30, "https://www", "https://abtesting")
local v34 = string.gsub(v30, "https://www.", "https://catalog.")
local v35 = string.gsub(v30, "https://www.", "https://economy.")
local v36 = string.gsub(v30, "https://www.", "https://premiumfeatures.")
local v37 = string.gsub(v30, "https://www.", "https://economycreatorstats.")
local v38 = string.gsub(v30, "https://www", "https://users")

local function request(p1, p2, p3) -- line: 53
	-- upvalues: debugLog (copy), serializeTable (copy), HttpService (copy)
	debugLog(function() -- line: 54
		-- upvalues: p1 (copy), serializeTable (copy)
		return "Request " .. p1.Url .. "\n" .. serializeTable(p1)
	end)

	return HttpService:RequestInternal(p1):Start(function(p4, p5) -- line: 57
		-- upvalues: debugLog (copy), p1 (copy), serializeTable (copy), HttpService (copy), p2 (copy), p3 (copy)
		debugLog(function() -- line: 58
			-- upvalues: p1 (copy), serializeTable (copy), p5 (copy)
			return "Response " .. p1.Url .. "\n" .. serializeTable(p5)
		end)

		if p4 then
			local ok, result = pcall(HttpService.JSONDecode, HttpService, p5.Body)

			if ok then
				p2(result)

				return
			end

			p3("Could not parse JSON.")

			return
		end

		p3((tostring(p5.StatusMessage)))
	end)
end
local function getABTestGroup(p6, p7) -- line: 78
	-- upvalues: Promise (copy), request (copy), v33 (copy), HttpService (copy)
	local t1 = {{
		SubjectType = 1,
		ExperimentName = p7,
		SubjectTargetId = p6
	}}

	return Promise.new(function(resolve, reject) -- line: 87
		-- upvalues: request (copy), v33 (copy), HttpService (copy), t1 (copy)
		return request({
			Method = "POST",
			Url = v33 .. "v1/get-enrollments",
			Body = HttpService:JSONEncode(t1),
			Headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		}, resolve, reject)
	end)
end
local function getProductInfo(p8, p9) -- line: 100
	-- upvalues: MarketplaceService (copy)
	if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
		return MarketplaceService:GetProductInfoAsync(p8, p9)
	end

	return MarketplaceService:GetProductInfo(p8, p9)
end
local function getSubscriptionProductInfo(p10) -- line: 108
	-- upvalues: MarketplaceService (copy)
	return MarketplaceService:GetSubscriptionProductInfoAsync(p10)
end
local function getPremiumProductInfo() -- line: 112
	-- upvalues: Promise (copy), request (copy), v36 (copy), PremiumProduct (copy), UserInputService (copy)
	return Promise.new(function(resolve, reject) -- line: 113
		-- upvalues: request (copy), v36 (copy), PremiumProduct (copy), UserInputService (copy)
		request({
			Method = "GET",
			Url = v36 .. "v1/products?typeName=Subscription"
		}, function(p11) -- line: 117
			-- upvalues: PremiumProduct (copy), UserInputService (copy), resolve (copy)
			local v227 = nil

			for _, v in ipairs(p11.products) do
				local v230 = PremiumProduct(v)

				if v230 ~= nil and (v227 == nil or v227.robuxAmount > v230.robuxAmount) then
					v227 = v230
				end
			end

			if UserInputService:GetPlatform() == Enum.Platform.Android and v227 ~= nil and v227.mobileProductId ~= nil then
				v227.mobileProductId = v227.mobileProductId:lower()
			end

			resolve(v227)
		end, reject)
	end)
end
local function getPlayerOwns(p12, p13, p14) -- line: 140
	-- upvalues: MarketplaceService (copy), EngineFeature (copy)
	if p14 == Enum.InfoType.Asset then
		if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
			return MarketplaceService:PlayerOwnsAssetAsync(p12, p13)
		end

		return MarketplaceService:PlayerOwnsAsset(p12, p13)
	end

	if EngineFeature and p14 == Enum.InfoType.Bundle then
		if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
			return MarketplaceService:PlayerOwnsBundleAsync(p12, p13)
		end

		return MarketplaceService:PlayerOwnsBundle(p12, p13)
	end

	if p14 == Enum.InfoType.GamePass then
		return MarketplaceService:UserOwnsGamePassAsync(p12.UserId, p13)
	end

	if p14 == Enum.InfoType.Subscription then
		return MarketplaceService:IsPlayerSubscribed(p12, p13)
	end

	return false
end
local function performPurchase(p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26) -- line: 162
	-- upvalues: GetFFlagEnablePromptPurchaseRequestedV2 (copy), GetFFlagEnablePromptPurchaseRequestedV2Take2 (copy), FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), MarketplaceService (copy), FFlagEnablePurchasePayloadInExperienceShop (copy), isGenericChallengeResponse (copy)
	local ok, result = pcall(function() -- line: 176
		-- upvalues: GetFFlagEnablePromptPurchaseRequestedV2 (copy), GetFFlagEnablePromptPurchaseRequestedV2Take2 (copy), FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), MarketplaceService (copy), p15 (copy), p16 (copy), p17 (copy), p18 (copy), p19 (copy), p20 (copy), p21 (copy), p22 (copy), p23 (copy), p24 (copy), FFlagEnablePurchasePayloadInExperienceShop (copy), p25 (copy), p26 (copy)
		if GetFFlagEnablePromptPurchaseRequestedV2() or GetFFlagEnablePromptPurchaseRequestedV2Take2() then
			if FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then
				return MarketplaceService:PerformPurchase(p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, if not FFlagEnablePurchasePayloadInExperienceShop then nil else p25, p26)
			end

			if FFlagEnablePurchasePayloadInExperienceShop then
				return MarketplaceService:PerformPurchase(p15, p16, p17, p18, p19, p20, p21, p22, p23, nil, p25)
			end

			return MarketplaceService:PerformPurchase(p15, p16, p17, p18, p19, p20, p21, p22, p23)
		end

		return MarketplaceService:PerformPurchase(p15, p16, p17, p18, p19, p20, p21, p22)
	end)

	if ok then
		return result
	end

	if isGenericChallengeResponse(result) then
		return result
	end

	error((tostring(result)))
end
local function performPurchaseV2(p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37) -- line: 248
	-- upvalues: MarketplaceService (copy), isGenericChallengeResponse (copy)
	local ok, result = pcall(function() -- line: 261
		-- upvalues: p32 (copy), p33 (copy), p34 (copy), p35 (copy), p36 (copy), p37 (copy), MarketplaceService (copy), p27 (copy), p28 (copy), p29 (copy), p30 (copy), p31 (copy)
		local t2 = {
			CollectibleItemId = p32,
			CollectibleProductId = p33,
			IdempotencyKey = p34,
			PurchaseAuthToken = p35,
			CollectibleItemInstanceId = p36,
			PurchaseOptions = p37
		}

		return MarketplaceService:PerformPurchaseV2(p27, p28, p29, p30, p31, t2)
	end)

	if ok then
		return result
	end

	if isGenericChallengeResponse(result) then
		return result
	end

	error((tostring(result)))
end
local function performCreatorStorePurchase(p38, p39) -- line: 295
	-- upvalues: CreatorStoreService (copy), isGenericChallengeResponse (copy)
	local ok, result = pcall(function() -- line: 296
		-- upvalues: CreatorStoreService (copy), p38 (copy), p39 (copy)
		return CreatorStoreService:performCreatorStorePurchase(p38, p39)
	end)

	if ok then
		return result
	end

	if isGenericChallengeResponse(result) then
		return result
	end

	error((tostring(result)))
end
local function getAssetInfo(n1: number) -- line: 315
	-- upvalues: CreatorStoreService (copy)
	return CreatorStoreService:getAssetInfoAsync(n1)
end
local function getCreatorStoreProductInfo(n2: number, s1: string) -- line: 319
	-- upvalues: CreatorStoreService (copy)
	return CreatorStoreService:getCreatorStoreProductInfoAsync(n2, s1)
end
local function loadAssetForEquip(p40) -- line: 323
	-- upvalues: InsertService (copy)
	return InsertService:LoadAsset(p40)
end
local function getAccountInfo() -- line: 327
	-- upvalues: Promise (copy), request (copy), v38 (copy)
	return Promise.new(function(resolve, reject) -- line: 328
		-- upvalues: request (copy), v38 (copy)
		request({
			Method = "GET",
			Url = v38 .. "v1/users/authenticated/app-launch-info"
		}, resolve, reject)
	end)
end
local function getBalanceInfo() -- line: 336
	-- upvalues: Promise (copy), request (copy), v35 (copy)
	return Promise.new(function(resolve, reject) -- line: 337
		-- upvalues: request (copy), v35 (copy)
		request({
			Method = "GET",
			Url = v35 .. "v1/user/currency"
		}, resolve, reject)
	end)
end
local function getBundleDetails(p41) -- line: 345
	-- upvalues: v34 (copy), Promise (copy), request (copy)
	local v121 = v34 .. "v1/bundles/" .. tostring(p41) .. "/details"
	local t3 = {
		Method = "GET",
		Url = v121
	}

	return Promise.new(function(resolve, reject) -- line: 352
		-- upvalues: request (copy), t3 (copy)
		spawn(function() -- line: 353
			-- upvalues: request (copy), t3 (copy), resolve (copy), reject (copy)
			request(t3, resolve, reject)
		end)
	end)
end
local function getProductPurchasableDetails(p42) -- line: 359
	-- upvalues: v35 (copy), Promise (copy), request (copy)
	local v124 = v35 .. "v1/products/" .. tostring(p42) .. "?showPurchasable=true"
	local t4 = {
		Method = "GET",
		Url = v124
	}

	return Promise.new(function(resolve, reject) -- line: 366
		-- upvalues: request (copy), t4 (copy)
		spawn(function() -- line: 367
			-- upvalues: request (copy), t4 (copy), resolve (copy), reject (copy)
			request(t4, resolve, reject)
		end)
	end)
end
local function getCatalogItemDetails(n3: number, s2: string) -- line: 373
	-- upvalues: v34 (copy), Promise (copy), request (copy)
	local t5 = {
		Method = "GET",
		Url = string.format("%sv1/catalog/items/%d/details?itemType=%s", v34, n3, s2)
	}

	return Promise.new(function(resolve, reject) -- line: 379
		-- upvalues: request (copy), t5 (copy)
		spawn(function() -- line: 380
			-- upvalues: request (copy), t5 (copy), resolve (copy), reject (copy)
			request(t5, resolve, reject)
		end)
	end)
end
local function getResellers(s3: string, n4: number?) -- line: 386
	-- upvalues: v31 (copy), Promise (copy), request (copy)
	local v131 = n4 or 10
	local t6 = {
		Method = "GET",
		Url = string.format("%smarketplace-sales/v1/item/%s/resellers?cursor=&limit=%d", v31, s3, v131)
	}

	return Promise.new(function(resolve, reject) -- line: 398
		-- upvalues: request (copy), t6 (copy)
		spawn(function() -- line: 399
			-- upvalues: request (copy), t6 (copy), resolve (copy), reject (copy)
			request(t6, resolve, reject)
		end)
	end)
end
local function postCartPricing(p43) -- line: 405
	-- upvalues: v31 (copy), HttpService (copy), Promise (copy), request (copy)
	local t7 = {
		["Content-Type"] = "application/json",
		Accept = "application/json"
	}
	local t8 = {
		Method = "POST",
		Url = v31 .. "marketplace-sales/v1/cart-pricing",
		Body = HttpService:JSONEncode(p43),
		Headers = t7
	}

	return Promise.new(function(resolve, reject) -- line: 418
		-- upvalues: request (copy), t8 (copy)
		spawn(function() -- line: 419
			-- upvalues: request (copy), t8 (copy), resolve (copy), reject (copy)
			request(t8, function(p44) -- line: 420
				-- upvalues: resolve (copy)
				resolve(p44)
			end, function(p45) -- line: 422
				-- upvalues: reject (copy)
				reject(p45)
			end)
		end)
	end)
end
local function postPremiumImpression() -- line: 429
	-- upvalues: v37 (copy), HttpService (copy), Promise (copy)
	local v136 = v37 .. "v1/universes/" .. tostring(game.GameId) .. "/premium-impressions/increment"
	local t9 = {
		Method = "POST",
		Url = v136,
		Body = HttpService:JSONEncode("{}"),
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		}
	}

	return Promise.new(function(_, _) -- line: 444
		-- upvalues: HttpService (copy), t9 (copy)
		spawn(function() -- line: 445
			-- upvalues: HttpService (copy), t9 (copy)
			return HttpService:RequestInternal(t9):Start(function(_, _) -- line: 446
			end)
		end)
	end)
end
local function getPremiumUpsellPrecheck() -- line: 453
	-- upvalues: v36 (copy), Players (copy), Promise (copy), HttpService (copy)
	local t10 = {
		Method = "GET",
		Url = string.format("%sv1/users/%d/premium-upsell-precheck?universeId=%d&placeId=%d", v36, Players.LocalPlayer.UserId, game.GameId, game.PlaceId)
	}

	return Promise.new(function(resolve, reject) -- line: 465
		-- upvalues: HttpService (copy), t10 (copy)
		spawn(function() -- line: 466
			-- upvalues: HttpService (copy), t10 (copy), resolve (copy), reject (copy)
			return HttpService:RequestInternal(t10):Start(function(p50, p51) -- line: 467
				-- upvalues: resolve (copy), reject (copy)
				if p50 and p51.StatusCode == 200 then
					resolve()

					return
				end

				reject()
			end)
		end)
	end)
end
local function getSubscriptionPurchaseInfo(p52) -- line: 478
	-- upvalues: MarketplaceService (copy)
	return MarketplaceService:GetSubscriptionPurchaseInfoAsync(p52)
end
local function performSubscriptionPurchase(p53, p54) -- line: 482
	-- upvalues: MarketplaceService (copy)
	return MarketplaceService:PerformSubscriptionPurchaseV2(p53, p54)
end
local function getPurchaseWarning(s4: string?, n5: number?, b1: boolean) -- line: 486
	-- upvalues: UrlBuilder (copy), Promise (copy), request (copy)
	local v145 = UrlBuilder.economy.purchaseWarning.getPurchaseWarning(s4, n5, not b1)
	local t11 = {
		Method = "GET",
		Url = v145
	}

	return Promise.new(function(resolve, reject) -- line: 492
		-- upvalues: request (copy), t11 (copy)
		spawn(function() -- line: 493
			-- upvalues: request (copy), t11 (copy), resolve (copy), reject (copy)
			request(t11, resolve, reject)
		end)
	end)
end
local function postPurchaseWarningAcknowledge(p55) -- line: 499
	-- upvalues: UrlBuilder (copy), HttpService (copy), Promise (copy)
	local v148 = UrlBuilder.economy.purchaseWarning.ackPurchaseWarning()
	local t12 = {
		Method = "POST",
		Url = v148,
		Body = HttpService:JSONEncode({
			acknowledgement = p55
		}),
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		}
	}

	return Promise.new(function(_, _) -- line: 513
		-- upvalues: HttpService (copy), t12 (copy)
		spawn(function() -- line: 514
			-- upvalues: HttpService (copy), t12 (copy)
			return HttpService:RequestInternal(t12):Start(function(_, _) -- line: 515
			end)
		end)
	end)
end
local function checkUserPurchaseSettings() -- line: 522
	-- upvalues: UrlBuilder (copy), HttpService (copy), Promise (copy), request (copy)
	local v150 = UrlBuilder.economy.paymentsGateway.checkUserPurchaseSettings()
	local t13 = {
		Method = "POST",
		Url = v150,
		Body = HttpService:JSONEncode("{}"),
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		}
	}

	return Promise.new(function(resolve, reject) -- line: 535
		-- upvalues: request (copy), t13 (copy)
		spawn(function() -- line: 536
			-- upvalues: request (copy), t13 (copy), resolve (copy), reject (copy)
			request(t13, resolve, reject)
		end)
	end)
end
local function getVngShopUrl() -- line: 542
	-- upvalues: UrlBuilder (copy), Promise (copy), request (copy)
	local v152 = UrlBuilder.economy.vngPayments.getVngShopUrl()
	local t14 = {
		Method = "GET",
		Url = v152
	}

	return Promise.new(function(resolve, reject) -- line: 550
		-- upvalues: request (copy), t14 (copy)
		spawn(function() -- line: 551
			-- upvalues: request (copy), t14 (copy), resolve (copy), reject (copy)
			request(t14, resolve, reject)
		end)
	end)
end
local function performDevProductEdpPurchase(n6: number, p60) -- line: 557
	-- upvalues: v31 (copy), HttpService (copy), Promise (copy), request (copy)
	local v156 = ("%sdeveloper-products/v1/developer-products/%i/purchase?requestLocationType=ExperienceDetailPage"):format(v31, n6)
	local t15 = {
		Method = "POST",
		Url = v156,
		Body = HttpService:JSONEncode(p60),
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		}
	}

	return Promise.new(function(resolve, reject) -- line: 573
		-- upvalues: request (copy), t15 (copy)
		spawn(function() -- line: 574
			-- upvalues: request (copy), t15 (copy), resolve (copy), reject (copy)
			request(t15, resolve, reject)
		end)
	end)
end
local function getExperienceProductInfo(p61) -- line: 580
	-- upvalues: v32 (copy), Promise (copy), request (copy)
	local v159 = ("%sv1/games/games-product-info?universeIds=%s"):format(v32, p61)
	local t16 = {
		Method = "GET",
		Url = v159
	}

	return Promise.new(function(resolve, reject) -- line: 588
		-- upvalues: request (copy), t16 (copy)
		spawn(function() -- line: 589
			-- upvalues: request (copy), t16 (copy), resolve (copy), reject (copy)
			request(t16, resolve, reject)
		end)
	end)
end
local function performExperiencePurchase(s5: string, p62) -- line: 595
	-- upvalues: v35 (copy), HttpService (copy), Promise (copy), request (copy)
	local v163 = ("%sv1/purchases/products/%s"):format(v35, s5)
	local t17 = {
		Method = "POST",
		Url = v163,
		Body = HttpService:JSONEncode(p62),
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		}
	}

	return Promise.new(function(resolve, reject) -- line: 608
		-- upvalues: request (copy), t17 (copy)
		spawn(function() -- line: 609
			-- upvalues: request (copy), t17 (copy), resolve (copy), reject (copy)
			request(t17, resolve, reject)
		end)
	end)
end
local function performLookPurchase(s6: string, p63) -- line: 615
	-- upvalues: v31 (copy), HttpService (copy), Promise (copy), request (copy)
	local v167 = ("%slook-api/v2/looks/%s/purchase"):format(v31, s6)
	local t18 = {
		Method = "POST",
		Url = v167,
		Body = HttpService:JSONEncode(p63),
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		}
	}

	return Promise.new(function(resolve, reject) -- line: 628
		-- upvalues: request (copy), t18 (copy)
		spawn(function() -- line: 629
			-- upvalues: request (copy), t18 (copy), resolve (copy), reject (copy)
			request(t18, resolve, reject)
		end)
	end)
end
local function performDeveloperSubscriptionRobuxPurchase(s7: string, n7: number) -- line: 635
	-- upvalues: EngineFeature2 (copy), MarketplaceService (copy)
	if EngineFeature2 then
		local ok, result = pcall(function() -- line: 637
			-- upvalues: MarketplaceService (copy), s7 (copy), n7 (copy)
			MarketplaceService:PerformSubscriptionPurchaseWithRobuxAsync(s7, n7)
		end)

		if not ok then
			error(result)
		end

		return
	end

	error("Developer subscription Robux purchase requires engine feature to be enabled")
end
local function getUnifiedPurchaseFlowUserEligibility() -- line: 649
	-- upvalues: v31 (copy), Promise (copy), request (copy)
	local v173 = ("%sroblox-subscriptions/v1/metadata"):format(v31)
	local t19 = {
		Method = "GET",
		Url = v173
	}

	return Promise.new(function(resolve, reject) -- line: 657
		-- upvalues: request (copy), t19 (copy)
		spawn(function() -- line: 658
			-- upvalues: request (copy), t19 (copy), resolve (copy), reject (copy)
			request(t19, resolve, reject)
		end)
	end)
end
local function GetLookDetailsV2ProductInfo(s8: string) -- line: 664
	-- upvalues: v31 (copy), Promise (copy), request (copy)
	local v176 = string.format("%slook-api/v2/looks/%s", v31, s8)
	local t20 = {
		Method = "GET",
		Url = v176
	}

	return Promise.new(function(resolve, reject) -- line: 672
		-- upvalues: request (copy), t20 (copy)
		spawn(function() -- line: 673
			-- upvalues: request (copy), t20 (copy), resolve (copy), reject (copy)
			request(t20, resolve, reject)
		end)
	end)
end

return {
	new = function() -- line: 683
		-- upvalues: Promise (copy), getABTestGroup (copy), getProductInfo (copy), getPlayerOwns (copy), performPurchase (copy), performPurchaseV2 (copy), GetFFlagEnableCreatorStorePurchasingCutover (copy), performCreatorStorePurchase (copy), loadAssetForEquip (copy), getAccountInfo (copy), getAssetInfo (copy), getBalanceInfo (copy), getBundleDetails (copy), getProductPurchasableDetails (copy), FFlagRefreshPriceOnRetryAfterUpsell (copy), getCatalogItemDetails (copy), getResellers (copy), getCreatorStoreProductInfo (copy), getPremiumProductInfo (copy), postPremiumImpression (copy), getPremiumUpsellPrecheck (copy), getSubscriptionPurchaseInfo (copy), performSubscriptionPurchase (copy), getPurchaseWarning (copy), postPurchaseWarningAcknowledge (copy), checkUserPurchaseSettings (copy), getVngShopUrl (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), performDevProductEdpPurchase (copy), getExperienceProductInfo (copy), performExperiencePurchase (copy), performLookPurchase (copy), getUnifiedPurchaseFlowUserEligibility (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), performDeveloperSubscriptionRobuxPurchase (copy), getSubscriptionProductInfo (copy), FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell (copy), GetLookDetailsV2ProductInfo (copy), FFlagPurchasePromptCartPricingEnabled (copy), postCartPricing (copy)
		local t21 = {
			getABTestGroup = Promise.promisify(getABTestGroup),
			getProductInfo = Promise.promisify(getProductInfo),
			getPlayerOwns = Promise.promisify(getPlayerOwns),
			performPurchase = Promise.promisify(performPurchase),
			performPurchaseV2 = Promise.promisify(performPurchaseV2),
			performCreatorStorePurchase = if not GetFFlagEnableCreatorStorePurchasingCutover() then nil else Promise.promisify(performCreatorStorePurchase),
			loadAssetForEquip = Promise.promisify(loadAssetForEquip),
			getAccountInfo = Promise.promisify(getAccountInfo),
			getAssetInfo = if not GetFFlagEnableCreatorStorePurchasingCutover() then nil else Promise.promisify(getAssetInfo),
			getBalanceInfo = Promise.promisify(getBalanceInfo),
			getBundleDetails = getBundleDetails,
			getProductPurchasableDetails = getProductPurchasableDetails,
			getCatalogItemDetails = if not FFlagRefreshPriceOnRetryAfterUpsell then nil else getCatalogItemDetails,
			getResellers = if not FFlagRefreshPriceOnRetryAfterUpsell then nil else getResellers,
			getCreatorStoreProductInfo = if not GetFFlagEnableCreatorStorePurchasingCutover() then nil else Promise.promisify(getCreatorStoreProductInfo),
			getPremiumProductInfo = Promise.promisify(getPremiumProductInfo),
			postPremiumImpression = Promise.promisify(postPremiumImpression),
			getPremiumUpsellPrecheck = Promise.promisify(getPremiumUpsellPrecheck),
			getSubscriptionPurchaseInfo = Promise.promisify(getSubscriptionPurchaseInfo),
			performSubscriptionPurchase = Promise.promisify(performSubscriptionPurchase),
			getPurchaseWarning = Promise.promisify(getPurchaseWarning),
			postPurchaseWarningAcknowledge = Promise.promisify(postPurchaseWarningAcknowledge),
			checkUserPurchaseSettings = Promise.promisify(checkUserPurchaseSettings),
			getVngShopUrl = Promise.promisify(getVngShopUrl),
			performDevProductEdpPurchase = if not FFlagEnableUnifiedProductPurchaseFlow then nil else Promise.promisify(performDevProductEdpPurchase),
			getExperienceProductInfo = if not FFlagEnableUnifiedProductPurchaseFlow then nil else Promise.promisify(getExperienceProductInfo),
			performExperiencePurchase = if not FFlagEnableUnifiedProductPurchaseFlow then nil else Promise.promisify(performExperiencePurchase),
			performLookPurchase = if not FFlagEnableUnifiedProductPurchaseFlow then nil else Promise.promisify(performLookPurchase),
			getUnifiedPurchaseFlowUserEligibility = if not FFlagEnableUnifiedProductPurchaseFlow then nil else Promise.promisify(getUnifiedPurchaseFlowUserEligibility),
			performDeveloperSubscriptionRobuxPurchase = if not FFlagEnableUnifiedPurchaseFlowForDevSubs then nil else Promise.promisify(performDeveloperSubscriptionRobuxPurchase),
			getSubscriptionProductInfo = if not FFlagEnableUnifiedPurchaseFlowForDevSubs then nil else Promise.promisify(getSubscriptionProductInfo),
			GetLookDetailsV2ProductInfo = if not FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell then nil else Promise.promisify(GetLookDetailsV2ProductInfo),
			postCartPricing = if not FFlagPurchasePromptCartPricingEnabled then nil else postCartPricing
		}

		setmetatable(t21, {
			__tostring = function() -- line: 741
				return "Service(Network)"
			end
		})

		return t21
	end
}
