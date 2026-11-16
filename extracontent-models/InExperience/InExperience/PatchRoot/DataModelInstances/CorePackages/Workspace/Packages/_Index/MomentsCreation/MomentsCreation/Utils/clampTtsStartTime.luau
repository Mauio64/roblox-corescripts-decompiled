local MomentsCreation = script:FindFirstAncestor("MomentsCreation")

local GetFIntMomentsTTSStartTimeMinTailSeconds = require(MomentsCreation.Flags.GetFIntMomentsTTSStartTimeMinTailSeconds)

local function clampTtsStartTime(value: number, p: number)
	return (math.clamp(value, 0, (math.max(0, p - GetFIntMomentsTTSStartTimeMinTailSeconds()))))
end

return clampTtsStartTime
