local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local HttpService = game:GetService("HttpService")
local GetFFlagReportAnythingEnableAdReport = require(Parent.SharedFlags).GetFFlagReportAnythingEnableAdReport

local function transformVectorArray(t1: {[any]: any}) -- line: 70
	local t2 = {}

	for _, v in ipairs(t1) do
		t2[#t2 + 1] = {
			v.X,
			v.Y
		}
	end

	return t2
end
local function transformIdentifiedAds(t3: {[any]: any}) -- line: 78
	local t4 = {}

	for _, v in pairs(t3) do
		t4[#t4 + 1] = {
			assetId = v.assetId,
			distance = v.distance,
			boundingBox = {
				minX = v.boundingBox.min.X,
				minY = v.boundingBox.min.Y,
				maxX = v.boundingBox.max.X,
				maxY = v.boundingBox.max.Y
			},
			adUnitName = v.adUnitName,
			encryptedAdTrackingData = v.encryptedAdTrackingData,
			encryptionMetadata = v.encryptionMetadata
		}
	end

	return t4
end
local function transformIdentifiedAvatars(t5: {[any]: any}) -- line: 98
	-- upvalues: transformVectorArray (copy)
	local t6 = {}

	for k, v in pairs(t5) do
		local t7 = {
			userId = tostring(k),
			distance = v.distance,
			boundingBox = {
				minX = v.boundingBox.min.X,
				minY = v.boundingBox.min.Y,
				maxX = v.boundingBox.max.X,
				maxY = v.boundingBox.max.Y
			},
			hitRate = v.hitRate,
			convexHull = transformVectorArray(v.convexHull)
		}

		if v.pointProcessingStats ~= nil then
			t7.pointProcessingStats = {
				not v.pointProcessingStats.wasSkipped and 0 or 1,
				v.pointProcessingStats.total,
				v.pointProcessingStats.offScreenDiscardCount,
				v.pointProcessingStats.tooCloseDiscardCount
			}
		end

		t6[#t6 + 1] = t7
	end

	return t6
end
local function hasIdentifiedAvatars(t8: {[any]: any}) -- line: 130
	for _ in pairs(t8.identifiedAvatars) do
		return true
	end

	return false
end
local function hasIdentifiedAds(t9: {[any]: any}) -- line: 137
	for _ in pairs(t9.identifiedAds) do
		return true
	end

	return false
end

return {
	appendReportAnythingTags = function(t10: {[any]: any}, t11: {[any]: any}?) -- line: 144
		-- upvalues: HttpService (copy), transformIdentifiedAvatars (copy), GetFFlagReportAnythingEnableAdReport (copy), transformIdentifiedAds (copy)
		if not t11 then
			return t10
		end

		local identificationResults = t11.identificationResults
		local g31 = nil
		local v30 = nil
		local g34 = nil
		local v33 = nil

		for _ in pairs(identificationResults.identifiedAvatars) do
			v30 = true
			g31 = true

			if g31 then
				break
			end
		end

		if not g31 then
			v30 = false
		end

		g31 = false

		if v30 then
			t10.IDENTIFIED_AVATARS = {
				valueList = {{
					data = HttpService:JSONEncode((transformIdentifiedAvatars(identificationResults.identifiedAvatars)))
				}}
			}
		end

		if identificationResults.avatarIDStats then
			t10.AVATAR_ID_STATS = {
				valueList = {{
					data = HttpService:JSONEncode(identificationResults.avatarIDStats)
				}}
			}
		end

		if GetFFlagReportAnythingEnableAdReport() then
			for _ in pairs(identificationResults.identifiedAds) do
				v33 = true
				g34 = true

				if g34 then
					break
				end
			end

			if not g34 then
				v33 = false
			end

			g34 = false

			if v33 then
				t10.IDENTIFIED_ADS = {
					valueList = {{
						data = HttpService:JSONEncode((transformIdentifiedAds(identificationResults.identifiedAds)))
					}}
				}
			end

			if identificationResults.adIDStats then
				t10.AD_ID_STATS = {
					valueList = {{
						data = HttpService:JSONEncode(identificationResults.adIDStats)
					}}
				}
			end
		end

		if #t11.screenshotId > 0 then
			t10.SCREENSHOT_ID = {
				valueList = {{
					data = t11.screenshotId
				}}
			}
		end

		return t10
	end
}
