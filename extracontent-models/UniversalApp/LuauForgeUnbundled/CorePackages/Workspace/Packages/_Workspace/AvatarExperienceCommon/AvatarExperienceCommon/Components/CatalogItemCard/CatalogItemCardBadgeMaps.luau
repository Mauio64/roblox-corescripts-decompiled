require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceUIKit")
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/BuilderIcons")

local CatalogItemCardItemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/Enums/CatalogItemCardItemTypeEnum")
local CatalogItemCardItemInfoEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/Enums/CatalogItemCardItemInfoEnum")
local CatalogItemCardStatusIconTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/CatalogItemCard/Enums/CatalogItemCardStatusIconTypeEnum")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")
local fFlagAXModeratedItemIconUpdates = AvatarExperienceFlags.FFlagAXModeratedItemIconUpdates
local fFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell

local v5 = not fFlagAXModeratedItemIconUpdates and "icons/actions/info_small" or BuilderIcons.Icon.CircleI

local v6 = not fFlagAXModeratedItemIconUpdates and "icons/status/pending_small" or BuilderIcons.Icon.ClockDashed

local v7 = not fFlagAXModeratedItemIconUpdates and "icons/status/pending_small" or BuilderIcons.Icon.Clock
local v8 = not fFlagAXModeratedItemIconUpdates and "icons/actions/info_small" or BuilderIcons.Icon.CircleI
local v9

if fFlagAXShowFaeUpsell then
	v9 = not fFlagAXModeratedItemIconUpdates and "icons/status/private" or BuilderIcons.Icon.LockClosed
end

local v10 = not fFlagAXModeratedItemIconUpdates and "icons/status/warning_small" or BuilderIcons.Icon.CircleI

local v11 = not fFlagAXModeratedItemIconUpdates and "icons/status/error_large"
	or BuilderIcons.Icon.TriangleExclamation

return {
	itemTypeToContentMap = {
		[CatalogItemCardItemTypeEnum.Limited] = {
			{ type = "icon", icon = "icons/status/item/limited" }
		},
		[CatalogItemCardItemTypeEnum.Collectible] = {
			{ type = "icon", icon = "icons/status/item/limited" },
			{ type = "text", text = "#" }
		}
	},
	itemInfoIconMap = { [CatalogItemCardItemInfoEnum.DynamicHead] = "icons/menu/clothing/dynamicHead" },
	itemStatusIconTypeToIconMap = {
		[CatalogItemCardStatusIconTypeEnum.Moderated] = v5,
		[CatalogItemCardStatusIconTypeEnum.PendingModeration] = v6,
		[CatalogItemCardStatusIconTypeEnum.Durable] = v7,
		[CatalogItemCardStatusIconTypeEnum.Info] = v8,
		[CatalogItemCardStatusIconTypeEnum.Unavailable] = v10,
		[CatalogItemCardStatusIconTypeEnum.Error] = v11,
		[CatalogItemCardStatusIconTypeEnum.FAE] = v9
	},
	rowItemStatusIconTypeToIconMap = {
		[CatalogItemCardStatusIconTypeEnum.Moderated] = v5,
		[CatalogItemCardStatusIconTypeEnum.PendingModeration] = v6,
		[CatalogItemCardStatusIconTypeEnum.Unavailable] = v10,
		[CatalogItemCardStatusIconTypeEnum.Durable] = v7
	},
	MODERATED_ICON = v5,
	PENDING_MODERATION_ICON = v6,
	DURABLE_ICON = v7,
	INFO_ICON = v8,
	FAE_ICON = v9,
	UNAVAILABLE_ICON = v10,
	ERROR_ICON = v11
}
