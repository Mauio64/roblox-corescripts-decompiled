local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent
local Promise = require(ParentParent.Parent.Promise)
local APIUtil = require(ParentParent.util.APIUtil)

return {
	fetch = function() -- line: 42
		-- upvalues: Promise (copy), HttpService (copy), HttpRbxApiService (copy), APIUtil (copy)
		return Promise.try(function() -- line: 43
			-- upvalues: HttpService (copy), HttpRbxApiService (copy), APIUtil (copy)
			return HttpService:JSONDecode(HttpRbxApiService:GetAsyncFullUrl(`https://itemconfiguration.{ APIUtil.getBaseDomain() }/v1/bundles/metadata`))
		end)
	end,
	mock = function() -- line: 50
		return {
			isBundlesControllerEnabled = true,
			isBundlesCreationEnabled = true,
			isBundlesPublishingEnabled = true,
			allowedBundleTypeSettings = {
				Body = {
					marketplaceFeePercentage = 30,
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
					allowedPriceRange = {
						minimumPrice = 0,
						maximumPrice = 10000
					}
				},
				DynamicHead = {
					marketplaceFeePercentage = 30,
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
					allowedPriceRange = {
						minimumPrice = 0,
						maximumPrice = 10000
					}
				}
			}
		}
	end
}
