local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Promise = require(parent.Promise)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local PioneerUtils = require(parent.PioneerUtils)
local PioneerInfo = PioneerUtils.PioneerInfo
local createSignal = Signals.createSignal
local InExperienceOffers = require(parent.InExperienceOffers)
local FFlagEnableOffersPrefetch = SharedFlags.FFlagEnableOffersPrefetch
local FFlagOfferNineDotActivityIndicator = SharedFlags.FFlagOfferNineDotActivityIndicator
local FFlagOfferNotifyOnGlobalIcon = SharedFlags.FFlagOfferNotifyOnGlobalIcon
local FFlagHideOfferNotificationsWhenShopEmpty = SharedFlags.FFlagHideOfferNotificationsWhenShopEmpty

local Constants = require(InExperienceShop.Constants)
require(InExperienceShop.Types)
local hasOfferEligibleCategory = require(InExperienceShop.Utils.hasOfferEligibleCategory)
local Errors = require(InExperienceShop.Api.Errors)
local fetchAllShopData = require(InExperienceShop.Api.fetchAllShopData)
local fetchShopWidgetsOnly = require(InExperienceShop.Api.fetchShopWidgetsOnly)
local fetchRobuxWidgetsAfterPurchase = require(InExperienceShop.Api.fetchRobuxWidgetsAfterPurchase)
local mergeRobuxShopData = require(InExperienceShop.Api.mergeRobuxShopData)
local multiGetProductInfo = require(InExperienceShop.Api.multiGetProductInfo)
local streamMultiGetProductInfo = require(InExperienceShop.Api.streamMultiGetProductInfo)
local logCounter = require(InExperienceShop.Internal.logCounter)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)
local ProductInfoFailedItemsCounter = require(InExperienceShop.Events.ProductInfoFailedItemsCounter)
local userOwnsGamePass = require(InExperienceShop.Api.userOwnsGamePass)
local userOwnsGamePassHttp = require(InExperienceShop.Api.userOwnsGamePassHttp)
local fetchGamePassTrialAvailabilities = require(InExperienceShop.Api.fetchGamePassTrialAvailabilities)
local redeemGamePassTrial = require(InExperienceShop.Api.redeemGamePassTrial)
local getPassOwnership = require(InExperienceShop.Api.getPassOwnership)
local FFlagShopUseMockData = require(InExperienceShop.Flags.FFlagShopUseMockData)
local FFlagShopUseMockUserOwnsGamePass = require(InExperienceShop.Flags.FFlagShopUseMockUserOwnsGamePass)
local FFlagShopUseMockGamePassTrialAvailabilities = require(InExperienceShop.Flags.FFlagShopUseMockGamePassTrialAvailabilities)
local FFlagShopUseMockGamePassTrialRedemption = require(InExperienceShop.Flags.FFlagShopUseMockGamePassTrialRedemption)
local FFlagMockGetGamePassOwnership = require(InExperienceShop.Flags.FFlagMockGetGamePassOwnership)
local FFlagUseGetGamePassOwnershipApi = SharedFlags.FFlagUseGetGamePassOwnershipApi
local FFlagLuaAppEnableGamePassFreeTrials = require(InExperienceShop.Flags.FFlagLuaAppEnableGamePassFreeTrials)
local FFlagEnableGamePassTrialUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableGamePassTrialUnifiedLogging)
local FFlagCloseShopOnTrialRedemption = require(InExperienceShop.Flags.FFlagCloseShopOnTrialRedemption)
local FFlagShopUseMockMultiGetProductInfo = require(InExperienceShop.Flags.FFlagShopUseMockMultiGetProductInfo)
local FFlagEnableShopProductInfoRefresh = require(InExperienceShop.Flags.FFlagEnableShopProductInfoRefresh)
local FFlagEnableShopExposureLogging = require(InExperienceShop.Flags.FFlagEnableShopExposureLogging)
local FFlagEnableShopFlagLinkedExposureLogging = require(InExperienceShop.Flags.FFlagEnableShopFlagLinkedExposureLogging)
local FStringExperienceShopFlagLinkedLayer = require(InExperienceShop.Flags.FStringExperienceShopFlagLinkedLayer)
local FStringExperienceShopLayer1 = require(InExperienceShop.Flags.FStringExperienceShopLayer1)
local FStringExperienceShopLayer2 = require(InExperienceShop.Flags.FStringExperienceShopLayer2)
local FFlagRefetchRobuxWidgetAfterPurchase = require(InExperienceShop.Flags.FFlagRefetchRobuxWidgetAfterPurchase)
local FFlagSkipPaymentSessionForPlainRobux = require(InExperienceShop.Flags.FFlagSkipPaymentSessionForPlainRobux)
local FFlagEnablePartialDisplayInExperienceShop = require(InExperienceShop.Flags.FFlagEnablePartialDisplayInExperienceShop)
require(InExperienceShop.Flags.FFlagPromoteRobuxInTopPicks)
local FFlagEnableRobuxInExperienceShop = SharedFlags.FFlagEnableRobuxInExperienceShop
local FFlagLuaAppEnableNativePurchaseFinishedV2Signals = SharedFlags.FFlagLuaAppEnableNativePurchaseFinishedV2Signals
local FFlagShopListenNativePurchaseFinished = require(InExperienceShop.Flags.FFlagShopListenNativePurchaseFinished)
local FFlagShopRobuxPurchaseCompletionModal = require(InExperienceShop.Flags.FFlagShopRobuxPurchaseCompletionModal)
local FIntShopOwnershipFetchMaxAttempts = require(InExperienceShop.Flags.FIntShopOwnershipFetchMaxAttempts)
local MockFetchAllShopData = require(InExperienceShop.Mocks.MockFetchAllShopData)
local MockMultiGetProductInfo = require(InExperienceShop.Mocks.MockMultiGetProductInfo)
local MockUserOwnsGamePass = require(InExperienceShop.Mocks.MockUserOwnsGamePass)
local MockGamePassTrialAvailabilities = require(InExperienceShop.Mocks.MockGamePassTrialAvailabilities)
local MockGetPassOwnership = require(InExperienceShop.Mocks.MockGetPassOwnership)
local promoteBonusRobuxPackageToTopPicks = require(InExperienceShop.Api.promoteBonusRobuxPackageToTopPicks)
local BonusPromotionEligibility = require(InExperienceShop.Api.BonusPromotionEligibility)
local sortRobuxPackagesByAmountDescending = require(InExperienceShop.Utils.sortRobuxPackagesByAmountDescending)
local findTopPicksSectionIndex = require(InExperienceShop.Utils.findTopPicksSectionIndex)
local moveItemToPositionInShop = require(InExperienceShop.Utils.moveItemToPositionInShop)
local parseGamePassTrialRedeemErrorCode = require(InExperienceShop.Utils.parseGamePassTrialRedeemErrorCode)

local FFlagEnableExperienceShopGlobalIcon = require(InExperienceShop.Flags.FFlagEnableExperienceShopGlobalIcon)

local FFlagInExperienceShopExpectStringMetadataValues = require(InExperienceShop.Flags.FFlagInExperienceShopExpectStringMetadataValues)

local v = { InExperienceOffers.FeatureKeys.RobloxShop }

local function isValidShopData(p): boolean -- 3 equivalent calls inferred from this helper
	return type(p) == "table" and type(p.categories) == "table" and type(p.sections) == "table"
end

local function isPartialDisplayEnabled() -- 2 equivalent calls inferred from this helper
	local v2 = FFlagEnablePartialDisplayInExperienceShop

	if typeof(v2) == "function" then
		return (v2())
	end

	return v2
end

local function createInExperienceShopStore()
	local signal, v2 = createSignal({})
	local signal2, v3 = createSignal({})
	local signal3, v4 = createSignal(false)
	local signal4, v5 = createSignal(nil)
	local signal5, v6 = createSignal(nil)
	local signal6, v7 = createSignal(false)
	local signal7, v8 = createSignal(false)
	local signal8, v9 = createSignal(false)

	local signal9, v10 = createSignal({})

	local signal10, v11 = createSignal({ available = {}, active = {}, redeemed = {} })

	local signal11, v12 = createSignal({})

	local signal12, v13 = createSignal(Constants.MIN_COLUMNS)

	local signal13, v14 = createSignal(nil)

	local v15 = {}

	local v16 = false

	local v17 = false

	local signal14, v18 = createSignal(FFlagEnableGamePassTrialUnifiedLogging and FFlagLuaAppEnableGamePassFreeTrials and "pending" or "settled")

	local v19 = false

	local v20 = nil
	local v21 = nil
	local v22 = nil

	local v23 = {}
	local flag = false

	local function bonusGamePassIdForNativePurchase(p: string?, p2: string, p3: number?)
		if p2 == "" then
			ShopDebugLogger.log("bonusGamePassIdForNativePurchase: skip, empty store SKU")
			return
		end

		if FFlagRefetchRobuxWidgetAfterPurchase and (p == nil or p == "") then
			p = nil
		end

		v20 = p

		v21 = p2

		if FFlagShopRobuxPurchaseCompletionModal then
			if not PioneerInfo.isDaveyBazooka() or p3 == nil or not (p3 > 0) then
				p3 = nil
			end

			v22 = p3

			v14(nil)
		end

		ShopDebugLogger.logLazy(function()
			return "bonusGamePassIdForNativePurchase: recorded bonusGamePassId=" .. tostring(v20) .. " storeSku=" .. p2
		end)
	end

	local v24 = false
	local v25 = false
	local v26 = false

	local v27 = false

	local v28 = {}

	local v29 = {}

	local v30 = {}
	local v31 = {}

	local signal15, setShouldOpenToRobuxTab = createSignal(false)

	local signal16, setOpenedFromBuyRobux = createSignal(false)

	local function commitBonusPromotionEligibility(p: string, p2) -- 5 equivalent calls inferred from this helper
		v30[p] = p2
		v12(table.clone(v30))
	end

	local function sortRobuxPackagesInSections(list)
		local v32 = false

		for _, item in list do
			local robuxPackages = item.robuxPackages

			if robuxPackages ~= nil and #robuxPackages > 1 then
				v32 = true
				break
			end
		end

		if not v32 then
			return list
		end

		local clone = table.clone(list)

		for i, item in ipairs(list) do
			local robuxPackages = item.robuxPackages

			if robuxPackages == nil or #robuxPackages <= 1 then
				continue
			end

			clone[i] = {
				id = item.id,
				name = item.name,
				items = item.items,
				categoryType = item.categoryType,
				stableCategoryId = item.stableCategoryId,
				categoryGroup = item.categoryGroup,
				paymentSessionId = item.paymentSessionId,
				bonusJwt = item.bonusJwt,
				robuxPackages = sortRobuxPackagesByAmountDescending(robuxPackages),
				featuredRobuxPackage = item.featuredRobuxPackage
			}
		end

		return clone
	end

	local function reapplyFeaturedPromotion() -- 7 equivalent calls inferred from this helper
		v3(sortRobuxPackagesInSections(promoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(v29, v30)))
	end

	local function bumpRedeemedTrialToTopPicks(p: string) -- 2 equivalent calls inferred from this helper
		local topPicksSectionIndex = findTopPicksSectionIndex(v29)

		if topPicksSectionIndex ~= nil then
			v29 = moveItemToPositionInShop(v29, topPicksSectionIndex, p, "GamePass", 1)
		end

		reapplyFeaturedPromotion() -- inferred equivalent call
	end

	local function writeOwnership(p: string, flag2: boolean)
		local clone = table.clone(signal9(false))
		clone[p] = flag2
		v10(clone)

		if not (flag2 and FFlagEnableRobuxInExperienceShop) then
			return
		end

		local firstBonusRobuxPackage = promoteBonusRobuxPackageToTopPicks.findFirstBonusRobuxPackage(v29)
		local v32

		if firstBonusRobuxPackage ~= nil then
			v32 = promoteBonusRobuxPackageToTopPicks.getBonusGamePassId(firstBonusRobuxPackage)
		end

		if v32 == nil or v32 ~= p then
			return
		end

		commitBonusPromotionEligibility(p, BonusPromotionEligibility.Ineligible) -- inferred equivalent call
		reapplyFeaturedPromotion() -- inferred equivalent call
	end

	local function fetchOwnedGamePass(p: number)
		if FFlagUseGetGamePassOwnershipApi then
			local localPlayer = Players.LocalPlayer

			if localPlayer == nil then
				return Promise.reject("fetchOwnedGamePass: no LocalPlayer")
			end

			if FFlagMockGetGamePassOwnership then
				return MockGetPassOwnership.getPassOwnership(localPlayer, p)
			end

			return getPassOwnership.getPassOwnership(localPlayer, p):andThen(function(p2): boolean
				return p2 ~= nil and p2.Owned == true
			end)
		else
			local v32

			if FFlagShopUseMockUserOwnsGamePass then
				v32 = MockUserOwnsGamePass
			else
				v32 = userOwnsGamePass
			end

			return v32(p)
		end
	end

	local hydrateGamePassTrialAvailabilities

	local function retryTrialsIfRequested() -- 1 equivalent call inferred from this helper
		if v19 and v25 and not (v17 or v16) then
			hydrateGamePassTrialAvailabilities()
		end
	end

	hydrateGamePassTrialAvailabilities = function()
		if not FFlagLuaAppEnableGamePassFreeTrials or (v17 or v16) then
			return
		end

		v19 = false
		v16 = true
		local v32

		if FFlagShopUseMockGamePassTrialAvailabilities then
			v32 = MockGamePassTrialAvailabilities.fetchGamePassTrialAvailabilities
		else
			v32 = fetchGamePassTrialAvailabilities.fetchGamePassTrialAvailabilities
		end

		v32(game.GameId):andThen(function(p)
			v11(p)
			v17 = true

			if FFlagEnableGamePassTrialUnifiedLogging then
				v18("settled")
			end
		end):catch(function(p)
			if typeof(p) == "table" and p.errorMessage ~= nil then
				p = p.errorMessage
			end

			warn("[Shop] hydrateGamePassTrialAvailabilities failed", p)

			if FFlagEnableGamePassTrialUnifiedLogging then
				v18("settled")
			end
		end):finally(function()
			v16 = false
			retryTrialsIfRequested() -- inferred equivalent call
		end)
	end

	local function applyWidgetTrialAvailabilities(data): boolean -- 2 equivalent calls inferred from this helper
		if not FFlagLuaAppEnableGamePassFreeTrials or FFlagShopUseMockGamePassTrialAvailabilities then
			return false
		end

		local gamePassTrialAvailabilities = data.gamePassTrialAvailabilities

		if gamePassTrialAvailabilities == nil or v17 or v16 then
			return false
		end

		v11(gamePassTrialAvailabilities)
		v17 = true

		if FFlagEnableGamePassTrialUnifiedLogging then
			v18("settled")
		end

		return true
	end

	local signal17, v32 = createSignal({})
	local signal18, v35 = createSignal(0)
	local function noteTrialRedeemSucceeded() -- 2 equivalent calls inferred from this helper
		v35(signal18(false) + 1)
	end

	local signal19, v36 = createSignal(nil)

	local function sendTrialEvent(action: number, trialElement: string, itemId: string, data, metadata)
		local sendGamePassTrialUnifiedEvent = require(InExperienceShop.Analytics.sendGamePassTrialUnifiedEvent)
		sendGamePassTrialUnifiedEvent.send({
			action = action,
			elementName = trialElement,
			itemId = itemId,
			shopPageType = data.shopPageType,
			universeId = data.universeId,
			trialStatus = data.trialStatus,
			metadata = metadata
		})
	end

	local function setGamePassTrialRedemptionInFlight(p: string, flag2: boolean) -- 2 equivalent calls inferred from this helper
		local clone = table.clone(signal17(false))

		if flag2 then
			clone[p] = true
		else
			clone[p] = nil
		end

		v32(clone)
	end

	local function signalGamePassFreeTrialRedeemed(p: number) -- 2 equivalent calls inferred from this helper
		local localPlayer = Players.LocalPlayer

		if localPlayer == nil then
			return
		end

		local v37 = MarketplaceService
		local success, result = pcall(function()
			v37:SignalGamePassFreeTrialRedeemed(localPlayer, p)
		end)

		if not success then
			warn("[Shop] SignalGamePassFreeTrialRedeemed failed", p, result)
		end
	end

	local function markGamePassTrialActive(p: string)
		local v37 = signal10(false)
		local clone = table.clone(v37.available)
		local clone2 = table.clone(v37.active)
		local clone3 = table.clone(v37.redeemed or {})
		clone[p] = nil
		clone3[p] = nil
		clone2[p] = true
		v11({ available = clone, active = clone2, redeemed = clone3 })
	end

	local function getTrialRedemptionFailureReason(p)
		local v37 = parseGamePassTrialRedeemErrorCode(p)

		if v37 ~= nil then
			return v37
		end

		if typeof(p) == "table" then
			local errorMessage = p.errorMessage

			if type(errorMessage) == "string" then
				return errorMessage
			end

			local responseCode = p.responseCode

			if responseCode ~= nil then
				return (tostring(responseCode))
			end
		end

		return (tostring(p))
	end

	local function redeemGamePassTrial2(gamePassId: string, purchaseContext)
		if signal17(false)[gamePassId] then
			return
		end

		local v37 = typeof(purchaseContext) ~= "table" and {} or purchaseContext

		if FFlagShopUseMockGamePassTrialRedemption then
			if FFlagEnableGamePassTrialUnifiedLogging then
				local sendGamePassTrialUnifiedEvent = require(InExperienceShop.Analytics.sendGamePassTrialUnifiedEvent)
				sendTrialEvent(
					sendGamePassTrialUnifiedEvent.clickAction,
					sendGamePassTrialUnifiedEvent.trialElement,
					gamePassId,
					v37
				)
				sendTrialEvent(
					sendGamePassTrialUnifiedEvent.successAction,
					sendGamePassTrialUnifiedEvent.trialElement,
					gamePassId,
					v37,
					{ latencyMs = 0 }
				)
			end

			markGamePassTrialActive(gamePassId)

			if FFlagCloseShopOnTrialRedemption then
				noteTrialRedeemSucceeded() -- inferred equivalent call
			end

			bumpRedeemedTrialToTopPicks(gamePassId) -- inferred equivalent call
			local v38 = tonumber(gamePassId)

			if v38 ~= nil then
				signalGamePassFreeTrialRedeemed(v38) -- inferred equivalent call
			end
		else
			local v38 = tonumber(gamePassId)

			if v38 == nil then
				warn("[Shop] redeemGamePassTrial skipped, gamePassId is not numeric", gamePassId)
				return
			end

			local lastTime, flag2

			if FFlagEnableGamePassTrialUnifiedLogging then
				local sendGamePassTrialUnifiedEvent = require(InExperienceShop.Analytics.sendGamePassTrialUnifiedEvent)

				lastTime = os.clock()
				sendTrialEvent(
					sendGamePassTrialUnifiedEvent.clickAction,
					sendGamePassTrialUnifiedEvent.trialElement,
					gamePassId,
					v37
				)
				flag2 = true
			else
				flag2 = false
				lastTime = 0
			end

			setGamePassTrialRedemptionInFlight(gamePassId, true) -- inferred equivalent call
			local flag3 = false

			redeemGamePassTrial.redeemGamePassTrial(v38):andThen(function()
				flag3 = true

				if flag2 then
					local sendGamePassTrialUnifiedEvent = require(InExperienceShop.Analytics.sendGamePassTrialUnifiedEvent)
					local latencyMs = math.floor((os.clock() - lastTime) * 1000)
					sendTrialEvent(
						sendGamePassTrialUnifiedEvent.successAction,
						sendGamePassTrialUnifiedEvent.trialElement,
						gamePassId,
						v37,
						{ latencyMs = latencyMs }
					)
				end

				if FFlagCloseShopOnTrialRedemption then
					noteTrialRedeemSucceeded() -- inferred equivalent call
				end

				bumpRedeemedTrialToTopPicks(gamePassId) -- inferred equivalent call
				signalGamePassFreeTrialRedeemed(v38) -- inferred equivalent call
				return fetchGamePassTrialAvailabilities.fetchGamePassTrialAvailabilities(game.GameId)
			end):andThen(function(p)
				v11(p)
				v17 = true

				if p.available[gamePassId] then
					markGamePassTrialActive(gamePassId)
				end
			end):catch(function(p)
				warn("[Shop] redeemGamePassTrial failed", gamePassId, (tostring(p)))

				if flag3 then
					markGamePassTrialActive(gamePassId)
				elseif flag2 then
					local sendGamePassTrialUnifiedEvent = require(InExperienceShop.Analytics.sendGamePassTrialUnifiedEvent)
					local latencyMs = math.floor((os.clock() - lastTime) * 1000)
					local failureAction = sendGamePassTrialUnifiedEvent.failureAction
					local trialElement = sendGamePassTrialUnifiedEvent.trialElement
					local failureReason = parseGamePassTrialRedeemErrorCode(p)

					if failureReason == nil then
						if typeof(p) == "table" then
							failureReason = p.errorMessage

							if type(failureReason) ~= "string" then
								local responseCode = p.responseCode

								if responseCode == nil then
									failureReason = tostring(p)
								else
									failureReason = tostring(responseCode)
								end
							end
						else
							failureReason = tostring(p)
						end
					end

					sendTrialEvent(failureAction, trialElement, gamePassId, v37, {
						latencyMs = latencyMs,
						failureReason = failureReason
					})
				end

				if FFlagLuaAppEnableGamePassFreeTrials and not flag3 then
					v36({
						gamePassId = gamePassId,
						errorCode = parseGamePassTrialRedeemErrorCode(p),
						purchaseContext = purchaseContext
					})
				end
			end):finally(function()
				setGamePassTrialRedemptionInFlight(gamePassId, false) -- inferred equivalent call
			end)
		end
	end

	local function fetchBonusGamePassOwnershipForPromotionId(p: string)
		if FFlagRefetchRobuxWidgetAfterPurchase and v23[p] then
			ShopDebugLogger.logLazy(function()
				return "fetchBonusGamePassOwnershipForPromotion: skip, poll in flight itemId=" .. p
			end)

			return
		end

		if v31[p] then
			return
		end

		commitBonusPromotionEligibility(p, BonusPromotionEligibility.Unknown) -- inferred equivalent call
		reapplyFeaturedPromotion() -- inferred equivalent call
		local v37 = tonumber(p)

		if v37 == nil then
			commitBonusPromotionEligibility(p, BonusPromotionEligibility.Ineligible) -- inferred equivalent call
			reapplyFeaturedPromotion() -- inferred equivalent call
		else
			v31[p] = true
			fetchOwnedGamePass(v37):andThen(function(flag2: boolean)
				local v38

				if flag2 then
					v38 = BonusPromotionEligibility.Ineligible
				else
					v38 = BonusPromotionEligibility.Eligible
				end

				commitBonusPromotionEligibility(p, v38) -- inferred equivalent call

				if signal9(false)[p] == nil then
					writeOwnership(p, flag2)
				end

				reapplyFeaturedPromotion() -- inferred equivalent call
			end):catch(function(p2)
				warn("[Shop] fetchBonusGamePassOwnershipForPromotion failed", p, (tostring(p2)))
				commitBonusPromotionEligibility(p, BonusPromotionEligibility.Ineligible) -- inferred equivalent call
				reapplyFeaturedPromotion() -- inferred equivalent call
			end):finally(function()
				v31[p] = nil
			end)
		end
	end

	local function fetchBonusGamePassOwnershipForPromotion(p)
		if not FFlagEnableRobuxInExperienceShop then
			return
		end

		local firstBonusRobuxPackage = promoteBonusRobuxPackageToTopPicks.findFirstBonusRobuxPackage(p)
		local v37

		if firstBonusRobuxPackage ~= nil then
			v37 = promoteBonusRobuxPackageToTopPicks.getBonusGamePassId(firstBonusRobuxPackage)
		end

		for _, v38 in v37 == nil and {} or { v37 } do
			fetchBonusGamePassOwnershipForPromotionId(v38)
		end
	end

	local function applySections(p) -- 6 equivalent calls inferred from this helper
		v29 = promoteBonusRobuxPackageToTopPicks.withoutFeaturedPromotion(p)
		reapplyFeaturedPromotion() -- inferred equivalent call
		fetchBonusGamePassOwnershipForPromotion(v29)
	end

	local function commitShopMetadata(data)
		v9(data.notificationFreeTrialTopBarChip == true)

		if FFlagEnableExperienceShopGlobalIcon then
			local metadata = data.metadata
			v6(metadata)
			local inExperienceGlobalIconEnabled

			if metadata ~= nil then
				inExperienceGlobalIconEnabled = metadata.inExperienceGlobalIconEnabled
			end

			local v37

			if FFlagInExperienceShopExpectStringMetadataValues then
				v37 = inExperienceGlobalIconEnabled == "true"
			else
				v37 = inExperienceGlobalIconEnabled == true
			end

			v7(v37)
			v8(metadata ~= nil and metadata.newOffers == true)
		end
	end

	local function publishShopHasItems(data) -- 2 equivalent calls inferred from this helper
		if FFlagHideOfferNotificationsWhenShopEmpty then
			InExperienceOffers.getOffersStore(false).setShopHasItems(hasOfferEligibleCategory(data.categories))
		end
	end

	local function buildProductInfoRequestsForHydration(p, p2)
		local refreshShopItems = require(InExperienceShop.Api.refreshShopItems)
		local hydrateRobuxBonusItems = require(InExperienceShop.Api.hydrateRobuxBonusItems)
		local requestsFromSections = refreshShopItems.buildRequestsFromSections(p)

		if FFlagEnableRobuxInExperienceShop then
			hydrateRobuxBonusItems.appendBonusItemRequests(requestsFromSections, p)
		end

		refreshShopItems.appendFailedItemRequests(requestsFromSections, p2)
		return requestsFromSections
	end

	local function applyStreamingProductInfoResult(p, p2, items)
		local refreshShopItems = require(InExperienceShop.Api.refreshShopItems)
		local hydrateRobuxBonusItems = require(InExperienceShop.Api.hydrateRobuxBonusItems)
		local shopItemMapping = require(InExperienceShop.Api.shopItemMapping)
		local makeRequestKey = shopItemMapping.makeRequestKey

		local requestKey = makeRequestKey(p2.request.id, p2.request.infoType)
		local v37 = {}
		local result = {}

		for _, item in items do
			if makeRequestKey(item.id, item.infoType) == requestKey then
				table.insert(v37, item)
			else
				table.insert(result, item)
			end
		end

		local mergeProductInfoIntoSections = refreshShopItems.mergeProductInfoIntoSections(p, { p2 })

		if FFlagEnableRobuxInExperienceShop then
			mergeProductInfoIntoSections = hydrateRobuxBonusItems.mergeBonusItemDetailsIntoSections(
				mergeProductInfoIntoSections,
				{ p2 }
			)
		end

		local v38, v39 = refreshShopItems.insertRecoveredItemsIntoSections(mergeProductInfoIntoSections, { p2 }, v37)

		for _, v40 in v39 do
			table.insert(result, v40)
		end

		return v38, result
	end

	local function routeStreamMultiGetProductInfo(list, onResult)
		if FFlagShopUseMockData and FFlagShopUseMockMultiGetProductInfo then
			return MockMultiGetProductInfo.streamMultiGetProductInfo(list, { onResult = onResult }, 0)
		end

		return streamMultiGetProductInfo(list, { onResult = onResult })
	end

	local function streamProductInfoIntoSections(p, list, p2, callback)
		if #list == 0 then
			if callback then
				callback(p2)
			end
		else
			v27 = true
			local v37 = p
			local v38 = p2
			local v39 = nil
			local flag2 = false

			local function flushPendingSections() -- 2 equivalent calls inferred from this helper
				flag2 = false

				if v39 ~= nil then
					applySections(v39) -- inferred equivalent call
					v39 = nil
				end
			end

			local function scheduleFlush(p3) -- 1 equivalent call inferred from this helper
				v39 = p3

				if flag2 then
					return
				end

				flag2 = true
				task.delay(0.05, flushPendingSections)
			end

			routeStreamMultiGetProductInfo(list, function(p3)
				v37, v38 = applyStreamingProductInfoResult(v37, p3, v38)
				scheduleFlush(v37) -- inferred equivalent call
			end):andThen(function(_)
				flushPendingSections() -- inferred equivalent call
				applySections(v37) -- inferred equivalent call
				v28 = v38

				if #v38 > 0 then
					logCounter(ProductInfoFailedItemsCounter, #v38)
				end

				v27 = false

				if callback then
					callback(v38)
				end
			end):catch(function(p3)
				warn("[Shop] streamProductInfoIntoSections failed", (tostring(p3)))
				flushPendingSections() -- inferred equivalent call
				v27 = false

				if callback then
					callback(v38)
				end
			end)
		end
	end

	local function runShopFetch(callback, callback2, p: string)
		if v25 or v24 then
			return
		end

		v24 = true
		v4(true)
		v5(nil)
		local v37

		if FFlagShopUseMockData then
			v37 = callback2()
		else
			v37 = callback()
		end

		v37:andThen(function(data)
			if not isValidShopData(data) then -- inferred equivalent call
				return Errors.rejectSchema(
					string.format("createInExperienceShopStore: %s payload missing categories/sections", p),
					data
				)
			end

			v2(data.categories)
			applySections(data.sections) -- inferred equivalent call
			commitShopMetadata(data)
			publishShopHasItems(data) -- inferred equivalent call
			v28 = data.failedItems or {}
			v4(false)
			v24 = false
			v25 = true

			if not applyWidgetTrialAvailabilities(data) then -- inferred equivalent call
				hydrateGamePassTrialAvailabilities()
			end

			if not FFlagEnableOffersPrefetch then
				InExperienceOffers.getOffersStore(false).fetchOffers(v)
			end
		end):catch(function(p2)
			v5(p2)
			v2({})
			v3({})

			v28 = {}
			v4(false)
			v24 = false
		end)
	end

	local function runPartialDisplayShopFetch(fetchShopWidgetsOnly2, fetchShopWidgetsOnly3, p: string)
		if v25 or v24 then
			return
		end

		v24 = true
		v4(true)
		v5(nil)
		local v37

		if FFlagShopUseMockData then
			v37 = fetchShopWidgetsOnly3()
		else
			v37 = fetchShopWidgetsOnly2()
		end

		v37:andThen(function(data)
			if not isValidShopData(data) then -- inferred equivalent call
				return Errors.rejectSchema(
					string.format("createInExperienceShopStore: %s payload missing categories/sections", p),
					data
				)
			end

			v2(data.categories)
			applySections(data.sections) -- inferred equivalent call
			commitShopMetadata(data)
			publishShopHasItems(data) -- inferred equivalent call
			v28 = data.failedItems or {}
			v4(false)
			v24 = false
			v25 = true

			if not applyWidgetTrialAvailabilities(data) then -- inferred equivalent call
				hydrateGamePassTrialAvailabilities()
			end

			if not FFlagEnableOffersPrefetch then
				InExperienceOffers.getOffersStore(false).fetchOffers(v)
			end

			streamProductInfoIntoSections(v29, buildProductInfoRequestsForHydration(v29, v28), v28, nil)
		end):catch(function(p2)
			v5(p2)
			v2({})
			v3({})
			v28 = {}
			v4(false)
			v24 = false
		end)
	end

	local function fetchAllShopData2() -- 1 equivalent call inferred from this helper
		if isPartialDisplayEnabled() then -- inferred equivalent call
			runPartialDisplayShopFetch(
				fetchShopWidgetsOnly,
				MockFetchAllShopData.fetchShopWidgetsOnly,
				"fetchAllShopData"
			)
		else
			runShopFetch(fetchAllShopData, MockFetchAllShopData.fetchAllShopData, "fetchAllShopData")
		end
	end

	local function refreshShopItemInfo()
		if not FFlagEnableShopProductInfoRefresh or (not v25 or v26 or v27) then
			return
		end

		local refreshShopItems = require(InExperienceShop.Api.refreshShopItems)
		local hydrateRobuxBonusItems = require(InExperienceShop.Api.hydrateRobuxBonusItems)
		local v37

		if #v29 > 0 then
			v37 = v29
		else
			v37 = signal2(false)
		end

		local requestsFromSections = refreshShopItems.buildRequestsFromSections(v37)

		if FFlagEnableRobuxInExperienceShop then
			hydrateRobuxBonusItems.appendBonusItemRequests(requestsFromSections, v37)
		end

		local v38 = v28
		refreshShopItems.appendFailedItemRequests(requestsFromSections, v38)

		if #requestsFromSections == 0 then
			return
		end

		v26 = true

		if isPartialDisplayEnabled() then -- inferred equivalent call
			streamProductInfoIntoSections(v37, requestsFromSections, v38, function()
				v26 = false
			end)
			return
		end

		local v39

		if FFlagShopUseMockData and FFlagShopUseMockMultiGetProductInfo then
			v39 = MockMultiGetProductInfo.multiGetProductInfo(requestsFromSections, 0)
		else
			v39 = multiGetProductInfo(requestsFromSections)
		end

		v39:andThen(function(p)
			local mergeProductInfoIntoSections = refreshShopItems.mergeProductInfoIntoSections(v37, p)

			if FFlagEnableRobuxInExperienceShop then
				mergeProductInfoIntoSections = hydrateRobuxBonusItems.mergeBonusItemDetailsIntoSections(
					mergeProductInfoIntoSections,
					p
				)
			end

			local v40, v41 = refreshShopItems.insertRecoveredItemsIntoSections(mergeProductInfoIntoSections, p, v38)
			v28 = v41
			applySections(v40) -- inferred equivalent call
			v26 = false
		end):catch(function(p)
			warn("[Shop] refreshShopItemInfo failed", (tostring(p)))
			v26 = false
		end)
	end

	local function onShopOpened()
		if FFlagOfferNineDotActivityIndicator or FFlagOfferNotifyOnGlobalIcon then
			InExperienceOffers.getOffersStore(false).markInExperienceShopOpened()
		end

		if FFlagEnableShopExposureLogging then
			local IxpServiceWrapper = require(parent.IxpServiceWrapper)
			local ixpServiceWrapper = IxpServiceWrapper.IXPServiceWrapper

			for _, v37 in { FStringExperienceShopLayer1, FStringExperienceShopLayer2 } do
				if v37 ~= "" then
					ixpServiceWrapper:LogUserLayerExposure(v37)
				end
			end
		end

		if FFlagEnableShopFlagLinkedExposureLogging and FStringExperienceShopFlagLinkedLayer ~= "" then
			local IxpServiceWrapper = require(parent.IxpServiceWrapper)
			IxpServiceWrapper.IXPServiceWrapper:LogFlagLinkedUserLayerExposure(FStringExperienceShopFlagLinkedLayer)
		end

		if FFlagLuaAppEnableGamePassFreeTrials and not v17 then
			if v25 and not v16 then
				hydrateGamePassTrialAvailabilities()
			else
				v19 = true
			end
		end

		fetchAllShopData2() -- inferred equivalent call
		refreshShopItemInfo()
	end

	local function refreshRobuxWidgetsAfterPurchase()
		if not FFlagRefetchRobuxWidgetAfterPurchase or not v25 or flag then
			return Promise.resolve()
		end

		flag = true
		ShopDebugLogger.log("refreshRobuxWidgetsAfterPurchase: start")
		local v37

		if FFlagShopUseMockData then
			v37 = MockFetchAllShopData.fetchRobuxWidgetsAfterPurchase(0)
		else
			v37 = fetchRobuxWidgetsAfterPurchase.fetchRobuxWidgetsAfterPurchase()
		end

		return v37:andThen(function(p)
			if not isValidShopData(p) then -- inferred equivalent call
				ShopDebugLogger.log("refreshRobuxWidgetsAfterPurchase: skip, invalid payload")
				return
			end

			local v38, v39 = mergeRobuxShopData(signal(false), v29, p)
			v2(v38)
			applySections(v39) -- inferred equivalent call
		end):catch(function(p)
			ShopDebugLogger.logLazy(function()
				return "refreshRobuxWidgetsAfterPurchase: failed err=" .. tostring(p)
			end)
		end):finally(function()
			flag = false
		end)
	end

	local function pollOwnershipUntilTrue(callback, p: number, p2: number, POLL_INITIAL_DELAY_SECONDS: number)
		return callback(p):andThen(function(flag2: boolean)
			if flag2 then
				return true
			end

			if p2 <= 1 then
				return false
			end

			return Promise.delay(POLL_INITIAL_DELAY_SECONDS):andThen(function()
				return pollOwnershipUntilTrue(
					callback,
					p,
					p2 - 1,
					POLL_INITIAL_DELAY_SECONDS * Constants.POLL_BACKOFF_MULTIPLIER
				)
			end)
		end):catch(function(p3)
			if p2 <= 1 then
				warn("[Shop] pollOwnershipUntilTrue exhausted with engine error", p, (tostring(p3)))
				return nil
			end

			return Promise.delay(POLL_INITIAL_DELAY_SECONDS):andThen(function()
				return pollOwnershipUntilTrue(
					callback,
					p,
					p2 - 1,
					POLL_INITIAL_DELAY_SECONDS * Constants.POLL_BACKOFF_MULTIPLIER
				)
			end)
		end)
	end

	local function pollGamePassOwnershipAfterPurchase(p: string, FIntShopOwnershipFetchMaxAttempts2: number, callback, flag2: boolean?)
		if v23[p] then
			ShopDebugLogger.logLazy(function()
				return "pollGamePassOwnership: already in flight itemId=" .. p
			end)

			return
		end

		local v37 = tonumber(p)

		if v37 == nil then
			ShopDebugLogger.logLazy(function()
				return "pollGamePassOwnership: skip invalid itemId=" .. p
			end)

			return
		end

		v23[p] = true
		ShopDebugLogger.logLazy(function()
			return "pollGamePassOwnership: start itemId=" .. p .. " maxAttempts=" .. tostring(FIntShopOwnershipFetchMaxAttempts2) .. " signalOnSuccess=" .. tostring(flag2 == true)
		end)

		local function startPoll()
			pollOwnershipUntilTrue(
				callback,
				v37,
				FIntShopOwnershipFetchMaxAttempts2,
				Constants.POLL_INITIAL_DELAY_SECONDS
			):andThen(function(flag3: boolean?)
				ShopDebugLogger.logLazy(function()
					return "pollGamePassOwnership: result itemId=" .. p .. " owned=" .. tostring(flag3)
				end)

				if flag3 ~= true then
					return
				end

				writeOwnership(p, flag3)

				if flag2 then
					local localPlayer = Players.LocalPlayer

					if localPlayer ~= nil then
						ShopDebugLogger.logLazy(function()
							return "pollGamePassOwnership: SignalPromptGamePassPurchaseFinished itemId=" .. p
						end)

						MarketplaceService:SignalPromptGamePassPurchaseFinished(localPlayer, v37, true)
					end
				end
			end):finally(function()
				v23[p] = nil
			end)
		end

		Promise.delay(Constants.POLL_INITIAL_DELAY_SECONDS):andThen(startPoll)
	end

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p, p2: number, flag2: boolean)
		if not flag2 then
			return
		end

		local localPlayer = Players.LocalPlayer

		if localPlayer == nil or p.UserId ~= localPlayer.UserId then
			return
		end

		pollGamePassOwnershipAfterPurchase(tostring(p2), FIntShopOwnershipFetchMaxAttempts, fetchOwnedGamePass)
	end)

	if FFlagShopListenNativePurchaseFinished and FFlagEnableRobuxInExperienceShop then
		local function pollBonusOwnershipAfterNativeRobuxPurchase(flag2: boolean, p, p2)
			if p2 ~= nil then
				local localPlayer = Players.LocalPlayer

				if localPlayer == nil or p2.UserId ~= localPlayer.UserId then
					ShopDebugLogger.log("NativePurchaseFinished: ignored, not local player")
					return
				end
			end

			local v37 = v20
			local v38 = v21
			local v39 = v22

			if
				v38 == nil
				or not FFlagRefetchRobuxWidgetAfterPurchase
				and v37 == nil
				and (not FFlagShopRobuxPurchaseCompletionModal or v39 == nil)
			then
				ShopDebugLogger.log("NativePurchaseFinished: skip, no pending shop Robux purchase")
				return
			end

			if tostring(p) ~= v38 then
				ShopDebugLogger.logLazy(function()
					return "NativePurchaseFinished: skip, sku mismatch productId=" .. tostring(p) .. " pendingStoreSku=" .. v38
				end)

				return
			end

			v20 = nil
			v21 = nil
			v22 = nil

			if not flag2 then
				ShopDebugLogger.logLazy(function()
					return "NativePurchaseFinished: skip, not purchased bonusGamePassId=" .. tostring(v37)
				end)

				return
			end

			if FFlagShopRobuxPurchaseCompletionModal and v39 ~= nil then
				v14(v39)
			end

			if v37 ~= nil then
				ShopDebugLogger.logLazy(function()
					return "NativePurchaseFinished: polling bonusGamePassId=" .. v37
				end)
				local v40

				if FFlagShopUseMockUserOwnsGamePass then
					v40 = MockUserOwnsGamePass
				else
					v40 = userOwnsGamePassHttp
				end

				pollGamePassOwnershipAfterPurchase(v37, FIntShopOwnershipFetchMaxAttempts, v40, true)
			end

			if FFlagRefetchRobuxWidgetAfterPurchase and (v37 ~= nil or not FFlagSkipPaymentSessionForPlainRobux) then
				refreshRobuxWidgetsAfterPurchase()
			end
		end

		local function onNativePurchaseFinished(p, p2, flag2: boolean, p3: string?)
			ShopDebugLogger.logLazy(function()
				return "NativePurchaseFinished: productId=" .. tostring(p2) .. " wasPurchased=" .. tostring(flag2) .. " checkoutSessionId=" .. tostring(p3)
			end)

			pollBonusOwnershipAfterNativeRobuxPurchase(flag2, p2, p)
		end

		local function onNativePurchaseFinishedWithLocalPlayer(p, flag2: boolean, p2: string?)
			ShopDebugLogger.logLazy(function()
				return "NativePurchaseFinishedWithLocalPlayer: productId=" .. tostring(p) .. " wasPurchased=" .. tostring(flag2) .. " checkoutSessionId=" .. tostring(p2)
			end)

			pollBonusOwnershipAfterNativeRobuxPurchase(flag2, p, nil)
		end

		local function connectIfAvailable(value, callback) -- 4 equivalent calls inferred from this helper
			if typeof(value) == "RBXScriptSignal" or type(value) == "table" and value.Connect ~= nil then
				value:Connect(callback)
			end
		end

		local v37 = MarketplaceService
		local engineFeature = game:GetEngineFeature("NativePurchaseWithLocalPlayer")
		ShopDebugLogger.logLazy(function()
			return "NativePurchaseFinished: connecting v2=" .. tostring(FFlagLuaAppEnableNativePurchaseFinishedV2Signals) .. " localPlayerFeature=" .. tostring(engineFeature)
		end)

		connectIfAvailable(v37.NativePurchaseFinished, onNativePurchaseFinished) -- inferred equivalent call

		if FFlagLuaAppEnableNativePurchaseFinishedV2Signals then
			connectIfAvailable(v37.NativePurchaseFinishedV2, onNativePurchaseFinished) -- inferred equivalent call
		end

		if engineFeature then
			connectIfAvailable(v37.NativePurchaseFinishedWithLocalPlayer, onNativePurchaseFinishedWithLocalPlayer) -- inferred equivalent call

			if FFlagLuaAppEnableNativePurchaseFinishedV2Signals then
				connectIfAvailable(v37.NativePurchaseFinishedWithLocalPlayerV2, onNativePurchaseFinishedWithLocalPlayer) -- inferred equivalent call
			end
		end
	end

	return {
		getCategories = signal,
		getSections = signal2,
		getLoading = signal3,
		getError = signal4,
		getOwnership = signal9,
		getTrialAvailabilities = signal10,
		getTrialAvailabilityPhase = signal14,
		getTrialRedemptionInFlight = signal17,
		getTrialRedeemSuccessCount = signal18,
		getTrialRedemptionError = signal19,
		dismissTrialRedemptionError = function()
			v36(nil)
		end,
		getBonusPromotionEligibility = signal11,
		getItemsPerRow = signal12,
		getMetadata = signal5,
		getGlobalIconBackendEnabled = signal6,
		getGlobalIconHasNewOffers = signal7,
		getNotificationFreeTrialTopBarChip = signal8,
		getShouldOpenToRobuxTab = signal15,
		getOpenedFromBuyRobux = signal16,
		getPurchasedRobuxAmount = signal13,
		dismissRobuxPurchaseSuccess = function()
			v14(nil)
		end,
		onShopOpened = onShopOpened,
		fetchAllShopData = fetchAllShopData2,
		prefetchWidgetsOnly = function()
			runShopFetch(fetchShopWidgetsOnly, MockFetchAllShopData.fetchShopWidgetsOnly, "prefetchWidgetsOnly")
		end,
		refreshShopItemInfo = refreshShopItemInfo,
		refreshRobuxWidgetsAfterPurchase = refreshRobuxWidgetsAfterPurchase,
		fetchGamePassOwnership = function(p: string)
			if v15[p] or signal9(false)[p] ~= nil then
				return
			end

			local v34 = tonumber(p)

			if v34 == nil then
				return
			end

			v15[p] = true
			fetchOwnedGamePass(v34):andThen(function(flag2: boolean)
				if signal9(false)[p] ~= nil then
					return
				end

				writeOwnership(p, flag2)
			end):catch(function(p2)
				warn("[Shop] fetchGamePassOwnership failed", p, (tostring(p2)))
			end):finally(function()
				v15[p] = nil
			end)
		end,
		redeemGamePassTrial = redeemGamePassTrial2,
		pollGamePassOwnership = pollGamePassOwnershipAfterPurchase,
		bonusGamePassIdForNativePurchase = bonusGamePassIdForNativePurchase,
		setItemsPerRow = function(p: number)
			v13(p)
		end,
		setShouldOpenToRobuxTab = setShouldOpenToRobuxTab,
		setOpenedFromBuyRobux = setOpenedFromBuyRobux
	}
end

return createInExperienceShopStore
