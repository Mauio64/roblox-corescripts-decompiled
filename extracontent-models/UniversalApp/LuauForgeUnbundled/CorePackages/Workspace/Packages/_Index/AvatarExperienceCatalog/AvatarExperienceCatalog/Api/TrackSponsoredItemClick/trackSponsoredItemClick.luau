local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http").Url

local function trackSponsoredItemClick(callback, p2)
	return callback(string.format("%sv2/tracking/click", url.AD_CONFIGURATION_URL), "POST", {
		postBody = HttpService:JSONEncode({
			encryptedAdTrackingData = p2,
			campaignTargetType = "Asset",
			placementLocation = "AvatarShop"
		})
	})
end

return trackSponsoredItemClick
