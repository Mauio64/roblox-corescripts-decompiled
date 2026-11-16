local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

require(parent.MomentsTypes)

local Constants = require(MomentsCreation.Constants)

local function makeMomentMetadata(data, description: string?, edits, assetTotalDuration: number?, commentsEnabled: boolean?)
	if data.CaptureType == Enum.CaptureType.Screenshot then
		assetTotalDuration = Constants.ScreenshotMusicDuration
	elseif assetTotalDuration == nil or not (assetTotalDuration > 0) then
		assetTotalDuration = data.TimeLength
	end

	return {
		assetTotalDuration = assetTotalDuration,
		captureType = data.CaptureType,
		description = description,
		universeId = data.SourceUniverseId,
		placeId = data.SourcePlaceId,
		edits = edits,
		commentsEnabled = commentsEnabled
	}
end

return makeMomentMetadata
