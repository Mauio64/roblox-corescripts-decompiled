local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local OutfitTypes = require(AvatarExperienceCommon.Enums.OutfitTypes)
require(AvatarExperienceCommon.Types.CategoryTypes.CategoryTypes)
local Constants = require(AvatarExperienceCommon.Constants)

local NON_EDITABLE_MAKEUP_GRANT_KEY = Constants.NON_EDITABLE_MAKEUP_GRANT_KEY

local function getGrantedOutfitIds(p, p2, flag: boolean?)
	if not p then
		return {}
	end

	local v

	if p2 == OutfitTypes.Avatar then
		if flag == nil then
			v = { OutfitTypes.EditableAvatar, OutfitTypes.Avatar }
		elseif flag then
			v = { OutfitTypes.EditableAvatar }
		else
			v = { OutfitTypes.Avatar }
		end
	elseif p2 == OutfitTypes.Makeup then
		if flag == nil then
			v = { OutfitTypes.Makeup, NON_EDITABLE_MAKEUP_GRANT_KEY }
		elseif flag then
			v = { OutfitTypes.Makeup }
		else
			v = { NON_EDITABLE_MAKEUP_GRANT_KEY }
		end
	else
		v = { p2 }
	end

	local set = {}
	local result = {}

	for _, v2 in v do
		local grantedOutfit = p.grantedOutfitsByType[v2]

		if not grantedOutfit then
			continue
		end

		for _, v3 in grantedOutfit do
			local v4 = tostring(v3)

			if set[v4] then
				continue
			end

			set[v4] = true
			table.insert(result, v4)
		end
	end

	return result
end

return getGrantedOutfitIds
