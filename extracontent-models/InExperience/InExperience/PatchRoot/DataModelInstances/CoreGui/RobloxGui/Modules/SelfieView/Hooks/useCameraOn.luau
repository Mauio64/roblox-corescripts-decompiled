local useTrackerMode = require(script.Parent.useTrackerMode)

local function useCameraOn() -- line: 5
	-- upvalues: useTrackerMode (copy)
	local v3 = useTrackerMode()

	return v3 == Enum.TrackerMode.Video or v3 == Enum.TrackerMode.AudioVideo
end

return useCameraOn
