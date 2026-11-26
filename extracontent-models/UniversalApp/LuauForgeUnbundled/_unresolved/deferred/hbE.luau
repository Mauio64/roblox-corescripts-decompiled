local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module3 = require("@luauforge/deferred/gPt")

local catalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local itemCardThumbnail = module3.ItemCardComponents.ItemCardThumbnail

require("@luauforge/bundled/dPs")

local module4 = require("@luauforge/deferred/hbF")
local fFlagAXTestSkeletonInCatalog = AvatarExperienceFlags.FFlagAXTestSkeletonInCatalog

return (React.forwardRef(function(props, p2)
	local v5 = useTokens()

	local v6 = React.useMemo(function()
		if props.thumbnailUrl then
			return (React.createElement(itemCardThumbnail, {
				ref = props.thumbnailRef,
				tag = props.thumbnailTag,
				url = props.thumbnailUrl,
				onLoaded = props.onThumbnailLoaded,
				imageRect = props.thumbnailRect,
				inSkeletonExperiment = fFlagAXTestSkeletonInCatalog
			}))
		end

		return nil
	end, {
		props.thumbnailRef,
		props.thumbnailTag,
		props.inputBindings,
		props.thumbnailUrl,
		props.onThumbnailLoaded,
		props.thumbnailRect,
		v5.Radius.Medium
	})

	local createElement = React.createElement
	local fragment = React.Fragment
	local v9 = if props.animationTabsItemData then React.createElement(module4, {
		bundleInfo = props.animationTabsItemData,
		ZIndex = 2,
		paddingTop = UDim.new(0, v5.Gap.XSmall)
	}) else nil
	return createElement(fragment, nil, {
		AnimationTabs = v9,
		Tile = React.createElement(catalogItemCard, {
			ref = p2,
			onActivated = props.onActivated,
			onOverlayButtonActivated = props.onOverlayButtonActivated,
			overlayButtonText = props.overlayButtonText,
			presentationSlot = v6,
			priceLineContent = props.priceLineContent,
			creator = props.creator,
			title = props.title,
			itemType = props.itemType,
			itemInfo = props.itemInfo,
			itemStatus = props.itemStatus,
			itemLicensingInfo = props.itemLicensingInfo,
			headerAspectRatio = props.headerAspectRatio,
			headerSize = props.headerSize,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			isSelected = props.isSelected,
			backgroundLayers = props.backgroundLayers,
			imageScaleType = props.imageScaleType
		})
	})
end))
