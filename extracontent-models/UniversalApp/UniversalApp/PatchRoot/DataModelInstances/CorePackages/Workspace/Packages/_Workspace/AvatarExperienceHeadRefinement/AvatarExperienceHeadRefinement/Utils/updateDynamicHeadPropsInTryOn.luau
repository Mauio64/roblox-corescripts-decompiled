local Parent = script:FindFirstAncestor("AvatarExperienceHeadRefinement").Parent
local Cryo = require(Parent.Cryo)
local AvatarExperienceCommon = require(Parent.AvatarExperienceCommon)

require(Parent.AvatarExperienceRodux)

local DynamicHead = AvatarExperienceCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING.DynamicHead

local function updateDynamicHeadPropsInTryOn(p1, p2: ((...any) -> ...any)) -- line: 28
	-- upvalues: DynamicHead (copy), Cryo (copy)
	local t1 = {}

	for v9, v10 in p1 do
		if v10.bundleInfo then
			local t2 = {}

			for v12, v13 in v10.bundleInfo do
				if v13.assetType == DynamicHead then
					local v14 = p2(v13)

					t2[v12] = if not v14 then v13 else Cryo.Dictionary.join(v13, v14)
				else
					t2[v12] = v13
				end
			end

			t1[v9] = Cryo.Dictionary.join(v10, {
				bundleInfo = t2
			})
		else
			t1[v9] = v10
		end
	end

	return t1
end

return updateDynamicHeadPropsInTryOn
