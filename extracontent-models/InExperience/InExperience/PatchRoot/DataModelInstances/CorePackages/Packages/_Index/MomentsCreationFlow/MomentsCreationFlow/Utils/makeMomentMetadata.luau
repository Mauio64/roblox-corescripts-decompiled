local Parent = script:FindFirstAncestor("MomentsCreationFlow").Parent
local MomentsCommon = require(Parent.MomentsCommon)

local function makeMomentMetadata(p1, s1: string?, p2) -- line: 9
	-- upvalues: MomentsCommon (copy)
	return {
		assetTotalDuration = if p1.CaptureType ~= Enum.CaptureType.Screenshot then p1.TimeLength else MomentsCommon.Constants.ScreenshotMusicDuration,
		captureType = p1.CaptureType,
		description = s1,
		universeId = p1.SourceUniverseId,
		placeId = p1.SourcePlaceId,
		edits = p2
	}
end

return makeMomentMetadata
