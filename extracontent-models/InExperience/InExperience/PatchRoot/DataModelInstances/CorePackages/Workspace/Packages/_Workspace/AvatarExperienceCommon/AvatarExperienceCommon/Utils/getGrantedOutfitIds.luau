local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local OutfitTypes = require(AvatarExperienceCommon.Enums.OutfitTypes)

require(AvatarExperienceCommon.Types.CategoryTypes.CategoryTypes)

local NON_EDITABLE_MAKEUP_GRANT_KEY = require(AvatarExperienceCommon.Constants).NON_EDITABLE_MAKEUP_GRANT_KEY

local function getGrantedOutfitIds(t1: {[any]: any}?, p1, b1: boolean?) -- line: 33
	-- upvalues: OutfitTypes (copy), NON_EDITABLE_MAKEUP_GRANT_KEY (copy)
	if not t1 then
		return {}
	end

	local t2 = {}
	local t3 = {}

	for _, v11 in if p1 ~= OutfitTypes.Avatar then if p1 ~= OutfitTypes.Makeup then { p1 } else if b1 ~= nil then if not b1 then { NON_EDITABLE_MAKEUP_GRANT_KEY } else { OutfitTypes.Makeup } else {
		OutfitTypes.Makeup,
		NON_EDITABLE_MAKEUP_GRANT_KEY
	} else if b1 ~= nil then if not b1 then { OutfitTypes.Avatar } else { OutfitTypes.EditableAvatar } else {
		OutfitTypes.EditableAvatar,
		OutfitTypes.Avatar
	} do
		local v12 = t1.grantedOutfitsByType[v11]

		if v12 then
			for _, v14 in v12 do
				local str = tostring(v14)

				if not t3[str] then
					t3[str] = true
					table.insert(t2, str)
				end
			end
		end
	end

	return t2
end

return getGrantedOutfitIds
