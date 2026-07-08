local Parent = script:FindFirstAncestor("MomentsCreationFlow").Parent
local MomentsCommon = require(Parent.MomentsCommon)
local AttributeType = MomentsCommon.Enums.AttributeType
local getTagsForMoment = MomentsCommon.Utils.getTagsForMoment

local function makeRegistrationInfo(p1, p2) -- line: 12
	-- upvalues: AttributeType (copy), getTagsForMoment (copy)
	local edits = p2.edits
	local t1 = {}
	local v10

	if edits and edits.trim then
		table.insert(t1, {
			AssetId = 0,
			Description = AttributeType.PrimaryAsset,
			TrimStartTime = edits.trim.startTime
		})
		v10 = edits.trim.endTime - edits.trim.startTime
	else
		table.insert(t1, {
			AssetId = 0,
			TrimStartTime = 0,
			Description = AttributeType.PrimaryAsset
		})
		v10 = p2.assetTotalDuration
	end

	if edits and edits.music then
		table.insert(t1, {
			AssetId = edits.music.assetId,
			Description = AttributeType.Music,
			TrimStartTime = edits.music.startTime
		})
	end

	return {
		attributes = t1,
		contentType = if p1.CaptureType ~= Enum.CaptureType.Screenshot then Enum.RecommendationItemContentType.Dynamic else Enum.RecommendationItemContentType.Static,
		customTags = getTagsForMoment(p2),
		duration = v10
	}
end

return makeRegistrationInfo
