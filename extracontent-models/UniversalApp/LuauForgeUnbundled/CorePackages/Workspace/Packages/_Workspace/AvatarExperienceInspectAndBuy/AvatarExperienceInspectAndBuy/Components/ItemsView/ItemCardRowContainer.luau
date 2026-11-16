local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceCommon")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local useItemCardRowProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/useItemCardRowProps")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/ViewType")

local catalogRowItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogRowItemCard

return function(props)
	local v5 = useItemCardRowProps(
		props.item,
		props.LayoutOrder,
		props.view,
		props.onItemCardActivated,
		props.itemCardWidth
	)
	return React.createElement(catalogRowItemCard, v5)
end
