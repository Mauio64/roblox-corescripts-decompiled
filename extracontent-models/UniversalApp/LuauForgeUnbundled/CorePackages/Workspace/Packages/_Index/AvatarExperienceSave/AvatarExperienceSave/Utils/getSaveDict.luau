local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/tutils")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/AvatarSaveContext")
local fFlagAXBackgroundsPersistence = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/AvatarExperienceFlags").FFlagAXBackgroundsPersistence

local defineFastFlag = game:DefineFastFlag("AXFixEmptyDictionaryKeysForSaveDict2", false)

local function filterEmptyDicts(p2)
	local clone = table.clone(p2)

	for k, v5 in clone do
		if not (type(v5) == "table" and next(v5) == nil) then
			continue
		end

		clone[k] = nil
	end

	return clone
end

local function deepEqualWithoutEmptyDicts(p2, p3)
	local v5 = filterEmptyDicts(p2)
	local v6 = filterEmptyDicts(p3)
	return tutils.deepEqual(v5, v6)
end

local function getSaveDict(p2, p3)
	local equipped = p2.equipped
	local equipped2 = p3.equipped
	local v5

	if fFlagAXBackgroundsPersistence then
		v5 = equipped.BackgroundAssetId ~= equipped2.BackgroundAssetId
	end

	if not defineFastFlag then
		return {
			BodyColors = not tutils.deepEqual(equipped.BodyColor3s, equipped2.BodyColor3s),
			AvatarType = equipped.AvatarType ~= equipped2.AvatarType,
			Scales = not tutils.deepEqual(equipped.AvatarScales, equipped2.AvatarScales),
			Assets = equipped.EquippedAssets and not tutils.deepEqual(
				equipped.EquippedAssets,
				equipped2.EquippedAssets
			),
			Emotes = not tutils.deepEqual(
				equipped.EquippedEmotes.slotInfo,
				equipped2.EquippedEmotes.slotInfo
			),
			Background = v5
		}
	end

	local bodyColor3s = equipped.BodyColor3s
	local bodyColor3s2 = equipped2.BodyColor3s
	local v7 = filterEmptyDicts(bodyColor3s)
	local v8 = filterEmptyDicts(bodyColor3s2)
	local v6 = {
		BodyColors = not tutils.deepEqual(v7, v8),
		AvatarType = equipped.AvatarType ~= equipped2.AvatarType,
		Scales = 0,
		Assets = 0,
		Emotes = 0,
		Background = 0
	}
	local avatarScales = equipped.AvatarScales
	local avatarScales2 = equipped2.AvatarScales
	local v9 = filterEmptyDicts(avatarScales)
	local v10 = filterEmptyDicts(avatarScales2)
	v6.Scales = not tutils.deepEqual(v9, v10)
	local v11 = equipped.EquippedAssets

	if v11 then
		local equippedAssets = equipped.EquippedAssets
		local equippedAssets2 = equipped2.EquippedAssets
		local v12 = filterEmptyDicts(equippedAssets)
		local v13 = filterEmptyDicts(equippedAssets2)
		v11 = not tutils.deepEqual(v12, v13)
	end

	v6.Assets = v11

	local slotInfo = equipped.EquippedEmotes.slotInfo
	local slotInfo2 = equipped2.EquippedEmotes.slotInfo
	local v12 = filterEmptyDicts(slotInfo)
	local v13 = filterEmptyDicts(slotInfo2)
	v6.Emotes = not tutils.deepEqual(v12, v13)

	v6.Background = v5
	return v6
end

return getSaveDict
