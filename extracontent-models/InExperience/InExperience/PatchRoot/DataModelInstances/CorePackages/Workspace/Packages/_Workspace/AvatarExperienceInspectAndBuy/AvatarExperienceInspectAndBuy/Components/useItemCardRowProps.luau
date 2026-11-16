local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local SessionService = game:GetService("SessionService")
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Localization = require(parent.Localization)
local AXCommon = require(parent.AXCommon)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail
local AvatarExperienceTimedOptions = require(parent.AvatarExperienceTimedOptions)
local WearTimeSelectedOptionInList = AvatarExperienceTimedOptions.WearTimeSelectedOptionInList
local useLocalization = Localization.Hooks.useLocalization
local React = require(parent.React)
local useConvertedItemData = require(AvatarExperienceInspectAndBuy.Hooks.useConvertedItemData)
require(AvatarExperienceInspectAndBuy.Types)
local Constants = require(AvatarExperienceInspectAndBuy.Constants)
local AssetLocalizationKeys = Constants.AssetLocalizationKeys
local BundleLocalizationKeys = Constants.BundleLocalizationKeys
local PriceStatusLocalizationKeys = Constants.PriceStatusLocalizationKeys
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
require(AvatarExperienceInspectAndBuy.Enums.ViewType)
local PriceStatus = require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
local Http = require(parent.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus
local getItemThumbnailUrl = require(AvatarExperienceInspectAndBuy.Utils.getItemThumbnailUrl)
local getCatalogCardItemType = require(AvatarExperienceInspectAndBuy.Utils.getCatalogCardItemType)
local getPriceLineContent = require(AvatarExperienceInspectAndBuy.Utils.getPriceLineContent)
local itemDetailsUtils = require(AvatarExperienceInspectAndBuy.Utils.itemDetailsUtils)
local getPriceInRobux = itemDetailsUtils.getPriceInRobux
local getPriceStatus = require(AvatarExperienceInspectAndBuy.Utils.getPriceStatus)
local Cryo = require(parent.Cryo)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local ItemSelectionStoreContext = require(AvatarExperienceInspectAndBuy.Contexts.ItemSelectionStoreContext)
local useItemSelectionStore = ItemSelectionStoreContext.useItemSelectionStore

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMarketplaceLicensingItemCards = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemCards

local CatalogItemCardStatusIconTypeEnum = AXCommon.Components.CatalogItemCard.CatalogItemCardStatusIconTypeEnum

return function(p, layoutOrder: number, _, callback, p2: number)
	local v = useTokens()
	local v2, v3 = useConvertedItemData(p)
	local v4

	if p.itemType == ItemTypeEnum.Bundle then
		v4 = BundleLocalizationKeys
	else
		v4 = AssetLocalizationKeys
	end

	local v5 = useLocalization((Cryo.Dictionary.join(v4, PriceStatusLocalizationKeys)))

	local v6 = useItemSelectionStore()
	local v7 = useSignalState(v6.getItemData(p.id))

	local isOwned = React.useMemo(function(): boolean
		return getPriceStatus(v2) == PriceStatus.Owned
	end, { v2 })

	React.useEffect(function()
		if not (v2 and v2.timedOptions) then
			return
		end

		local price = getPriceInRobux(v2, getPriceStatus(v2)) or 0
		local clone = table.clone(v2.timedOptions)
		table.insert(clone, { days = 0, price = price, selected = true })

		v6.setItemData(p.id, { timedOptions = clone })
	end, { v2, p.id, v6 })

	local onTimedOptionPriceChanged = React.useCallback(function(p3: number, p4: number?)
		if not (v7 and v7.timedOptions) then
			return
		end

		local timedOptions = {}

		for _, timedOption in v7.timedOptions do
			local v8 = {
				days = timedOption.days,
				price = timedOption.price,
				selected = timedOption.price == p3 and (p4 == nil or timedOption.days == p4)
			}
			table.insert(timedOptions, v8)
		end

		v6.setItemData(p.id, { timedOptions = timedOptions })
	end, { p.id, v7, v6 })

	local timedOptions = v7 and v7.timedOptions or nil

	local selectedTimedOptionPrice = React.useMemo(function()
		if not timedOptions then
			return nil
		end

		for _, timedOption in timedOptions do
			if timedOption.selected then
				return timedOption.price
			end
		end

		return nil
	end, { timedOptions })

	if not v2 then
		return {}
	end

	local itemThumbnailUrl = getItemThumbnailUrl(p)
	local itemSubType = v5[v2.itemSubType]
	local catalogCardItemType = getCatalogCardItemType(v2.itemRestrictions)
	local itemStatus = v2.timedOptions
		and not isOwned
		and { type = "icon", iconType = CatalogItemCardStatusIconTypeEnum.Durable }
		or nil
	local priceLineContent

	if v3 == RetrievalStatus.Done then
		priceLineContent = getPriceLineContent(v2, v, v5)
	end

	local creator = v2.creator and {
		name = v2.creator.creatorName or "",
		verified = v2.creator.creatorHasVerifiedBadge
	} or nil

	local ref = React.useRef(nil)
	React.useEffect(function()
		addUnifiedEventLogging(ref, {
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = UnifiedLoggingSurface.IN_EXPERIENCE_INSPECT_BUY,
			elementName = "CLICK_INSPECTBUY_ITEM_" .. p.id
		}, {
			sessionTagName = SessionService:GetSessionTag("level2a")
		})
	end, { p.id })

	local onActivated = React.useCallback(function()
		callback(p)
	end, { callback, p })

	local v8 = {
		title = v2.name,
		presentationSlot = React.createElement(ItemCardThumbnail, { url = itemThumbnailUrl }),
		itemSubType = itemSubType,
		itemType = catalogCardItemType,
		creator = creator,
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
	local itemLicensingInfo

	if FFlagAXMarketplaceLicensingItemCards then
		itemLicensingInfo = v2.itemLicensingInfo
	end

	v8.itemLicensingInfo = itemLicensingInfo
	v8.priceLineContent = priceLineContent
	v8.LayoutOrder = layoutOrder
	v8.Size = UDim2.fromOffset(p2, 0)
	v8.headerSize = UDim2.fromOffset(p2, p2)
	v8.footerAutomaticSize = Enum.AutomaticSize.XY
	v8.AutomaticSize = Enum.AutomaticSize.XY
	v8.onActivated = onActivated
	v8.ref = ref
	v8.itemStatus = itemStatus
	v8.isOwned = isOwned
	v8.timedOptions = timedOptions
	v8.onTimedOptionPriceChanged = onTimedOptionPriceChanged
	v8.selectedTimedOptionPrice = selectedTimedOptionPrice
	v8.wearTimeSelectedOptionInList = WearTimeSelectedOptionInList
	return v8
end
