local CrossExperience = script:FindFirstAncestor("CrossExperience")
local dependencies = require(CrossExperience.dependencies)

local rodux = dependencies.Rodux
local cryo = dependencies.Cryo
local sharedFlags = dependencies.SharedFlags

local Actions = require(CrossExperience.Actions)
local ExperienceJoined = Actions.ExperienceJoined
local Actions2 = require(CrossExperience.Actions)
local ExperienceLeft = Actions2.ExperienceLeft
local Actions3 = require(CrossExperience.Actions)
local RestoreState = Actions3.RestoreState
local Actions4 = require(CrossExperience.Actions)
local VoiceStatusChanged = Actions4.VoiceStatusChanged

require(CrossExperience.Types)
local Constants = require(CrossExperience.Constants)

local fStringTimeoutLoadingLocalPlayerInBackgroundDM = sharedFlags.FStringTimeoutLoadingLocalPlayerInBackgroundDM

local VOICE_STATUS = Constants.VOICE_STATUS

local v = {
	jobId = nil,
	gameId = nil,
	placeId = nil,
	voiceStatus = VOICE_STATUS.DISCONNECTED,
	voiceChannelId = nil,
	voiceSessionId = nil
}

local function isAllowedVoiceStatusTransition(voiceStatus, status): boolean -- 1 equivalent call inferred from this helper
	if sharedFlags.GetFFlagFixPartyVoiceGetPermissions() and voiceStatus == VOICE_STATUS.ERROR_VOICE_MIC_REJECTED then
		return status == VOICE_STATUS.VOICE_CONNECTING
	end

	return voiceStatus ~= status
end

return function(p)
	return rodux.createReducer(p or v, {
		[ExperienceJoined.name] = function(p2, p3)
			local payload = p3.payload
			return cryo.Dictionary.join(p2, {
				jobId = payload.jobId,
				gameId = payload.gameId,
				placeId = payload.placeId
			})
		end,
		[ExperienceLeft.name] = function(p2)
			local voiceStatus = p2.voiceStatus
			local voiceStatus2 = p2.voiceStatus

			if
				voiceStatus ~= Constants.VOICE_STATUS.ERROR_VOICE_DISCONNECTED
				and voiceStatus ~= Constants.VOICE_STATUS.ERROR_START_BACKGROUND_DM
				and voiceStatus ~= Constants.VOICE_STATUS.ERROR_RCC_CONNECTING
				and voiceStatus ~= Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT
				and (fStringTimeoutLoadingLocalPlayerInBackgroundDM == Constants.LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable or voiceStatus ~= Constants.VOICE_STATUS.ERROR_BACKGROUND_DM_LOAD_LOCALPLAYER_TIMEOUT)
			then
				voiceStatus2 = Constants.VOICE_STATUS.DISCONNECTED
			end

			return {
				jobId = nil,
				gameId = nil,
				placeId = nil,
				voiceChannelId = nil,
				voiceSessionId = nil,
				voiceStatus = voiceStatus2
			}
		end,
		[RestoreState.name] = function(p2, p3)
			if p3.payload.Experience then
				return cryo.Dictionary.join({}, p3.payload.Experience)
			end

			return p2
		end,
		[VoiceStatusChanged.name] = function(p2, p3)
			if not isAllowedVoiceStatusTransition(p2.voiceStatus, p3.payload.status) then -- inferred equivalent call
				return p2
			end

			local joined = cryo.Dictionary.join(p2, { voiceStatus = p3.payload.status })

			if p3.payload.status == VOICE_STATUS.VOICE_CONNECTED then
				joined = cryo.Dictionary.join(joined, {
					voiceChannelId = p3.payload.voiceChannelId,
					voiceSessionId = p3.payload.voiceSessionId
				})
			end

			return joined
		end
	})
end
