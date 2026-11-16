local parent = script:FindFirstAncestor("ProfilePlatform").Parent

require(parent.DataHydration.MomentsStoreTypes)

local function isPlayableVideoMoment(p): boolean
	return p.metadata.isMomentScene ~= true and p.metadata.captureType == Enum.CaptureType.Video
end

return isPlayableVideoMoment
