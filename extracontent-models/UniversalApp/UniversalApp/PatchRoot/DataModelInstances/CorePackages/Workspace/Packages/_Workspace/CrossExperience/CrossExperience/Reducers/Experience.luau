local CrossExperience = script:FindFirstAncestor("CrossExperience")
local dependencies = require(CrossExperience.dependencies)
local Rodux = dependencies.Rodux
local Cryo = dependencies.Cryo
local SharedFlags = dependencies.SharedFlags
local ExperienceJoined = require(CrossExperience.Actions).ExperienceJoined
local ExperienceLeft = require(CrossExperience.Actions).ExperienceLeft
local RestoreState = require(CrossExperience.Actions).RestoreState
local VoiceStatusChanged = require(CrossExperience.Actions).VoiceStatusChanged

require(CrossExperience.Types)

local Constants = require(CrossExperience.Constants)
local FStringTimeoutLoadingLocalPlayerInBackgroundDM = SharedFlags.FStringTimeoutLoadingLocalPlayerInBackgroundDM
local VOICE_STATUS = Constants.VOICE_STATUS
local t1 = {
	jobId = nil,
	gameId = nil,
	placeId = nil,
	voiceChannelId = nil,
	voiceSessionId = nil,
	voiceStatus = VOICE_STATUS.DISCONNECTED
}

local function isAllowedVoiceStatusTransition(p1, p2) -- line: 29
	-- upvalues: SharedFlags (copy), VOICE_STATUS (copy)
	if SharedFlags.GetFFlagFixPartyVoiceGetPermissions() and p1 == VOICE_STATUS.ERROR_VOICE_MIC_REJECTED then
		return p2 == VOICE_STATUS.VOICE_CONNECTING
	end

	return p1 ~= p2
end

return function(p3) -- line: 43
	-- upvalues: Rodux (copy), t1 (copy), ExperienceJoined (copy), Cryo (copy), ExperienceLeft (copy), Constants (copy), FStringTimeoutLoadingLocalPlayerInBackgroundDM (copy), RestoreState (copy), VoiceStatusChanged (copy), SharedFlags (copy), VOICE_STATUS (copy)
	return Rodux.createReducer(p3 or t1, {
		[ExperienceJoined.name] = function(p4, p5) -- line: 46
			-- upvalues: Cryo (copy)
			local payload = p5.payload

			return Cryo.Dictionary.join(p4, {
				jobId = payload.jobId,
				gameId = payload.gameId,
				placeId = payload.placeId
			})
		end,
		[ExperienceLeft.name] = function(p6) -- line: 55
			-- upvalues: Constants (copy), FStringTimeoutLoadingLocalPlayerInBackgroundDM (copy)
			local voiceStatus = p6.voiceStatus
			local voiceStatus2 = p6.voiceStatus

			if voiceStatus ~= Constants.VOICE_STATUS.ERROR_VOICE_DISCONNECTED and (voiceStatus ~= Constants.VOICE_STATUS.ERROR_START_BACKGROUND_DM and voiceStatus ~= Constants.VOICE_STATUS.ERROR_RCC_CONNECTING and voiceStatus ~= Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT) and (FStringTimeoutLoadingLocalPlayerInBackgroundDM == Constants.LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable or voiceStatus ~= Constants.VOICE_STATUS.ERROR_BACKGROUND_DM_LOAD_LOCALPLAYER_TIMEOUT) then
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
		[RestoreState.name] = function(p7, p8) -- line: 84
			-- upvalues: Cryo (copy)
			if p8.payload.Experience then
				return Cryo.Dictionary.join({}, p8.payload.Experience)
			end

			return p7
		end,
		[VoiceStatusChanged.name] = function(p9, p10) -- line: 91
			-- upvalues: SharedFlags (copy), VOICE_STATUS (copy), Cryo (copy)
			local voiceStatus = p9.voiceStatus
			local status = p10.payload.status

			if if not SharedFlags.GetFFlagFixPartyVoiceGetPermissions() or voiceStatus ~= VOICE_STATUS.ERROR_VOICE_MIC_REJECTED then voiceStatus ~= status else status == VOICE_STATUS.VOICE_CONNECTING then
				local v30 = Cryo.Dictionary.join(p9, {
					voiceStatus = p10.payload.status
				})

				if p10.payload.status == VOICE_STATUS.VOICE_CONNECTED then
					v30 = Cryo.Dictionary.join(v30, {
						voiceChannelId = p10.payload.voiceChannelId,
						voiceSessionId = p10.payload.voiceSessionId
					})
				end

				return v30
			end

			return p9
		end
	})
end
