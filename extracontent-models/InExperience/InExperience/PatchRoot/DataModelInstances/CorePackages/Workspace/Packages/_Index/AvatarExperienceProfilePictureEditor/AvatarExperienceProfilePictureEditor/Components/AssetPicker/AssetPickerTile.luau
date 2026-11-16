local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)

local View = Foundation.View
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local CatalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail

local function buildPresentationSlot(iconName, image: string?)
	local content = nil
	local alignxcenteralignycentersizefullpaddingsmall = false

	if iconName then
		content = React.createElement(Icon, { name = iconName, size = IconSize.Large })
		alignxcenteralignycentersizefullpaddingsmall = true
	elseif image then
		content = React.createElement(ItemCardThumbnail, { url = image })
	end

	if content == nil then
		return nil
	end

	return React.createElement(View, {
		tag = {
			["align-x-center align-y-center size-full padding-small"] = alignxcenteralignycentersizefullpaddingsmall,
			["size-full padding-small"] = not alignxcenteralignycentersizefullpaddingsmall
		}
	}, { Content = content })
end

local function AssetPickerTile(props)
	local item = props.item
	local isSelected = item.id == props.selectedId
	local onDetailsActivated = props.onDetailsActivated
	local v = isSelected and onDetailsActivated ~= nil
	local createElement = React.createElement
	local v2 = {
		title = item.label,
		presentationSlot = buildPresentationSlot(item.iconName, item.image),
		priceLineContent = item.priceLineContent,
		isSelected = isSelected,
		onActivated = function()
			props.onSelect(item.id)
		end,
		onOverlayButtonActivated = v and onDetailsActivated and function()
			onDetailsActivated(item.id)
		end or nil,
		overlayButtonText = 0,
		headerAspectRatio = 1,
		Size = 0,
		AutomaticSize = 0,
		LayoutOrder = 0
	}
	local overlayButtonText

	if v then
		overlayButtonText = props.labels.details
	end

	v2.overlayButtonText = overlayButtonText

	v2.Size = UDim2.fromScale(1, 0)
	v2.AutomaticSize = Enum.AutomaticSize.Y
	v2.LayoutOrder = props.layoutOrder
	return createElement(CatalogItemCard, v2)
end

return AssetPickerTile
