local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local Constants = require(AvatarExperienceCommon.Constants)
local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local destroyMakeupDescriptions = require(AvatarExperienceCommon.Utils.Humanoid.destroyMakeupDescriptions)

local function setMakeupDescriptions(parent, items)
	destroyMakeupDescriptions(parent)

	for k, item in items do
		if not ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[k] then
			continue
		end

		for k2, v in item do
			local makeupDescription = Instance.new("MakeupDescription")
			makeupDescription.MakeupType = ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[k]
			makeupDescription.AssetId = tonumber(k2) or 0
			makeupDescription.Parent = parent

			if v.order then
				makeupDescription.Order = v.order
			end
		end
	end
end

return setMakeupDescriptions
