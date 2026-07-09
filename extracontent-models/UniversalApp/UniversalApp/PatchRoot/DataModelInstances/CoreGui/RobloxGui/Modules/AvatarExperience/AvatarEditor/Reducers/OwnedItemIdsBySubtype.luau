local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local SetOwnedItemIdsBySubtype = require(Modules.AvatarExperience.AvatarEditor.Actions.SetOwnedItemIdsBySubtype)
local GrantAsset = require(Modules.AvatarExperience.AvatarEditor.Actions.GrantAsset)
local RevokeAsset = require(Modules.AvatarExperience.AvatarEditor.Actions.RevokeAsset)
local GrantOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.GrantOutfit)
local GrantEditableOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.GrantEditableOutfit)
local GrantPurchasedOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.GrantPurchasedOutfit)
local GrantOutfitByType = require(Modules.AvatarExperience.AvatarEditor.Actions.GrantOutfitByType)
local RevokeOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.RevokeOutfit)
local UpdateOutfit = require(Modules.AvatarExperience.AvatarEditor.Actions.UpdateOutfit)

require(Modules.AvatarExperience.Common.Types)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local GetAvatarEditorStructure = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorStructure)
local FFlagAXFixMakeupLookGrantOutfitHoisting = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixMakeupLookGrantOutfitHoisting

local function GetAssetTypeToSearchUuids() -- line: 27
	-- upvalues: GetAvatarEditorStructure (copy)
	return GetAvatarEditorStructure().AssetTypeToSearchUuids
end

return Rodux.createReducer({}, {
	[SetOwnedItemIdsBySubtype.name] = function(p1, p2) -- line: 39
		-- upvalues: Cryo (copy)
		local t1 = {}
		local v22 = p1[p2.itemSubType] and p1[p2.itemSubType] or {}

		for _, v24 in v22 do
			t1[v24] = v24
		end

		for _, v26 in p2.itemIds do
			if not t1[v26] then
				v22[#v22 + 1] = v26
				t1[v26] = v26
			end
		end

		return Cryo.Dictionary.join(p1, {
			[p2.itemSubType] = v22
		})
	end,
	[GrantAsset.name] = function(p3, p4) -- line: 61
		-- upvalues: GetAvatarEditorStructure (copy), Cryo (copy)
		local t2 = {}
		local str = tostring(p4.assetTypeId)
		local str2 = tostring(p4.assetId)
		local v32 = GetAvatarEditorStructure().AssetTypeToSearchUuids[str]

		if not v32 then
			return p3
		end

		for _, v34 in v32 do
			local t3 = { str2 }
			local v36 = false

			for v37, v38 in p3[v34] and p3[v34] or {} do
				if v38 == str2 then
					v36 = true

					break
				end

				t3[v37 + 1] = v38
			end

			if not v36 then
				t2[v34] = t3
			end
		end

		if next(t2) then
			return Cryo.Dictionary.join(p3, t2)
		end

		return p3
	end,
	[RevokeAsset.name] = function(p5, p6) -- line: 105
		-- upvalues: GetAvatarEditorStructure (copy), Cryo (copy)
		local t4 = {}
		local str = tostring(p6.assetTypeId)
		local str3 = tostring(p6.assetId)
		local v44 = GetAvatarEditorStructure().AssetTypeToSearchUuids[str]

		if not v44 then
			return p5
		end

		for _, v46 in v44 do
			local v47 = p5[v46] and p5[v46] or {}
			local v48 = Cryo.List.removeValue(v47, str3)

			if #v47 ~= #v48 then
				t4[v46] = v48
			end
		end

		if next(t4) then
			return Cryo.Dictionary.join(p5, t4)
		end

		return p5
	end,
	[GrantOutfitByType.name] = function(p7, p8) -- line: 138
		-- upvalues: Cryo (copy)
		local str = tostring(p8.outfitId)
		local outfitTypeId = p8.outfitTypeId
		local t5 = { str }

		for _, v55 in p7[outfitTypeId] or {} do
			if v55 == str then
				return p7
			end

			table.insert(t5, v55)
		end

		return Cryo.Dictionary.join(p7, {
			[outfitTypeId] = t5
		})
	end,
	[GrantOutfit.name] = function(p9, p10) -- line: 161
		-- upvalues: Constants2 (copy), Cryo (copy)
		local str = tostring(p10.outfitId)
		local t6 = { str }

		for v60, v61 in p9[Constants2.CharacterKey] or {} do
			if v61 == str then
				return p9
			end

			t6[v60 + 1] = v61
		end

		return Cryo.Dictionary.join(p9, {
			[Constants2.CharacterKey] = t6
		})
	end,
	[GrantEditableOutfit.name] = function(p11, p12) -- line: 182
		-- upvalues: Constants2 (copy), Cryo (copy)
		local str = tostring(p12.outfitId)
		local t7 = { str }

		for v66, v67 in p11[Constants2.EditableCharacterKey] or {} do
			if v67 == str then
				return p11
			end

			t7[v66 + 1] = v67
		end

		return Cryo.Dictionary.join(p11, {
			[Constants2.EditableCharacterKey] = t7
		})
	end,
	[GrantPurchasedOutfit.name] = function(p13, p14) -- line: 203
		-- upvalues: Constants2 (copy), Cryo (copy)
		local str = tostring(p14.outfitId)
		local t8 = { str }

		for v72, v73 in p13[Constants2.PurchasedCharacterKey] or {} do
			if v73 == str then
				return p13
			end

			t8[v72 + 1] = v73
		end

		return Cryo.Dictionary.join(p13, {
			[Constants2.PurchasedCharacterKey] = t8
		})
	end,
	[UpdateOutfit.name] = function(p15, p16) -- line: 225
		-- upvalues: FFlagAXFixMakeupLookGrantOutfitHoisting (copy), Constants (copy), Constants2 (copy), Cryo (copy)
		local str = tostring(p16.outfitId)

		if FFlagAXFixMakeupLookGrantOutfitHoisting and p16.outfitType == Constants.OutfitTypes.Makeup then
			local v77 = p15[Constants2.MakeupOutfitKey] or {}
			local v78 = Cryo.List.join({ str }, Cryo.List.removeValue(v77, str))

			return Cryo.Dictionary.join(p15, {
				[Constants2.MakeupOutfitKey] = v78
			})
		end

		local v79 = p15[Constants2.CharacterKey] or {}
		local v80 = p15[Constants2.EditableCharacterKey] or {}

		if p16.isEditable then
			v80 = Cryo.List.join({ str }, Cryo.List.removeValue(v80, str))
		else
			v79 = Cryo.List.join({ str }, Cryo.List.removeValue(v79, str))
		end

		return Cryo.Dictionary.join(p15, {
			[Constants2.CharacterKey] = v79,
			[Constants2.EditableCharacterKey] = v80
		})
	end,
	[RevokeOutfit.name] = function(p17, p18) -- line: 267
		-- upvalues: Constants2 (copy), Cryo (copy)
		local str = tostring(p18.outfitId)
		local v84 = p17[Constants2.CharacterKey] or {}
		local v85 = Cryo.List.removeValue(v84, str)
		local v86 = p17[Constants2.EditableCharacterKey] or {}
		local v87 = Cryo.List.removeValue(v86, str)

		return Cryo.Dictionary.join(p17, {
			[Constants2.CharacterKey] = v85,
			[Constants2.EditableCharacterKey] = v87
		})
	end
})
