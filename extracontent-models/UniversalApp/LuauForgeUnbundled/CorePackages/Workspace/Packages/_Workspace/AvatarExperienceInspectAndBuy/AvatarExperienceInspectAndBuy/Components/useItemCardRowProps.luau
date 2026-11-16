local SessionService = game:GetService("SessionService")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation").Hooks.useTokens
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Localization")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceCommon")
local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceModel").Enums.ItemTypeEnum
local itemCardThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceUIKit").ItemCardComponents.ItemCardThumbnail
local wearTimeSelectedOptionInList = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceTimedOptions").WearTimeSelectedOptionInList
local useLocalization = Localization.Hooks.useLocalization
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local useConvertedItemData = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Hooks/useConvertedItemData")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Constants")
local assetLocalizationKeys = Constants.AssetLocalizationKeys
local bundleLocalizationKeys = Constants.BundleLocalizationKeys
local priceStatusLocalizationKeys = Constants.PriceStatusLocalizationKeys
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceAnalytics")
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/ViewType")
local PriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/PriceStatus")
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Http").Enum.RetrievalStatus
local getItemThumbnailUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getItemThumbnailUrl")
local getCatalogCardItemType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getCatalogCardItemType")
local getPriceLineContent = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceLineContent")
local getPriceInRobux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/itemDetailsUtils").getPriceInRobux
local getPriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceStatus")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Cryo")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/SignalsReact").useSignalState
local useItemSelectionStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Contexts/ItemSelectionStoreContext").useItemSelectionStore

local fFlagAXMarketplaceLicensingItemCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceFlags").FFlagAXMarketplaceLicensingItemCards

local catalogItemCardStatusIconTypeEnum = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCardStatusIconTypeEnum

return function(p2, layoutOrder, p3, callback, p4)
	local v5 = useTokens()
	local v6, v7 = useConvertedItemData(p2)
	local v8

	if p2.itemType == itemTypeEnum.Bundle then
		v8 = bundleLocalizationKeys
	else
		v8 = assetLocalizationKeys
	end

	local v9 = useLocalization((Cryo.Dictionary.join(v8, priceStatusLocalizationKeys)))

	local v10 = useItemSelectionStore()
	local v11 = useSignalState(v10.getItemData(p2.id))

	local v12 = React.useMemo(function(): boolean
		return getPriceStatus(v6) == PriceStatus.Owned
	end, { v6 })

	React.useEffect(function()
		if not (v6 and v6.timedOptions) then
			return
		end

		local v13 = getPriceInRobux(v6, getPriceStatus(v6)) or 0
		local clone = table.clone(v6.timedOptions)
		table.insert(clone, { days = 0, price = v13, selected = true })

		v10.setItemData(p2.id, { timedOptions = clone })
	end, { v6, p2.id, v10 })

	local v13 = React.useCallback(function(p5, p6)
		if not (v11 and v11.timedOptions) then
			return
		end

		local v14 = {}

		for k, timedOption in v11.timedOptions do
			local v15 = {
				days = timedOption.days,
				price = timedOption.price,
				selected = timedOption.price == p5 and (p6 == nil or timedOption.days == p6)
			}
			table.insert(v14, v15)
		end

		v10.setItemData(p2.id, { timedOptions = v14 })
	end, { p2.id, v11, v10 })

	local timedOptions = v11 and v11.timedOptions or nil

	local v14 = React.useMemo(function()
		if not timedOptions then
			return nil
		end

		for k, timedOption in timedOptions do
			if timedOption.selected then
				return timedOption.price
			end
		end

		return nil
	end, { timedOptions })

	if not v6 then
		return {}
	end

	local v15 = getItemThumbnailUrl(p2)
	local v16 = v9[v6.itemSubType]
	local v17 = getCatalogCardItemType(v6.itemRestrictions)
	local v18 = v6.timedOptions
		and not v12
		and { type = "icon", iconType = catalogItemCardStatusIconTypeEnum.Durable }
		or nil

	local v19 = if v7 == retrievalStatus.Done then getPriceLineContent(v6, v5, v9) else nil

	local v20 = v6.creator and {
		name = v6.creator.creatorName or "",
		verified = v6.creator.creatorHasVerifiedBadge
	} or nil

	local ref = React.useRef(nil)
	React.useEffect(function()
		addUnifiedEventLogging(ref, {
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = unifiedLoggingSurface.IN_EXPERIENCE_INSPECT_BUY,
			elementName = "CLICK_INSPECTBUY_ITEM_" .. p2.id
		}, {
			sessionTagName = SessionService:GetSessionTag("level2a")
		})
	end, { p2.id })

	local v21 = React.useCallback(function()
		callback(p2)
	end, { callback, p2 })

	local v22 = {
		title = v6.name,
		presentationSlot = React.createElement(itemCardThumbnail, { url = v15 }),
		itemSubType = v16,
		itemType = v17,
		creator = v20,
		itemLicensingInfo = 0,
		priceLineContent = 0,
		LayoutOrder = 0,
		Size = 0,
		headerSize = 0,
		footerAutomaticSize = 0,
		AutomaticSize = 0,
		onActivated = 0,
		ref = 0,
		itemStatus = 0,
		isOwned = 0,
		timedOptions = 0,
		onTimedOptionPriceChanged = 0,
		selectedTimedOptionPrice = 0,
		wearTimeSelectedOptionInList = 0
	}

	local v23 = if fFlagAXMarketplaceLicensingItemCards then v6.itemLicensingInfo else nil
	v22.itemLicensingInfo = v23
	v22.priceLineContent = v19
	v22.LayoutOrder = layoutOrder
	v22.Size = UDim2.fromOffset(p4, 0)
	v22.headerSize = UDim2.fromOffset(p4, p4)
	v22.footerAutomaticSize = Enum.AutomaticSize.XY
	v22.AutomaticSize = Enum.AutomaticSize.XY
	v22.onActivated = v21
	v22.ref = ref
	v22.itemStatus = v18
	v22.isOwned = v12
	v22.timedOptions = timedOptions
	v22.onTimedOptionPriceChanged = v13
	v22.selectedTimedOptionPrice = v14
	v22.wearTimeSelectedOptionInList = wearTimeSelectedOptionInList
	return v22
end
