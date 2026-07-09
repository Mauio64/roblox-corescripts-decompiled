local Parent = script:FindFirstAncestor("MomentsCreation").Parent

require(Parent.MomentsTypes)

local function makeMomentMetadata(p1, s1: string?, p2) -- line: 27
	return {
		assetTotalDuration = if p1.CaptureType ~= Enum.CaptureType.Screenshot then p1.TimeLength else 7,
		captureType = p1.CaptureType,
		description = s1,
		universeId = p1.SourceUniverseId,
		placeId = p1.SourcePlaceId,
		edits = p2
	}
end

return makeMomentMetadata
