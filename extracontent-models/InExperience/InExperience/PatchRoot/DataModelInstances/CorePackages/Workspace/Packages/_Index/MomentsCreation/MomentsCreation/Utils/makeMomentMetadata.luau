local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent

require(MomentsCreationParent.MomentsTypes)

local Constants = require(MomentsCreation.Constants)

local function makeMomentMetadata(p1, s1: string?, p2, n1: number?) -- line: 27
	-- upvalues: Constants (copy)
	return {
		assetTotalDuration = if p1.CaptureType ~= Enum.CaptureType.Screenshot then if n1 == nil or not (n1 > 0) then p1.TimeLength else n1 else Constants.ScreenshotMusicDuration,
		captureType = p1.CaptureType,
		description = s1,
		universeId = p1.SourceUniverseId,
		placeId = p1.SourcePlaceId,
		edits = p2
	}
end

return makeMomentMetadata
