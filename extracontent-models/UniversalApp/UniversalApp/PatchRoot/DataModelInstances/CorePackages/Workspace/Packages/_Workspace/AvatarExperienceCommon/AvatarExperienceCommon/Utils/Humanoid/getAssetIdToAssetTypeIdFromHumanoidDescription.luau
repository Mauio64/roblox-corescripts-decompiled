local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local Constants = require(AvatarExperienceCommon.Constants)

local function getAssetIdToAssetTypeIdFromHumanoidDescription(p1) -- line: 5
	-- upvalues: Constants (copy)
	local t1 = {}

	for v6, v7 in Constants.ASSET_TYPE_ID_STRING_TO_HUMANOID_DESCRIPTION_PROP do
		if Constants.ASSET_TYPE_TO_ACCESSORY_TYPE[tostring(v6)] == nil then
			local v8 = p1[v7]

			if typeof(v8) == "number" and v8 > 0 then
				t1[tostring(v8)] = tostring(v6)
			elseif typeof(v8) == "string" and v8 ~= "" then
				for match in v8:gmatch("([%d]+),?") do
					t1[match] = tostring(v6)
				end
			end
		end
	end

	for _, v11 in (p1:GetAccessories(true)) do
		local AccessoryType = v11.AccessoryType

		t1[tostring(v11.AssetId)] = Constants.ACCESSORY_TYPE_TO_ASSET_TYPE[AccessoryType]
	end

	return t1
end

return getAssetIdToAssetTypeIdFromHumanoidDescription
