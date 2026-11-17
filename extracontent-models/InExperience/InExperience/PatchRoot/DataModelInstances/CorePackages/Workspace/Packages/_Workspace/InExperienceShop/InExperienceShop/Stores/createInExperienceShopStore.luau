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
local FFlagEnableFreeTrialTopBarChip = require(InExperienceShop.Flags.FFlagEnableFreeTrialTopBarChip)
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
local FFlagRefetchShopWidgetsAfterPassPurchase = require(InExperienceShop.Flags.FFlagRefetchShopWidgetsAfterPassPurchase)
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
	local count = 0
	local count2 = 0

	local v28 = false

	local v29 = {}

	local v30 = {}

	local v31 = {}
	local v32 = {}

	local signal15, setShouldOpenToRobuxTab = createSignal(false)

	local signal16, setOpenedFromBuyRobux = createSignal(false)

	local function commitBonusPromotionEligibility(p: string, p2) -- 5 equivalent calls inferred from this helper
		v31[p] = p2
		v12(table.clone(v31))
	end

	local function sortRobuxPackagesInSections(list)
		local v35 = false

		for _, item in list do
			local robuxPackages = item.robuxPackages

			if robuxPackages ~= nil and #robuxPackages > 1 then
				v35 = true
				break
			end
		end

		if not v35 then
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
		v3(sortRobuxPackagesInSections(promoteBonusRobuxPackageToTopPicks.promoteBonusRobuxPackageToTopPicks(v30, v31)))
	end

	local function bumpRedeemedTrialToTopPicks(p: string) -- 2 equivalent calls inferred from this helper
		local topPicksSectionIndex = findTopPicksSectionIndex(v30)

		if topPicksSectionIndex ~= nil then
			v30 = moveItemToPositionInShop(v30, topPicksSectionIndex, p, "GamePass", 1)
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

		local firstBonusRobuxPackage = promoteBonusRobuxPackageToTopPicks.findFirstBonusRobuxPackage(v30)
		local v35

		if firstBonusRobuxPackage ~= nil then
			v35 = promoteBonusRobuxPackageToTopPicks.getBonusGamePassId(firstBonusRobuxPackage)
		end

		if v35 == nil or v35 ~= p then
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
			local v35

			if FFlagShopUseMockUserOwnsGamePass then
				v35 = MockUserOwnsGamePass
			else
				v35 = userOwnsGamePass
			end

			return v35(p)
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
		local v35

		if FFlagShopUseMockGamePassTrialAvailabilities then
			v35 = MockGamePassTrialAvailabilities.fetchGamePassTrialAvailabilities
		else
			v35 = fetchGamePassTrialAvailabilities.fetchGamePassTrialAvailabilities
		end

		v35(game.GameId):andThen(function(p)
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

	local signal17, v35 = createSignal({})
	local signal18, v36 = createSignal(nil)
	local signal19, v37 = createSignal(nil)
	local signal20, v38 = createSignal(0)
	local function recordRedeemedTrialThumbnail(gamePassId: string, p: string?) -- 2 equivalent calls inferred from this helper
		v36({
			image = p == nil and "" or p,
			gamePassId = gamePassId
		})
	end
	local function noteTrialRedeemSucceeded() -- 2 equivalent calls inferred from this helper
		v38(signal20(false) + 1)
	end

	local signal21, v39 = createSignal(nil)

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

		v35(clone)
	end

	local function signalGamePassFreeTrialRedeemed(p: number) -- 2 equivalent calls inferred from this helper
		local localPlayer = Players.LocalPlayer

		if localPlayer == nil then
			return
		end

		local v40 = MarketplaceService
		local success, result = pcall(function()
			v40:SignalGamePassFreeTrialRedeemed(localPlayer, p)
		end)

		if not success then
			warn("[Shop] SignalGamePassFreeTrialRedeemed failed", p, result)
		end
	end

	local function markGamePassTrialActive(p: string)
		local v40 = signal10(false)
		local clone = table.clone(v40.available)
		local clone2 = table.clone(v40.active)
		local clone3 = table.clone(v40.redeemed or {})
		clone[p] = nil
		clone3[p] = nil
		clone2[p] = true
		v11({ available = clone, active = clone2, redeemed = clone3 })
	end

	local function getTrialRedemptionFailureReason(p)
		local v40 = parseGamePassTrialRedeemErrorCode(p)

		if v40 ~= nil then
			return v40
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

	local function redeemGamePassTrial2(gamePassId: string, purchaseContext, p: string?)
		if signal17(false)[gamePassId] then
			return
		end

		local v40 = typeof(purchaseContext) ~= "table" and {} or purchaseContext

		if FFlagShopUseMockGamePassTrialRedemption then
			if FFlagEnableGamePassTrialUnifiedLogging then
				local sendGamePassTrialUnifiedEvent = require(InExperienceShop.Analytics.sendGamePassTrialUnifiedEvent)
				sendTrialEvent(
					sendGamePassTrialUnifiedEvent.clickAction,
					sendGamePassTrialUnifiedEvent.trialElement,
					gamePassId,
					v40
				)
				sendTrialEvent(
					sendGamePassTrialUnifiedEvent.successAction,
					sendGamePassTrialUnifiedEvent.trialElement,
					gamePassId,
					v40,
					{ latencyMs = 0 }
				)
			end

			markGamePassTrialActive(gamePassId)

			if FFlagEnableFreeTrialTopBarChip then
				recordRedeemedTrialThumbnail(gamePassId, p) -- inferred equivalent call
			end

			if FFlagCloseShopOnTrialRedemption then
				noteTrialRedeemSucceeded() -- inferred equivalent call
			end

			bumpRedeemedTrialToTopPicks(gamePassId) -- inferred equivalent call
			local v41 = tonumber(gamePassId)

			if v41 ~= nil then
				signalGamePassFreeTrialRedeemed(v41) -- inferred equivalent call
			end
		else
			local v41 = tonumber(gamePassId)

			if v41 == nil then
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
					v40
				)
				flag2 = true
			else
				flag2 = false
				lastTime = 0
			end

			setGamePassTrialRedemptionInFlight(gamePassId, true) -- inferred equivalent call
			local flag3 = false

			redeemGamePassTrial.redeemGamePassTrial(v41):andThen(function()
				flag3 = true

				if flag2 then
					local sendGamePassTrialUnifiedEvent = require(InExperienceShop.Analytics.sendGamePassTrialUnifiedEvent)
					local latencyMs = math.floor((os.clock() - lastTime) * 1000)
					sendTrialEvent(
						sendGamePassTrialUnifiedEvent.successAction,
						sendGamePassTrialUnifiedEvent.trialElement,
						gamePassId,
						v40,
						{ latencyMs = latencyMs }
					)
				end

				if FFlagEnableFreeTrialTopBarChip then
					recordRedeemedTrialThumbnail(gamePassId, p) -- inferred equivalent call
				end

				if FFlagCloseShopOnTrialRedemption then
					noteTrialRedeemSucceeded() -- inferred equivalent call
				end

				bumpRedeemedTrialToTopPicks(gamePassId) -- inferred equivalent call
				signalGamePassFreeTrialRedeemed(v41) -- inferred equivalent call
				return fetchGamePassTrialAvailabilities.fetchGamePassTrialAvailabilities(game.GameId)
			end):andThen(function(p2)
				v11(p2)
				v17 = true

				if p2.available[gamePassId] then
					markGamePassTrialActive(gamePassId)
				end
			end):catch(function(p2)
				warn("[Shop] redeemGamePassTrial failed", gamePassId, (tostring(p2)))

				if flag3 then
					markGamePassTrialActive(gamePassId)
				elseif flag2 then
					local sendGamePassTrialUnifiedEvent = require(InExperienceShop.Analytics.sendGamePassTrialUnifiedEvent)
					local latencyMs = math.floor((os.clock() - lastTime) * 1000)
					local failureAction = sendGamePassTrialUnifiedEvent.failureAction
					local trialElement = sendGamePassTrialUnifiedEvent.trialElement
					local failureReason = parseGamePassTrialRedeemErrorCode(p2)

					if failureReason == nil then
						if typeof(p2) == "table" then
							failureReason = p2.errorMessage

							if type(failureReason) ~= "string" then
								local responseCode = p2.responseCode

								if responseCode == nil then
									failureReason = tostring(p2)
								else
									failureReason = tostring(responseCode)
								end
							end
						else
							failureReason = tostring(p2)
						end
					end

					sendTrialEvent(failureAction, trialElement, gamePassId, v40, {
						latencyMs = latencyMs,
						failureReason = failureReason
					})
				end

				if FFlagLuaAppEnableGamePassFreeTrials and not flag3 then
					v39({
						gamePassId = gamePassId,
						errorCode = parseGamePassTrialRedeemErrorCode(p2),
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

		if v32[p] then
			return
		end

		commitBonusPromotionEligibility(p, BonusPromotionEligibility.Unknown) -- inferred equivalent call
		reapplyFeaturedPromotion() -- inferred equivalent call
		local v40 = tonumber(p)

		if v40 == nil then
			commitBonusPromotionEligibility(p, BonusPromotionEligibility.Ineligible) -- inferred equivalent call
			reapplyFeaturedPromotion() -- inferred equivalent call
		else
			v32[p] = true
			fetchOwnedGamePass(v40):andThen(function(flag2: boolean)
				local v41

				if flag2 then
					v41 = BonusPromotionEligibility.Ineligible
				else
					v41 = BonusPromotionEligibility.Eligible
				end

				commitBonusPromotionEligibility(p, v41) -- inferred equivalent call

				if signal9(false)[p] == nil then
					writeOwnership(p, flag2)
				end

				reapplyFeaturedPromotion() -- inferred equivalent call
			end):catch(function(p2)
				warn("[Shop] fetchBonusGamePassOwnershipForPromotion failed", p, (tostring(p2)))
				commitBonusPromotionEligibility(p, BonusPromotionEligibility.Ineligible) -- inferred equivalent call
				reapplyFeaturedPromotion() -- inferred equivalent call
			end):finally(function()
				v32[p] = nil
			end)
		end
	end

	local function fetchBonusGamePassOwnershipForPromotion(p)
		if not FFlagEnableRobuxInExperienceShop then
			return
		end

		local firstBonusRobuxPackage = promoteBonusRobuxPackageToTopPicks.findFirstBonusRobuxPackage(p)
		local v40

		if firstBonusRobuxPackage ~= nil then
			v40 = promoteBonusRobuxPackageToTopPicks.getBonusGamePassId(firstBonusRobuxPackage)
		end

		for _, v41 in v40 == nil and {} or { v40 } do
			fetchBonusGamePassOwnershipForPromotionId(v41)
		end
	end

	local function applySections(p) -- 6 equivalent calls inferred from this helper
		v30 = promoteBonusRobuxPackageToTopPicks.withoutFeaturedPromotion(p)
		reapplyFeaturedPromotion() -- inferred equivalent call
		fetchBonusGamePassOwnershipForPromotion(v30)
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

			local v40

			if FFlagInExperienceShopExpectStringMetadataValues then
				v40 = inExperienceGlobalIconEnabled == "true"
			else
				v40 = inExperienceGlobalIconEnabled == true
			end

			v7(v40)
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
		local v40 = {}
		local result = {}

		for _, item in items do
			if makeRequestKey(item.id, item.infoType) == requestKey then
				table.insert(v40, item)
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

		local v41, v42 = refreshShopItems.insertRecoveredItemsIntoSections(mergeProductInfoIntoSections, { p2 }, v40)

		for _, v43 in v42 do
			table.insert(result, v43)
		end

		return v41, result
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
			v28 = true
			local v40 = p
			local v41 = p2
			local v42 = nil
			local flag2 = false
			local v43 = count2

			local function flushPendingSections() -- 2 equivalent calls inferred from this helper
				flag2 = false

				if v42 ~= nil and v43 == count2 then
					applySections(v42) -- inferred equivalent call
				end

				v42 = nil
			end

			local function scheduleFlush(p3) -- 1 equivalent call inferred from this helper
				v42 = p3

				if flag2 then
					return
				end

				flag2 = true
				task.delay(0.05, flushPendingSections)
			end

			routeStreamMultiGetProductInfo(list, function(p3)
				v40, v41 = applyStreamingProductInfoResult(v40, p3, v41)
				scheduleFlush(v40) -- inferred equivalent call
			end):andThen(function(_)
				flushPendingSections() -- inferred equivalent call

				if v43 == count2 then
					applySections(v40) -- inferred equivalent call
					v29 = v41

					if #v41 > 0 then
						logCounter(ProductInfoFailedItemsCounter, #v41)
					end

					v28 = false

					if callback then
						callback(v41)
					end
				else
					v28 = false

					if callback then
						callback(v29)
					end
				end
			end):catch(function(p3)
				warn("[Shop] streamProductInfoIntoSections failed", (tostring(p3)))
				flushPendingSections() -- inferred equivalent call
				v28 = false

				if callback then
					callback(v41)
				end
			end)
		end
	end

	local function finishWidgetFetch(p: number) -- 2 equivalent calls inferred from this helper
		v25 = p == count
		v27 = not v25
	end

	local function isFailedItemOnScreen(failedItems): boolean
		if failedItems == nil or #failedItems == 0 then
			return false
		end

		local set = {}

		for _, v40 in v30 do
			for _, item in v40.items do
				set[`{item.itemType}:{item.id}`] = true
			end
		end

		for _, item in failedItems do
			if set[`{item.itemType}:{item.id}`] then
				return true
			end
		end

		return false
	end

	local function runShopFetch(callback, callback2, p: string)
		if v25 or v24 then
			return
		end

		v24 = true
		local v40 = v27
		local v41 = count

		if not v40 then
			v4(true)
			v5(nil)
		end

		local v42

		if FFlagShopUseMockData then
			v42 = callback2()
		else
			v42 = callback()
		end

		v42:andThen(function(data)
			if not isValidShopData(data) then -- inferred equivalent call
				return Errors.rejectSchema(
					string.format("createInExperienceShopStore: %s payload missing categories/sections", p),
					data
				)
			end

			if v40 and isFailedItemOnScreen(data.failedItems) then
				warn("[Shop] stale widget refetch missing on-screen items", #data.failedItems)
				v24 = false
			else
				count2 += 1
				v2(data.categories)
				applySections(data.sections) -- inferred equivalent call
				commitShopMetadata(data)
				publishShopHasItems(data) -- inferred equivalent call
				v29 = data.failedItems or {}
				v4(false)
				v24 = false
				finishWidgetFetch(v41) -- inferred equivalent call

				if not applyWidgetTrialAvailabilities(data) then -- inferred equivalent call
					hydrateGamePassTrialAvailabilities()
				end

				if not FFlagEnableOffersPrefetch then
					InExperienceOffers.getOffersStore(false).fetchOffers(v)
				end
			end
		end):catch(function(p2)
			if v40 then
				warn("[Shop] stale widget refetch failed", (tostring(p2)))
			else
				v5(p2)
				v2({})
				v3({})

				v29 = {}
				v4(false)
			end

			v24 = false
		end)
	end

	local function runPartialDisplayShopFetch(fetchShopWidgetsOnly2, fetchShopWidgetsOnly3, p: string)
		if v25 or v24 then
			return
		end

		v24 = true
		local v40 = count
		v4(true)
		v5(nil)
		local v41

		if FFlagShopUseMockData then
			v41 = fetchShopWidgetsOnly3()
		else
			v41 = fetchShopWidgetsOnly2()
		end

		v41:andThen(function(data)
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
			v29 = data.failedItems or {}
			v4(false)
			v24 = false
			finishWidgetFetch(v40) -- inferred equivalent call

			if not applyWidgetTrialAvailabilities(data) then -- inferred equivalent call
				hydrateGamePassTrialAvailabilities()
			end

			if not FFlagEnableOffersPrefetch then
				InExperienceOffers.getOffersStore(false).fetchOffers(v)
			end

			streamProductInfoIntoSections(v30, buildProductInfoRequestsForHydration(v30, v29), v29, nil)
		end):catch(function(p2)
			v5(p2)
			v2({})
			v3({})
			v29 = {}
			v4(false)
			v24 = false
		end)
	end

	local function fetchAllShopData2() -- 1 equivalent call inferred from this helper
		if v27 then
			return
		end

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

	local function prefetchWidgetsOnly()
		if v27 then
			return
		end

		runShopFetch(fetchShopWidgetsOnly, MockFetchAllShopData.fetchShopWidgetsOnly, "prefetchWidgetsOnly")
	end

	local function refreshShopItemInfo()
		if not FFlagEnableShopProductInfoRefresh or (not v25 or v26 or v28) then
			return
		end

		local refreshShopItems = require(InExperienceShop.Api.refreshShopItems)
		local hydrateRobuxBonusItems = require(InExperienceShop.Api.hydrateRobuxBonusItems)
		local v40

		if #v30 > 0 then
			v40 = v30
		else
			v40 = signal2(false)
		end

		local requestsFromSections = refreshShopItems.buildRequestsFromSections(v40)

		if FFlagEnableRobuxInExperienceShop then
			hydrateRobuxBonusItems.appendBonusItemRequests(requestsFromSections, v40)
		end

		local v41 = v29
		refreshShopItems.appendFailedItemRequests(requestsFromSections, v41)

		if #requestsFromSections == 0 then
			return
		end

		v26 = true

		if isPartialDisplayEnabled() then -- inferred equivalent call
			streamProductInfoIntoSections(v40, requestsFromSections, v41, function()
				v26 = false
			end)
			return
		end

		local v42

		if FFlagShopUseMockData and FFlagShopUseMockMultiGetProductInfo then
			v42 = MockMultiGetProductInfo.multiGetProductInfo(requestsFromSections, 0)
		else
			v42 = multiGetProductInfo(requestsFromSections)
		end

		local v43 = count2

		v42:andThen(function(p)
			if v43 ~= count2 then
				v26 = false
				return
			end

			local mergeProductInfoIntoSections = refreshShopItems.mergeProductInfoIntoSections(v40, p)

			if FFlagEnableRobuxInExperienceShop then
				mergeProductInfoIntoSections = hydrateRobuxBonusItems.mergeBonusItemDetailsIntoSections(
					mergeProductInfoIntoSections,
					p
				)
			end

			local v44, v45 = refreshShopItems.insertRecoveredItemsIntoSections(mergeProductInfoIntoSections, p, v41)
			v29 = v45
			applySections(v44) -- inferred equivalent call
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

			for _, v40 in { FStringExperienceShopLayer1, FStringExperienceShopLayer2 } do
				if v40 ~= "" then
					ixpServiceWrapper:LogUserLayerExposure(v40)
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

		if v27 then
			runShopFetch(fetchAllShopData, MockFetchAllShopData.fetchAllShopData, "fetchAllShopData")
		else
			fetchAllShopData2() -- inferred equivalent call
		end

		refreshShopItemInfo()
	end

	local function refreshRobuxWidgetsAfterPurchase()
		if not FFlagRefetchRobuxWidgetAfterPurchase or not (v25 or v27) or flag then
			return Promise.resolve()
		end

		flag = true
		ShopDebugLogger.log("refreshRobuxWidgetsAfterPurchase: start")
		local v40

		if FFlagShopUseMockData then
			v40 = MockFetchAllShopData.fetchRobuxWidgetsAfterPurchase(0)
		else
			v40 = fetchRobuxWidgetsAfterPurchase.fetchRobuxWidgetsAfterPurchase()
		end

		return v40:andThen(function(p)
			if not isValidShopData(p) then -- inferred equivalent call
				ShopDebugLogger.log("refreshRobuxWidgetsAfterPurchase: skip, invalid payload")
				return
			end

			local v41, v42 = mergeRobuxShopData(signal(false), v30, p)
			v2(v41)
			applySections(v42) -- inferred equivalent call
		end):catch(function(p)
			ShopDebugLogger.logLazy(function()
				return "refreshRobuxWidgetsAfterPurchase: failed err=" .. tostring(p)
			end)
		end):finally(function()
			flag = false
		end)
	end

	local function markWidgetDataStale() -- 1 equivalent call inferred from this helper
		count += 1

		if v25 then
			v25 = false
			v27 = true
		end
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

	local function pollGamePassOwnershipAfterPurchase(p: string, FIntShopOwnershipFetchMaxAttempts2: number, callback, flag2: boolean?, callback2)
		if v23[p] then
			ShopDebugLogger.logLazy(function()
				return "pollGamePassOwnership: already in flight itemId=" .. p
			end)

			return
		end

		local v40 = tonumber(p)

		if v40 == nil then
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
				v40,
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

				if FFlagRefetchShopWidgetsAfterPassPurchase then
					markWidgetDataStale() -- inferred equivalent call
				end

				if callback2 ~= nil then
					callback2(p)
				end

				if flag2 then
					local localPlayer = Players.LocalPlayer

					if localPlayer ~= nil then
						ShopDebugLogger.logLazy(function()
							return "pollGamePassOwnership: SignalPromptGamePassPurchaseFinished itemId=" .. p
						end)

						MarketplaceService:SignalPromptGamePassPurchaseFinished(localPlayer, v40, true)
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

		local fn = FFlagEnableFreeTrialTopBarChip and function(gamePassId: string)
			v37({ gamePassId = gamePassId })
		end or nil

		pollGamePassOwnershipAfterPurchase(tostring(p2), FIntShopOwnershipFetchMaxAttempts, fetchOwnedGamePass, nil, fn)
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

			local v40 = v20
			local v41 = v21
			local v42 = v22

			if
				v41 == nil
				or not FFlagRefetchRobuxWidgetAfterPurchase
				and v40 == nil
				and (not FFlagShopRobuxPurchaseCompletionModal or v42 == nil)
			then
				ShopDebugLogger.log("NativePurchaseFinished: skip, no pending shop Robux purchase")
				return
			end

			if tostring(p) ~= v41 then
				ShopDebugLogger.logLazy(function()
					return "NativePurchaseFinished: skip, sku mismatch productId=" .. tostring(p) .. " pendingStoreSku=" .. v41
				end)

				return
			end

			v20 = nil
			v21 = nil
			v22 = nil

			if not flag2 then
				ShopDebugLogger.logLazy(function()
					return "NativePurchaseFinished: skip, not purchased bonusGamePassId=" .. tostring(v40)
				end)

				return
			end

			if FFlagShopRobuxPurchaseCompletionModal and v42 ~= nil then
				v14(v42)
			end

			if v40 ~= nil then
				ShopDebugLogger.logLazy(function()
					return "NativePurchaseFinished: polling bonusGamePassId=" .. v40
				end)
				local v43

				if FFlagShopUseMockUserOwnsGamePass then
					v43 = MockUserOwnsGamePass
				else
					v43 = userOwnsGamePassHttp
				end

				pollGamePassOwnershipAfterPurchase(v40, FIntShopOwnershipFetchMaxAttempts, v43, true)
			end

			if FFlagRefetchRobuxWidgetAfterPurchase and (v40 ~= nil or not FFlagSkipPaymentSessionForPlainRobux) then
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

		local v40 = MarketplaceService
		local engineFeature = game:GetEngineFeature("NativePurchaseWithLocalPlayer")
		ShopDebugLogger.logLazy(function()
			return "NativePurchaseFinished: connecting v2=" .. tostring(FFlagLuaAppEnableNativePurchaseFinishedV2Signals) .. " localPlayerFeature=" .. tostring(engineFeature)
		end)

		connectIfAvailable(v40.NativePurchaseFinished, onNativePurchaseFinished) -- inferred equivalent call

		if FFlagLuaAppEnableNativePurchaseFinishedV2Signals then
			connectIfAvailable(v40.NativePurchaseFinishedV2, onNativePurchaseFinished) -- inferred equivalent call
		end

		if engineFeature then
			connectIfAvailable(v40.NativePurchaseFinishedWithLocalPlayer, onNativePurchaseFinishedWithLocalPlayer) -- inferred equivalent call

			if FFlagLuaAppEnableNativePurchaseFinishedV2Signals then
				connectIfAvailable(v40.NativePurchaseFinishedWithLocalPlayerV2, onNativePurchaseFinishedWithLocalPlayer) -- inferred equivalent call
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
		getTrialRedeemSuccessCount = signal20,
		getTrialRedemptionError = signal21,
		getTrialRedeemThumbnail = signal18,
		dismissTrialRedemptionError = function()
			v39(nil)
		end,
		getBonusPromotionEligibility = signal11,
		getItemsPerRow = signal12,
		getMetadata = signal5,
		getGlobalIconBackendEnabled = signal6,
		getGlobalIconHasNewOffers = signal7,
		getNotificationFreeTrialTopBarChip = signal8,
		getPurchasedOwnedGamePass = signal19,
		getShouldOpenToRobuxTab = signal15,
		getOpenedFromBuyRobux = signal16,
		getPurchasedRobuxAmount = signal13,
		dismissRobuxPurchaseSuccess = function()
			v14(nil)
		end,
		onShopOpened = onShopOpened,
		fetchAllShopData = fetchAllShopData2,
		prefetchWidgetsOnly = prefetchWidgetsOnly,
		refreshShopItemInfo = refreshShopItemInfo,
		refreshRobuxWidgetsAfterPurchase = refreshRobuxWidgetsAfterPurchase,
		fetchGamePassOwnership = function(p: string)
			if v15[p] or signal9(false)[p] ~= nil then
				return
			end

			local v35 = tonumber(p)

			if v35 == nil then
				return
			end

			v15[p] = true
			fetchOwnedGamePass(v35):andThen(function(flag2: boolean)
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
		currentlyOwnsGamePass = function(p: string)
			local v35 = tonumber(p)

			if v35 == nil then
				return Promise.resolve(false)
			end

			return fetchOwnedGamePass(v35)
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
