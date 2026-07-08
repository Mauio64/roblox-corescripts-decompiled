local CrossExperience = script:FindFirstAncestor("CrossExperience")
local Constants = require(CrossExperience.Constants)

require(CrossExperience.Types)

local VOICE_STATUS = Constants.VOICE_STATUS
local t1 = {
	[VOICE_STATUS.ERROR_VOICE_INIT] = true,
	[VOICE_STATUS.ERROR_VOICE_SETUP] = true,
	[VOICE_STATUS.ERROR_VOICE_JOIN] = true,
	[VOICE_STATUS.ERROR_VOICE_MIC_REJECTED] = true,
	[VOICE_STATUS.ERROR_VOICE_MODERATED] = true,
	[VOICE_STATUS.ERROR_VOICE_FAILED] = true
}
local t2 = {
	[VOICE_STATUS.ERROR_START_BACKGROUND_DM] = true,
	[VOICE_STATUS.ERROR_RCC_CONNECTING] = true,
	[VOICE_STATUS.ERROR_VOICE_DISCONNECTED] = true,
	[VOICE_STATUS.ERROR_RCC_TIMEOUT] = true,
	[VOICE_STATUS.ERROR_BACKGROUND_DM_LOAD_LOCALPLAYER_TIMEOUT] = true
}

t1[VOICE_STATUS.ERROR_VOICE_MIC_REJECTED] = nil

function isVoiceRetriableErrorByGameJoin(p1) -- line: 29
	-- upvalues: t2 (copy)
	if p1 == nil then
		return false
	end

	return t2[p1] == true
end
function isMicPermissionsError(p2) -- line: 36
	-- upvalues: VOICE_STATUS (copy)
	if p2 == nil then
		return false
	end

	return p2 == VOICE_STATUS.ERROR_VOICE_MIC_REJECTED
end
function isVoiceRetriableErrorByVoiceJoin(p3) -- line: 43
	-- upvalues: t1 (copy)
	if p3 == nil then
		return false
	end

	return t1[p3] == true
end
function isVoiceRetriableError(p4) -- line: 51
	return isVoiceRetriableErrorByGameJoin(p4) or isVoiceRetriableErrorByVoiceJoin(p4)
end

return {
	isVoiceRetriableError = isVoiceRetriableError,
	isVoiceRetriableErrorByGameJoin = isVoiceRetriableErrorByGameJoin,
	isVoiceRetriableErrorByVoiceJoin = isVoiceRetriableErrorByVoiceJoin,
	isMicPermissionsError = isMicPermissionsError
}
