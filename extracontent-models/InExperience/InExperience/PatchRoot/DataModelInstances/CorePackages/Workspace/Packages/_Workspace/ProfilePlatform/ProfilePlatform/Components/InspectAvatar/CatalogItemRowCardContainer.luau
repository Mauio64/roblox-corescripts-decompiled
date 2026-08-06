local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local CatalogRowItemCard = require(ProfilePlatformParent.AvatarExperienceCommon).Components.CatalogItemCard.CatalogRowItemCard
local ItemCardThumbnail = require(ProfilePlatformParent.AvatarExperienceUIKit).ItemCardComponents.ItemCardThumbnail
local getPriceLineContent = require(ProfilePlatformParent.AvatarExperienceInspectAndBuy).Utils.getPriceLineContent
local View = Foundation.View
local Checkbox = Foundation.Checkbox
local useTokens = Foundation.Hooks.useTokens
local InputSize = Foundation.Enums.InputSize
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local FFlagProfileInspectAvatarBuyAll = require(ProfilePlatform.Flags.FFlagProfileInspectAvatarBuyAll)

require(ProfilePlatform.Common.Types)

local ItemDisplayHelpers = require(script.Parent.ItemDisplayHelpers)

local function CatalogItemRowCardContainer(t1: {[any]: any}) -- line: 41
	-- upvalues: useTokens (copy), ItemDisplayHelpers (copy), useLocalization (copy), React (copy), View (copy), FFlagProfileInspectAvatarBuyAll (copy), Checkbox (copy), InputSize (copy), CatalogRowItemCard (copy), ItemCardThumbnail (copy), getPriceLineContent (copy)
	local v17 = useTokens()
	local asset = t1.asset
	local id = asset.id
	local v20 = ItemDisplayHelpers.shouldShowBundleParts(asset)
	local v21 = useLocalization(if not v20 then {} else {
		bundleParts = {
			"Feature.Catalog.Label.UsingBundleParts",
			count = asset.bundlePartsCount
		}
	})
	local v22 = ItemDisplayHelpers.getThumbnailUrl(asset)

	return React.createElement(View, {
		tag = "row align-y-top gap-medium",
		Size = UDim2.new(1, 0, 0, t1.rowHeight),
		LayoutOrder = t1.index
	}, {
		ItemCheckbox = if not FFlagProfileInspectAvatarBuyAll then React.createElement(Checkbox, {
			label = "",
			LayoutOrder = 1,
			isChecked = t1.isPurchasable and t1.isChecked,
			isDisabled = not t1.isPurchasable,
			size = InputSize.Small,
			onActivated = function(_: boolean) -- line: 70
				-- upvalues: t1 (copy), id (copy)
				t1.onToggleItem(id)
			end
		}) else nil,
		ItemCard = React.createElement(View, {
			tag = "fill size-0-full",
			LayoutOrder = 2
		}, {
			Card = React.createElement(CatalogRowItemCard, {
				tag = "size-full",
				title = asset.name,
				presentationSlot = React.createElement(ItemCardThumbnail, {
					url = v22
				}),
				creator = if not asset.creator or not asset.creator.creatorName then nil else {
					name = asset.creator.creatorName,
					verified = asset.creator.creatorHasVerifiedBadge
				},
				itemSubType = ItemDisplayHelpers.getItemTypeDisplayName(asset, t1.localizedStrings),
				bundlePartsText = v21.bundleParts,
				priceLineContent = getPriceLineContent(asset, v17, t1.priceStatusLocalized, {
					isShopContext = true
				}),
				headerSize = UDim2.fromOffset(t1.rowHeight, t1.rowHeight),
				footerSize = UDim2.fromScale(0, 1),
				footerAutomaticSize = Enum.AutomaticSize.X,
				onActivated = function() -- line: 99
					-- upvalues: t1 (copy), id (copy), asset (copy)
					t1.openItemDetails(id, asset.itemType or "Asset", t1.index)
				end
			})
		})
	})
end

return CatalogItemRowCardContainer
