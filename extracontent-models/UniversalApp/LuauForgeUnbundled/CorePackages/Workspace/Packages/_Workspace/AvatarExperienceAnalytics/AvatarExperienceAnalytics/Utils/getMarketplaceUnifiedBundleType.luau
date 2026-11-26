local bundleTypeIdStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceModel").Constants.BundleTypeIdStrings

local function getMarketplaceUnifiedBundleType(p2)
	if p2 == nil then
		return nil
	end

	return tonumber(p2) or tonumber(bundleTypeIdStrings[p2])
end

return getMarketplaceUnifiedBundleType
