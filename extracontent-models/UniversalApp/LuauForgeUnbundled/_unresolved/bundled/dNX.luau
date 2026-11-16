local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
require("@luauforge/bundled/dHL")

local module = require("@luauforge/bundled/dNY")
local SetTryingOnInfo = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Actions/SetTryingOnInfo")
local module3 = require("@luauforge/bundled/dNZ")
local module4 = require("@luauforge/bundled/dOa")
local module5 = require("@luauforge/bundled/dOd")
local module6 = require("@luauforge/bundled/dOe")
local module7 = require("@luauforge/bundled/dOf")
local module8 = require("@luauforge/bundled/dOg")
local module9 = require("@luauforge/bundled/dOh")
require("@luauforge/bundled/dMc")

local module10 = require("@luauforge/bundled/dMx")
local module11 = require("@luauforge/bundled/dNQ")

local avatarEditorCategories = require("@luauforge/bundled/dMd").Enums.AvatarEditorCategories

local avatarEditorSubcategories = require("@luauforge/bundled/dMd").Enums.AvatarEditorSubcategories
local module12 = require("@luauforge/bundled/dOi")

local fFlagAXOutfitPageRevamp = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXOutfitPageRevamp

local fFlagAXMigrateOutfitsToUserInventory = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMigrateOutfitsToUserInventory

local function GetAssetTypeToSearchUuids()
	return module12().AssetTypeToSearchUuids
end

return Rodux.createReducer({}, {
	[module.name] = function(p2, p3)
		local itemIds = p2[p3.itemSubType] and p2[p3.itemSubType] or {}
		local v6 = {}

		for k, v7 in itemIds do
			v6[v7] = v7
		end

		for k, itemId in p3.itemIds do
			if v6[itemId] then
				continue
			end

			itemIds[#itemIds + 1] = itemId

			v6[itemId] = itemId
		end

		return Cryo.Dictionary.join(p2, { [p3.itemSubType] = itemIds })
	end,
	[SetTryingOnInfo.name] = function(p2, p3)
		local v6 = {}

		local assetTypeId = tostring(p3.assetTypeId)
		local assetId = tostring(p3.assetId)
		local assetTypeToSearchUuid = module12().AssetTypeToSearchUuids[assetTypeId]

		if not assetTypeToSearchUuid then
			return p2
		end

		for k, v7 in assetTypeToSearchUuid do
			local v8 = { assetId }
			local v9 = false

			for k2, v11 in p2[v7] and p2[v7] or {} do
				if v11 == assetId then
					v9 = true
					break
				end

				v8[k2 + 1] = v11
			end

			if not v9 then
				v6[v7] = v8
			end
		end

		if next(v6) then
			return Cryo.Dictionary.join(p2, v6)
		end

		return p2
	end,
	[module3.name] = function(p2, p3)
		local v6 = {}

		local assetTypeId = tostring(p3.assetTypeId)
		local assetId = tostring(p3.assetId)
		local assetTypeToSearchUuid = module12().AssetTypeToSearchUuids[assetTypeId]

		if not assetTypeToSearchUuid then
			return p2
		end

		for k, v7 in assetTypeToSearchUuid do
			local v8 = p2[v7] and p2[v7] or {}
			local v9 = Cryo.List.removeValue(v8, assetId)

			if #v8 ~= #v9 then
				v6[v7] = v9
			end
		end

		if next(v6) then
			return Cryo.Dictionary.join(p2, v6)
		end

		return p2
	end,
	[module7.name] = function(p2, p3)
		local outfitId = tostring(p3.outfitId)
		local outfitTypeId = p3.outfitTypeId

		local v6 = { outfitId }

		for k, v7 in p2[outfitTypeId] or {} do
			if v7 == outfitId then
				return p2
			end

			table.insert(v6, v7)
		end

		return Cryo.Dictionary.join(p2, { [outfitTypeId] = v6 })
	end,
	[module4.name] = function(p2, p3)
		local outfitId = tostring(p3.outfitId)

		local v6 = { outfitId }

		for k, v7 in p2[module11.CharacterKey] or {} do
			if v7 == outfitId then
				return p2
			end

			v6[k + 1] = v7
		end

		return Cryo.Dictionary.join(p2, { [module11.CharacterKey] = v6 })
	end,
	[module5.name] = function(p2, p3)
		local outfitId = tostring(p3.outfitId)
		local v6

		if fFlagAXMigrateOutfitsToUserInventory then
			v6 = avatarEditorCategories.Avatars
		else
			v6 = module11.EditableCharacterKey
		end

		local v7 = { outfitId }

		for k, v8 in p2[v6] or {} do
			if v8 == outfitId then
				return p2
			end

			v7[k + 1] = v8
		end

		local join = Cryo.Dictionary.join
		local v9

		if fFlagAXMigrateOutfitsToUserInventory then
			v9 = avatarEditorCategories.Avatars
		else
			v9 = module11.EditableCharacterKey
		end

		return join(p2, { [v9] = v7 })
	end,
	[module6.name] = function(p2, p3)
		local outfitId = tostring(p3.outfitId)

		local v6 = { outfitId }

		for k, v7 in p2[module11.PurchasedCharacterKey] or {} do
			if v7 == outfitId then
				return p2
			end

			v6[k + 1] = v7
		end

		return Cryo.Dictionary.join(p2, { [module11.PurchasedCharacterKey] = v6 })
	end,
	[module9.name] = function(p2, data)
		local outfitId = tostring(data.outfitId)

		if data.outfitType == module10.OutfitTypes.Makeup then
			local v6 = if fFlagAXMigrateOutfitsToUserInventory then avatarEditorSubcategories.MakeupLooks else module11.MakeupOutfitKey
			local v7 = p2[v6] or {}
			local joined = Cryo.List.join({ outfitId }, Cryo.List.removeValue(v7, outfitId))

			local join = Cryo.Dictionary.join
			local v8

			if fFlagAXMigrateOutfitsToUserInventory then
				v8 = avatarEditorSubcategories.MakeupLooks
			else
				v8 = module11.MakeupOutfitKey
			end

			return join(p2, { [v8] = joined })
		else
			local v6 = p2[module11.CharacterKey] or {}

			local v7 = if fFlagAXMigrateOutfitsToUserInventory then avatarEditorCategories.Avatars else module11.EditableCharacterKey
			local v8 = p2[v7] or {}

			if data.isEditable then
				v8 = Cryo.List.join({ outfitId }, Cryo.List.removeValue(v8, outfitId))
			else
				v6 = Cryo.List.join({ outfitId }, Cryo.List.removeValue(v6, outfitId))
			end

			local join = Cryo.Dictionary.join
			local v9 = { [module11.CharacterKey] = v6 }
			local v10

			if fFlagAXMigrateOutfitsToUserInventory then
				v10 = avatarEditorCategories.Avatars
			else
				v10 = module11.EditableCharacterKey
			end

			v9[v10] = v8
			return join(p2, v9)
		end
	end,
	[module8.name] = function(p2, p3)
		local outfitId = tostring(p3.outfitId)
		local v6 = p2[module11.CharacterKey] or {}
		local v7 = Cryo.List.removeValue(v6, outfitId)

		local v8 = if fFlagAXMigrateOutfitsToUserInventory then avatarEditorCategories.Avatars else module11.EditableCharacterKey
		local v9 = p2[v8] or {}
		local v10 = Cryo.List.removeValue(v9, outfitId)

		if fFlagAXOutfitPageRevamp then
			local v11 = if fFlagAXMigrateOutfitsToUserInventory then avatarEditorSubcategories.MakeupLooks else module11.MakeupOutfitKey
			local v12 = p2[v11] or {}
			local v13 = Cryo.List.removeValue(v12, outfitId)
			local v14 = { [module11.CharacterKey] = v7 }
			local v15

			if fFlagAXMigrateOutfitsToUserInventory then
				v15 = avatarEditorCategories.Avatars
			else
				v15 = module11.EditableCharacterKey
			end

			v14[v15] = v10
			local v16

			if fFlagAXMigrateOutfitsToUserInventory then
				v16 = avatarEditorSubcategories.MakeupLooks
			else
				v16 = module11.MakeupOutfitKey
			end

			v14[v16] = v13

			if fFlagAXMigrateOutfitsToUserInventory then
				local v17 = p2[module11.EditableMakeupOutfitKey] or {}
				v14[module11.EditableMakeupOutfitKey] = Cryo.List.removeValue(v17, outfitId)
			end

			return Cryo.Dictionary.join(p2, v14)
		else
			local join = Cryo.Dictionary.join
			local v11 = { [module11.CharacterKey] = v7 }
			local v12

			if fFlagAXMigrateOutfitsToUserInventory then
				v12 = avatarEditorCategories.Avatars
			else
				v12 = module11.EditableCharacterKey
			end

			v11[v12] = v10
			return join(p2, v11)
		end
	end
})
