local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AvatarExperienceCommon")
local AvatarExperienceUIKit = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AvatarExperienceUIKit")

local view = Foundation.View
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local catalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local itemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail

local function buildPresentationSlot(iconName, image)
	local v5 = nil
	local v6 = false

	if iconName then
		v5 = React.createElement(icon, { name = iconName, size = iconSize.Large })
		v6 = true
	elseif image then
		v5 = React.createElement(itemCardThumbnail, { url = image })
	end

	if v5 == nil then
		return nil
	end

	return React.createElement(view, {
		tag = {
			["align-x-center align-y-center size-full padding-small"] = v6,
			["size-full padding-small"] = not v6
		}
	}, { Content = v5 })
end

local function AssetPickerTile(props)
	local item = props.item
	local v5 = item.id == props.selectedId
	local onDetailsActivated = props.onDetailsActivated
	local v6 = v5 and onDetailsActivated ~= nil
	local createElement = React.createElement
	local v8 = {
		title = item.label,
		presentationSlot = buildPresentationSlot(item.iconName, item.image),
		priceLineContent = item.priceLineContent,
		isSelected = v5,
		onActivated = function()
			props.onSelect(item.id)
		end,
		onOverlayButtonActivated = v6 and onDetailsActivated and function()
			onDetailsActivated(item.id)
		end or nil,
		overlayButtonText = 0,
		headerAspectRatio = 1,
		Size = 0,
		AutomaticSize = 0,
		LayoutOrder = 0
	}

	local v9 = if v6 then props.labels.details else nil
	v8.overlayButtonText = v9

	v8.Size = UDim2.fromScale(1, 0)
	v8.AutomaticSize = Enum.AutomaticSize.Y
	v8.LayoutOrder = props.layoutOrder
	return createElement(catalogItemCard, v8)
end

return AssetPickerTile
