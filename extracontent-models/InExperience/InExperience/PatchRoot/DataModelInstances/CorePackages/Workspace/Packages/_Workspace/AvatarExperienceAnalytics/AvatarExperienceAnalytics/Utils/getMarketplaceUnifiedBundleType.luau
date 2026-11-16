local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local BundleTypeIdStrings = AvatarExperienceModel.Constants.BundleTypeIdStrings

local function getMarketplaceUnifiedBundleType(p: string?)
	if p == nil then
		return nil
	end

	return tonumber(p) or tonumber(BundleTypeIdStrings[p])
end

return getMarketplaceUnifiedBundleType
