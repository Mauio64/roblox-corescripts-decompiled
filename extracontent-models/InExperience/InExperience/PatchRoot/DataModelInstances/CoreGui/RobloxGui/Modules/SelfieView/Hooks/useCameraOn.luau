local useTrackerMode = require(script.Parent.useTrackerMode)

local function useCameraOn(): boolean
	local v = useTrackerMode()
	return v == Enum.TrackerMode.Video or v == Enum.TrackerMode.AudioVideo
end

return useCameraOn
