local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local SessionService = game:GetService("SessionService")
local useTokens = require(AvatarExperienceInspectAndBuyParent.Foundation).Hooks.useTokens
local Localization = require(AvatarExperienceInspectAndBuyParent.Localization)
local AXCommon = require(AvatarExperienceInspectAndBuyParent.AXCommon)
local ItemTypeEnum = AXCommon.Enums.ItemTypeEnum
local ItemCardThumbnail = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceUIKit).ItemCardComponents.ItemCardThumbnail
local WearTimeSelectedOptionInList = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceTimedOptions).WearTimeSelectedOptionInList
local useLocalization = Localization.Hooks.useLocalization
local React = require(AvatarExperienceInspectAndBuyParent.React)
local useConvertedItemData = require(AvatarExperienceInspectAndBuy.Hooks.useConvertedItemData)

require(AvatarExperienceInspectAndBuy.Types)

local Constants = require(AvatarExperienceInspectAndBuy.Constants)
local AssetLocalizationKeys = Constants.AssetLocalizationKeys
local BundleLocalizationKeys = Constants.BundleLocalizationKeys
local PriceStatusLocalizationKeys = Constants.PriceStatusLocalizationKeys
local AvatarExperienceAnalytics = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceAnalytics)
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local UnifiedLoggingSurface = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceNavigation).Enums.UnifiedLoggingSurface

require(AvatarExperienceInspectAndBuy.Enums.ViewType)

local PriceStatus = require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
local RetrievalStatus = require(AvatarExperienceInspectAndBuyParent.Http).Enum.RetrievalStatus
local getItemThumbnailUrl = require(AvatarExperienceInspectAndBuy.Utils.getItemThumbnailUrl)
local getCatalogCardItemType = require(AvatarExperienceInspectAndBuy.Utils.getCatalogCardItemType)
local getPriceLineContent = require(AvatarExperienceInspectAndBuy.Utils.getPriceLineContent)
local getPriceInRobux = require(AvatarExperienceInspectAndBuy.Utils.itemDetailsUtils).getPriceInRobux
local getPriceStatus = require(AvatarExperienceInspectAndBuy.Utils.getPriceStatus)
local Cryo = require(AvatarExperienceInspectAndBuyParent.Cryo)
local useSignalState = require(AvatarExperienceInspectAndBuyParent.SignalsReact).useSignalState
local useItemSelectionStore = require(AvatarExperienceInspectAndBuy.Contexts.ItemSelectionStoreContext).useItemSelectionStore

require(AvatarExperienceInspectAndBuy.Stores.createItemSelectionStore)

local FFlagAXEnableIaBTimedOptionsBulkPurchase = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceFlags).FFlagAXEnableIaBTimedOptionsBulkPurchase
local CatalogItemCardStatusIconTypeEnum = AXCommon.Components.CatalogItemCard.CatalogItemCardStatusIconTypeEnum

return function(p1, n1: number, _, p3: ((...any) -> ...any), n2: number) -- line: 54
	-- upvalues: useTokens (copy), useConvertedItemData (copy), ItemTypeEnum (copy), BundleLocalizationKeys (copy), AssetLocalizationKeys (copy), Cryo (copy), PriceStatusLocalizationKeys (copy), useLocalization (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), useItemSelectionStore (copy), useSignalState (copy), React (copy), getPriceStatus (copy), PriceStatus (copy), getPriceInRobux (copy), getItemThumbnailUrl (copy), getCatalogCardItemType (copy), CatalogItemCardStatusIconTypeEnum (copy), RetrievalStatus (copy), getPriceLineContent (copy), addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), SessionService (copy), ItemCardThumbnail (copy), WearTimeSelectedOptionInList (copy)
	local v38 = useTokens()
	local v39, v40 = useConvertedItemData(p1)
	local v41 = if p1.itemType ~= ItemTypeEnum.Bundle then AssetLocalizationKeys else BundleLocalizationKeys
	local v42 = Cryo.Dictionary.join(v41, PriceStatusLocalizationKeys)
	local v43 = useLocalization(v42)
	local v44 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else useItemSelectionStore()
	local v45 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else useSignalState(v44.getItemData(p1.id))
	local v46 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else React.useMemo(function() -- line: 76
		-- upvalues: getPriceStatus (copy), v39 (copy), PriceStatus (copy)
		return getPriceStatus(v39) == PriceStatus.Owned
	end, { v39 })

	if FFlagAXEnableIaBTimedOptionsBulkPurchase then
		React.useEffect(function() -- line: 86
			-- upvalues: v39 (copy), getPriceInRobux (copy), getPriceStatus (copy), v44 (copy), p1 (copy)
			if not v39 or not v39.timedOptions then
				return
			end

			local v58 = getPriceInRobux(v39, getPriceStatus(v39)) or 0
			local v59 = table.clone(v39.timedOptions)

			table.insert(v59, {
				days = 0,
				selected = true,
				price = v58
			})
			v44.setItemData(p1.id, {
				timedOptions = v59
			})
		end, {
			v39,
			p1.id,
			v44
		})
	end

	local v47 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else React.useCallback(function(n3: number, n4: number?) -- line: 107
		-- upvalues: v45 (copy), v44 (copy), p1 (copy)
		if not v45 or not v45.timedOptions then
			return
		end

		local t1 = {}

		for _, v64 in v45.timedOptions do
			table.insert(t1, {
				days = v64.days,
				price = v64.price,
				selected = n3 == v64.price and (n4 == nil or n4 == v64.days)
			})
		end

		v44.setItemData(p1.id, {
			timedOptions = t1
		})
	end, {
		p1.id,
		v45,
		v44
	})
	local v48 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v45 and v45.timedOptions or nil
	local v49 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else React.useMemo(function() -- line: 134
		-- upvalues: v48 (copy)
		if not v48 then
			return nil
		end

		for _, v66 in v48 do
			if v66.selected then
				return v66.price
			end
		end

		return nil
	end, { v48 })

	if not v39 then
		return {}
	end

	local v50 = getItemThumbnailUrl(p1)
	local v51 = v43[v39.itemSubType]
	local v52 = getCatalogCardItemType(v39.itemRestrictions)
	local v53 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase or (not v39.timedOptions or v46) then nil else {
		type = "icon",
		iconType = CatalogItemCardStatusIconTypeEnum.Durable
	}
	local v54 = if v40 ~= RetrievalStatus.Done then nil else getPriceLineContent(v39, v38, v43)
	local v55 = if not v39.creator then nil else {
		name = v39.creator.creatorName or "",
		verified = v39.creator.creatorHasVerifiedBadge
	}
	local v56 = React.useRef(nil)

	React.useEffect(function() -- line: 171
		-- upvalues: addUnifiedEventLogging (copy), v56 (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), p1 (copy), SessionService (copy)
		addUnifiedEventLogging(v56, {
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = UnifiedLoggingSurface.IN_EXPERIENCE_INSPECT_BUY,
			elementName = "CLICK_INSPECTBUY_ITEM_" .. p1.id
		}, {
			sessionTagName = SessionService:GetSessionTag("level2a")
		})
	end, { p1.id })

	local v57 = React.useCallback(function() -- line: 181
		-- upvalues: p3 (copy), p1 (copy)
		p3(p1)
	end, {
		p3,
		p1
	})

	return {
		title = v39.name,
		presentationSlot = React.createElement(ItemCardThumbnail, {
			url = v50
		}),
		itemSubType = v51,
		itemType = v52,
		creator = v55,
		priceLineContent = v54,
		LayoutOrder = n1,
		Size = UDim2.fromOffset(n2, 0),
		headerSize = UDim2.fromOffset(n2, n2),
		footerAutomaticSize = Enum.AutomaticSize.XY,
		AutomaticSize = Enum.AutomaticSize.XY,
		onActivated = v57,
		ref = v56,
		itemStatus = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v53,
		isOwned = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v46,
		timedOptions = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v48,
		onTimedOptionPriceChanged = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v47,
		selectedTimedOptionPrice = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v49,
		wearTimeSelectedOptionInList = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else WearTimeSelectedOptionInList
	}
end
