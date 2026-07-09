local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local SessionService = game:GetService("SessionService")
local React = require(InExperienceShopParent.React)
local Foundation = require(InExperienceShopParent.Foundation)
local SignalsReact = require(InExperienceShopParent.SignalsReact)
local PurchasePrompt = require(InExperienceShopParent.PurchasePrompt)
local View = Foundation.View
local FIntShopOwnershipFetchMaxAttempts = require(InExperienceShop.Flags.FIntShopOwnershipFetchMaxAttempts)
local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)
local FFlagShopUseMockUserOwnsGamePass = require(InExperienceShop.Flags.FFlagShopUseMockUserOwnsGamePass)
local GetBlockRobuxTileClickInShop = require(InExperienceShop.Flags.GetBlockRobuxTileClickInShop)
local userOwnsGamePassHttp = require(InExperienceShop.Api.userOwnsGamePassHttp)
local MockUserOwnsGamePass = require(InExperienceShop.Mocks.MockUserOwnsGamePass)
local RobuxPackageTile = require(InExperienceShop.Components.RobuxPackageTile)
local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local getRobuxPackageBonusPresentation = require(InExperienceShop.Utils.getRobuxPackageBonusPresentation)
local promoteBonusRobuxPackageToTopPicks = require(InExperienceShop.Api.promoteBonusRobuxPackageToTopPicks)

require(InExperienceShop.Types)

local function RobuxPackageTileContainer(t1: {[any]: any}) -- line: 40
	-- upvalues: React (copy), SignalsReact (copy), getInExperienceShopStore (copy), promoteBonusRobuxPackageToTopPicks (copy), getRobuxPackageBonusPresentation (copy), FFlagEnableInExperienceShopUnifiedLogging (copy), InExperienceShopParent (copy), SessionService (copy), FFlagShopUseMockUserOwnsGamePass (copy), MockUserOwnsGamePass (copy), userOwnsGamePassHttp (copy), FIntShopOwnershipFetchMaxAttempts (copy), PurchasePrompt (copy), GetBlockRobuxTileClickInShop (copy), View (copy), RobuxPackageTile (copy)
	local pkg = t1.pkg
	local v22 = React.useRef(nil)
	local v23 = SignalsReact.useSignalState(getInExperienceShopStore)
	local v24 = promoteBonusRobuxPackageToTopPicks.getBonusGamePassId(pkg)
	local v25 = SignalsReact.useSignalState(function(p1) -- line: 46
		-- upvalues: v23 (copy), v24 (copy)
		local v38 = v23.getOwnership(p1)

		if v24 == nil then
			return nil
		end

		return v38[v24]
	end)
	local v26 = SignalsReact.useSignalState(function(p2) -- line: 56
		-- upvalues: v23 (copy), v24 (copy)
		local v40 = v23.getBonusPromotionEligibility(p2)

		if v24 == nil then
			return nil
		end

		return v40[v24]
	end)
	local v27 = getRobuxPackageBonusPresentation(pkg, v25, v26)
	local mobileProductId = pkg.mobileProductId
	local productId = pkg.productId
	local paymentSessionId = t1.paymentSessionId

	React.useEffect(function() -- line: 75
		-- upvalues: FFlagEnableInExperienceShopUnifiedLogging (copy), InExperienceShopParent (copy), pkg (copy), productId (copy), t1 (copy), v22 (copy), SessionService (copy)
		if not FFlagEnableInExperienceShopUnifiedLogging then
			return
		end

		task.defer(function() -- line: 80
			-- upvalues: InExperienceShopParent (copy), pkg (copy), productId (copy), t1 (copy), v22 (copy), SessionService (copy)
			local AvatarExperienceAnalytics = require(InExperienceShopParent.AvatarExperienceAnalytics)
			local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
			local MarketplaceUnifiedItemType = AvatarExperienceAnalytics.UnifiedEventLogEnums.MarketplaceUnifiedItemType
			local v47 = pkg.bonusItem ~= nil
			local t2 = {
				universeId = game.GameId,
				itemId = if productId == nil then pkg.id else productId,
				itemType = if not v47 then MarketplaceUnifiedItemType.ROBUX else MarketplaceUnifiedItemType.ROBUX_WITH_BONUS,
				categoryId = t1.categoryId,
				gridPositionRow = t1.gridPositionRow,
				gridPositionColumn = t1.gridPositionColumn
			}

			addUnifiedEventLogging(v22, t2, {
				sessionTagName = SessionService:GetSessionTag("level2a")
			})
		end)
	end, {
		pkg.id,
		productId,
		pkg.bonusItem,
		t1.categoryId,
		t1.gridPositionRow,
		t1.gridPositionColumn
	})

	local v31 = React.useCallback(function() -- line: 114
		-- upvalues: v24 (copy), FFlagShopUseMockUserOwnsGamePass (copy), MockUserOwnsGamePass (copy), userOwnsGamePassHttp (copy), v23 (copy), FIntShopOwnershipFetchMaxAttempts (copy)
		if v24 == nil then
			return
		end

		local v41 = if not FFlagShopUseMockUserOwnsGamePass then userOwnsGamePassHttp else MockUserOwnsGamePass

		v23.pollGamePassOwnership(v24, FIntShopOwnershipFetchMaxAttempts, v41, true)
	end, {
		v24,
		v23
	})
	local v32 = React.useCallback(function() -- line: 124
		-- upvalues: PurchasePrompt (copy), mobileProductId (copy), productId (copy), paymentSessionId (copy), v31 (copy)
		local launchRobuxPackagePurchase = PurchasePrompt.launchRobuxPackagePurchase

		if launchRobuxPackagePurchase == nil then
			return
		end

		launchRobuxPackagePurchase({
			mobileProductId = mobileProductId or "",
			productId = productId,
			paymentSessionId = paymentSessionId,
			onWebViewClosed = v31
		})
	end, {
		mobileProductId,
		productId,
		paymentSessionId,
		v31
	})
	local hasBonusItem = v27.hasBonusItem
	local bonusItemDetails = pkg.bonusItemDetails
	local onBonusItemActivated = t1.onBonusItemActivated
	local v36 = React.useCallback(function() -- line: 140
		-- upvalues: GetBlockRobuxTileClickInShop (copy), hasBonusItem (copy), bonusItemDetails (copy), onBonusItemActivated (copy)
		if GetBlockRobuxTileClickInShop() then
			return
		end

		if not hasBonusItem or bonusItemDetails == nil or onBonusItemActivated == nil then
			return
		end

		local itemType = bonusItemDetails.itemType

		if itemType == nil then
			return
		end

		onBonusItemActivated(bonusItemDetails.id, itemType)
	end, {
		hasBonusItem,
		bonusItemDetails,
		onBonusItemActivated
	})

	return React.createElement(View, {
		tag = "fill size-full-0",
		LayoutOrder = t1.LayoutOrder,
		ref = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v22
	}, {
		Tile = React.createElement(RobuxPackageTile, {
			robuxAmount = pkg.robuxAmount,
			currencyAmountStr = pkg.currencyAmountStr,
			robuxImage = pkg.robuxImage,
			hasBonusItem = v27.hasBonusItem,
			bonusItemThumbnail = v27.bonusItemThumbnail,
			onTileActivated = v36,
			onBuyActivated = v32,
			isPrimaryRobuxPackage = pkg.isPrimaryRobuxPackage == true,
			mediaHeightScale = t1.mediaHeightScale
		})
	})
end

return React.memo(RobuxPackageTileContainer)
