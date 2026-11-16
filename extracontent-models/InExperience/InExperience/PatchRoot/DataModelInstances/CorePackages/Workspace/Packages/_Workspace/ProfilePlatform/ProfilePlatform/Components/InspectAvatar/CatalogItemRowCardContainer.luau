local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local CatalogRowItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogRowItemCard
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail
local AvatarExperienceInspectAndBuy = require(parent.AvatarExperienceInspectAndBuy)
local getPriceLineContent = AvatarExperienceInspectAndBuy.Utils.getPriceLineContent

local View = Foundation.View
local Checkbox = Foundation.Checkbox
local useTokens = Foundation.Hooks.useTokens
local InputSize = Foundation.Enums.InputSize

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local FFlagProfileInspectAvatarBuyAll = require(ProfilePlatform.Flags.FFlagProfileInspectAvatarBuyAll)

require(ProfilePlatform.Common.Types)
local ItemDisplayHelpers = require(script.Parent.ItemDisplayHelpers)

local function CatalogItemRowCardContainer(props)
	local v = useTokens()
	local asset = props.asset
	local id = asset.id

	local v2 = useLocalization(ItemDisplayHelpers.shouldShowBundleParts(asset) and {
		bundleParts = {
			"Feature.Catalog.Label.UsingBundleParts",
			count = asset.bundlePartsCount
		}
	} or {})

	local thumbnailUrl = ItemDisplayHelpers.getThumbnailUrl(asset)

	local createElement = React.createElement
	local v3 = {
		tag = "row align-y-top gap-medium",
		Size = UDim2.new(1, 0, 0, props.rowHeight),
		LayoutOrder = props.index
	}
	local itemCheckbox

	if not FFlagProfileInspectAvatarBuyAll then
		itemCheckbox = React.createElement(Checkbox, {
			label = "",
			isChecked = props.isPurchasable and props.isChecked,
			isDisabled = not props.isPurchasable,
			size = InputSize.Small,
			onActivated = function(_: boolean)
				props.onToggleItem(id)
			end,
			LayoutOrder = 1
		})
	end

	return createElement(View, v3, {
		ItemCheckbox = itemCheckbox,
		ItemCard = React.createElement(View, { tag = "fill size-0-full", LayoutOrder = 2 }, {
			Card = React.createElement(CatalogRowItemCard, {
				title = asset.name,
				tag = "size-full",
				presentationSlot = React.createElement(ItemCardThumbnail, { url = thumbnailUrl }),
				creator = asset.creator and asset.creator.creatorName and {
					name = asset.creator.creatorName,
					verified = asset.creator.creatorHasVerifiedBadge
				} or nil,
				itemSubType = ItemDisplayHelpers.getItemTypeDisplayName(asset, props.localizedStrings),
				bundlePartsText = v2.bundleParts,
				priceLineContent = getPriceLineContent(asset, v, props.priceStatusLocalized, {
					isShopContext = true
				}),
				headerSize = UDim2.fromOffset(props.rowHeight, props.rowHeight),
				footerSize = UDim2.fromScale(0, 1),
				footerAutomaticSize = Enum.AutomaticSize.X,
				onActivated = function()
					props.openItemDetails(id, asset.itemType or "Asset", props.index)
				end
			})
		})
	})
end

return CatalogItemRowCardContainer
