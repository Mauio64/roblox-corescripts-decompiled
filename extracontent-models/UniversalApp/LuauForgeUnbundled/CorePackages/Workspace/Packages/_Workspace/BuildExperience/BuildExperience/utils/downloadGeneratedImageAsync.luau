local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")

local FFlagBuildExperienceMonetizationFailureCauses = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationFailureCauses")
local getThumbnailUrlAsync = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/getThumbnailUrlAsync")
local monetizationFailureCauses = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/monetizationFailureCauses")

local asPromise = HttpClient.asPromise
local fetch = HttpClient.fetch

local function downloadGeneratedImageAsync(p2)
	return getThumbnailUrlAsync(p2):andThen(function(p3)
		if p3.status ~= "completed" then
			return Promise.reject(monetizationFailureCauses.MESSAGES.imageInReview)
		end

		return asPromise((fetch({
			method = "GET",
			url = p3.imageUrl,
			analyticsKey = "build-experience.download-developer-product-image",
			responseEncoding = "protobuf",
			decode = function(p4)
				return p4
			end
		}))):andThen(function(buf)
			if buffer.len(buf) > 5242880 then
				return Promise.reject(not FFlagBuildExperienceMonetizationFailureCauses and "The generated image exceeds the 5 MB developer-product limit." or monetizationFailureCauses.MESSAGES.imageTooLarge)
			end

			return {
				content = buffer.tostring(buf),
				contentType = "image/png",
				fileName = `generated-{p2}.png`
			}
		end)
	end)
end

return downloadGeneratedImageAsync
