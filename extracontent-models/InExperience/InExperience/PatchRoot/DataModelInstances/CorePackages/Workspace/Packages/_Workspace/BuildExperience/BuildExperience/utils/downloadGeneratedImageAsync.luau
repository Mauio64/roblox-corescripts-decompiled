local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local HttpClient = require(parent.HttpClient)
local Promise = require(parent.Promise)

local FFlagBuildExperienceMonetizationFailureCauses = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationFailureCauses)
local getThumbnailUrlAsync = require(script.Parent.getThumbnailUrlAsync)
local monetizationFailureCauses = require(script.Parent.monetizationFailureCauses)

local asPromise = HttpClient.asPromise
local fetch = HttpClient.fetch

local function downloadGeneratedImageAsync(p: number)
	return getThumbnailUrlAsync(p):andThen(function(p2)
		if p2.status == "completed" then
			return asPromise((fetch({
				method = "GET",
				url = p2.imageUrl,
				analyticsKey = "build-experience.download-developer-product-image",
				responseEncoding = "protobuf",
				decode = function(buf: buffer)
					return buf
				end
			}))):andThen(function(buf: buffer)
				if buffer.len(buf) > 5242880 then
					return (Promise.reject(not FFlagBuildExperienceMonetizationFailureCauses and "The generated image exceeds the 5 MB developer-product limit." or monetizationFailureCauses.MESSAGES.imageTooLarge))
				end

				return {
					content = buffer.tostring(buf),
					contentType = "image/png",
					fileName = `generated-{p}.png`
				}
			end)
		end

		return Promise.reject(monetizationFailureCauses.MESSAGES.imageInReview)
	end)
end

return downloadGeneratedImageAsync
