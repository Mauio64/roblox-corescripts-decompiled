local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Constants")
require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Types")
local VOICE_STATUS = Constants.VOICE_STATUS

local v5 = {
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

v5[VOICE_STATUS.ERROR_VOICE_MIC_REJECTED] = nil

function LUAUFORGE_MODULE_GLOBALS_boO_isVoiceRetriableErrorByGameJoin(p2): boolean
	if p2 == nil then
		return false
	end

	return set[p2] == true
end

function LUAUFORGE_MODULE_GLOBALS_boO_isMicPermissionsError(p2): boolean
	if p2 == nil then
		return false
	end

	return p2 == VOICE_STATUS.ERROR_VOICE_MIC_REJECTED
end

function LUAUFORGE_MODULE_GLOBALS_boO_isVoiceRetriableErrorByVoiceJoin(p2): boolean
	if p2 == nil then
		return false
	end

	return v5[p2] == true
end

function LUAUFORGE_MODULE_GLOBALS_boO_isVoiceRetriableError(p2)
	return LUAUFORGE_MODULE_GLOBALS_boO_isVoiceRetriableErrorByGameJoin(p2)
		or LUAUFORGE_MODULE_GLOBALS_boO_isVoiceRetriableErrorByVoiceJoin(p2)
end

return {
	isVoiceRetriableError = LUAUFORGE_MODULE_GLOBALS_boO_isVoiceRetriableError,
	isVoiceRetriableErrorByGameJoin = LUAUFORGE_MODULE_GLOBALS_boO_isVoiceRetriableErrorByGameJoin,
	isVoiceRetriableErrorByVoiceJoin = LUAUFORGE_MODULE_GLOBALS_boO_isVoiceRetriableErrorByVoiceJoin,
	isMicPermissionsError = LUAUFORGE_MODULE_GLOBALS_boO_isMicPermissionsError
}
