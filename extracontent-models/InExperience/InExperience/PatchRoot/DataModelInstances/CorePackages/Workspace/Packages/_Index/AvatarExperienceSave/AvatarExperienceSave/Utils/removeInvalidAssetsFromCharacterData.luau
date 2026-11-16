local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")

local parent = AvatarExperienceSave.Parent
local tutils = require(parent.tutils)

require(AvatarExperienceSave.Context.AvatarSaveContext)

local function removeInvalidAssetsFromCharacterData(p, items)
	local v = false

	for k, item in items do
		if not (p.equipped.EquippedAssets[item] and p.equipped.EquippedAssets[item][k]) then
			continue
		end

		v = true
		p.equipped.EquippedAssets[item][k] = nil

		if tutils.fieldCount(p.equipped.EquippedAssets[item]) == 0 then
			p.equipped.EquippedAssets[item] = nil
		end
	end

	return p, v
end

return removeInvalidAssetsFromCharacterData
