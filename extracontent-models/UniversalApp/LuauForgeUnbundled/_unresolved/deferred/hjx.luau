local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module2 = require("@luauforge/deferred/gPt")
local catalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local itemCardThumbnail = module2.ItemCardComponents.ItemCardThumbnail

local function OutfitSelectionGridItem(props)
	local createElement = React.createElement
	local v6 = {
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		isSelected = props.isSelected,
		onActivated = props.onActivated,
		title = props.title,
		Selectable = true,
		ref = props.focusNavigationRef,
		presentationSlot = 0
	}
	local createElement2 = React.createElement
	local view = Foundation.View
	local v7 = {
		tag = "size-full radius-medium clip",
		Size = UDim2.fromScale(1, 1),
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v9 = if props.thumbnail then React.createElement(itemCardThumbnail, {
		url = props.thumbnail
	}) else nil
	v6.presentationSlot = createElement2(view, v7, { Thumbnail = v9 })
	return createElement(catalogItemCard, v6)
end

return React.memo(OutfitSelectionGridItem)
