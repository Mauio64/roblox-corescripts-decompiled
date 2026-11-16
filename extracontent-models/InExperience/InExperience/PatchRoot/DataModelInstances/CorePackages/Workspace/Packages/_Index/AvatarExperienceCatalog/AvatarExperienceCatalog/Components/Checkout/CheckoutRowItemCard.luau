local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local CatalogRowItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogRowItemCard
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail
local tutils = require(parent.tutils)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(AvatarExperienceCatalog.Stores.createAXShoppingCartStore)
local PurchaseItemsErrorStatusMap = require(AvatarExperienceCatalog.Enums.PurchaseItemsErrorStatusMap)
local Constants = require(AvatarExperienceCatalog.Constants)

local useCheckoutRowItemCardViewModel = require(script.Parent.useCheckoutRowItemCardViewModel)

local AvatarExperienceGifting = require(parent.AvatarExperienceGifting)
local AvatarItemGiftEntryPoint = AvatarExperienceGifting.Components.AvatarItemGiftEntryPoint
local useAvatarItemGiftEligibility = AvatarExperienceGifting.Hooks.useAvatarItemGiftEligibility

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXGifting = AvatarExperienceFlags.FFlagAXGifting
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local FFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local FFlagAXMISOffersChip = AvatarExperienceFlags.FFlagAXMISOffersChip
local FFlagAXMISSmallUIChanges = AvatarExperienceFlags.FFlagAXMISSmallUIChanges
local FFlagAXMISWithOffers = AvatarExperienceFlags.FFlagAXMISWithOffers

local AvatarExperienceTimedOptions = require(parent.AvatarExperienceTimedOptions)
local WearTimeSelectedOptionInList = AvatarExperienceTimedOptions.WearTimeSelectedOptionInList
local WearTimeOptionButton = AvatarExperienceTimedOptions.WearTimeOptionButton

local constants = AvatarExperienceCommon.Constants

local ASSET_TYPE_LOCALIZED = Constants.ASSET_TYPE_LOCALIZED
local BUNDLE_TYPE_LOCALIZED = Constants.BUNDLE_TYPE_LOCALIZED
local OFFERS_LOCALIZED = Constants.OFFERS_LOCALIZED

local v = {
	[tostring(PurchaseItemsErrorStatusMap.SOLD_OUT)] = "Feature.Catalog.Label.Checkout.SoldOut",
	[tostring(PurchaseItemsErrorStatusMap.ALREADY_OWNED)] = "Feature.Catalog.Label.Owned",
	[tostring(PurchaseItemsErrorStatusMap.EXPERIENCE_LINK)] = "Feature.Catalog.Label.Checkout.InExperienceOnly",
	[tostring(PurchaseItemsErrorStatusMap.QUANTITY_LIMIT_EXCEEDED)] = "Feature.Catalog.Label.Checkout.LimitReached",
	[tostring(PurchaseItemsErrorStatusMap.NOT_AVAILABLE_FOR_PURCHASER)] = "Feature.Catalog.Label.Checkout.Unavailable",
	[tostring(PurchaseItemsErrorStatusMap.NOT_FOR_SALE)] = "Feature.Catalog.Label.Checkout.OffSale",
	[tostring(PurchaseItemsErrorStatusMap.PURCHASER_IS_SELLER)] = "Feature.Catalog.Label.Checkout.Unavailable",
	[tostring(PurchaseItemsErrorStatusMap.PURCHASE_PLACE_INVALID)] = "Feature.Catalog.Label.Checkout.InExperienceOnly",
	[tostring(PurchaseItemsErrorStatusMap.PRICE_MISMATCH)] = "Feature.Catalog.Label.Checkout.PriceChanged",
	Unvailable = "Feature.Catalog.Label.Checkout.Unavailable"
}

local function hasAssetTypeLocalizedString(itemType: string, itemSubType: string): boolean -- 1 equivalent call inferred from this helper
	return itemType == Enum.AvatarItemType.Asset.Name and ASSET_TYPE_LOCALIZED[tostring(itemSubType)] ~= nil
end

local function hasBundleTypeLocalizedString(itemType: string, itemSubType: string): boolean -- 1 equivalent call inferred from this helper
	return itemType == Enum.AvatarItemType.Bundle.Name and BUNDLE_TYPE_LOCALIZED[tostring(itemSubType)] ~= nil
end

local function getThumbnailType(itemType: string): string -- 1 equivalent call inferred from this helper
	if itemType == Enum.AvatarItemType.Bundle.Name then
		return "BundleThumbnail"
	end

	return "Asset"
end

local function CheckoutRowItemCard(props)
	local v2 = Foundation.Hooks.useTokens()

	local thumbnailSize = props.thumbnailSize or v2.Size.Size_2100
	local selectedTimedOptionPrice, setSelectedTimedOptionPrice, showOfferPillTooltip

	if FFlagAXDurablesForMIS then
		local v3 = useCheckoutRowItemCardViewModel(props)
		selectedTimedOptionPrice = v3.selectedTimedOptionPrice
		setSelectedTimedOptionPrice = v3.setSelectedTimedOptionPrice

		if FFlagAXDurables2Option then
			showOfferPillTooltip = v3.showOfferPillTooltip
		end
	else
		setSelectedTimedOptionPrice = nil
	end

	local v3 = useLocalization(ASSET_TYPE_LOCALIZED)
	local v4 = useLocalization(BUNDLE_TYPE_LOCALIZED)
	local v5 = useLocalization(v)
	local offersLocalized

	if FFlagAXMISOffersChip then
		offersLocalized = useLocalization(OFFERS_LOCALIZED)
	end

	local thumbnailType = getThumbnailType(props.itemType) -- inferred equivalent call

	local itemSubType = React.useMemo(function()
		local itemType = props.itemType
		local itemSubType = props.itemSubType

		if hasAssetTypeLocalizedString(itemType, itemSubType) then -- inferred equivalent call
			return v3[tostring(itemSubType)]
		end

		if hasBundleTypeLocalizedString(itemType, itemSubType) then -- inferred equivalent call
			return v4[tostring(itemSubType)]
		end

		return ""
	end, { v3, v4, props.itemType, props.itemSubType })

	local useMemo = React.useMemo
	local function fn()
		local v6 = {}

		if props.status == nil then
			local v7 = {
				type = "price",
				price = props.priceInRobux,
				priceInRobuxDiscountedByOffers = 0
			}
			local priceInRobuxDiscountedByOffers

			if FFlagAXMISWithOffers then
				priceInRobuxDiscountedByOffers = props.priceInRobuxDiscountedByOffers
			end

			v7.priceInRobuxDiscountedByOffers = priceInRobuxDiscountedByOffers
			table.insert(v6, v7)

			if
				props.discountInformation
				and (not FFlagAXMISWithOffers or FFlagAXMISWithOffers and props.discountInformation.totalDiscountAmount and props.discountInformation.totalDiscountAmount > 0)
			then
				local v8 = {
					type = "price",
					price = props.discountInformation.originalPrice,
					strikethrough = true,
					isOriginalPrice = true,
					shouldShowOriginalPrice = 0
				}
				local shouldShowOriginalPrice

				if FFlagAXMISWithOffers then
					shouldShowOriginalPrice = props.priceInRobuxDiscountedByOffers ~= nil
				end

				v8.shouldShowOriginalPrice = shouldShowOriginalPrice
				table.insert(v6, v8)
				return v6
			end
		elseif props.status == PurchaseItemsErrorStatusMap.PRICE_MISMATCH then
			if not props.priceMismatchMetadata then
				table.insert(v6, {
					type = "text",
					text = v5[tostring(PurchaseItemsErrorStatusMap.PRICE_MISMATCH)]
				})
				return v6
			end

			local v7 = {
				type = "price",
				price = props.priceInRobux,
				priceInRobuxDiscountedByOffers = 0,
				colorStyle = 0
			}
			local priceInRobuxDiscountedByOffers

			if FFlagAXMISWithOffers then
				priceInRobuxDiscountedByOffers = props.priceInRobuxDiscountedByOffers
			end

			v7.priceInRobuxDiscountedByOffers = priceInRobuxDiscountedByOffers

			v7.colorStyle = v2.Color.System.Warning
			table.insert(v6, v7)

			if not (FFlagAXMISWithOffers and props.priceInRobuxDiscountedByOffers) then
				table.insert(v6, {
					type = "price",
					price = props.priceMismatchMetadata.oldPriceInRobux,
					strikethrough = true
				})
				return v6
			end
		else
			if props.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED then
				table.insert(v6, {
					type = "text",
					text = v5[tostring(PurchaseItemsErrorStatusMap.ALREADY_OWNED)]
				})
				return v6
			end

			if props.status == PurchaseItemsErrorStatusMap.QUANTITY_LIMIT_EXCEEDED then
				table.insert(v6, {
					type = "text",
					text = v5[tostring(PurchaseItemsErrorStatusMap.QUANTITY_LIMIT_EXCEEDED)]
				})
				return v6
			end

			local text

			if v[tostring(props.status)] then
				text = v5[tostring(props.status)]
			else
				text = v5.Unvailable
			end

			local v7 = { type = "text", text = text, colorStyle = v2.Color.System.Warning }
			table.insert(v6, v7)
		end

		return v6
	end

	local priceInRobux = props.priceInRobux
	local status = props.status
	local priceMismatchMetadata = props.priceMismatchMetadata

	local discountInformation = props.discountInformation
	local v6

	if FFlagAXMISWithOffers then
		v6 = props.priceInRobuxDiscountedByOffers
	end

	local priceLineContent = useMemo(fn, {
		priceInRobux,
		status,
		priceMismatchMetadata,
		v5,
		v2,
		discountInformation,
		v6
	})
	local optionsButtonsView

	if FFlagAXDurables2Option then
		local v7 = React.useMemo(function()
			local children = {}

			if not props.timedOptions then
				return children
			end

			for k, timedOption in props.timedOptions do
				if not (timedOption.days == 3 or timedOption.days == 0) then
					continue
				end

				local formatted = `Option{k}`
				local createElement = React.createElement
				local view = Foundation.View
				local v7 = {
					tag = "fill auto-y padding-top-small",
					LayoutOrder = #props.timedOptions - k + 1
				}

				local createElement2 = React.createElement

				local option = {
					days = timedOption.days,
					price = timedOption.price,
					discountInformation = timedOption.discountInformation,
					selected = 0,
					priceInRobuxDiscountedByOffers = 0
				}
				local selected

				if props.selectedTimedOptionIndexInReducer then
					selected = k == props.selectedTimedOptionIndexInReducer
				else
					selected = timedOption.selected
				end

				option.selected = selected

				option.priceInRobuxDiscountedByOffers = props.priceInRobuxDiscountedByOffers
				children[formatted] = createElement(view, v7, {
					Button = createElement2(WearTimeOptionButton, {
						isFullWidth = true,
						option = option,
						onActivated = function()
							local timedOption2 = props.timedOptions[k]

							if timedOption2 then
								if setSelectedTimedOptionPrice then
									setSelectedTimedOptionPrice(timedOption2.price)
								end

								if props.onTimedOptionPriceChanged then
									local v8

									if timedOption2.days ~= 0 then
										v8 = timedOption2.days
									end

									props.onTimedOptionPriceChanged(timedOption2.price, v8)
								end
							end
						end
					})
				})
			end

			return children
		end, {
			props.timedOptions,
			props.onTimedOptionPriceChanged,
			props.selectedTimedOptionIndexInReducer,
			setSelectedTimedOptionPrice
		})

		optionsButtonsView = React.createElement(
			Foundation.View,
			{ tag = "row gap-medium align-y-center size-full-0 auto-y", LayoutOrder = 2 },
			v7
		)
	end

	local collectibleItemId

	if FFlagAXGifting and props.itemId ~= constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
		collectibleItemId = props.collectibleItemId
	end

	local v7

	if FFlagAXGifting then
		v7 = useAvatarItemGiftEligibility(collectibleItemId).areItemsGiftable
	else
		v7 = false
	end

	local giftButton

	if v7 then
		giftButton = React.createElement(AvatarItemGiftEntryPoint, {
			collectibleItemId = props.collectibleItemId,
			isCircular = true,
			LayoutOrder = 1
		})
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v8 = {
		tag = FFlagAXDurables2Option and "auto-y col size-full-0 gap-xxsmall" or "auto-y row size-full-0 gap-small",
		LayoutOrder = props.LayoutOrder,
		testId = `CheckoutRowItemCard-{props.itemId}`
	}
	local rowItemCardContainer

	if not FFlagAXDurables2Option then
		local createElement2 = React.createElement
		local view2 = Foundation.View
		local createElement3 = React.createElement
		local v9 = {
			title = props.name,
			presentationSlot = React.createElement(ItemCardThumbnail, {
				url = `rbxthumb://type={thumbnailType}&id={props.itemId}&w=150&h=150`
			}),
			onActivated = props.onActivated,
			creator = not FFlagAXMISSmallUIChanges and {
				name = props.creatorName,
				verified = props.creatorVerified
			} or nil,
			priceLineContent = priceLineContent,
			itemType = props.itemRestriction,
			itemSubType = itemSubType,
			timedOptions = 0,
			expirationTime = 0,
			isOwned = 0,
			onTimedOptionPriceChanged = 0,
			selectedTimedOptionPrice = 0,
			setSelectedTimedOptionPrice = 0,
			selectedTimedOptionIndexInReducer = 0,
			wearTimeSelectedOptionInList = 0,
			headerSize = 0,
			footerSize = 0,
			footerAutomaticSize = 0,
			AutomaticSize = 0,
			offersLocalized = 0,
			offerApplied = 0
		}
		local timedOptions

		if FFlagAXDurablesForMIS then
			timedOptions = props.timedOptions
		end

		v9.timedOptions = timedOptions
		local expirationTime

		if FFlagAXDurablesForMIS then
			expirationTime = props.expirationTime
		end

		v9.expirationTime = expirationTime
		local isOwned

		if FFlagAXDurablesForMIS then
			isOwned = props.isOwned
		end

		v9.isOwned = isOwned
		local onTimedOptionPriceChanged

		if FFlagAXDurablesForMIS then
			onTimedOptionPriceChanged = props.onTimedOptionPriceChanged
		end

		v9.onTimedOptionPriceChanged = onTimedOptionPriceChanged
		local selectedTimedOptionPrice2

		if FFlagAXDurablesForMIS then
			selectedTimedOptionPrice2 = selectedTimedOptionPrice
		end

		v9.selectedTimedOptionPrice = selectedTimedOptionPrice2
		local setSelectedTimedOptionPrice2

		if FFlagAXDurablesForMIS then
			setSelectedTimedOptionPrice2 = setSelectedTimedOptionPrice
		end

		v9.setSelectedTimedOptionPrice = setSelectedTimedOptionPrice2
		local selectedTimedOptionIndexInReducer

		if FFlagAXDurablesForMIS then
			selectedTimedOptionIndexInReducer = props.selectedTimedOptionIndexInReducer
		end

		v9.selectedTimedOptionIndexInReducer = selectedTimedOptionIndexInReducer
		local wearTimeSelectedOptionInList

		if FFlagAXDurablesForMIS then
			wearTimeSelectedOptionInList = WearTimeSelectedOptionInList
		end

		v9.wearTimeSelectedOptionInList = wearTimeSelectedOptionInList
		v9.headerSize = UDim2.fromOffset(thumbnailSize, thumbnailSize)
		v9.footerSize = UDim2.fromScale(0, 1)
		v9.footerAutomaticSize = Enum.AutomaticSize.XY
		v9.AutomaticSize = Enum.AutomaticSize.XY
		local offersLocalized2

		if FFlagAXMISOffersChip then
			offersLocalized2 = offersLocalized
		end

		v9.offersLocalized = offersLocalized2
		local offerApplied

		if FFlagAXMISOffersChip then
			offerApplied = props.offerApplied
		end

		v9.offerApplied = offerApplied
		rowItemCardContainer = createElement2(view2, { tag = "auto-xy fill", LayoutOrder = 1 }, {
			CatalogRowItemCard = createElement3(CatalogRowItemCard, v9)
		})
	end

	local rightSlot

	if not FFlagAXDurables2Option then
		local createElement2 = React.createElement
		local view2 = Foundation.View
		local giftButton2

		if FFlagAXGifting then
			giftButton2 = giftButton
		end

		local removeButton

		if props.onRemove then
			removeButton = React.createElement(Foundation.IconButton, {
				icon = "x",
				isCircular = true,
				variant = Foundation.Enums.ButtonVariant.Standard,
				onActivated = props.onRemove,
				LayoutOrder = FFlagAXGifting and 2 or nil
			})
		end

		rightSlot = createElement2(view2, {
			tag = FFlagAXGifting and {
				["row self-center gap-small anchor-top-right auto-xy"] = true
			} or "auto-xy anchor-top-right self-center",
			LayoutOrder = 2
		}, { GiftButton = giftButton2, RemoveButton = removeButton })
	end

	local itemRow

	if FFlagAXDurables2Option then
		local createElement2 = React.createElement
		local view2 = Foundation.View

		local createElement3 = React.createElement
		local view3 = Foundation.View

		local createElement4 = React.createElement
		local v9 = {
			title = props.name,
			presentationSlot = React.createElement(ItemCardThumbnail, {
				url = `rbxthumb://type={thumbnailType}&id={props.itemId}&w=150&h=150`
			}),
			onActivated = props.onActivated,
			onRemove = props.onRemove,
			giftButton = 0,
			hideTimedOptionSelections = true,
			creator = 0,
			priceLineContent = 0,
			itemStatusInCheckout = 0,
			itemType = 0,
			itemSubType = 0,
			timedOptions = 0,
			expirationTime = 0,
			isOwned = 0,
			onTimedOptionPriceChanged = 0,
			selectedTimedOptionPrice = 0,
			setSelectedTimedOptionPrice = 0,
			selectedTimedOptionIndexInReducer = 0,
			wearTimeSelectedOptionInList = 0,
			headerSize = 0,
			footerSize = 0,
			footerAutomaticSize = 0,
			AutomaticSize = 0,
			offersLocalized = 0,
			showOfferPillTooltip = 0,
			offerApplied = 0
		}

		if not FFlagAXGifting then
			giftButton = nil
		end

		v9.giftButton = giftButton

		v9.creator = not FFlagAXMISSmallUIChanges and {
				name = props.creatorName,
				verified = props.creatorVerified
			}
			or nil

		v9.priceLineContent = priceLineContent
		v9.itemStatusInCheckout = props.status
		v9.itemType = props.itemRestriction
		v9.itemSubType = itemSubType
		local timedOptions

		if FFlagAXDurablesForMIS then
			timedOptions = props.timedOptions
		end

		v9.timedOptions = timedOptions
		local expirationTime

		if FFlagAXDurablesForMIS then
			expirationTime = props.expirationTime
		end

		v9.expirationTime = expirationTime
		local isOwned

		if FFlagAXDurablesForMIS then
			isOwned = props.isOwned
		end

		v9.isOwned = isOwned
		local onTimedOptionPriceChanged

		if FFlagAXDurablesForMIS then
			onTimedOptionPriceChanged = props.onTimedOptionPriceChanged
		end

		v9.onTimedOptionPriceChanged = onTimedOptionPriceChanged

		if not FFlagAXDurablesForMIS then
			selectedTimedOptionPrice = nil
		end

		v9.selectedTimedOptionPrice = selectedTimedOptionPrice
		local setSelectedTimedOptionPrice2

		if FFlagAXDurablesForMIS then
			setSelectedTimedOptionPrice2 = setSelectedTimedOptionPrice
		end

		v9.setSelectedTimedOptionPrice = setSelectedTimedOptionPrice2
		local selectedTimedOptionIndexInReducer

		if FFlagAXDurablesForMIS then
			selectedTimedOptionIndexInReducer = props.selectedTimedOptionIndexInReducer
		end

		v9.selectedTimedOptionIndexInReducer = selectedTimedOptionIndexInReducer
		local wearTimeSelectedOptionInList

		if FFlagAXDurablesForMIS then
			wearTimeSelectedOptionInList = WearTimeSelectedOptionInList
		end

		v9.wearTimeSelectedOptionInList = wearTimeSelectedOptionInList

		v9.headerSize = UDim2.fromOffset(thumbnailSize, thumbnailSize)
		v9.footerSize = UDim2.fromScale(0, 1)
		v9.footerAutomaticSize = Enum.AutomaticSize.XY
		v9.AutomaticSize = Enum.AutomaticSize.XY
		v9.offersLocalized = offersLocalized
		v9.showOfferPillTooltip = showOfferPillTooltip
		v9.offerApplied = props.offerApplied
		itemRow = createElement2(view2, {
			tag = "auto-y row size-full-0 gap-small",
			LayoutOrder = 1
		}, {
			RowItemCardContainer = createElement3(view3, { tag = "auto-xy fill", LayoutOrder = 1 }, {
				CatalogRowItemCard = createElement4(CatalogRowItemCard, v9)
			})
		})
	end

	if not FFlagAXDurables2Option or props.isOwned and props.expirationTime == nil then
		optionsButtonsView = nil
	end

	local optionsButtonsDivider

	if FFlagAXDurables2Option then
		optionsButtonsDivider = React.createElement(
			Foundation.View,
			{ tag = "col size-full-0 auto-y padding-y-medium", LayoutOrder = 3 },
			{
				Divider = React.createElement(Foundation.Divider)
			}
		)
	end

	return createElement(view, v8, {
		RowItemCardContainer = rowItemCardContainer,
		RightSlot = rightSlot,
		ItemRow = itemRow,
		OptionsButtonsView = optionsButtonsView,
		OptionsButtonsDivider = optionsButtonsDivider
	})
end

return React.memo(CheckoutRowItemCard, tutils.deepEqual)
