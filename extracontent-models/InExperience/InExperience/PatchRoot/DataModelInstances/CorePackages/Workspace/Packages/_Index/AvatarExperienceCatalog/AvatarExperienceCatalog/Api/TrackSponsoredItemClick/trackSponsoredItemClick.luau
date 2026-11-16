local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local HttpService = game:GetService("HttpService")

local parent = AvatarExperienceCatalog.Parent
local Http = require(parent.Http)
local Url = Http.Url

local function trackSponsoredItemClick(callback, encryptedAdTrackingData: string)
	return callback(string.format("%sv2/tracking/click", Url.AD_CONFIGURATION_URL), "POST", {
		postBody = HttpService:JSONEncode({
			encryptedAdTrackingData = encryptedAdTrackingData,
			campaignTargetType = "Asset",
			placementLocation = "AvatarShop"
		})
	})
end

return trackSponsoredItemClick
