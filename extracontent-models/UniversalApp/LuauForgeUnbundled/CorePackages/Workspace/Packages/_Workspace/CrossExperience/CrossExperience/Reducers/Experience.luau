local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/dependencies")

local rodux = dependencies.Rodux
local cryo = dependencies.Cryo
local sharedFlags = dependencies.SharedFlags

local experienceJoined = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").ExperienceJoined
local experienceLeft = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").ExperienceLeft
local restoreState = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").RestoreState
local voiceStatusChanged = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").VoiceStatusChanged

require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Types")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Constants")

local fStringTimeoutLoadingLocalPlayerInBackgroundDM = sharedFlags.FStringTimeoutLoadingLocalPlayerInBackgroundDM

local VOICE_STATUS = Constants.VOICE_STATUS

local v5 = {
	jobId = nil,
	gameId = nil,
	placeId = nil,
	voiceStatus = VOICE_STATUS.DISCONNECTED,
	voiceChannelId = nil,
	voiceSessionId = nil
}

local function isAllowedVoiceStatusTransition(p2, p3): boolean
	if
		sharedFlags.GetFFlagFixPartyVoiceGetPermissions()
		and p2 == VOICE_STATUS.ERROR_VOICE_MIC_REJECTED
	then
		return p3 == VOICE_STATUS.VOICE_CONNECTING
	end

	return p2 ~= p3
end

return function(p2)
	return rodux.createReducer(p2 or v5, {
		[experienceJoined.name] = function(p3, p4)
			local payload = p4.payload
			return cryo.Dictionary.join(p3, {
				jobId = payload.jobId,
				gameId = payload.gameId,
				placeId = payload.placeId
			})
		end,
		[experienceLeft.name] = function(p3)
			local voiceStatus = p3.voiceStatus
			local v8 = p3.voiceStatus

			if
				voiceStatus ~= Constants.VOICE_STATUS.ERROR_VOICE_DISCONNECTED
				and voiceStatus ~= Constants.VOICE_STATUS.ERROR_START_BACKGROUND_DM
				and voiceStatus ~= Constants.VOICE_STATUS.ERROR_RCC_CONNECTING
				and voiceStatus ~= Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT
				and (fStringTimeoutLoadingLocalPlayerInBackgroundDM == Constants.LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable or voiceStatus ~= Constants.VOICE_STATUS.ERROR_BACKGROUND_DM_LOAD_LOCALPLAYER_TIMEOUT)
			then
				v8 = Constants.VOICE_STATUS.DISCONNECTED
			end

			return {
				jobId = nil,
				gameId = nil,
				placeId = nil,
				voiceChannelId = nil,
				voiceSessionId = nil,
				voiceStatus = v8
			}
		end,
		[restoreState.name] = function(p3, p4)
			if p4.payload.Experience then
				return cryo.Dictionary.join({}, p4.payload.Experience)
			end

			return p3
		end,
		[voiceStatusChanged.name] = function(p3, p4)
			local voiceStatus = p3.voiceStatus
			local status = p4.payload.status
			local v8

			if
				sharedFlags.GetFFlagFixPartyVoiceGetPermissions()
				and voiceStatus == VOICE_STATUS.ERROR_VOICE_MIC_REJECTED
			then
				v8 = status == VOICE_STATUS.VOICE_CONNECTING
			else
				v8 = voiceStatus ~= status
			end

			if not v8 then
				return p3
			end

			local joined = cryo.Dictionary.join(p3, { voiceStatus = p4.payload.status })

			if p4.payload.status == VOICE_STATUS.VOICE_CONNECTED then
				joined = cryo.Dictionary.join(joined, {
					voiceChannelId = p4.payload.voiceChannelId,
					voiceSessionId = p4.payload.voiceSessionId
				})
			end

			return joined
		end
	})
end
