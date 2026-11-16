local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local SessionService = game:GetService("SessionService")

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SignalsReact = require(parent.SignalsReact)
local PurchasePrompt = require(parent.PurchasePrompt)
local Promise = require(parent.Promise)

local View = Foundation.View

local FIntShopOwnershipFetchMaxAttempts = require(InExperienceShop.Flags.FIntShopOwnershipFetchMaxAttempts)
local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)
local FFlagEnableCategoryLoggingInShop = require(InExperienceShop.Flags.FFlagEnableCategoryLoggingInShop)
local FFlagShopUseMockUserOwnsGamePass = require(InExperienceShop.Flags.FFlagShopUseMockUserOwnsGamePass)
local FFlagSkipPaymentSessionForPlainRobux = require(InExperienceShop.Flags.FFlagSkipPaymentSessionForPlainRobux)
local FFlagHideBonusInShopWhenNotClaimable = require(InExperienceShop.Flags.FFlagHideBonusInShopWhenNotClaimable)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBonusJwtInShop = SharedFlags.FFlagEnableBonusJwtInShop
local FFlagShopListenNativePurchaseFinished = require(InExperienceShop.Flags.FFlagShopListenNativePurchaseFinished)
local FFlagShopRobuxPurchaseCompletionModal = require(InExperienceShop.Flags.FFlagShopRobuxPurchaseCompletionModal)
local FFlagRefetchRobuxWidgetAfterPurchase = require(InExperienceShop.Flags.FFlagRefetchRobuxWidgetAfterPurchase)
local FFlagEnableShopRobuxBuyTelemetry = require(InExperienceShop.Flags.FFlagEnableShopRobuxBuyTelemetry)
local GetBlockRobuxTileClickInShop = require(InExperienceShop.Flags.GetBlockRobuxTileClickInShop)
local userOwnsGamePassHttp = require(InExperienceShop.Api.userOwnsGamePassHttp)
local MockUserOwnsGamePass = require(InExperienceShop.Mocks.MockUserOwnsGamePass)
local RobuxPackageTile = require(InExperienceShop.Components.RobuxPackageTile)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)
local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local toUnifiedCategoryId = require(InExperienceShop.Analytics.toUnifiedCategoryId)
local getRobuxPackageBonusPresentation = require(InExperienceShop.Utils.getRobuxPackageBonusPresentation)
local promoteBonusRobuxPackageToTopPicks = require(InExperienceShop.Api.promoteBonusRobuxPackageToTopPicks)
local redeemBonusToken = require(InExperienceShop.Api.redeemBonusToken)

require(InExperienceShop.Types)

local function isPromise(p): boolean -- 2 equivalent calls inferred from this helper
	return typeof(p) == "table" and typeof(p.andThen) == "function"
end

local function RobuxPackageTileContainer(props)
	local pkg = props.pkg
	local ref = React.useRef(nil)
	local v = SignalsReact.useSignalState(getInExperienceShopStore)
	local bonusGamePassId = promoteBonusRobuxPackageToTopPicks.getBonusGamePassId(pkg)
	local state, setState, ref2, ref3, ref4

	if FFlagEnableBonusJwtInShop then
		state, setState = React.useState(false)
		ref2 = React.useRef(false)
		ref3 = React.useRef(true)
		ref4 = React.useRef(nil)

		React.useEffect(function()
			ref3.current = true
			return function()
				ref3.current = false
				local current = ref4.current
				ref4.current = nil

				if current ~= nil and typeof(current.cancel) == "function" then
					current:cancel()
				end
			end
		end, {})
	else
		ref2 = nil
		ref4 = nil
		setState = nil
		ref3 = nil
	end

	local robuxPackageBonusPresentation = getRobuxPackageBonusPresentation(pkg, SignalsReact.useSignalState(function(p)
		local ownership = v.getOwnership(p)

		if bonusGamePassId == nil then
			return nil
		end

		return ownership[bonusGamePassId]
	end), (SignalsReact.useSignalState(function(p)
		local bonusPromotionEligibility = v.getBonusPromotionEligibility(p)

		if bonusGamePassId == nil then
			return nil
		end

		return bonusPromotionEligibility[bonusGamePassId]
	end)))

	local mobileProductId = pkg.mobileProductId
	local productId = pkg.productId
	local paymentSessionId = props.paymentSessionId
	local bonusJwt

	if FFlagEnableBonusJwtInShop then
		bonusJwt = props.bonusJwt
	else
		bonusJwt = nil
	end

	local hasBonusItem = robuxPackageBonusPresentation.hasBonusItem
	local v2

	if paymentSessionId == nil or paymentSessionId == "" then
		if bonusJwt == nil then
			v2 = false
		else
			v2 = bonusJwt ~= ""
		end
	else
		v2 = true
	end

	local hasBonusItem2 = hasBonusItem and (not FFlagHideBonusInShopWhenNotClaimable or v2)
	local useEffect = React.useEffect
	local function fn()
		if not FFlagEnableInExperienceShopUnifiedLogging then
			return
		end

		task.defer(function()
			local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
			local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
			local marketplaceUnifiedItemType = AvatarExperienceAnalytics.UnifiedEventLogEnums.MarketplaceUnifiedItemType

			local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceAnalytics.Flags.FFlagAXUnifiedEventStrictPayloads
			local v3 = pkg.bonusItem ~= nil
			local v4 = {
				universeId = game.GameId,
				itemId = 0,
				itemType = 0,
				categoryId = 0,
				categoryType = 0,
				gridPositionRow = 0,
				gridPositionColumn = 0,
				stableCategoryId = 0,
				categoryGroup = 0,
				categoryName = 0
			}
			local itemId

			if fFlagAXUnifiedEventStrictPayloads then
				local v5

				if productId == nil then
					v5 = pkg.id
				else
					v5 = productId
				end

				itemId = tostring(v5)
			else
				itemId = if productId == nil then pkg.id else productId
			end

			v4.itemId = itemId
			local itemType

			if v3 then
				itemType = marketplaceUnifiedItemType.ROBUX_WITH_BONUS
			else
				itemType = marketplaceUnifiedItemType.ROBUX
			end

			v4.itemType = itemType
			local categoryId

			if fFlagAXUnifiedEventStrictPayloads then
				categoryId = toUnifiedCategoryId(props.categoryId)
			else
				categoryId = props.categoryId
			end

			v4.categoryId = categoryId

			v4.categoryType = props.categoryType
			v4.gridPositionRow = props.gridPositionRow
			v4.gridPositionColumn = props.gridPositionColumn
			local stableCategoryId

			if FFlagEnableCategoryLoggingInShop then
				stableCategoryId = props.stableCategoryId
			end

			v4.stableCategoryId = stableCategoryId
			local categoryGroup

			if FFlagEnableCategoryLoggingInShop then
				categoryGroup = props.categoryGroup
			end

			v4.categoryGroup = categoryGroup
			local categoryName

			if FFlagEnableCategoryLoggingInShop then
				categoryName = props.categoryName
			end

			v4.categoryName = categoryName

			addUnifiedEventLogging(ref, v4, {
				sessionTagName = SessionService:GetSessionTag("level2a")
			})
		end)
	end

	local id = pkg.id

	local bonusItem = pkg.bonusItem
	local categoryId = props.categoryId
	local categoryType = props.categoryType
	local gridPositionRow = props.gridPositionRow
	local gridPositionColumn = props.gridPositionColumn
	local stableCategoryId

	if FFlagEnableCategoryLoggingInShop then
		stableCategoryId = props.stableCategoryId
	end

	local categoryGroup

	if FFlagEnableCategoryLoggingInShop then
		categoryGroup = props.categoryGroup
	end

	local v3

	if FFlagEnableCategoryLoggingInShop then
		v3 = props.categoryName
	end

	useEffect(fn, {
		id,
		productId,
		bonusItem,
		categoryId,
		categoryType,
		gridPositionRow,
		gridPositionColumn,
		stableCategoryId,
		categoryGroup,
		v3
	})

	local onWebViewClosed = React.useCallback(function()
		if bonusGamePassId == nil then
			ShopDebugLogger.log("refreshBonusOwnership: skip poll, no bonus game pass")
		else
			ShopDebugLogger.logLazy(function()
				return "refreshBonusOwnership: polling bonusGamePassId=" .. bonusGamePassId
			end)
			local v4

			if FFlagShopUseMockUserOwnsGamePass then
				v4 = MockUserOwnsGamePass
			else
				v4 = userOwnsGamePassHttp
			end

			v.pollGamePassOwnership(bonusGamePassId, FIntShopOwnershipFetchMaxAttempts, v4, true)
		end

		if
			FFlagRefetchRobuxWidgetAfterPurchase
			and (bonusGamePassId ~= nil or not FFlagSkipPaymentSessionForPlainRobux)
		then
			v.refreshRobuxWidgetsAfterPurchase()
		end
	end, { bonusGamePassId, v })
	local onNativePurchaseLaunched

	if FFlagShopListenNativePurchaseFinished then
		onNativePurchaseLaunched = React.useCallback(function()
			if mobileProductId == nil or mobileProductId == "" then
				ShopDebugLogger.log("onNativePurchaseLaunched: skip, no store SKU")
				return
			end

			if
				not FFlagRefetchRobuxWidgetAfterPurchase
				and not FFlagShopRobuxPurchaseCompletionModal
				and bonusGamePassId == nil
			then
				ShopDebugLogger.log("onNativePurchaseLaunched: skip, no bonus game pass")
				return
			end

			ShopDebugLogger.logLazy(function()
				return "onNativePurchaseLaunched: recording bonusGamePassId=" .. tostring(bonusGamePassId) .. " storeSku=" .. mobileProductId
			end)

			if FFlagShopRobuxPurchaseCompletionModal then
				v.bonusGamePassIdForNativePurchase(bonusGamePassId, mobileProductId, pkg.robuxAmount)
			else
				v.bonusGamePassIdForNativePurchase(bonusGamePassId, mobileProductId)
			end
		end, { bonusGamePassId, mobileProductId, pkg.robuxAmount, v })
	else
		onNativePurchaseLaunched = nil
	end

	local onBuyActivated = React.useCallback(function()
		local launchRobuxPackagePurchase = PurchasePrompt.launchRobuxPackagePurchase

		if launchRobuxPackagePurchase == nil then
			ShopDebugLogger.log("onBuyActivated: skip, launchRobuxPackagePurchase missing")
			return
		end

		if FFlagEnableBonusJwtInShop and ref2.current then
			return
		end

		if FFlagEnableShopRobuxBuyTelemetry and FFlagEnableInExperienceShopUnifiedLogging and ref.current ~= nil then
			local sendRobuxBuyClickUnifiedEvent = require(InExperienceShop.Analytics.sendRobuxBuyClickUnifiedEvent)
			sendRobuxBuyClickUnifiedEvent(ref.current, props.shopPageType)
		end

		ShopDebugLogger.logLazy(function()
			return "onBuyActivated: launch mobileProductId=" .. tostring(mobileProductId) .. " productId=" .. tostring(productId) .. " bonusGamePassId=" .. tostring(bonusGamePassId)
		end)

		local v4 = {
			mobileProductId = mobileProductId or "",
			productId = productId,
			paymentSessionId = FFlagSkipPaymentSessionForPlainRobux and not hasBonusItem and "" or paymentSessionId,
			onWebViewClosed = onWebViewClosed
		}

		if FFlagShopListenNativePurchaseFinished then
			v4.onNativePurchaseLaunched = onNativePurchaseLaunched
		end

		if not FFlagEnableBonusJwtInShop then
			launchRobuxPackagePurchase(v4)
			return
		end

		v4.bonusJwt = FFlagSkipPaymentSessionForPlainRobux and not hasBonusItem and "" or bonusJwt

		if FFlagRefetchRobuxWidgetAfterPurchase then
			function v4.redeemBonusToken(p: string, p2: number)
				return redeemBonusToken(p, p2):catch(function(p3)
					if typeof(p3) ~= "table" or p3.kind ~= "BadRequest" then
						return Promise.reject(p3)
					end

					ShopDebugLogger.log("redeemBonusToken: HTTP 400, refreshing Robux widgets")
					local v5 = v.refreshRobuxWidgetsAfterPurchase()

					if not isPromise(v5) then -- inferred equivalent call
						v5 = Promise.resolve()
					end

					return v5:andThen(function()
						return Promise.reject(p3)
					end)
				end)
			end
		else
			v4.redeemBonusToken = redeemBonusToken
		end

		local current = launchRobuxPackagePurchase(v4)

		if not isPromise(current) then -- inferred equivalent call
			return
		end

		ref2.current = true
		ref4.current = current
		setState(true)

		local function settle()
			ref2.current = false
			ref4.current = nil

			if ref3.current then
				setState(false)
			end
		end

		current:catch(function(p)
			ShopDebugLogger.logLazy(function()
				local v5

				if typeof(p) == "table" then
					v5 = tostring(p.message)
				else
					v5 = tostring(p)
				end

				return "RobuxPackageTile: purchase launch failed err=" .. v5
			end)
		end):finally(settle)
	end, {
		mobileProductId,
		productId,
		paymentSessionId,
		bonusJwt,
		onWebViewClosed,
		onNativePurchaseLaunched,
		hasBonusItem,
		bonusGamePassId,
		v,
		props.shopPageType
	})

	local bonusItemDetails = pkg.bonusItemDetails
	local onBonusItemActivated = props.onBonusItemActivated
	local onTileActivated = React.useCallback(function()
		if
			GetBlockRobuxTileClickInShop()
			or (not hasBonusItem2 or bonusItemDetails == nil or onBonusItemActivated == nil)
		then
			return
		end

		local itemType = bonusItemDetails.itemType

		if itemType == nil then
			return
		end

		onBonusItemActivated(bonusItemDetails.id, itemType)
	end, { hasBonusItem2, bonusItemDetails, onBonusItemActivated })

	local createElement = React.createElement
	local v4 = { tag = "fill size-full-0", LayoutOrder = props.LayoutOrder, ref = 0 }
	local ref5

	if FFlagEnableInExperienceShopUnifiedLogging then
		ref5 = ref
	end

	v4.ref = ref5

	local createElement2 = React.createElement
	local v5 = {
		robuxAmount = pkg.robuxAmount,
		currencyAmountStr = pkg.currencyAmountStr,
		robuxImage = pkg.robuxImage,
		hasBonusItem = hasBonusItem2,
		bonusItemThumbnail = robuxPackageBonusPresentation.bonusItemThumbnail,
		onTileActivated = onTileActivated,
		onBuyActivated = onBuyActivated,
		isBuyLoading = 0,
		isPrimaryRobuxPackage = 0,
		mediaHeightScale = 0
	}

	if not FFlagEnableBonusJwtInShop then
		state = nil
	end

	v5.isBuyLoading = state
	v5.isPrimaryRobuxPackage = pkg.isPrimaryRobuxPackage == true
	v5.mediaHeightScale = props.mediaHeightScale
	return createElement(View, v4, {
		Tile = createElement2(RobuxPackageTile, v5)
	})
end

return React.memo(RobuxPackageTileContainer)
