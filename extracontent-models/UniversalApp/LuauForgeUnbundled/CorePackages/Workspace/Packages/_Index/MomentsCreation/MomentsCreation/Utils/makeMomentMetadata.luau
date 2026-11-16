require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")

local function makeMomentMetadata(data, description, edits, assetTotalDuration, commentsEnabled)
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
