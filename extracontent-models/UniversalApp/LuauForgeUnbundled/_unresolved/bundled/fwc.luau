local CorePackages = game:GetService("CorePackages")

local generateStringId = require("@game/CorePackages/Workspace/Packages/AppCommonLib").GenerateStringId
local module = require("@luauforge/bundled/dNQ")
local module2 = require("@luauforge/bundled/dMx")
require("@luauforge/bundled/dMc")
local module3 = require("@luauforge/bundled/dOE")
local module4 = require("@luauforge/bundled/fuD")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local Cryo = require(CorePackages.Packages.Cryo)

local module6 = require("@luauforge/bundled/dOc")

local fFlagAXModeratedItemsFlow = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXModeratedItemsFlow
local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local fFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse
local fFlagAXModeratedItemIconUpdates = AvatarExperienceFlags.FFlagAXModeratedItemIconUpdates
local fFlagAXMigrateOutfitsToUserInventory = AvatarExperienceFlags.FFlagAXMigrateOutfitsToUserInventory
local fFlagAXBackgroundsOutfitPersistence = AvatarExperienceFlags.FFlagAXBackgroundsOutfitPersistence

local inventoryItemAvailability = require("@luauforge/bundled/fuM").Enums.InventoryItemAvailability

local v5 = {}

function v5.new()
	return {}
end

v5.MockPantsAssetId = "123"
v5.MockHatAssetId = "124"

function v5.mock()
	local v6 = v5.new()

	v6.outfitId = generateStringId()
	v6.name = ""
	v6.assets = {
		["66"] = {
			[v5.MockPantsAssetId] = {
				version = "1",
				order = 2,
				type = Enum.AccessoryType.Jacket,
				isLayered = true
			}
		},
		["8"] = {
			[v5.MockHatAssetId] = {
				version = "1",
				order = 1,
				type = Enum.AccessoryType.Hat,
				isLayered = true
			}
		}
	}

	v6.bodyColor3s = {
		headColor3 = module4.bodyColorToBodyColor3(194),
		leftArmColor3 = module4.bodyColorToBodyColor3(194),
		leftLegColor3 = module4.bodyColorToBodyColor3(194),
		rightArmColor3 = module4.bodyColorToBodyColor3(194),
		rightLegColor3 = module4.bodyColorToBodyColor3(194),
		torsoColor3 = module4.bodyColorToBodyColor3(194)
	}

	v6.scales = {
		height = 0,
		width = 0,
		head = 0,
		depth = 0,
		proportion = 0,
		bodyType = 0
	}

	v6.avatarType = module.AvatarType.R15
	v6.isEditable = true
	v6.updateCounter = 0
	v6.outfitType = "Avatar"

	if fFlagAXMigrateOutfitsToUserInventory then
		v6.receivedFromInventoryFetch = false
		v6.receivedFromGetOutfit = false
	end

	return v6
end

function v5.mockWithData(p2)
	local mock = v5.mock()
	return (Cryo.Dictionary.join(mock, p2))
end

function v5.fromWebApi(outfitId, value, data)
	local result = v5.new()

	result.containsDynamicHead = false

	local v6 = {}
	local v7 = fFlagAXModeratedItemsFlow and 0 or nil
	local v8 = fFlagAXInventoryDurablesSupport and 0 or nil
	local v9 = inventoryItemAvailability.Available

	if data.assets then
		for k, asset in data.assets do
			local id = tostring(asset.assetType.id)
			local id2 = tostring(asset.id)
			local supportsHeadShapes = if fFlagParseHeadShapeFromAPIResponse then asset.supportsHeadShapes else nil

			local v10 = v6[id] or {}
			v10[id2] = module3.fromMetadata(asset.meta, id)

			if fFlagParseHeadShapeFromAPIResponse then
				v10[id2].supportsHeadShapes = supportsHeadShapes
			end

			if fFlagAXModeratedItemsFlow then
				v10[id2].availabilityStatus = asset.availabilityStatus

				if
					asset.availabilityStatus == inventoryItemAvailability.Unavailable
					or asset.availabilityStatus == inventoryItemAvailability.Revoked
				then
					v7 += 1
				elseif
					fFlagAXInventoryDurablesSupport
					and asset.availabilityStatus == inventoryItemAvailability.Expired
				then
					v8 += 1
				end
			end

			if not fFlagAXModeratedItemsFlow then
				v10[id2].availabilityStatus = asset.availabilityStatus

				if
					fFlagAXInventoryDurablesSupport
					and asset.availabilityStatus == inventoryItemAvailability.Expired
				then
					v8 += 1
				end
			end

			v6[id] = v10

			if id == module2.AssetTypeIdStrings.DynamicHead then
				result.containsDynamicHead = true
			end
		end

		if fFlagAXModeratedItemsFlow then
			if v7 == #data.assets and (not fFlagAXModeratedItemIconUpdates or #data.assets > 0) then
				v9 = inventoryItemAvailability.Unavailable
			elseif
				fFlagAXInventoryDurablesSupport
				and v8 == #data.assets
				and (not fFlagAXModeratedItemIconUpdates or #data.assets > 0)
			then
				v9 = inventoryItemAvailability.Expired
			elseif v7 > 0 then
				v9 = inventoryItemAvailability.PartiallyAvailableWithUnavailableSubitems
			elseif fFlagAXInventoryDurablesSupport and v8 > 0 then
				v9 = inventoryItemAvailability.PartiallyAvailableWithExpiredSubitems
			end
		end

		if not fFlagAXModeratedItemsFlow then
			if fFlagAXInventoryDurablesSupport and v8 == #data.assets then
				v9 = inventoryItemAvailability.Expired
			elseif fFlagAXInventoryDurablesSupport and v8 > 0 then
				v9 = inventoryItemAvailability.PartiallyAvailableWithExpiredSubitems
			end
		end
	end

	result.outfitId = outfitId
	result.name = data.name
	result.assets = v6

	result.bodyColor3s = module4.convertBodyColor3HexesToColor3s(data.bodyColor3s)

	result.scales = data.scale
	result.avatarType = data.playerAvatarType
	result.isEditable = data.isEditable
	result.outfitType = data.outfitType
	local v10 = if module6() then data.inventoryType else nil
	result.inventoryType = v10
	local v11 = if data.universeId ~= 0 and data.universeId ~= nil then tostring(data.universeId) else nil
	result.creatingUniverseId = v11

	result.moderationStatus = data.moderationStatus
	result.availabilityStatus = v9
	result.bundleId = tostring(data.bundleId)

	if fFlagAXBackgroundsOutfitPersistence and data.profileConfiguration ~= nil then
		result.profileConfiguration = {
			BackgroundAssetId = data.profileConfiguration.backgroundAssetId
		}
	end

	result.updateCounter = value or 0

	if fFlagAXMigrateOutfitsToUserInventory then
		result.receivedFromInventoryFetch = false
		result.receivedFromGetOutfit = false
	end

	return result
end

return v5
