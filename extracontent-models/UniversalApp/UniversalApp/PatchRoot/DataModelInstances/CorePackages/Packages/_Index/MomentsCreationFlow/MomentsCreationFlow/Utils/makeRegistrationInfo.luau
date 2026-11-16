local parent = script:FindFirstAncestor("MomentsCreationFlow").Parent

local MomentsCommon = require(parent.MomentsCommon)

local AttributeType = MomentsCommon.Enums.AttributeType
local getTagsForMoment = MomentsCommon.Utils.getTagsForMoment

local function makeRegistrationInfo(p, p2)
	local edits = p2.edits
	local attributes = {}
	local duration

	if edits and edits.trim then
		table.insert(attributes, {
			AssetId = 0,
			Description = AttributeType.PrimaryAsset,
			TrimStartTime = edits.trim.startTime
		})

		duration = edits.trim.endTime - edits.trim.startTime
	else
		table.insert(attributes, {
			AssetId = 0,
			Description = AttributeType.PrimaryAsset,
			TrimStartTime = 0
		})

		duration = p2.assetTotalDuration
	end

	if edits and edits.music then
		table.insert(attributes, {
			AssetId = edits.music.assetId,
			Description = AttributeType.Music,
			TrimStartTime = edits.music.startTime
		})
	end

	local contentType

	if p.CaptureType == Enum.CaptureType.Screenshot then
		contentType = Enum.RecommendationItemContentType.Static
	else
		contentType = Enum.RecommendationItemContentType.Dynamic
	end

	return {
		attributes = attributes,
		contentType = contentType,
		customTags = getTagsForMoment(p2),
		duration = duration
	}
end

return makeRegistrationInfo
