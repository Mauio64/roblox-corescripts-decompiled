local OutfitTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/OutfitTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/CategoryTypes/CategoryTypes")
local NON_EDITABLE_MAKEUP_GRANT_KEY = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants").NON_EDITABLE_MAKEUP_GRANT_KEY

local function getGrantedOutfitIds(p2, p3, p4)
	if not p2 then
		return {}
	end

	local v5

	if p3 == OutfitTypes.Avatar then
		if p4 == nil then
			v5 = { OutfitTypes.EditableAvatar, OutfitTypes.Avatar }
		elseif p4 then
			v5 = { OutfitTypes.EditableAvatar }
		else
			v5 = { OutfitTypes.Avatar }
		end
	elseif p3 == OutfitTypes.Makeup then
		if p4 == nil then
			v5 = { OutfitTypes.Makeup, NON_EDITABLE_MAKEUP_GRANT_KEY }
		elseif p4 then
			v5 = { OutfitTypes.Makeup }
		else
			v5 = { NON_EDITABLE_MAKEUP_GRANT_KEY }
		end
	else
		v5 = { p3 }
	end

	local set = {}
	local result = {}

	for k, v6 in v5 do
		local grantedOutfit = p2.grantedOutfitsByType[v6]

		if not grantedOutfit then
			continue
		end

		for k2, v7 in grantedOutfit do
			local v8 = tostring(v7)

			if set[v8] then
				continue
			end

			set[v8] = true
			table.insert(result, v8)
		end
	end

	return result
end

return getGrantedOutfitIds
