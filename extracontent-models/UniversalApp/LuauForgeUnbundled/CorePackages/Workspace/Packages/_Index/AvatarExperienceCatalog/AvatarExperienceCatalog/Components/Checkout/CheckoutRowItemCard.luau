local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local catalogRowItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogRowItemCard
local itemCardThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceUIKit").ItemCardComponents.ItemCardThumbnail
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/tutils")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/createAXShoppingCartStore")
local PurchaseItemsErrorStatusMap = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Enums/PurchaseItemsErrorStatusMap")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Constants")

local useCheckoutRowItemCardViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/useCheckoutRowItemCardViewModel")

local AvatarExperienceGifting = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceGifting")
local avatarItemGiftEntryPoint = AvatarExperienceGifting.Components.AvatarItemGiftEntryPoint
local useAvatarItemGiftEligibility = AvatarExperienceGifting.Hooks.useAvatarItemGiftEligibility

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local fFlagAXGifting = AvatarExperienceFlags.FFlagAXGifting
local fFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local fFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local fFlagAXMISOffersChip = AvatarExperienceFlags.FFlagAXMISOffersChip
local fFlagAXMISSmallUIChanges = AvatarExperienceFlags.FFlagAXMISSmallUIChanges
local fFlagAXMISWithOffers = AvatarExperienceFlags.FFlagAXMISWithOffers

local AvatarExperienceTimedOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceTimedOptions")
local wearTimeSelectedOptionInList = AvatarExperienceTimedOptions.WearTimeSelectedOptionInList
local wearTimeOptionButton = AvatarExperienceTimedOptions.WearTimeOptionButton

local constants = AvatarExperienceCommon.Constants

local ASSET_TYPE_LOCALIZED = Constants.ASSET_TYPE_LOCALIZED
local BUNDLE_TYPE_LOCALIZED = Constants.BUNDLE_TYPE_LOCALIZED
local OFFERS_LOCALIZED = Constants.OFFERS_LOCALIZED

local v5 = {
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

local function hasAssetTypeLocalizedString(p2, p3): boolean
	return p2 == Enum.AvatarItemType.Asset.Name and ASSET_TYPE_LOCALIZED[tostring(p3)] ~= nil
end

local function hasBundleTypeLocalizedString(p2, p3): boolean
	return p2 == Enum.AvatarItemType.Bundle.Name and BUNDLE_TYPE_LOCALIZED[tostring(p3)] ~= nil
end

local function getThumbnailType(p2): string
	if p2 == Enum.AvatarItemType.Bundle.Name then
		return "BundleThumbnail"
	end

	return "Asset"
end

local function CheckoutRowItemCard(props)
	local v6 = Foundation.Hooks.useTokens()

	local thumbnailSize = props.thumbnailSize or v6.Size.Size_2100
	local selectedTimedOptionPrice, setSelectedTimedOptionPrice, showOfferPillTooltip

	if fFlagAXDurablesForMIS then
		local v7 = useCheckoutRowItemCardViewModel(props)
		selectedTimedOptionPrice = v7.selectedTimedOptionPrice
		setSelectedTimedOptionPrice = v7.setSelectedTimedOptionPrice

		if fFlagAXDurables2Option then
			showOfferPillTooltip = v7.showOfferPillTooltip
		end
	else
		setSelectedTimedOptionPrice = nil
	end

	local v7 = useLocalization(ASSET_TYPE_LOCALIZED)
	local v8 = useLocalization(BUNDLE_TYPE_LOCALIZED)
	local v9 = useLocalization(v5)
	local v10 = if fFlagAXMISOffersChip then useLocalization(OFFERS_LOCALIZED) else nil
	local v11 = props.itemType == Enum.AvatarItemType.Bundle.Name and "BundleThumbnail" or "Asset"

	local v12 = React.useMemo(function()
		local itemType = props.itemType
		local itemSubType = props.itemSubType
		local v13

		if itemType == Enum.AvatarItemType.Asset.Name then
			v13 = ASSET_TYPE_LOCALIZED[tostring(itemSubType)] ~= nil
		else
			v13 = false
		end

		if v13 then
			return v7[tostring(itemSubType)]
		end

		local v14

		if itemType == Enum.AvatarItemType.Bundle.Name then
			v14 = BUNDLE_TYPE_LOCALIZED[tostring(itemSubType)] ~= nil
		else
			v14 = false
		end

		if v14 then
			return v8[tostring(itemSubType)]
		end

		return ""
	end, { v7, v8, props.itemType, props.itemSubType })

	local useMemo = React.useMemo
	local function fn()
		local v13 = {}

		if props.status == nil then
			local v14 = {
				type = "price",
				price = props.priceInRobux,
				priceInRobuxDiscountedByOffers = 0
			}

			local v15 = if fFlagAXMISWithOffers then props.priceInRobuxDiscountedByOffers else nil
			v14.priceInRobuxDiscountedByOffers = v15
			table.insert(v13, v14)

			if
				props.discountInformation
				and (not fFlagAXMISWithOffers or fFlagAXMISWithOffers and props.discountInformation.totalDiscountAmount and props.discountInformation.totalDiscountAmount > 0)
			then
				local v16 = {
					type = "price",
					price = props.discountInformation.originalPrice,
					strikethrough = true,
					isOriginalPrice = true,
					shouldShowOriginalPrice = 0
				}

				local v17 = if fFlagAXMISWithOffers then props.priceInRobuxDiscountedByOffers ~= nil else nil
				v16.shouldShowOriginalPrice = v17
				table.insert(v13, v16)
				return v13
			end
		elseif props.status == PurchaseItemsErrorStatusMap.PRICE_MISMATCH then
			if not props.priceMismatchMetadata then
				table.insert(v13, {
					type = "text",
					text = v9[tostring(PurchaseItemsErrorStatusMap.PRICE_MISMATCH)]
				})
				return v13
			end

			local v14 = {
				type = "price",
				price = props.priceInRobux,
				priceInRobuxDiscountedByOffers = 0,
				colorStyle = 0
			}

			local v15 = if fFlagAXMISWithOffers then props.priceInRobuxDiscountedByOffers else nil
			v14.priceInRobuxDiscountedByOffers = v15

			v14.colorStyle = v6.Color.System.Warning
			table.insert(v13, v14)

			if not (fFlagAXMISWithOffers and props.priceInRobuxDiscountedByOffers) then
				table.insert(v13, {
					type = "price",
					price = props.priceMismatchMetadata.oldPriceInRobux,
					strikethrough = true
				})
				return v13
			end
		else
			if props.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED then
				table.insert(v13, {
					type = "text",
					text = v9[tostring(PurchaseItemsErrorStatusMap.ALREADY_OWNED)]
				})
				return v13
			end

			if props.status == PurchaseItemsErrorStatusMap.QUANTITY_LIMIT_EXCEEDED then
				table.insert(v13, {
					type = "text",
					text = v9[tostring(PurchaseItemsErrorStatusMap.QUANTITY_LIMIT_EXCEEDED)]
				})
				return v13
			end

			local v15 = if v5[tostring(props.status)] then v9[tostring(props.status)] else v9.Unvailable
			local v14 = {
				type = "text",
				text = v15,
				colorStyle = v6.Color.System.Warning
			}
			table.insert(v13, v14)
		end

		return v13
	end

	local priceInRobux = props.priceInRobux
	local status = props.status
	local priceMismatchMetadata = props.priceMismatchMetadata

	local discountInformation = props.discountInformation
	local v14 = if fFlagAXMISWithOffers then props.priceInRobuxDiscountedByOffers else nil
	local v15 = useMemo(fn, {
		priceInRobux,
		status,
		priceMismatchMetadata,
		v9,
		v6,
		discountInformation,
		v14
	})
	local v16

	if fFlagAXDurables2Option then
		local v17 = React.useMemo(function()
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
				local v18 = {
					tag = "fill auto-y padding-top-small",
					LayoutOrder = #props.timedOptions - k + 1
				}

				local createElement2 = React.createElement

				local v21 = {
					days = timedOption.days,
					price = timedOption.price,
					discountInformation = timedOption.discountInformation,
					selected = 0,
					priceInRobuxDiscountedByOffers = 0
				}
				local v22 = if props.selectedTimedOptionIndexInReducer then k == props.selectedTimedOptionIndexInReducer else timedOption.selected
				v21.selected = v22

				v21.priceInRobuxDiscountedByOffers = props.priceInRobuxDiscountedByOffers
				children[formatted] = createElement(view, v18, {
					Button = createElement2(wearTimeOptionButton, {
						isFullWidth = true,
						option = v21,
						onActivated = function()
							local timedOption2 = props.timedOptions[k]

							if timedOption2 then
								if setSelectedTimedOptionPrice then
									setSelectedTimedOptionPrice(timedOption2.price)
								end

								if props.onTimedOptionPriceChanged then
									local v23 = if timedOption2.days ~= 0 then timedOption2.days else nil
									props.onTimedOptionPriceChanged(timedOption2.price, v23)
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

		v16 = React.createElement(
			Foundation.View,
			{
				tag = "row gap-medium align-y-center size-full-0 auto-y",
				LayoutOrder = 2
			},
			v17
		)
	end

	local collectibleItemId

	if fFlagAXGifting and props.itemId ~= constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
		collectibleItemId = props.collectibleItemId
	end

	local v17

	if fFlagAXGifting then
		v17 = useAvatarItemGiftEligibility(collectibleItemId).areItemsGiftable
	else
		v17 = false
	end

	local v18

	if v17 then
		v18 = React.createElement(avatarItemGiftEntryPoint, {
			collectibleItemId = props.collectibleItemId,
			isCircular = true,
			LayoutOrder = 1
		})
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v19 = {
		tag = fFlagAXDurables2Option and "auto-y col size-full-0 gap-xxsmall" or "auto-y row size-full-0 gap-small",
		LayoutOrder = props.LayoutOrder,
		testId = `CheckoutRowItemCard-{props.itemId}`
	}
	local v21

	if not fFlagAXDurables2Option then
		local createElement2 = React.createElement
		local view2 = Foundation.View
		local createElement3 = React.createElement
		local v25 = {
			title = props.name,
			presentationSlot = React.createElement(itemCardThumbnail, {
				url = `rbxthumb://type={v11}&id={props.itemId}&w=150&h=150`
			}),
			onActivated = props.onActivated,
			creator = not fFlagAXMISSmallUIChanges and {
				name = props.creatorName,
				verified = props.creatorVerified
			} or nil,
			priceLineContent = v15,
			itemType = props.itemRestriction,
			itemSubType = v12,
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

		local v26 = if fFlagAXDurablesForMIS then props.timedOptions else nil
		v25.timedOptions = v26
		local v27 = if fFlagAXDurablesForMIS then props.expirationTime else nil
		v25.expirationTime = v27
		local v28 = if fFlagAXDurablesForMIS then props.isOwned else nil
		v25.isOwned = v28
		local v29 = if fFlagAXDurablesForMIS then props.onTimedOptionPriceChanged else nil
		v25.onTimedOptionPriceChanged = v29
		v25.selectedTimedOptionPrice = if fFlagAXDurablesForMIS then selectedTimedOptionPrice else nil
		v25.setSelectedTimedOptionPrice = if fFlagAXDurablesForMIS then setSelectedTimedOptionPrice else nil

		local v32 = if fFlagAXDurablesForMIS then props.selectedTimedOptionIndexInReducer else nil
		v25.selectedTimedOptionIndexInReducer = v32

		v25.wearTimeSelectedOptionInList = if fFlagAXDurablesForMIS then wearTimeSelectedOptionInList else nil
		v25.headerSize = UDim2.fromOffset(thumbnailSize, thumbnailSize)
		v25.footerSize = UDim2.fromScale(0, 1)
		v25.footerAutomaticSize = Enum.AutomaticSize.XY
		v25.AutomaticSize = Enum.AutomaticSize.XY
		v25.offersLocalized = if fFlagAXMISOffersChip then v10 else nil
		local v35 = if fFlagAXMISOffersChip then props.offerApplied else nil
		v25.offerApplied = v35
		v21 = createElement2(view2, { tag = "auto-xy fill", LayoutOrder = 1 }, {
			CatalogRowItemCard = createElement3(catalogRowItemCard, v25)
		})
	end

	local v22

	if not fFlagAXDurables2Option then
		local createElement2 = React.createElement
		local view2 = Foundation.View

		local v24 = {
			GiftButton = if fFlagAXGifting then v18 else nil,
			RemoveButton = 0
		}

		local v26 = if props.onRemove then React.createElement(Foundation.IconButton, {
			icon = "x",
			isCircular = true,
			variant = Foundation.Enums.ButtonVariant.Standard,
			onActivated = props.onRemove,
			LayoutOrder = fFlagAXGifting and 2 or nil
		}) else nil
		v24.RemoveButton = v26
		v22 = createElement2(view2, {
			tag = fFlagAXGifting and {
				["row self-center gap-small anchor-top-right auto-xy"] = true
			} or "auto-xy anchor-top-right self-center",
			LayoutOrder = 2
		}, v24)
	end

	local v23

	if fFlagAXDurables2Option then
		local createElement2 = React.createElement
		local view2 = Foundation.View

		local createElement3 = React.createElement
		local view3 = Foundation.View

		local createElement4 = React.createElement
		local v29 = {
			title = props.name,
			presentationSlot = React.createElement(itemCardThumbnail, {
				url = `rbxthumb://type={v11}&id={props.itemId}&w=150&h=150`
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

		if not fFlagAXGifting then
			v18 = nil
		end

		v29.giftButton = v18

		v29.creator = not fFlagAXMISSmallUIChanges
			and { name = props.creatorName, verified = props.creatorVerified }
			or nil

		v29.priceLineContent = v15
		v29.itemStatusInCheckout = props.status
		v29.itemType = props.itemRestriction
		v29.itemSubType = v12
		local v30 = if fFlagAXDurablesForMIS then props.timedOptions else nil
		v29.timedOptions = v30
		local v31 = if fFlagAXDurablesForMIS then props.expirationTime else nil
		v29.expirationTime = v31
		local v32 = if fFlagAXDurablesForMIS then props.isOwned else nil
		v29.isOwned = v32

		local v33 = if fFlagAXDurablesForMIS then props.onTimedOptionPriceChanged else nil
		v29.onTimedOptionPriceChanged = v33

		if not fFlagAXDurablesForMIS then
			selectedTimedOptionPrice = nil
		end

		v29.selectedTimedOptionPrice = selectedTimedOptionPrice
		v29.setSelectedTimedOptionPrice = if fFlagAXDurablesForMIS then setSelectedTimedOptionPrice else nil

		local v35 = if fFlagAXDurablesForMIS then props.selectedTimedOptionIndexInReducer else nil
		v29.selectedTimedOptionIndexInReducer = v35

		v29.wearTimeSelectedOptionInList = if fFlagAXDurablesForMIS then wearTimeSelectedOptionInList else nil

		v29.headerSize = UDim2.fromOffset(thumbnailSize, thumbnailSize)
		v29.footerSize = UDim2.fromScale(0, 1)
		v29.footerAutomaticSize = Enum.AutomaticSize.XY
		v29.AutomaticSize = Enum.AutomaticSize.XY
		v29.offersLocalized = v10
		v29.showOfferPillTooltip = showOfferPillTooltip
		v29.offerApplied = props.offerApplied
		v23 = createElement2(view2, {
			tag = "auto-y row size-full-0 gap-small",
			LayoutOrder = 1
		}, {
			RowItemCardContainer = createElement3(view3, {
				tag = "auto-xy fill",
				LayoutOrder = 1
			}, {
				CatalogRowItemCard = createElement4(catalogRowItemCard, v29)
			})
		})
	end

	if not fFlagAXDurables2Option or props.isOwned and props.expirationTime == nil then
		v16 = nil
	end

	local v24 = if fFlagAXDurables2Option then React.createElement(
		Foundation.View,
		{ tag = "col size-full-0 auto-y padding-y-medium", LayoutOrder = 3 },
		{
			Divider = React.createElement(Foundation.Divider)
		}
	) else nil
	return createElement(view, v19, {
		RowItemCardContainer = v21,
		RightSlot = v22,
		ItemRow = v23,
		OptionsButtonsView = v16,
		OptionsButtonsDivider = v24
	})
end

return React.memo(CheckoutRowItemCard, tutils.deepEqual)
