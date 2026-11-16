require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
local FFlagMomentsTTSTooManyDigitsError = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSTooManyDigitsError")

local v5 = {
	FilteredText = "moderated",
	FilteredAudio = "moderated",
	NotEnoughQuota = "quotaExceeded",
	["Rate limited by the client"] = "quotaExceeded",
	Timeout = "timeout"
}

local function classifyTTSError(p2)
	if p2 == nil then
		return "failure"
	end

	if FFlagMomentsTTSTooManyDigitsError and p2 == "TooManyDigits" then
		return "tooManyDigits"
	end

	return v5[p2] or "failure"
end

return classifyTTSError
