local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")

local catalogRowItemCard = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceCommon").Components.CatalogItemCard.CatalogRowItemCard
local itemCardThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceUIKit").ItemCardComponents.ItemCardThumbnail
local getPriceLineContent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceInspectAndBuy").Utils.getPriceLineContent

local view = Foundation.View
local checkbox = Foundation.Checkbox
local useTokens = Foundation.Hooks.useTokens
local inputSize = Foundation.Enums.InputSize

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization

local FFlagProfileInspectAvatarBuyAll = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileInspectAvatarBuyAll")

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local ItemDisplayHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/ItemDisplayHelpers")

local function CatalogItemRowCardContainer(props)
	local v5 = useTokens()
	local asset = props.asset
	local id = asset.id

	local v6 = useLocalization(ItemDisplayHelpers.shouldShowBundleParts(asset) and {
		bundleParts = {
			"Feature.Catalog.Label.UsingBundleParts",
			count = asset.bundlePartsCount
		}
	} or {})

	local thumbnailUrl = ItemDisplayHelpers.getThumbnailUrl(asset)

	local createElement = React.createElement
	local v8 = {
		tag = "row align-y-top gap-medium",
		Size = UDim2.new(1, 0, 0, props.rowHeight),
		LayoutOrder = props.index
	}
	local v10

	if not FFlagProfileInspectAvatarBuyAll then
		v10 = React.createElement(checkbox, {
			label = "",
			isChecked = props.isPurchasable and props.isChecked,
			isDisabled = not props.isPurchasable,
			size = inputSize.Small,
			onActivated = function(p2)
				props.onToggleItem(id)
			end,
			LayoutOrder = 1
		})
	end

	return createElement(view, v8, {
		ItemCheckbox = v10,
		ItemCard = React.createElement(view, {
			tag = "fill size-0-full",
			LayoutOrder = 2
		}, {
			Card = React.createElement(catalogRowItemCard, {
				title = asset.name,
				tag = "size-full",
				presentationSlot = React.createElement(itemCardThumbnail, {
					url = thumbnailUrl
				}),
				creator = asset.creator and asset.creator.creatorName and {
					name = asset.creator.creatorName,
					verified = asset.creator.creatorHasVerifiedBadge
				} or nil,
				itemSubType = ItemDisplayHelpers.getItemTypeDisplayName(asset, props.localizedStrings),
				bundlePartsText = v6.bundleParts,
				priceLineContent = getPriceLineContent(asset, v5, props.priceStatusLocalized, {
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
