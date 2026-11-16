local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local parent = AvatarExperienceSave.Parent

local tutils = require(parent.tutils)

require(AvatarExperienceSave.Context.AvatarSaveContext)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXBackgroundsPersistence = AvatarExperienceFlags.FFlagAXBackgroundsPersistence

local defineFastFlag = game:DefineFastFlag("AXFixEmptyDictionaryKeysForSaveDict2", false)

local function filterEmptyDicts(p)
	local clone = table.clone(p)

	for k, v in clone do
		if not (type(v) == "table" and next(v) == nil) then
			continue
		end

		clone[k] = nil
	end

	return clone
end

local function deepEqualWithoutEmptyDicts(p, p2) -- 4 equivalent calls inferred from this helper
	local v = filterEmptyDicts(p)
	local v2 = filterEmptyDicts(p2)
	return tutils.deepEqual(v, v2)
end

local function getSaveDict(p, p2)
	local equipped = p.equipped
	local equipped2 = p2.equipped
	local background

	if FFlagAXBackgroundsPersistence then
		background = equipped.BackgroundAssetId ~= equipped2.BackgroundAssetId
	end

	if not defineFastFlag then
		return {
			BodyColors = not tutils.deepEqual(equipped.BodyColor3s, equipped2.BodyColor3s),
			AvatarType = equipped.AvatarType ~= equipped2.AvatarType,
			Scales = not tutils.deepEqual(equipped.AvatarScales, equipped2.AvatarScales),
			Assets = equipped.EquippedAssets and not tutils.deepEqual(equipped.EquippedAssets, equipped2.EquippedAssets),
			Emotes = not tutils.deepEqual(equipped.EquippedEmotes.slotInfo, equipped2.EquippedEmotes.slotInfo),
			Background = background
		}
	end

	return {
		BodyColors = not deepEqualWithoutEmptyDicts(equipped.BodyColor3s, equipped2.BodyColor3s), -- inferred equivalent call
		AvatarType = equipped.AvatarType ~= equipped2.AvatarType,
		Scales = not deepEqualWithoutEmptyDicts(equipped.AvatarScales, equipped2.AvatarScales), -- inferred equivalent call
		Assets = equipped.EquippedAssets and not deepEqualWithoutEmptyDicts( -- inferred equivalent call
			equipped.EquippedAssets,
			equipped2.EquippedAssets
		),
		Emotes = not deepEqualWithoutEmptyDicts(equipped.EquippedEmotes.slotInfo, equipped2.EquippedEmotes.slotInfo), -- inferred equivalent call
		Background = background
	}
end

return getSaveDict
