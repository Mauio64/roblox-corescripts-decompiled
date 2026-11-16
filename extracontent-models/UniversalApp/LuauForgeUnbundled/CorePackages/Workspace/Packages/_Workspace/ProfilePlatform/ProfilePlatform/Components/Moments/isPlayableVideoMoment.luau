require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration/MomentsStoreTypes")

local function isPlayableVideoMoment(p2): boolean
	if p2.metadata.isMomentScene == true then
		return false
	end

	return p2.metadata.captureType == Enum.CaptureType.Video
end

return isPlayableVideoMoment
