local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/tutils")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/AvatarSaveContext")

local function removeInvalidAssetsFromCharacterData(p2, items)
	local v5 = false

	for k, item in items do
		if not (p2.equipped.EquippedAssets[item] and p2.equipped.EquippedAssets[item][k]) then
			continue
		end

		v5 = true
		p2.equipped.EquippedAssets[item][k] = nil

		if tutils.fieldCount(p2.equipped.EquippedAssets[item]) == 0 then
			p2.equipped.EquippedAssets[item] = nil
		end
	end

	return p2, v5
end

return removeInvalidAssetsFromCharacterData
