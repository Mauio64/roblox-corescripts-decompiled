local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")

local parent = script.Parent.Parent

local Promise = require(parent.Parent.Promise)

local APIUtil = require(parent.util.APIUtil)
local BundlesMetadata = {}

function BundlesMetadata.fetch()
	return Promise.try(function()
		return HttpService:JSONDecode(HttpRbxApiService:GetAsyncFullUrl(`https://itemconfiguration.{APIUtil.getBaseDomain()}/v1/bundles/metadata`))
	end)
end

function BundlesMetadata.mock()
	return {
		isBundlesControllerEnabled = true,
		isBundlesCreationEnabled = true,
		isBundlesPublishingEnabled = true,
		allowedBundleTypeSettings = {
			Body = {
				allowedAssetTypeSettings = {
					DynamicHead = {
						minimumQuantity = 1,
						maximumQuantity = 1,
						isEligibleForUpload = true,
						allowedFileExtensions = { ".rbxm" }
					},
					EyebrowAccessory = {
						minimumQuantity = 0,
						maximumQuantity = 1,
						isEligibleForUpload = true,
						allowedFileExtensions = { ".rbxm" }
					},
					EyelashAccessory = {
						minimumQuantity = 0,
						maximumQuantity = 1,
						isEligibleForUpload = true,
						allowedFileExtensions = { ".rbxm" }
					},
					HairAccessory = {
						minimumQuantity = 0,
						maximumQuantity = 1,
						isEligibleForUpload = true,
						allowedFileExtensions = { ".rbxm" }
					},
					LeftArm = {
						minimumQuantity = 1,
						maximumQuantity = 1,
						isEligibleForUpload = true,
						allowedFileExtensions = { ".rbxm" }
					},
					LeftLeg = {
						minimumQuantity = 1,
						maximumQuantity = 1,
						isEligibleForUpload = true,
						allowedFileExtensions = { ".rbxm" }
					},
					RightArm = {
						minimumQuantity = 1,
						maximumQuantity = 1,
						isEligibleForUpload = true,
						allowedFileExtensions = { ".rbxm" }
					},
					RightLeg = {
						minimumQuantity = 1,
						maximumQuantity = 1,
						isEligibleForUpload = true,
						allowedFileExtensions = { ".rbxm" }
					},
					Torso = {
						minimumQuantity = 1,
						maximumQuantity = 1,
						isEligibleForUpload = true,
						allowedFileExtensions = { ".rbxm" }
					}
				},
				marketplaceFeePercentage = 30,
				allowedPriceRange = { minimumPrice = 0, maximumPrice = 10000 }
			},
			DynamicHead = {
				allowedAssetTypeSettings = {
					DynamicHead = {
						minimumQuantity = 1,
						maximumQuantity = 1,
						isEligibleForUpload = true,
						allowedFileExtensions = { ".rbxm" }
					},
					EyebrowAccessory = {
						minimumQuantity = 0,
						maximumQuantity = 1,
						isEligibleForUpload = true,
						allowedFileExtensions = { ".rbxm" }
					},
					EyelashAccessory = {
						minimumQuantity = 0,
						maximumQuantity = 1,
						isEligibleForUpload = true,
						allowedFileExtensions = { ".rbxm" }
					}
				},
				marketplaceFeePercentage = 30,
				allowedPriceRange = { minimumPrice = 0, maximumPrice = 10000 }
			}
		}
	}
end

return BundlesMetadata
