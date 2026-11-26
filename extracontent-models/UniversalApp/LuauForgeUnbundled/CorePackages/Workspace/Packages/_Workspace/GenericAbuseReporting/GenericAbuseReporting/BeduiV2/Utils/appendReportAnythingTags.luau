local HttpService = game:GetService("HttpService")

local getFFlagReportAnythingEnableAdReport = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").GetFFlagReportAnythingEnableAdReport

local function transformVectorArray(convexHull)
	local result = {}

	for i, item in ipairs(convexHull) do
		result[#result + 1] = { item.X, item.Y }
	end

	return result
end

local function transformIdentifiedAds(identifiedAds)
	local result = {}

	for k, item in pairs(identifiedAds) do
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
		local v5 = {
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
			v5.pointProcessingStats = {
				item.pointProcessingStats.wasSkipped and 1 or 0,
				item.pointProcessingStats.total,
				item.pointProcessingStats.offScreenDiscardCount,
				item.pointProcessingStats.tooCloseDiscardCount
			}
		end

		result[#result + 1] = v5
	end

	return result
end

local function hasIdentifiedAvatars(p2): boolean
	for k in pairs(p2.identifiedAvatars) do
		return true
	end

	return false
end

local function hasIdentifiedAds(p2): boolean
	for k in pairs(p2.identifiedAds) do
		return true
	end

	return false
end

return {
	appendReportAnythingTags = function(p2, p3)
		if not p3 then
			return p2
		end

		local identificationResults = p3.identificationResults
		local flag = true
		local flag2

		for k in pairs(identificationResults.identifiedAvatars) do
			flag2 = true
			flag = false
			break
		end

		if flag then
			flag2 = false
		end

		if flag2 then
			p2.IDENTIFIED_AVATARS = {
				valueList = {
					{
						data = HttpService:JSONEncode(transformIdentifiedAvatars(identificationResults.identifiedAvatars))
					}
				}
			}
		end

		if identificationResults.avatarIDStats then
			p2.AVATAR_ID_STATS = {
				valueList = {
					{
						data = HttpService:JSONEncode(identificationResults.avatarIDStats)
					}
				}
			}
		end

		if getFFlagReportAnythingEnableAdReport() then
			local flag3 = true
			local flag4

			for k in pairs(identificationResults.identifiedAds) do
				flag4 = true
				flag3 = false
				break
			end

			if flag3 then
				flag4 = false
			end

			if flag4 then
				p2.IDENTIFIED_ADS = {
					valueList = {
						{
							data = HttpService:JSONEncode(transformIdentifiedAds(identificationResults.identifiedAds))
						}
					}
				}
			end

			if identificationResults.adIDStats then
				p2.AD_ID_STATS = {
					valueList = {
						{
							data = HttpService:JSONEncode(identificationResults.adIDStats)
						}
					}
				}
			end
		end

		if #p3.screenshotId > 0 then
			p2.SCREENSHOT_ID = {
				valueList = {
					{ data = p3.screenshotId }
				}
			}
		end

		return p2
	end
}
