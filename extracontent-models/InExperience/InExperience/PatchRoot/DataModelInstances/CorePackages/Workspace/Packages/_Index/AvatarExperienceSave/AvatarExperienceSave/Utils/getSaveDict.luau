local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local AvatarExperienceSaveParent = AvatarExperienceSave.Parent
local tutils = require(AvatarExperienceSaveParent.tutils)

require(AvatarExperienceSave.Context.AvatarSaveContext)

local AvatarExperienceFlags = require(AvatarExperienceSaveParent.AvatarExperienceFlags)
local FFlagAXRootSlotBasedEditorFlag = AvatarExperienceFlags.FFlagAXRootSlotBasedEditorFlag
local FFlagAXBackgroundsPersistence = AvatarExperienceFlags.FFlagAXBackgroundsPersistence
local v7 = FFlagAXRootSlotBasedEditorFlag and game:DefineFastFlag("AXFixEmptyDictionaryKeysForSaveDict2", false)

local function filterEmptyDicts(t1: {[any]: any}) -- line: 23
	local v12 = table.clone(t1)

	for v13, v14 in v12 do
		if type(v14) == "table" and next(v14) == nil then
			v12[v13] = nil
		end
	end

	return v12
end
local function deepEqualWithoutEmptyDicts(t2: {[any]: any}, t3: {[any]: any}) -- line: 33
	-- upvalues: filterEmptyDicts (copy), tutils (copy)
	local v17 = filterEmptyDicts(t2)
	local v18 = filterEmptyDicts(t3)

	return tutils.deepEqual(v17, v18)
end
local function getSaveDict(p1, p2) -- line: 43
	-- upvalues: FFlagAXBackgroundsPersistence (copy), v7 (copy), filterEmptyDicts (copy), tutils (copy)
	local equipped = p1.equipped
	local equipped2 = p2.equipped
	local v23 = if not FFlagAXBackgroundsPersistence then nil else equipped.BackgroundAssetId ~= equipped2.BackgroundAssetId

	if v7 then
		local t4 = {}
		local BodyColor3s = equipped.BodyColor3s
		local BodyColor3s2 = equipped2.BodyColor3s
		local v27 = filterEmptyDicts(BodyColor3s)
		local v28 = filterEmptyDicts(BodyColor3s2)

		t4.BodyColors = not tutils.deepEqual(v27, v28)
		t4.AvatarType = equipped.AvatarType ~= equipped2.AvatarType

		local AvatarScales = equipped.AvatarScales
		local AvatarScales2 = equipped2.AvatarScales
		local v31 = filterEmptyDicts(AvatarScales)
		local v32 = filterEmptyDicts(AvatarScales2)

		t4.Scales = not tutils.deepEqual(v31, v32)

		local EquippedAssets = equipped.EquippedAssets

		if EquippedAssets then
			local EquippedAssets2 = equipped.EquippedAssets
			local EquippedAssets3 = equipped2.EquippedAssets
			local v36 = filterEmptyDicts(EquippedAssets2)
			local v37 = filterEmptyDicts(EquippedAssets3)

			EquippedAssets = not tutils.deepEqual(v36, v37)
		end

		t4.Assets = EquippedAssets

		local slotInfo = equipped.EquippedEmotes.slotInfo
		local slotInfo2 = equipped2.EquippedEmotes.slotInfo
		local v40 = filterEmptyDicts(slotInfo)
		local v41 = filterEmptyDicts(slotInfo2)

		t4.Emotes = not tutils.deepEqual(v40, v41)
		t4.Background = v23

		return t4
	end

	return {
		BodyColors = not tutils.deepEqual(equipped.BodyColor3s, equipped2.BodyColor3s),
		AvatarType = equipped.AvatarType ~= equipped2.AvatarType,
		Scales = not tutils.deepEqual(equipped.AvatarScales, equipped2.AvatarScales),
		Assets = equipped.EquippedAssets and not tutils.deepEqual(equipped.EquippedAssets, equipped2.EquippedAssets),
		Emotes = not tutils.deepEqual(equipped.EquippedEmotes.slotInfo, equipped2.EquippedEmotes.slotInfo),
		Background = v23
	}
end

return getSaveDict
