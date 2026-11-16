local CrossExperience = script:FindFirstAncestor("CrossExperience")
local dependencies = require(CrossExperience.dependencies)

local rodux = dependencies.Rodux
local cryo = dependencies.Cryo

local Actions = require(CrossExperience.Actions)
local ParticipantAdded = Actions.ParticipantAdded
local Actions2 = require(CrossExperience.Actions)
local ParticipantRemoved = Actions2.ParticipantRemoved
local Actions3 = require(CrossExperience.Actions)
local ParticipantIsActive = Actions3.ParticipantIsActive
local Actions4 = require(CrossExperience.Actions)
local ParticipantIsInactive = Actions4.ParticipantIsInactive
local Actions5 = require(CrossExperience.Actions)
local ParticipantWasMuted = Actions5.ParticipantWasMuted
local Actions6 = require(CrossExperience.Actions)
local ParticipantWasUnmuted = Actions6.ParticipantWasUnmuted
local Actions7 = require(CrossExperience.Actions)
local VoiceChangerWasEnabled = Actions7.VoiceChangerWasEnabled
local Actions8 = require(CrossExperience.Actions)
local VoiceChangerWasDisabled = Actions8.VoiceChangerWasDisabled
local Actions9 = require(CrossExperience.Actions)
local VoicePackWasSet = Actions9.VoicePackWasSet
local Actions10 = require(CrossExperience.Actions)
local VoiceChangerFeedbackWasEnabled = Actions10.VoiceChangerFeedbackWasEnabled
local Actions11 = require(CrossExperience.Actions)
local VoiceChangerFeedbackWasDisabled = Actions11.VoiceChangerFeedbackWasDisabled
local Actions12 = require(CrossExperience.Actions)
local ParticipantAudioFocusChanged = Actions12.ParticipantAudioFocusChanged
local Actions13 = require(CrossExperience.Actions)
local ExperienceJoined = Actions13.ExperienceJoined
local Actions14 = require(CrossExperience.Actions)
local ExperienceLeft = Actions14.ExperienceLeft
local Actions15 = require(CrossExperience.Actions)
local RestoreState = Actions15.RestoreState
local Actions16 = require(CrossExperience.Actions)
local MuteParticipant = Actions16.MuteParticipant
local Actions17 = require(CrossExperience.Actions)
local UnmuteParticipant = Actions17.UnmuteParticipant

require(CrossExperience.Types)
local Utils = require(CrossExperience.Utils)

local v = { participants = {}, activeUserIds = {}, publicVoiceFocusedUserIds = {} }

local function fn(data) -- 1 equivalent call inferred from this helper
	local v2 = v

	if data then
		v2.participants = Utils.stringMapToNumberMap(data.participants)
		v2.activeUserIds = data.activeUserIds
		v2.publicVoiceFocusedUserIds = Utils.stringMapToNumberMap(data.publicVoiceFocusedUserIds)
	end

	return v2
end

return function(data)
	local createReducer = rodux.createReducer
	local v2 = fn(data) -- inferred equivalent call
	return createReducer(v2, {
		[ParticipantAdded.name] = function(p, p2)
			local participant = p2.payload.participant

			if p.participants[participant.userId] then
				return p
			end

			local clone = table.clone(p.participants)
			clone[participant.userId] = participant

			return cryo.Dictionary.join(p, { participants = clone })
		end,
		[ParticipantRemoved.name] = function(data2, p)
			local userId = p.payload.userId

			if not data2.participants[userId] then
				return data2
			end

			local clone = table.clone(data2.participants)
			local clone2 = table.clone(data2.activeUserIds)
			local publicVoiceFocusedUserIds = data2.publicVoiceFocusedUserIds
			local index = table.find(clone2, userId)

			clone[userId] = nil

			if publicVoiceFocusedUserIds[userId] then
				publicVoiceFocusedUserIds = table.clone(data2.publicVoiceFocusedUserIds)
				publicVoiceFocusedUserIds[userId] = nil
			end

			if index then
				table.remove(clone2, index)
			end

			return cryo.Dictionary.join(data2, {
				participants = clone,
				activeUserIds = clone2,
				publicVoiceFocusedUserIds = publicVoiceFocusedUserIds
			})
		end,
		[ParticipantWasMuted.name] = function(p, p2)
			local userId = p2.payload.userId

			if not p.participants[userId] then
				return p
			end

			local participants = p.participants
			local activeUserIds = p.activeUserIds

			local index = table.find(activeUserIds, userId)

			if not participants[userId].isMuted then
				participants = table.clone(p.participants)
				participants[userId].isMuted = true
			end

			if index then
				activeUserIds = table.clone(p.activeUserIds)
				table.remove(activeUserIds, index)
			end

			return cryo.Dictionary.join(p, {
				participants = participants,
				activeUserIds = activeUserIds
			})
		end,
		[ParticipantWasUnmuted.name] = function(p, p2)
			local userId = p2.payload.userId

			if p.participants[userId] and p.participants[userId].isMuted then
				local clone = table.clone(p.participants)
				clone[userId].isMuted = false

				return cryo.Dictionary.join(p, { participants = clone })
			end

			return p
		end,
		[VoiceChangerWasEnabled.name] = function(p, p2)
			local userId = p2.payload.userId

			if not p.participants[userId] then
				return p
			end

			local clone = table.clone(p.participants)
			local clone2 = table.clone(p.participants[userId])

			clone2.isVoiceChangerActive = true
			clone[userId] = clone2

			return cryo.Dictionary.join(p, { participants = clone })
		end,
		[VoiceChangerWasDisabled.name] = function(p, p2)
			local userId = p2.payload.userId

			if not p.participants[userId] then
				return p
			end

			local clone = table.clone(p.participants)
			local clone2 = table.clone(p.participants[userId])

			clone2.isVoiceChangerActive = false
			clone[userId] = clone2

			return cryo.Dictionary.join(p, { participants = clone })
		end,
		[VoicePackWasSet.name] = function(p, p2)
			local userId = p2.payload.userId

			if not p.participants[userId] then
				return p
			end

			local clone = table.clone(p.participants)
			local clone2 = table.clone(p.participants[userId])

			clone2.selectedVoicePack = p2.payload.voicePackName or "None"
			clone[userId] = clone2

			return cryo.Dictionary.union(p, { participants = clone })
		end,
		[VoiceChangerFeedbackWasEnabled.name] = function(p, p2)
			local userId = p2.payload.userId

			if not p.participants[userId] then
				return p
			end

			local clone = table.clone(p.participants)
			local clone2 = table.clone(p.participants[userId])

			clone2.isVoiceChangerHearMyselfActive = true
			clone[userId] = clone2

			return cryo.Dictionary.join(p, { participants = clone })
		end,
		[VoiceChangerFeedbackWasDisabled.name] = function(p, p2)
			local userId = p2.payload.userId

			if not p.participants[userId] then
				return p
			end

			local clone = table.clone(p.participants)
			local clone2 = table.clone(p.participants[userId])

			clone2.isVoiceChangerHearMyselfActive = false
			clone[userId] = clone2

			return cryo.Dictionary.join(p, { participants = clone })
		end,
		[ParticipantIsActive.name] = function(p, p2)
			local userId = p2.payload.userId
			local clone = table.clone(p.activeUserIds)
			local index = table.find(clone, userId)

			if index then
				if index ~= #clone then
					table.remove(clone, index)
					table.insert(clone, userId)
				end
			else
				table.insert(clone, userId)
			end

			return cryo.Dictionary.join(p, { activeUserIds = clone })
		end,
		[ParticipantIsInactive.name] = function(p, p2)
			local userId = p2.payload.userId
			local index = table.find(p.activeUserIds, userId)

			if not index then
				return p
			end

			local clone = table.clone(p.activeUserIds)
			table.remove(clone, index)
			return cryo.Dictionary.join(p, { activeUserIds = clone })
		end,
		[ExperienceJoined.name] = function(p, p2)
			local payload = p2.payload

			if payload.participants and payload.activeUserIds then
				return cryo.Dictionary.join(p, {
					participants = payload.participants,
					activeUserIds = payload.activeUserIds,
					publicVoiceFocusedUserIds = payload.publicVoiceFocusedUserIds
				})
			end

			return p
		end,
		[RestoreState.name] = function(p, p2)
			if p2.payload.Participants then
				return cryo.Dictionary.join({}, p2.payload.Participants)
			end

			return p
		end,
		[ParticipantAudioFocusChanged.name] = function(p, p2)
			local contextIds = p2.payload.contextIds

			local clone = table.clone(p.publicVoiceFocusedUserIds)

			if contextIds then
				for k, contextId in pairs(contextIds) do
					local v3 = tonumber(k)

					if not v3 then
						continue
					end

					if contextId == 1 then
						clone[v3] = true
					else
						clone[v3] = nil
					end
				end
			end

			return cryo.Dictionary.join(p, { publicVoiceFocusedUserIds = clone })
		end,
		[MuteParticipant.name] = function(p, p2)
			local userId = p2.payload.userId

			if p.participants[userId] and not p.participants[userId].isMutedLocally then
				local clone = table.clone(p.participants)
				clone[userId].isMutedLocally = true

				return cryo.Dictionary.join(p, { participants = clone })
			end

			return p
		end,
		[UnmuteParticipant.name] = function(p, p2)
			local userId = p2.payload.userId

			if not p.participants[userId] or p.participants[userId].isMutedLocally ~= true then
				return p
			end

			local clone = table.clone(p.participants)
			clone[userId].isMutedLocally = false

			return cryo.Dictionary.join(p, { participants = clone })
		end,
		[ExperienceLeft.name] = function()
			return { participants = {}, activeUserIds = {}, publicVoiceFocusedUserIds = {} }
		end
	})
end
