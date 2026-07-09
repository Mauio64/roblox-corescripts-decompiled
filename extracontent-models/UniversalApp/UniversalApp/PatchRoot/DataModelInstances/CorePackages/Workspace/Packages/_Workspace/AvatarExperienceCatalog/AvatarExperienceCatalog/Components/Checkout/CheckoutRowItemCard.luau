local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local Foundation = require(AvatarExperienceCatalogParent.Foundation)
local CatalogRowItemCard = require(AvatarExperienceCatalogParent.AvatarExperienceCommon).Components.CatalogItemCard.CatalogRowItemCard
local ItemCardThumbnail = require(AvatarExperienceCatalogParent.AvatarExperienceUIKit).ItemCardComponents.ItemCardThumbnail
local tutils = require(AvatarExperienceCatalogParent.tutils)
local useLocalization = require(AvatarExperienceCatalogParent.Localization).Hooks.useLocalization

require(AvatarExperienceCatalog.Stores.createAXShoppingCartStore)

local PurchaseItemsErrorStatusMap = require(AvatarExperienceCatalog.Enums.PurchaseItemsErrorStatusMap)
local Constants = require(AvatarExperienceCatalog.Constants)
local useCheckoutRowItemCardViewModel = require(script.Parent.useCheckoutRowItemCardViewModel)
local AvatarExperienceFlags = require(AvatarExperienceCatalogParent.AvatarExperienceFlags)
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local FFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local FFlagAXMISSmallUIChanges = AvatarExperienceFlags.FFlagAXMISSmallUIChanges
local FFlagAXMISWithOffers = AvatarExperienceFlags.FFlagAXMISWithOffers
local AvatarExperienceTimedOptions = require(AvatarExperienceCatalogParent.AvatarExperienceTimedOptions)
local WearTimeSelectedOptionInList = AvatarExperienceTimedOptions.WearTimeSelectedOptionInList
local WearTimeOptionButton = AvatarExperienceTimedOptions.WearTimeOptionButton
local ASSET_TYPE_LOCALIZED = Constants.ASSET_TYPE_LOCALIZED
local BUNDLE_TYPE_LOCALIZED = Constants.BUNDLE_TYPE_LOCALIZED
local t1 = {
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

local function hasAssetTypeLocalizedString(s1: string, s2: string) -- line: 47
	-- upvalues: ASSET_TYPE_LOCALIZED (copy)
	return s1 == Enum.AvatarItemType.Asset.Name and ASSET_TYPE_LOCALIZED[tostring(s2)] ~= nil
end
local function hasBundleTypeLocalizedString(s3: string, s4: string) -- line: 51
	-- upvalues: BUNDLE_TYPE_LOCALIZED (copy)
	return s3 == Enum.AvatarItemType.Bundle.Name and BUNDLE_TYPE_LOCALIZED[tostring(s4)] ~= nil
end
local function getThumbnailType(s5: string) -- line: 55
	if s5 == Enum.AvatarItemType.Bundle.Name then
		return "BundleThumbnail"
	end

	return "Asset"
end
local function CheckoutRowItemCard(p1) -- line: 71
	-- upvalues: Foundation (copy), FFlagAXDurablesForMIS (copy), useCheckoutRowItemCardViewModel (copy), useLocalization (copy), ASSET_TYPE_LOCALIZED (copy), BUNDLE_TYPE_LOCALIZED (copy), t1 (copy), React (copy), FFlagAXMISWithOffers (copy), PurchaseItemsErrorStatusMap (copy), CatalogRowItemCard (copy), ItemCardThumbnail (copy), FFlagAXDurables2Option (copy), FFlagAXMISSmallUIChanges (copy), WearTimeSelectedOptionInList (copy), WearTimeOptionButton (copy)
	local v33 = Foundation.Hooks.useTokens()
	local v34 = p1.thumbnailSize or v33.Size.Size_2100
	local selectedTimedOptionPrice = nil
	local setSelectedTimedOptionPrice = nil

	if FFlagAXDurablesForMIS then
		local v37 = useCheckoutRowItemCardViewModel(p1)

		selectedTimedOptionPrice = v37.selectedTimedOptionPrice
		setSelectedTimedOptionPrice = v37.setSelectedTimedOptionPrice
	end

	local v38 = useLocalization(ASSET_TYPE_LOCALIZED)
	local v39 = useLocalization(BUNDLE_TYPE_LOCALIZED)
	local v40 = useLocalization(t1)
	local v41 = p1.itemType ~= Enum.AvatarItemType.Bundle.Name and "Asset" or "BundleThumbnail"
	local v42 = React.useMemo(function() -- line: 90
		-- upvalues: p1 (copy), ASSET_TYPE_LOCALIZED (copy), v38 (copy), BUNDLE_TYPE_LOCALIZED (copy), v39 (copy)
		local itemType = p1.itemType
		local itemSubType = p1.itemSubType

		if itemType == Enum.AvatarItemType.Asset.Name and ASSET_TYPE_LOCALIZED[tostring(itemSubType)] ~= nil then
			return v38[tostring(itemSubType)]
		end

		if itemType == Enum.AvatarItemType.Bundle.Name and BUNDLE_TYPE_LOCALIZED[tostring(itemSubType)] ~= nil then
			return v39[tostring(itemSubType)]
		end

		return ""
	end, {
		v38,
		v39,
		p1.itemType,
		p1.itemSubType
	})
	local v43 = React.useMemo(function() -- line: 103
		-- upvalues: p1 (copy), FFlagAXMISWithOffers (copy), PurchaseItemsErrorStatusMap (copy), v33 (copy), v40 (copy), t1 (copy)
		local t2 = {}

		if p1.status == nil then
			table.insert(t2, {
				type = "price",
				price = p1.priceInRobux,
				priceInRobuxDiscountedByOffers = if not FFlagAXMISWithOffers then nil else p1.priceInRobuxDiscountedByOffers
			})

			if p1.discountInformation and (not FFlagAXMISWithOffers or FFlagAXMISWithOffers and p1.discountInformation.totalDiscountAmount and p1.discountInformation.totalDiscountAmount > 0) then
				table.insert(t2, {
					type = "price",
					strikethrough = true,
					isOriginalPrice = true,
					price = p1.discountInformation.originalPrice,
					shouldShowOriginalPrice = if not FFlagAXMISWithOffers then nil else p1.priceInRobuxDiscountedByOffers ~= nil
				})

				return t2
			end
		elseif p1.status == PurchaseItemsErrorStatusMap.PRICE_MISMATCH then
			if not p1.priceMismatchMetadata then
				table.insert(t2, {
					type = "text",
					text = v40[tostring(PurchaseItemsErrorStatusMap.PRICE_MISMATCH)]
				})

				return t2
			end

			table.insert(t2, {
				type = "price",
				price = p1.priceInRobux,
				priceInRobuxDiscountedByOffers = if not FFlagAXMISWithOffers then nil else p1.priceInRobuxDiscountedByOffers,
				colorStyle = v33.Color.System.Warning
			})

			if not FFlagAXMISWithOffers or not p1.priceInRobuxDiscountedByOffers then
				table.insert(t2, {
					type = "price",
					strikethrough = true,
					price = p1.priceMismatchMetadata.oldPriceInRobux
				})

				return t2
			end
		else
			if p1.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED then
				table.insert(t2, {
					type = "text",
					text = v40[tostring(PurchaseItemsErrorStatusMap.ALREADY_OWNED)]
				})

				return t2
			end

			table.insert(t2, {
				type = "text",
				text = if not t1[tostring(p1.status)] then v40.Unvailable else v40[tostring(p1.status)],
				colorStyle = v33.Color.System.Warning
			})
		end

		return t2
	end, {
		p1.priceInRobux,
		p1.status,
		p1.priceMismatchMetadata,
		v40,
		v33,
		p1.discountInformation,
		if not FFlagAXMISWithOffers then nil else p1.priceInRobuxDiscountedByOffers
	})

	return React.createElement(Foundation.View, {
		tag = "auto-y row size-full-0 gap-small",
		LayoutOrder = p1.LayoutOrder,
		testId = `CheckoutRowItemCard-{ p1.itemId }`
	}, {
		RowItemCardContainer = React.createElement(Foundation.View, {
			tag = "auto-xy fill",
			LayoutOrder = 1
		}, {
			CatalogRowItemCard = React.createElement(CatalogRowItemCard, {
				title = p1.name,
				presentationSlot = React.createElement(ItemCardThumbnail, {
					url = `rbxthumb://type={ v41 }&id={ p1.itemId }&w=150&h=150`
				}),
				onActivated = p1.onActivated,
				onRemove = if not FFlagAXDurables2Option then nil else p1.onRemove,
				creator = if not FFlagAXMISSmallUIChanges then {
					name = p1.creatorName,
					verified = p1.creatorVerified
				} else nil,
				priceLineContent = v43,
				itemType = p1.itemRestriction,
				itemSubType = v42,
				timedOptions = if not FFlagAXDurablesForMIS then nil else p1.timedOptions,
				expirationTime = if not FFlagAXDurablesForMIS then nil else p1.expirationTime,
				isOwned = if not FFlagAXDurablesForMIS then nil else p1.isOwned,
				onTimedOptionPriceChanged = if not FFlagAXDurablesForMIS then nil else p1.onTimedOptionPriceChanged,
				selectedTimedOptionPrice = if not FFlagAXDurablesForMIS then nil else selectedTimedOptionPrice,
				setSelectedTimedOptionPrice = if not FFlagAXDurablesForMIS then nil else setSelectedTimedOptionPrice,
				selectedTimedOptionIndexInReducer = if not FFlagAXDurablesForMIS then nil else p1.selectedTimedOptionIndexInReducer,
				wearTimeSelectedOptionInList = if not FFlagAXDurablesForMIS then nil else WearTimeSelectedOptionInList,
				wearTimeOptionButton = if not FFlagAXDurables2Option then nil else WearTimeOptionButton,
				headerSize = UDim2.fromOffset(v34, v34),
				footerSize = UDim2.fromScale(0, 1),
				footerAutomaticSize = Enum.AutomaticSize.XY,
				AutomaticSize = Enum.AutomaticSize.XY
			})
		}),
		RightSlot = if FFlagAXDurables2Option then nil else React.createElement(Foundation.View, {
			tag = "auto-xy anchor-top-right self-center",
			LayoutOrder = 2
		}, {
			RemoveButton = if not p1.onRemove then nil else React.createElement(Foundation.IconButton, {
				icon = "x",
				isCircular = true,
				variant = Foundation.Enums.ButtonVariant.Standard,
				onActivated = p1.onRemove
			})
		})
	})
end

return React.memo(CheckoutRowItemCard, tutils.deepEqual)
