local GetFIntMomentsTTSStartTimeMinTailSeconds = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFIntMomentsTTSStartTimeMinTailSeconds")

local function clampTtsStartTime(value, p2)
	return (math.clamp(value, 0, (math.max(0, p2 - GetFIntMomentsTTSStartTimeMinTailSeconds()))))
end

return clampTtsStartTime
