local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module2 = require("@luauforge/bundled/dMd")

local catalogItemCardStatusIconTypeEnum = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCardStatusIconTypeEnum
local itemTypeEnum = module2.Enums.ItemTypeEnum
local module3 = require("@luauforge/bundled/dMx")
require("@luauforge/bundled/dMc")
local itemStatus = AvatarExperienceCommon.Enums.ItemStatus

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXDurablesFooter = AvatarExperienceFlags.FFlagAXDurablesFooter
local fFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell

local function getLookStatusFromModerationStatus(p2)
	if p2 == module3.ModerationStatus.PendingModeration then
		return { type = "icon", iconType = "PendingModeration" }
	end

	if p2 == module3.ModerationStatus.Moderated then
		return { type = "icon", iconType = "Moderated" }
	end

	return nil
end

local function showDurableBadge(p2)
	if fFlagAXDurablesFooter or not (p2 and p2.timedOptions) then
		return nil
	end

	for k, timedOption in p2.timedOptions do
		if timedOption.selected then
			return {
				type = "badge",
				iconType = catalogItemCardStatusIconTypeEnum.Durable,
				text = not (timedOption.days > 0) and "" or tostring(timedOption.days)
			}
		end
	end

	return {
		type = "badge",
		iconType = catalogItemCardStatusIconTypeEnum.Durable,
		text = ""
	}
end

local function showFAEBadge(p2, p3): boolean
	if not (p2 and p2.itemStatus and table.find(p2.itemStatus, itemStatus.IsFAE) ~= nil and p3) then
		return false
	end

	return p3.showFaeUpsell == true and p3.canClaimFaeItem == false
end

local function getItemCardStatus(p2, p3, p4, p5, p6, p7)
	if p2 then
		return p2
	end

	if fFlagAXShowFaeUpsell then
		local v5

		if
			p6
			and p6.itemStatus
			and table.find(p6.itemStatus, itemStatus.IsFAE) ~= nil
			and p7
			and p7.showFaeUpsell == true
		then
			v5 = p7.canClaimFaeItem == false
		else
			v5 = false
		end

		if v5 then
			return { type = "badge", iconType = catalogItemCardStatusIconTypeEnum.FAE }
		end
	end

	if p3 == itemTypeEnum.Look then
		return getLookStatusFromModerationStatus(p4)
	end

	if p5 then
		return { type = "text", text = p5 }
	end

	return showDurableBadge(p6)
end

return getItemCardStatus
