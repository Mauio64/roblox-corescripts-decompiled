local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceUIKit = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit)
local CatalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

local FFlagAXLookAndFeelBackgrounds = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXLookAndFeelBackgrounds
local CatalogItemCardAnimationIndicatorContainer = require(script.Parent.CatalogItemCardAnimationIndicatorContainer)

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 55
	-- upvalues: useTokens (copy), React (copy), ItemCardThumbnail (copy), CatalogItemCardAnimationIndicatorContainer (copy), CatalogItemCard (copy), FFlagAXLookAndFeelBackgrounds (copy)
	local v13 = useTokens()
	local v14 = React.useMemo(function() -- line: 59
		-- upvalues: t1 (copy), React (copy), ItemCardThumbnail (copy)
		if t1.thumbnailUrl then
			return (React.createElement(ItemCardThumbnail, {
				ref = t1.thumbnailRef,
				tag = t1.thumbnailTag,
				url = t1.thumbnailUrl,
				onLoaded = t1.onThumbnailLoaded,
				imageRect = t1.thumbnailRect
			}))
		end

		return nil
	end, {
		t1.thumbnailRef,
		t1.thumbnailTag,
		t1.inputBindings,
		t1.thumbnailUrl,
		t1.onThumbnailLoaded,
		t1.thumbnailRect,
		v13.Radius.Medium
	})

	return React.createElement(React.Fragment, nil, {
		AnimationTabs = if not t1.animationTabsItemData then nil else React.createElement(CatalogItemCardAnimationIndicatorContainer, {
			ZIndex = 2,
			bundleInfo = t1.animationTabsItemData,
			paddingTop = UDim.new(0, v13.Gap.XSmall)
		}),
		Tile = React.createElement(CatalogItemCard, {
			ref = p1,
			onActivated = t1.onActivated,
			onOverlayButtonActivated = t1.onOverlayButtonActivated,
			overlayButtonText = t1.overlayButtonText,
			presentationSlot = v14,
			priceLineContent = t1.priceLineContent,
			creator = t1.creator,
			title = t1.title,
			itemType = t1.itemType,
			itemInfo = t1.itemInfo,
			itemStatus = t1.itemStatus,
			headerAspectRatio = t1.headerAspectRatio,
			headerSize = t1.headerSize,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			isSelected = t1.isSelected,
			backgroundLayers = if not FFlagAXLookAndFeelBackgrounds then nil else t1.backgroundLayers,
			imageScaleType = if not FFlagAXLookAndFeelBackgrounds then nil else t1.imageScaleType
		})
	})
end))
