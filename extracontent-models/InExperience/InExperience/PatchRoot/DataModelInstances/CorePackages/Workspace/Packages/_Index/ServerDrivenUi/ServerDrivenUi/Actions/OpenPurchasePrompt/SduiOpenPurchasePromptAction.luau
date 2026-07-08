local Parent = script:FindFirstAncestor("OpenPurchasePrompt"):FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay
local CloseCentralOverlay = require(Parent.CentralOverlay).Thunks.CloseCentralOverlay
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local DataHydration = require(Parent.DataHydration)
local Promise = require(Parent.Promise)
local TimeToInteractiveTracker = require(Parent.TimeToInteractiveTracker).TimeToInteractiveTracker
local PurchasePromptLite = require(Parent.PurchasePromptLite)
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local ProductKind = PurchasePromptLite.Enums.ProductKind
local SharedFlags = require(Parent.SharedFlags)
local FFlagSduiDevStoreSeeAllSupport = SharedFlags.FFlagSduiDevStoreSeeAllSupport
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local ExperienceService = game:GetService("ExperienceService")
local Players = game:GetService("Players")
local v19 = game:DefineFastFlag("EnableJoinAfterBuyFromEDP", false)

local function mapPriceDiscountDetails(t1: {[any]: any}?) -- line: 40
	if t1 == nil or #t1 == 0 then
		return nil
	end

	local t2 = {}

	for _, v29 in t1 do
		table.insert(t2, {
			Type = v29.type,
			AmountInRobux = v29.amountInRobux,
			Percent = v29.percent
		})
	end

	return t2
end
local function buildFetchProductInfo(t3: {[any]: any}?, s1: string?) -- line: 55
	-- upvalues: Promise (copy), mapPriceDiscountDetails (copy)
	if t3 == nil then
		return nil
	end

	return function() -- line: 59
		-- upvalues: Promise (copy), t3 (copy), s1 (copy), mapPriceDiscountDetails (copy)
		return Promise.resolve({
			ProductId = t3.productId,
			TargetId = t3.targetId,
			Name = t3.productName,
			Description = t3.description,
			PriceInRobux = t3.priceInRobux,
			IsForSale = t3.isForSale == nil or t3.isForSale,
			ProductType = t3.productType or s1,
			ImageUrl = t3.imageUrl,
			DisplayPrice = t3.displayPrice,
			IconImageAssetId = t3.iconImageAssetId,
			BasePriceInRobux = t3.basePriceInRobux,
			PriceDiscountDetails = mapPriceDiscountDetails(t3.priceDiscountDetails)
		})
	end
end
local function buildOnPurchaseSuccess(s2: string?, s3: string?, s4: string?, s5: string?) -- line: 77
	-- upvalues: ProductKind (copy), ProductPurchaseSurface (copy), DataHydration (copy), FFlagSduiDevStoreSeeAllSupport (copy), Players (copy)
	if not s4 then
		return nil
	end

	if s3 == ProductKind.Gamepass and s2 == ProductPurchaseSurface.EDP then
		return function() -- line: 83
			-- upvalues: DataHydration (copy), s4 (copy)
			DataHydration.Game.getGamePassStore(false).updateGamePassInfo(s4, {
				isOwned = true
			})
		end
	end

	if FFlagSduiDevStoreSeeAllSupport and s3 == ProductKind.DeveloperSubscription and s2 == ProductPurchaseSurface.EDP then
		return function() -- line: 95
			-- upvalues: DataHydration (copy), s4 (copy)
			DataHydration.Game.getGameSubscriptionStore(false).updateGameSubscriptionInfo(s4, {
				isSubscribed = true
			})
		end
	end

	if FFlagSduiDevStoreSeeAllSupport and s3 == ProductKind.Product and s2 == ProductPurchaseSurface.EDP and s5 then
		return function() -- line: 112
			-- upvalues: Players (copy), DataHydration (copy), s5 (copy)
			local LocalPlayer = Players.LocalPlayer
			local v61 = LocalPlayer and LocalPlayer.UserId

			if v61 == nil then
				return
			end

			DataHydration.Game.getGameDeveloperProductStore(false).fetchStatuses(tostring(v61), (tostring(s5)))
		end
	end

	return nil
end
local function buildOnPurchaseComplete(s6: string?, s7: string?, p1) -- line: 127
	-- upvalues: v19 (copy), ProductPurchaseSurface (copy), ExperienceService (copy), CloseCentralOverlay (copy)
	if v19 and (s6 == ProductPurchaseSurface.EDP and s7) then
		return function() -- line: 129
			-- upvalues: ExperienceService (copy), s7 (copy), p1 (copy), CloseCentralOverlay (copy)
			ExperienceService:LaunchExperience({
				placeId = tonumber(s7)
			})
			p1(CloseCentralOverlay())
		end
	end

	return nil
end
local function buildOnFlowComplete(p2) -- line: 137
	-- upvalues: CloseCentralOverlay (copy)
	return function() -- line: 138
		-- upvalues: p2 (copy), CloseCentralOverlay (copy)
		p2(CloseCentralOverlay())
	end
end
local function normalizeProductPayload(t4: {[any]: any}, s8: string?) -- line: 146
	-- upvalues: ProductKind (copy)
	if (s8 == ProductKind.Gamepass or s8 == ProductKind.Product) and typeof(t4.id) == "string" then
		local num = tonumber(t4.id)

		if num ~= nil then
			t4.id = num
		end
	end

	if s8 == ProductKind.DeveloperSubscription then
		local expectedPrice = t4.expectedPrice

		if typeof(expectedPrice) == "string" then
			expectedPrice = tonumber(expectedPrice) or 0
			t4.expectedPrice = expectedPrice
		end

		if t4.isSubscriptionInRobux == nil then
			t4.isSubscriptionInRobux = typeof(expectedPrice) == "number" and expectedPrice > 0
		end
	end
end

return function(p3, _, p5) -- line: 168
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiDevStoreSeeAllSupport (copy), normalizeProductPayload (copy), PurchasePromptLite (copy), TimeToInteractiveTracker (copy), SetCentralOverlay (copy), CentralOverlayType (copy), buildOnPurchaseSuccess (copy), Promise (copy), mapPriceDiscountDetails (copy), CloseCentralOverlay (copy), v19 (copy), ProductPurchaseSurface (copy), ExperienceService (copy)
	local logger = p5.dependencies.logger
	local appPage = p5.appPage
	local dispatch = p5.dependencies.dispatch
	local v50 = p3 and p3.actionParams

	if v50 == nil then
		logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing action params",
			name = SduiActionType.OpenPurchasePrompt
		}, appPage)

		return
	end

	local productPayload = v50.productPayload
	local displayInfo = v50.displayInfo
	local purchaseOptions = v50.purchaseOptions
	local purchaseAnalyticsMetadata = v50.purchaseAnalyticsMetadata
	local rootPlaceId = v50.rootPlaceId

	if productPayload == nil then
		logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing productPayload",
			name = SduiActionType.OpenPurchasePrompt
		}, appPage)

		return
	end

	local kind = productPayload.kind
	local v57 = productPayload.id or productPayload.subscriptionId

	if FFlagSduiExperienceDetailsSupport or FFlagSduiDevStoreSeeAllSupport then
		normalizeProductPayload(productPayload, kind)
	end

	local v58 = purchaseAnalyticsMetadata and purchaseAnalyticsMetadata.surface

	if purchaseOptions and purchaseOptions.enablePreloadedPurchaseUi ~= nil then
		purchaseOptions.enablePreloadedPurchaseUI = purchaseOptions.enablePreloadedPurchaseUi
		purchaseOptions.enablePreloadedPurchaseUi = nil
	end

	local v59 = PurchasePromptLite.getTTIEventName(v58 or "Unknown")

	TimeToInteractiveTracker.trackStart(v59)
	TimeToInteractiveTracker.updateMetadata(v59, {
		category = "unified_purchase_modal",
		page = v58
	})
	dispatch(SetCentralOverlay(CentralOverlayType.UnifiedProductPurchaseModal, {
		productPayload = productPayload,
		purchaseCallbacks = {
			onPurchaseSuccess = buildOnPurchaseSuccess(v58, kind, v57, rootPlaceId),
			fetchProductInfo = displayInfo ~= nil and function() -- line: 59
				-- upvalues: Promise (copy), displayInfo (copy), kind (copy), mapPriceDiscountDetails (copy)
				return Promise.resolve({
					ProductId = displayInfo.productId,
					TargetId = displayInfo.targetId,
					Name = displayInfo.productName,
					Description = displayInfo.description,
					PriceInRobux = displayInfo.priceInRobux,
					IsForSale = displayInfo.isForSale == nil or displayInfo.isForSale,
					ProductType = displayInfo.productType or kind,
					ImageUrl = displayInfo.imageUrl,
					DisplayPrice = displayInfo.displayPrice,
					IconImageAssetId = displayInfo.iconImageAssetId,
					BasePriceInRobux = displayInfo.basePriceInRobux,
					PriceDiscountDetails = mapPriceDiscountDetails(displayInfo.priceDiscountDetails)
				})
			end or nil,
			onFlowComplete = function() -- line: 138
				-- upvalues: dispatch (copy), CloseCentralOverlay (copy)
				dispatch(CloseCentralOverlay())
			end,
			onPurchaseComplete = if not v19 or (v58 ~= ProductPurchaseSurface.EDP or not rootPlaceId) then nil else function() -- line: 129
				-- upvalues: ExperienceService (copy), rootPlaceId (copy), dispatch (copy), CloseCentralOverlay (copy)
				ExperienceService:LaunchExperience({
					placeId = tonumber(rootPlaceId)
				})
				dispatch(CloseCentralOverlay())
			end
		},
		purchaseAnalyticsMetadata = purchaseAnalyticsMetadata,
		purchaseOptions = purchaseOptions
	}))
end
