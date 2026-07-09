local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GenerateStringId = require(CorePackages.Workspace.Packages.AppCommonLib).GenerateStringId
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.Types)

local AssetMetadata = require(Modules.AvatarExperience.Common.Models.AssetMetadata)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Cryo = require(CorePackages.Packages.Cryo)
local EngineFeature = game:GetEngineFeature("AESUseModerationStatusEnum")
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse
local FFlagAXEnableModeratedItemsFlowForDurables = AvatarExperienceFlags.FFlagAXEnableModeratedItemsFlowForDurables
local FFlagAXModeratedItemIconUpdates = AvatarExperienceFlags.FFlagAXModeratedItemIconUpdates
local FFlagAXBackgroundsOutfitPersistence = AvatarExperienceFlags.FFlagAXBackgroundsOutfitPersistence
local InventoryItemAvailability = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Enums.InventoryItemAvailability
local t1 = {
	new = function() -- line: 33
		return {}
	end,
	MockPantsAssetId = "123",
	MockHatAssetId = "124"
}
local t2 = {
	Approved = Enum.ModerationStatus.ReviewedApproved,
	Moderated = Enum.ModerationStatus.ReviewedRejected,
	Pending = Enum.ModerationStatus.NotReviewed,
	RequiresIntervention = Enum.ModerationStatus.NotReviewed,
	Invalid = Enum.ModerationStatus.Invalid
}

local function convertModerationStatus(p1) -- line: 51
	-- upvalues: EngineFeature (copy), t2 (copy)
	if EngineFeature then
		return p1
	end

	return t2[p1 or ""]
end

function t1.mock() -- line: 60
	-- upvalues: t1 (copy), GenerateStringId (copy), Utils (copy), Constants (copy)
	local v23 = t1.new()

	v23.outfitId = GenerateStringId()
	v23.name = ""
	v23.assets = {
		["66"] = {
			[t1.MockPantsAssetId] = {
				version = "1",
				order = 2,
				isLayered = true,
				type = Enum.AccessoryType.Jacket
			}
		},
		["8"] = {
			[t1.MockHatAssetId] = {
				version = "1",
				order = 1,
				isLayered = true,
				type = Enum.AccessoryType.Hat
			}
		}
	}
	v23.bodyColor3s = {
		headColor3 = Utils.bodyColorToBodyColor3(194),
		leftArmColor3 = Utils.bodyColorToBodyColor3(194),
		leftLegColor3 = Utils.bodyColorToBodyColor3(194),
		rightArmColor3 = Utils.bodyColorToBodyColor3(194),
		rightLegColor3 = Utils.bodyColorToBodyColor3(194),
		torsoColor3 = Utils.bodyColorToBodyColor3(194)
	}
	v23.scales = {
		height = 0,
		width = 0,
		head = 0,
		depth = 0,
		proportion = 0,
		bodyType = 0
	}
	v23.avatarType = Constants.AvatarType.R15
	v23.isEditable = true
	v23.updateCounter = 0
	v23.outfitType = "Avatar"

	return v23
end
function t1.mockWithData(t3: {[any]: any}) -- line: 110
	-- upvalues: t1 (copy), Cryo (copy)
	local v25 = t1.mock()

	return (Cryo.Dictionary.join(v25, t3))
end
function t1.fromWebApi(s1: string, n1: number?, p2) -- line: 118
	-- upvalues: t1 (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXInventoryDurablesSupport (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), InventoryItemAvailability (copy), FFlagParseHeadShapeFromAPIResponse (copy), AssetMetadata (copy), Constants2 (copy), FFlagAXModeratedItemIconUpdates (copy), Utils (copy), GetFFlagAXEnableSlotBasedEditor (copy), EngineFeature (copy), t2 (copy), FFlagAXBackgroundsOutfitPersistence (copy)
	local v29 = t1.new()

	v29.containsDynamicHead = false

	local t4 = {}
	local v31 = if not FFlagAXModeratedItemsFlow then nil else 0
	local v32 = if not FFlagAXInventoryDurablesSupport then nil else 0
	local v33 = if not FFlagAXModeratedItemsFlow and not FFlagAXEnableModeratedItemsFlowForDurables then nil else InventoryItemAvailability.Available

	if p2.assets then
		for _, v35 in p2.assets do
			local str = tostring(v35.assetType.id)
			local str2 = tostring(v35.id)
			local v38 = if not FFlagParseHeadShapeFromAPIResponse then nil else v35.supportsHeadShapes
			local v39 = t4[str] or {}

			v39[str2] = AssetMetadata.fromMetadata(v35.meta, str)

			if FFlagParseHeadShapeFromAPIResponse then
				v39[str2].supportsHeadShapes = v38
			end

			if FFlagAXModeratedItemsFlow then
				v39[str2].availabilityStatus = v35.availabilityStatus

				if v35.availabilityStatus == InventoryItemAvailability.Unavailable or v35.availabilityStatus == InventoryItemAvailability.Revoked then
					v31 += 1
				elseif FFlagAXInventoryDurablesSupport and v35.availabilityStatus == InventoryItemAvailability.Expired then
					v32 += 1
				end
			end

			if FFlagAXEnableModeratedItemsFlowForDurables and not FFlagAXModeratedItemsFlow then
				v39[str2].availabilityStatus = v35.availabilityStatus

				if FFlagAXInventoryDurablesSupport and v35.availabilityStatus == InventoryItemAvailability.Expired then
					v32 += 1
				end
			end

			t4[str] = v39

			if str == Constants2.AssetTypeIdStrings.DynamicHead then
				v29.containsDynamicHead = true
			end
		end

		if FFlagAXModeratedItemsFlow then
			if v31 == #p2.assets and (not FFlagAXModeratedItemIconUpdates or #p2.assets > 0) then
				v33 = InventoryItemAvailability.Unavailable
			elseif FFlagAXInventoryDurablesSupport and v32 == #p2.assets and (not FFlagAXModeratedItemIconUpdates or #p2.assets > 0) then
				v33 = InventoryItemAvailability.Expired
			elseif v31 > 0 then
				v33 = InventoryItemAvailability.PartiallyAvailableWithUnavailableSubitems
			elseif FFlagAXInventoryDurablesSupport and v32 > 0 then
				v33 = InventoryItemAvailability.PartiallyAvailableWithExpiredSubitems
			end
		end

		if FFlagAXEnableModeratedItemsFlowForDurables and not FFlagAXModeratedItemsFlow then
			if FFlagAXInventoryDurablesSupport and v32 == #p2.assets then
				v33 = InventoryItemAvailability.Expired
			elseif FFlagAXInventoryDurablesSupport and v32 > 0 then
				v33 = InventoryItemAvailability.PartiallyAvailableWithExpiredSubitems
			end
		end
	end

	v29.outfitId = s1
	v29.name = p2.name
	v29.assets = t4
	v29.bodyColor3s = Utils.convertBodyColor3HexesToColor3s(p2.bodyColor3s)
	v29.scales = p2.scale
	v29.avatarType = p2.playerAvatarType
	v29.isEditable = p2.isEditable
	v29.outfitType = p2.outfitType
	v29.inventoryType = if not GetFFlagAXEnableSlotBasedEditor() then nil else p2.inventoryType
	v29.creatingUniverseId = if p2.universeId == 0 or p2.universeId == nil then nil else tostring(p2.universeId)

	local moderationStatus = p2.moderationStatus

	v29.moderationStatus = if not EngineFeature then t2[moderationStatus or ""] else moderationStatus
	v29.availabilityStatus = if not FFlagAXModeratedItemsFlow and not FFlagAXEnableModeratedItemsFlowForDurables then nil else v33
	v29.bundleId = tostring(p2.bundleId)

	if FFlagAXBackgroundsOutfitPersistence and p2.profileConfiguration ~= nil then
		v29.profileConfiguration = {
			BackgroundAssetId = p2.profileConfiguration.backgroundAssetId
		}
	end

	v29.updateCounter = n1 or 0

	return v29
end

return t1
