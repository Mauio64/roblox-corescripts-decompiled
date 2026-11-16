local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
require(parent.AvatarExperienceUIKit)
local BuilderIcons = require(parent.BuilderIcons)

local CatalogItemCardItemTypeEnum = require(script.Parent.Enums.CatalogItemCardItemTypeEnum)
local CatalogItemCardItemInfoEnum = require(script.Parent.Enums.CatalogItemCardItemInfoEnum)
local CatalogItemCardStatusIconTypeEnum = require(script.Parent.Enums.CatalogItemCardStatusIconTypeEnum)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXModeratedItemIconUpdates = AvatarExperienceFlags.FFlagAXModeratedItemIconUpdates
local FFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell

local v = not FFlagAXModeratedItemIconUpdates and "icons/actions/info_small" or BuilderIcons.Icon.CircleI

local v2 = not FFlagAXModeratedItemIconUpdates and "icons/status/pending_small" or BuilderIcons.Icon.ClockDashed

local v3 = not FFlagAXModeratedItemIconUpdates and "icons/status/pending_small" or BuilderIcons.Icon.Clock
local v4 = not FFlagAXModeratedItemIconUpdates and "icons/actions/info_small" or BuilderIcons.Icon.CircleI
local v5

if FFlagAXShowFaeUpsell then
	v5 = not FFlagAXModeratedItemIconUpdates and "icons/status/private" or BuilderIcons.Icon.LockClosed
end

local v6 = not FFlagAXModeratedItemIconUpdates and "icons/status/warning_small" or BuilderIcons.Icon.CircleI

local v7 = not FFlagAXModeratedItemIconUpdates and "icons/status/error_large" or BuilderIcons.Icon.TriangleExclamation

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
	itemInfoIconMap = {
		[CatalogItemCardItemInfoEnum.DynamicHead] = "icons/menu/clothing/dynamicHead"
	},
	itemStatusIconTypeToIconMap = {
		[CatalogItemCardStatusIconTypeEnum.Moderated] = v,
		[CatalogItemCardStatusIconTypeEnum.PendingModeration] = v2,
		[CatalogItemCardStatusIconTypeEnum.Durable] = v3,
		[CatalogItemCardStatusIconTypeEnum.Info] = v4,
		[CatalogItemCardStatusIconTypeEnum.Unavailable] = v6,
		[CatalogItemCardStatusIconTypeEnum.Error] = v7,
		[CatalogItemCardStatusIconTypeEnum.FAE] = v5
	},
	rowItemStatusIconTypeToIconMap = {
		[CatalogItemCardStatusIconTypeEnum.Moderated] = v,
		[CatalogItemCardStatusIconTypeEnum.PendingModeration] = v2,
		[CatalogItemCardStatusIconTypeEnum.Unavailable] = v6,
		[CatalogItemCardStatusIconTypeEnum.Durable] = v3
	},
	MODERATED_ICON = v,
	PENDING_MODERATION_ICON = v2,
	DURABLE_ICON = v3,
	INFO_ICON = v4,
	FAE_ICON = v5,
	UNAVAILABLE_ICON = v6,
	ERROR_ICON = v7
}
