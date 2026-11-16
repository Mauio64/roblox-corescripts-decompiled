local CrossExperience = script:FindFirstAncestor("CrossExperience")

local Constants = require(CrossExperience.Constants)
require(CrossExperience.Types)
local VOICE_STATUS = Constants.VOICE_STATUS

local v = {
	[VOICE_STATUS.ERROR_VOICE_INIT] = true,
	[VOICE_STATUS.ERROR_VOICE_SETUP] = true,
	[VOICE_STATUS.ERROR_VOICE_JOIN] = true,
	[VOICE_STATUS.ERROR_VOICE_MIC_REJECTED] = true,
	[VOICE_STATUS.ERROR_VOICE_MODERATED] = true,
	[VOICE_STATUS.ERROR_VOICE_FAILED] = true
}

local set = {
	[VOICE_STATUS.ERROR_START_BACKGROUND_DM] = true,
	[VOICE_STATUS.ERROR_RCC_CONNECTING] = true,
	[VOICE_STATUS.ERROR_VOICE_DISCONNECTED] = true,
	[VOICE_STATUS.ERROR_RCC_TIMEOUT] = true,
	[VOICE_STATUS.ERROR_BACKGROUND_DM_LOAD_LOCALPLAYER_TIMEOUT] = true
}

v[VOICE_STATUS.ERROR_VOICE_MIC_REJECTED] = nil

function isVoiceRetriableErrorByGameJoin(p): boolean
	return p ~= nil and set[p] == true
end

function isMicPermissionsError(p): boolean
	return p ~= nil and p == VOICE_STATUS.ERROR_VOICE_MIC_REJECTED
end

function isVoiceRetriableErrorByVoiceJoin(p): boolean
	return p ~= nil and v[p] == true
end

function isVoiceRetriableError(p)
	return isVoiceRetriableErrorByGameJoin(p) or isVoiceRetriableErrorByVoiceJoin(p)
end

return {
	isVoiceRetriableError = isVoiceRetriableError,
	isVoiceRetriableErrorByGameJoin = isVoiceRetriableErrorByGameJoin,
	isVoiceRetriableErrorByVoiceJoin = isVoiceRetriableErrorByVoiceJoin,
	isMicPermissionsError = isMicPermissionsError
}
