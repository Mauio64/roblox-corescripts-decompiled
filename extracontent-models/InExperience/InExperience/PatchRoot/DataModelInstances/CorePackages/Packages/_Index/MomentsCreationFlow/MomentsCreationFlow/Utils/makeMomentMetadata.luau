local parent = script:FindFirstAncestor("MomentsCreationFlow").Parent

local MomentsCommon = require(parent.MomentsCommon)

local function makeMomentMetadata(data, description: string?, edits)
	local assetTotalDuration

	if data.CaptureType == Enum.CaptureType.Screenshot then
		assetTotalDuration = MomentsCommon.Constants.ScreenshotMusicDuration
	else
		assetTotalDuration = data.TimeLength
	end

	return {
		assetTotalDuration = assetTotalDuration,
		captureType = data.CaptureType,
		description = description,
		universeId = data.SourceUniverseId,
		placeId = data.SourcePlaceId,
		edits = edits
	}
end

return makeMomentMetadata
