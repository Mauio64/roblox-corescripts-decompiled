local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceUIKit = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit)
local CatalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail

local function OutfitSelectionGridItem(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), CatalogItemCard (copy), Foundation (copy), ItemCardThumbnail (copy)
	return React.createElement(CatalogItemCard, {
		Selectable = true,
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		isSelected = t1.isSelected,
		onActivated = t1.onActivated,
		title = t1.title,
		ref = t1.focusNavigationRef,
		presentationSlot = React.createElement(Foundation.View, {
			tag = "size-full radius-medium clip",
			ClipsDescendants = true,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1)
		}, {
			Thumbnail = if not t1.thumbnail then nil else React.createElement(ItemCardThumbnail, {
				url = t1.thumbnail
			})
		})
	})
end

return React.memo(OutfitSelectionGridItem)
