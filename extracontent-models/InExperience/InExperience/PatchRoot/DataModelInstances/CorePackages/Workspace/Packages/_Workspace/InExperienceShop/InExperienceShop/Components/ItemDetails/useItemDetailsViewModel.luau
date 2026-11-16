local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local SharedFlags = require(parent.SharedFlags)
local AbuseVector = require(parent.GenericAbuseReporting.AbuseVector)
local FFlagLuaAppEnableGamePassFreeTrials = require(InExperienceShop.Flags.FFlagLuaAppEnableGamePassFreeTrials)
local FFlagEnableGamePassTrialUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableGamePassTrialUnifiedLogging)

local initiateShopItemPurchase = require(InExperienceShop.initiateShopItemPurchase)
local FFlagCategoryLoggingInShopPurchase = require(InExperienceShop.Flags.FFlagCategoryLoggingInShopPurchase)
local formatUpdatedDate = require(InExperienceShop.Utils.formatUpdatedDate)
local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local Constants = require(InExperienceShop.Constants)
local shopPageType

if SharedFlags.FFlagPassShopPurchaseSurfaceToBuyModal then
	local Constants2 = require(InExperienceShop.Analytics.Constants)
	shopPageType = Constants2.ShopPageType
else
	shopPageType = nil
end

local useGamePassTrialRedemption = require(InExperienceShop.Hooks.useGamePassTrialRedemption)
local useShopReportOverflow = require(InExperienceShop.Hooks.useShopReportOverflow)

require(InExperienceShop.Types)

require(script.Parent.ItemDetailsView)

local v = { product = "Feature.DeveloperProducts.Label.Product" }

local function findSectionForItem(items, id: string, itemType)
	for _, item in items do
		for _, item2 in item.items do
			if item2.id == id and item2.itemType == itemType then
				return item
			end
		end
	end

	return nil
end

local function categoryLabelForType(itemType, product: string) -- 1 equivalent call inferred from this helper
	return if itemType == "GamePass" then "Game pass" else product
end

local function useItemDetailsViewModel(data)
	local item = data.item
	local v2 = useLocalization(v)

	local v3 = SignalsReact.useSignalState(getInExperienceShopStore)
	local v4

	if FFlagCategoryLoggingInShopPurchase then
		v4 = SignalsReact.useSignalState(v3.getSections)
	else
		v4 = nil
	end

	local v5 = SignalsReact.useSignalState(function(p)
		return v3.getOwnership(p)[item.id]
	end)

	local showTry = SignalsReact.useSignalState(function(p): boolean
		if FFlagLuaAppEnableGamePassFreeTrials and item.itemType == "GamePass" then
			return v3.getTrialAvailabilities(p).available[item.id] == true
		end

		v3.getOwnership(p)
		return false
	end)

	React.useEffect(function()
		if item.itemType == "GamePass" then
			v3.fetchGamePassOwnership(item.id)
		end
	end, { item.id, item.itemType, v3.fetchGamePassOwnership })
	local isOwned

	if v5 == nil then
		isOwned = item.isOwned
	else
		isOwned = v5
	end

	local useMemo = React.useMemo
	local function fn()
		local categoryLocation = nil

		if FFlagCategoryLoggingInShopPurchase and v4 ~= nil then
			local sectionForItem = findSectionForItem(v4, item.id, item.itemType)

			categoryLocation = sectionForItem ~= nil
				and {
					categoryGroup = sectionForItem.categoryGroup,
					categoryPosition = sectionForItem.id,
					categoryName = sectionForItem.name,
					stableCategoryId = sectionForItem.stableCategoryId
				}
				or categoryLocation
		end

		local shopPageType2

		if shopPageType then
			shopPageType2 = shopPageType.Category
		end

		return {
			shopPageType = shopPageType2,
			categoryLocation = categoryLocation,
			trialStatus = FFlagEnableGamePassTrialUnifiedLogging and item.itemType == "GamePass" and (showTry and isOwned ~= true and "available" or "unavailable") or nil
		}
	end

	local id = item.id
	local itemType = item.itemType
	local v6

	if FFlagEnableGamePassTrialUnifiedLogging then
		v6 = showTry
	end

	local v7

	if FFlagEnableGamePassTrialUnifiedLogging then
		v7 = isOwned
	end

	local v8 = useMemo(fn, { id, itemType, v4, v6, v7 })

	local onBuyActivated = React.useCallback(function()
		local categoryLocation = v8.categoryLocation

		if categoryLocation == nil then
			initiateShopItemPurchase(item.id, item.itemType, v8.shopPageType)
		else
			initiateShopItemPurchase(item.id, item.itemType, v8.shopPageType, categoryLocation)
		end
	end, { item.id, item.itemType, v8 })

	local v9 = useGamePassTrialRedemption(item.id, v8)

	if FFlagEnableGamePassTrialUnifiedLogging then
		local ref = React.useRef(nil)
		React.useEffect(function()
			if item.itemType ~= "GamePass" or not showTry or v5 ~= false or ref.current == item.id then
				return
			end

			ref.current = item.id
			local sendGamePassTrialUnifiedEvent = require(InExperienceShop.Analytics.sendGamePassTrialUnifiedEvent)
			sendGamePassTrialUnifiedEvent.send({
				action = sendGamePassTrialUnifiedEvent.impressionAction,
				elementName = sendGamePassTrialUnifiedEvent.trialElement,
				itemId = item.id,
				shopPageType = v8.shopPageType,
				trialStatus = v8.trialStatus
			})
		end, { item.id, item.itemType, showTry, v5, v8 })
	end

	local fFlagEnableReportingFlowForExperienceShop = SharedFlags.FFlagEnableReportingFlowForExperienceShop

	local buildReportSession = React.useCallback(function()
		if item.itemType == "GamePass" then
			return { abuseVector = AbuseVector.GamePass, targetId = item.id }
		end

		return { abuseVector = AbuseVector.DeveloperProduct, targetId = item.id }
	end, { item.id, item.itemType })

	local v10 = useShopReportOverflow.useShopReportOverflow({
		isReportingEnabled = fFlagEnableReportingFlowForExperienceShop,
		buildReportSession = buildReportSession
	})

	local updated = React.useMemo(function()
		return formatUpdatedDate(item.updated)
	end, { item.updated })

	local categoryLabel = categoryLabelForType(item.itemType, v2.product) -- inferred equivalent call

	local state, setState = React.useState(false)

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		local x = p.AbsoluteSize.X

		if x <= 0 then
			return
		end

		local v11 = x < Constants.COMPACT_BREAKPOINT_WIDTH
		setState(function(p2)
			return if p2 == v11 then p2 else v11
		end)
	end, {})

	return {
		itemId = item.id,
		name = item.name,
		thumbnail = item.thumbnail,
		price = item.price,
		isOwned = isOwned,
		showTry = showTry,
		isActionLoading = v9.isActionLoading,
		isActionDisabled = v9.isActionDisabled,
		isBuyDisabled = data.disableBuy == true,
		description = item.description,
		creator = item.creator,
		categoryLabel = categoryLabel,
		updated = updated,
		isCompact = state,
		isOverflowMenuOpen = v10.isOverflowMenuOpen,
		isReportingEnabled = v10.isReportingEnabled,
		reportSession = v10.reportSession,
		onClose = data.onClose,
		onBuyActivated = onBuyActivated,
		onTryActivated = v9.onTryActivated,
		onOverflowActivated = v10.onOverflowActivated,
		onOverflowMenuClosed = v10.onOverflowMenuClosed,
		onMenuItemActivated = v10.onMenuItemActivated,
		onReportClose = v10.onReportClose,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged
	}
end

return useItemDetailsViewModel
