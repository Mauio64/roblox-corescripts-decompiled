local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local AvatarExperienceSaveParent = AvatarExperienceSave.Parent
local tutils = require(AvatarExperienceSaveParent.tutils)

require(AvatarExperienceSave.Context.AvatarSaveContext)

local function removeInvalidAssetsFromCharacterData(p1, t1: {[any]: any}) -- line: 8
	-- upvalues: tutils (copy)
	local v7 = false

	for v8, v9 in t1 do
		if p1.equipped.EquippedAssets[v9] and p1.equipped.EquippedAssets[v9][v8] then
			v7 = true
			p1.equipped.EquippedAssets[v9][v8] = nil

			if tutils.fieldCount(p1.equipped.EquippedAssets[v9]) == 0 then
				p1.equipped.EquippedAssets[v9] = nil
			end
		end
	end

	return p1, v7
end

return removeInvalidAssetsFromCharacterData
