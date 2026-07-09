local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local CatalogItemCardStatusIconTypeEnum = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCardStatusIconTypeEnum
local ItemTypeEnum = AvatarExperienceCommon.Enums.ItemTypeEnum
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.Types)

local ItemStatus = AvatarExperienceCommon.Enums.ItemStatus
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXDurablesFooter = AvatarExperienceFlags.FFlagAXDurablesFooter
local FFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell

local function getLookStatusFromModerationStatus(s1: string?) -- line: 18
	-- upvalues: Constants (copy)
	if s1 == Constants.ModerationStatus.PendingModeration then
		return {
			type = "icon",
			iconType = "PendingModeration"
		}
	end

	if s1 == Constants.ModerationStatus.Moderated then
		return {
			type = "icon",
			iconType = "Moderated"
		}
	end

	return nil
end
local function showDurableBadge(p1) -- line: 27
	-- upvalues: FFlagAXDurablesFooter (copy), CatalogItemCardStatusIconTypeEnum (copy)
	if FFlagAXDurablesFooter then
		return nil
	end

	if not p1 or not p1.timedOptions then
		return nil
	end

	for _, v18 in p1.timedOptions do
		if v18.selected then
			return {
				type = "badge",
				iconType = CatalogItemCardStatusIconTypeEnum.Durable,
				text = not (v18.days > 0) and "" or tostring(v18.days)
			}
		end
	end

	return {
		type = "badge",
		text = "",
		iconType = CatalogItemCardStatusIconTypeEnum.Durable
	}
end
local function showFAEBadge(p2, t1: {[any]: any}?) -- line: 67
	-- upvalues: ItemStatus (copy)
	if not p2 or not p2.itemStatus then
		return false
	end

	if table.find(p2.itemStatus, ItemStatus.IsFAE) == nil then
		return false
	end

	if not t1 then
		return false
	end

	return t1.showFaeUpsell == true and t1.canClaimFaeItem == false
end
local function getItemCardStatus(p3, s2: string?, s3: string?, s4: string?, p4, t2: {[any]: any}?) -- line: 80
	-- upvalues: FFlagAXShowFaeUpsell (copy), ItemStatus (copy), CatalogItemCardStatusIconTypeEnum (copy), ItemTypeEnum (copy), getLookStatusFromModerationStatus (copy), showDurableBadge (copy)
	if p3 then
		return p3
	end

	if FFlagAXShowFaeUpsell and (not not p4 and if p4.itemStatus then table.find(p4.itemStatus, ItemStatus.IsFAE) ~= nil and if t2 then t2.showFaeUpsell == true and t2.canClaimFaeItem == false else false else false) then
		return {
			type = "badge",
			iconType = CatalogItemCardStatusIconTypeEnum.FAE
		}
	end

	if s2 == ItemTypeEnum.Look then
		return (getLookStatusFromModerationStatus(s3))
	end

	if s4 then
		return {
			type = "text",
			text = s4
		}
	end

	return (showDurableBadge(p4))
end

return getItemCardStatus
