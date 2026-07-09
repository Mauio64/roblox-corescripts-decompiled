local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = require(AvatarExperienceCommon.Constants).ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local destroyMakeupDescriptions = require(AvatarExperienceCommon.Utils.Humanoid.destroyMakeupDescriptions)

local function setMakeupDescriptions(p1, t1: {[any]: any}) -- line: 17
	-- upvalues: destroyMakeupDescriptions (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy)
	destroyMakeupDescriptions(p1)

	for v7, v8 in t1 do
		if ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[v7] then
			for v9, v10 in v8 do
				local MakeupDescription = Instance.new("MakeupDescription")

				MakeupDescription.MakeupType = ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[v7]
				MakeupDescription.AssetId = tonumber(v9) or 0
				MakeupDescription.Parent = p1

				if v10.order then
					MakeupDescription.Order = v10.order
				end
			end
		end
	end
end

return setMakeupDescriptions
