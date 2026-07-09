local CrossExperience = script:FindFirstAncestor("CrossExperience")
local dependencies = require(CrossExperience.dependencies)
local Rodux = dependencies.Rodux
local Cryo = dependencies.Cryo
local ParticipantAdded = require(CrossExperience.Actions).ParticipantAdded
local ParticipantRemoved = require(CrossExperience.Actions).ParticipantRemoved
local ParticipantIsActive = require(CrossExperience.Actions).ParticipantIsActive
local ParticipantIsInactive = require(CrossExperience.Actions).ParticipantIsInactive
local ParticipantWasMuted = require(CrossExperience.Actions).ParticipantWasMuted
local ParticipantWasUnmuted = require(CrossExperience.Actions).ParticipantWasUnmuted
local VoiceChangerWasEnabled = require(CrossExperience.Actions).VoiceChangerWasEnabled
local VoiceChangerWasDisabled = require(CrossExperience.Actions).VoiceChangerWasDisabled
local VoicePackWasSet = require(CrossExperience.Actions).VoicePackWasSet
local VoiceChangerFeedbackWasEnabled = require(CrossExperience.Actions).VoiceChangerFeedbackWasEnabled
local VoiceChangerFeedbackWasDisabled = require(CrossExperience.Actions).VoiceChangerFeedbackWasDisabled
local ParticipantAudioFocusChanged = require(CrossExperience.Actions).ParticipantAudioFocusChanged
local ExperienceJoined = require(CrossExperience.Actions).ExperienceJoined
local ExperienceLeft = require(CrossExperience.Actions).ExperienceLeft
local RestoreState = require(CrossExperience.Actions).RestoreState
local MuteParticipant = require(CrossExperience.Actions).MuteParticipant
local UnmuteParticipant = require(CrossExperience.Actions).UnmuteParticipant

require(CrossExperience.Types)

local Utils = require(CrossExperience.Utils)
local t1 = {
	participants = {},
	activeUserIds = {},
	publicVoiceFocusedUserIds = {}
}

return function(p1) -- line: 67
	-- upvalues: Rodux (copy), t1 (copy), Utils (copy), ParticipantAdded (copy), Cryo (copy), ParticipantRemoved (copy), ParticipantWasMuted (copy), ParticipantWasUnmuted (copy), VoiceChangerWasEnabled (copy), VoiceChangerWasDisabled (copy), VoicePackWasSet (copy), VoiceChangerFeedbackWasEnabled (copy), VoiceChangerFeedbackWasDisabled (copy), ParticipantIsActive (copy), ParticipantIsInactive (copy), ExperienceJoined (copy), RestoreState (copy), ParticipantAudioFocusChanged (copy), MuteParticipant (copy), UnmuteParticipant (copy), ExperienceLeft (copy)
	local createReducer = Rodux.createReducer
	local v28 = t1

	if p1 then
		v28.participants = Utils.stringMapToNumberMap(p1.participants)
		v28.activeUserIds = p1.activeUserIds
		v28.publicVoiceFocusedUserIds = Utils.stringMapToNumberMap(p1.publicVoiceFocusedUserIds)
	end

	return createReducer(v28, {
		[ParticipantAdded.name] = function(p2, p3) -- line: 70
			-- upvalues: Cryo (copy)
			local participant = p3.payload.participant

			if not p2.participants[participant.userId] then
				local v32 = table.clone(p2.participants)

				v32[participant.userId] = participant

				return Cryo.Dictionary.join(p2, {
					participants = v32
				})
			end

			return p2
		end,
		[ParticipantRemoved.name] = function(p4, p5) -- line: 84
			-- upvalues: Cryo (copy)
			local userId = p5.payload.userId

			if p4.participants[userId] then
				local v36 = table.clone(p4.participants)
				local v37 = table.clone(p4.activeUserIds)
				local publicVoiceFocusedUserIds = p4.publicVoiceFocusedUserIds
				local v39 = table.find(v37, userId)

				v36[userId] = nil

				if publicVoiceFocusedUserIds[userId] then
					publicVoiceFocusedUserIds = table.clone(p4.publicVoiceFocusedUserIds)
					publicVoiceFocusedUserIds[userId] = nil
				end

				if v39 then
					table.remove(v37, v39)
				end

				return Cryo.Dictionary.join(p4, {
					participants = v36,
					activeUserIds = v37,
					publicVoiceFocusedUserIds = publicVoiceFocusedUserIds
				})
			end

			return p4
		end,
		[ParticipantWasMuted.name] = function(p6, p7) -- line: 113
			-- upvalues: Cryo (copy)
			local userId = p7.payload.userId

			if p6.participants[userId] then
				local participants = p6.participants
				local activeUserIds = p6.activeUserIds
				local v45 = table.find(activeUserIds, userId)

				if not participants[userId].isMuted then
					participants = table.clone(p6.participants)
					participants[userId].isMuted = true
				end

				if v45 then
					activeUserIds = table.clone(p6.activeUserIds)
					table.remove(activeUserIds, v45)
				end

				return Cryo.Dictionary.join(p6, {
					participants = participants,
					activeUserIds = activeUserIds
				})
			end

			return p6
		end,
		[ParticipantWasUnmuted.name] = function(p8, p9) -- line: 140
			-- upvalues: Cryo (copy)
			local userId = p9.payload.userId

			if p8.participants[userId] and p8.participants[userId].isMuted then
				local v49 = table.clone(p8.participants)

				v49[userId].isMuted = false

				return Cryo.Dictionary.join(p8, {
					participants = v49
				})
			end

			return p8
		end,
		[VoiceChangerWasEnabled.name] = function(p10, p11) -- line: 156
			-- upvalues: Cryo (copy)
			local userId = p11.payload.userId

			if p10.participants[userId] then
				local v53 = table.clone(p10.participants)
				local v54 = table.clone(p10.participants[userId])

				v54.isVoiceChangerActive = true
				v53[userId] = v54

				return Cryo.Dictionary.join(p10, {
					participants = v53
				})
			end

			return p10
		end,
		[VoiceChangerWasDisabled.name] = function(p12, p13) -- line: 175
			-- upvalues: Cryo (copy)
			local userId = p13.payload.userId

			if p12.participants[userId] then
				local v58 = table.clone(p12.participants)
				local v59 = table.clone(p12.participants[userId])

				v59.isVoiceChangerActive = false
				v58[userId] = v59

				return Cryo.Dictionary.join(p12, {
					participants = v58
				})
			end

			return p12
		end,
		[VoicePackWasSet.name] = function(p14, p15) -- line: 194
			-- upvalues: Cryo (copy)
			local userId = p15.payload.userId

			if p14.participants[userId] then
				local v63 = table.clone(p14.participants)
				local v64 = table.clone(p14.participants[userId])

				v64.selectedVoicePack = p15.payload.voicePackName or "None"
				v63[userId] = v64

				return Cryo.Dictionary.union(p14, {
					participants = v63
				})
			end

			return p14
		end,
		[VoiceChangerFeedbackWasEnabled.name] = function(p16, p17) -- line: 210
			-- upvalues: Cryo (copy)
			local userId = p17.payload.userId

			if p16.participants[userId] then
				local v68 = table.clone(p16.participants)
				local v69 = table.clone(p16.participants[userId])

				v69.isVoiceChangerHearMyselfActive = true
				v68[userId] = v69

				return Cryo.Dictionary.join(p16, {
					participants = v68
				})
			end

			return p16
		end,
		[VoiceChangerFeedbackWasDisabled.name] = function(p18, p19) -- line: 229
			-- upvalues: Cryo (copy)
			local userId = p19.payload.userId

			if p18.participants[userId] then
				local v73 = table.clone(p18.participants)
				local v74 = table.clone(p18.participants[userId])

				v74.isVoiceChangerHearMyselfActive = false
				v73[userId] = v74

				return Cryo.Dictionary.join(p18, {
					participants = v73
				})
			end

			return p18
		end,
		[ParticipantIsActive.name] = function(p20, p21) -- line: 248
			-- upvalues: Cryo (copy)
			local userId = p21.payload.userId
			local v78 = table.clone(p20.activeUserIds)
			local v79 = table.find(v78, userId)

			if v79 then
				if v79 ~= #v78 then
					table.remove(v78, v79)
					table.insert(v78, userId)
				end
			else
				table.insert(v78, userId)
			end

			return Cryo.Dictionary.join(p20, {
				activeUserIds = v78
			})
		end,
		[ParticipantIsInactive.name] = function(p22, p23) -- line: 267
			-- upvalues: Cryo (copy)
			local userId = p23.payload.userId
			local v83 = table.find(p22.activeUserIds, userId)

			if v83 then
				local v84 = table.clone(p22.activeUserIds)

				table.remove(v84, v83)

				return Cryo.Dictionary.join(p22, {
					activeUserIds = v84
				})
			end

			return p22
		end,
		[ExperienceJoined.name] = function(p24, p25) -- line: 283
			-- upvalues: Cryo (copy)
			local payload = p25.payload

			if payload.participants and payload.activeUserIds then
				return Cryo.Dictionary.join(p24, {
					participants = payload.participants,
					activeUserIds = payload.activeUserIds,
					publicVoiceFocusedUserIds = payload.publicVoiceFocusedUserIds
				})
			end

			return p24
		end,
		[RestoreState.name] = function(p26, p27) -- line: 295
			-- upvalues: Cryo (copy)
			if p27.payload.Participants then
				return Cryo.Dictionary.join({}, p27.payload.Participants)
			end

			return p26
		end,
		[ParticipantAudioFocusChanged.name] = function(p28, p29) -- line: 302
			-- upvalues: Cryo (copy)
			local contextIds = p29.payload.contextIds
			local v93 = table.clone(p28.publicVoiceFocusedUserIds)

			if contextIds then
				for k, v in pairs(contextIds) do
					local num = tonumber(k)

					if num then
						if v == 1 then
							v93[num] = true
						else
							v93[num] = nil
						end
					end
				end
			end

			return Cryo.Dictionary.join(p28, {
				publicVoiceFocusedUserIds = v93
			})
		end,
		[MuteParticipant.name] = function(p30, p31) -- line: 330
			-- upvalues: Cryo (copy)
			local userId = p31.payload.userId

			if p30.participants[userId] and not p30.participants[userId].isMutedLocally then
				local v100 = table.clone(p30.participants)

				v100[userId].isMutedLocally = true

				return Cryo.Dictionary.join(p30, {
					participants = v100
				})
			end

			return p30
		end,
		[UnmuteParticipant.name] = function(p32, p33) -- line: 343
			-- upvalues: Cryo (copy)
			local userId = p33.payload.userId

			if p32.participants[userId] and p32.participants[userId].isMutedLocally == true then
				local v104 = table.clone(p32.participants)

				v104[userId].isMutedLocally = false

				return Cryo.Dictionary.join(p32, {
					participants = v104
				})
			end

			return p32
		end,
		[ExperienceLeft.name] = function() -- line: 356
			return {
				participants = {},
				activeUserIds = {},
				publicVoiceFocusedUserIds = {}
			}
		end
	})
end
