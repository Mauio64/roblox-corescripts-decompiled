local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local SquareCollectionGridView = require(ProfilePlatform.BaseComponents.CollectionGridViews.SquareCollectionGridView)
local CatalogItemCard = require(ProfilePlatformParent.AvatarExperienceCommon).Components.CatalogItemCard.CatalogItemCard
local ItemCardThumbnail = require(ProfilePlatformParent.AvatarExperienceUIKit).ItemCardComponents.ItemCardThumbnail
local Enums = require(ProfilePlatform.Common.Enums)
local UserLib = require(ProfilePlatformParent.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

require(ProfilePlatform.Common.AssetInfo)

local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local FFlagProfileStoreEnableFreeItemPriceLabelFix = require(ProfilePlatform.Flags.FFlagProfileStoreEnableFreeItemPriceLabelFix)
local Asset = Constants.RbxthumbTypes.Asset
local BundleThumbnail = Constants.RbxthumbTypes.BundleThumbnail

local function v16(n1: number) -- line: 37
	return n1 + 49
end
local function StoreGrid(t1: {[any]: any}) -- line: 41
	-- upvalues: useLocalization (copy), TextKeys (copy), React (copy), Enums (copy), BundleThumbnail (copy), Asset (copy), FFlagProfileStoreEnableFreeItemPriceLabelFix (copy), CatalogItemCard (copy), ItemCardThumbnail (copy), getRbxthumbWithTypeSizeAndOptions (copy), SquareCollectionGridView (copy), v16 (copy)
	local v20 = useLocalization({
		store = TextKeys.Store,
		free = TextKeys.CatalogLabelFree
	})
	local v21 = React.useCallback(function(p1, n2: number) -- line: 47
		-- upvalues: Enums (copy), BundleThumbnail (copy), Asset (copy), FFlagProfileStoreEnableFreeItemPriceLabelFix (copy), v20 (copy), React (copy), CatalogItemCard (copy), ItemCardThumbnail (copy), getRbxthumbWithTypeSizeAndOptions (copy), t1 (copy)
		local v24 = if p1.itemType ~= Enums.ItemTypes.Bundle then Asset else BundleThumbnail
		local v25 = p1.price and {
			type = Enums.PriceLineContentType.Price,
			price = p1.price
		}

		if FFlagProfileStoreEnableFreeItemPriceLabelFix and (p1.price and p1.price == 0) then
			v25 = {
				type = Enums.PriceLineContentType.Text,
				text = v20.free
			}
		end

		return React.createElement(CatalogItemCard, {
			LayoutOrder = n2,
			title = p1.name,
			presentationSlot = React.createElement(ItemCardThumbnail, {
				url = getRbxthumbWithTypeSizeAndOptions(p1.id, v24, 150)
			}),
			onActivated = function() -- line: 69
				-- upvalues: t1 (copy), p1 (copy), n2 (copy)
				t1.openItemDetails(p1.id, p1.itemType, n2)
			end,
			priceLineContent = if not FFlagProfileStoreEnableFreeItemPriceLabelFix then p1.price and {
				type = Enums.PriceLineContentType.Price,
				price = p1.price
			} else v25,
			AutomaticSize = Enum.AutomaticSize.Y
		}), "ItemCard"
	end, { t1.openItemDetails })

	return React.createElement(SquareCollectionGridView, {
		layoutOrder = t1.layoutOrder,
		items = t1.assets,
		renderItem = v21,
		getItemHeight = v16,
		title = v20.store,
		onActivateHeader = t1.navigateToCatalogSearch,
		overrides = {
			numColumns = t1.numColumns or 3
		}
	})
end

return StoreGrid
