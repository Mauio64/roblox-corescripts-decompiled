local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local HttpService = game:GetService("HttpService")

local SharedFlags = require(parent.SharedFlags)
local GetFFlagReportAnythingEnableAdReport = SharedFlags.GetFFlagReportAnythingEnableAdReport

local function transformVectorArray(convexHull)
	local result = {}

	for _, item in ipairs(convexHull) do
		result[#result + 1] = { item.X, item.Y }
	end

	return result
end

local function transformIdentifiedAds(identifiedAds)
	local result = {}

	for _, item in pairs(identifiedAds) do
		result[#result + 1] = {
			assetId = item.assetId,
			distance = item.distance,
			boundingBox = {
				minX = item.boundingBox.min.X,
				minY = item.boundingBox.min.Y,
				maxX = item.boundingBox.max.X,
				maxY = item.boundingBox.max.Y
			},
			adUnitName = item.adUnitName,
			encryptedAdTrackingData = item.encryptedAdTrackingData,
			encryptionMetadata = item.encryptionMetadata
		}
	end

	return result
end

local function transformIdentifiedAvatars(identifiedAvatars)
	local result = {}

	for k, item in pairs(identifiedAvatars) do
		local v = {
			userId = tostring(k),
			distance = item.distance,
			boundingBox = {
				minX = item.boundingBox.min.X,
				minY = item.boundingBox.min.Y,
				maxX = item.boundingBox.max.X,
				maxY = item.boundingBox.max.Y
			},
			hitRate = item.hitRate,
			convexHull = transformVectorArray(item.convexHull)
		}

		if item.pointProcessingStats ~= nil then
			v.pointProcessingStats = {
				item.pointProcessingStats.wasSkipped and 1 or 0,
				item.pointProcessingStats.total,
				item.pointProcessingStats.offScreenDiscardCount,
				item.pointProcessingStats.tooCloseDiscardCount
			}
		end

		result[#result + 1] = v
	end

	return result
end

local function hasIdentifiedAvatars(identificationResults): boolean -- 1 equivalent call inferred from this helper
	for _ in pairs(identificationResults.identifiedAvatars) do
		return true
	end

	return false
end

local function hasIdentifiedAds(identificationResults): boolean -- 1 equivalent call inferred from this helper
	for _ in pairs(identificationResults.identifiedAds) do
		return true
	end

	return false
end

return {
	appendReportAnythingTags = function(p, p2)
		if not p2 then
			return p
		end

		local identificationResults = p2.identificationResults

		if hasIdentifiedAvatars(identificationResults) then -- inferred equivalent call
			p.IDENTIFIED_AVATARS = {
				valueList = {
					{
						data = HttpService:JSONEncode(transformIdentifiedAvatars(identificationResults.identifiedAvatars))
					}
				}
			}
		end

		if identificationResults.avatarIDStats then
			p.AVATAR_ID_STATS = {
				valueList = {
					{
						data = HttpService:JSONEncode(identificationResults.avatarIDStats)
					}
				}
			}
		end

		if GetFFlagReportAnythingEnableAdReport() then
			if hasIdentifiedAds(identificationResults) then -- inferred equivalent call
				p.IDENTIFIED_ADS = {
					valueList = {
						{
							data = HttpService:JSONEncode(transformIdentifiedAds(identificationResults.identifiedAds))
						}
					}
				}
			end

			if identificationResults.adIDStats then
				p.AD_ID_STATS = {
					valueList = {
						{
							data = HttpService:JSONEncode(identificationResults.adIDStats)
						}
					}
				}
			end
		end

		if #p2.screenshotId > 0 then
			p.SCREENSHOT_ID = {
				valueList = {
					{ data = p2.screenshotId }
				}
			}
		end

		return p
	end
}
