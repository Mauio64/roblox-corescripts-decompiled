local MomentsCreation = script:FindFirstAncestor("MomentsCreation")

require(MomentsCreation.Types.CreationFlowTypes)
local FFlagMomentsTTSTooManyDigitsError = require(MomentsCreation.Flags.FFlagMomentsTTSTooManyDigitsError)

local v = {
	FilteredText = "moderated",
	FilteredAudio = "moderated",
	NotEnoughQuota = "quotaExceeded",
	["Rate limited by the client"] = "quotaExceeded",
	Timeout = "timeout"
}

local function classifyTTSError(p: string?)
	if p == nil then
		return "failure"
	end

	if FFlagMomentsTTSTooManyDigitsError and p == "TooManyDigits" then
		return "tooManyDigits"
	end

	return v[p] or "failure"
end

return classifyTTSError
