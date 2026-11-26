local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/dependencies")

local rodux = dependencies.Rodux
local cryo = dependencies.Cryo

local participantAdded = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").ParticipantAdded
local participantRemoved = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").ParticipantRemoved
local participantIsActive = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").ParticipantIsActive
local participantIsInactive = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").ParticipantIsInactive
local participantWasMuted = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").ParticipantWasMuted
local participantWasUnmuted = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").ParticipantWasUnmuted
local voiceChangerWasEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").VoiceChangerWasEnabled
local voiceChangerWasDisabled = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").VoiceChangerWasDisabled
local voicePackWasSet = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").VoicePackWasSet
local voiceChangerFeedbackWasEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").VoiceChangerFeedbackWasEnabled
local voiceChangerFeedbackWasDisabled = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").VoiceChangerFeedbackWasDisabled
local participantAudioFocusChanged = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").ParticipantAudioFocusChanged
local experienceJoined = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").ExperienceJoined
local experienceLeft = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").ExperienceLeft
local restoreState = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").RestoreState
local muteParticipant = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").MuteParticipant
local unmuteParticipant = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions").UnmuteParticipant

require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Types")
local Utils = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Utils")

local v5 = { participants = {}, activeUserIds = {}, publicVoiceFocusedUserIds = {} }

return function(data)
	local createReducer = rodux.createReducer
	local v6 = v5

	if data then
		v6.participants = Utils.stringMapToNumberMap(data.participants)
		v6.activeUserIds = data.activeUserIds
		v6.publicVoiceFocusedUserIds = Utils.stringMapToNumberMap(data.publicVoiceFocusedUserIds)
	end

	return createReducer(v6, {
		[participantAdded.name] = function(p2, p3)
			local participant = p3.payload.participant

			if p2.participants[participant.userId] then
				return p2
			end

			local clone = table.clone(p2.participants)
			clone[participant.userId] = participant

			return cryo.Dictionary.join(p2, { participants = clone })
		end,
		[participantRemoved.name] = function(data2, p2)
			local userId = p2.payload.userId

			if not data2.participants[userId] then
				return data2
			end

			local clone = table.clone(data2.participants)
			local clone2 = table.clone(data2.activeUserIds)
			local v8 = data2.publicVoiceFocusedUserIds
			local index = table.find(clone2, userId)

			clone[userId] = nil

			if v8[userId] then
				v8 = table.clone(data2.publicVoiceFocusedUserIds)
				v8[userId] = nil
			end

			if index then
				table.remove(clone2, index)
			end

			return cryo.Dictionary.join(data2, {
				participants = clone,
				activeUserIds = clone2,
				publicVoiceFocusedUserIds = v8
			})
		end,
		[participantWasMuted.name] = function(p2, p3)
			local userId = p3.payload.userId

			if not p2.participants[userId] then
				return p2
			end

			local v8 = p2.participants
			local v9 = p2.activeUserIds

			local index = table.find(v9, userId)

			if not v8[userId].isMuted then
				v8 = table.clone(p2.participants)
				v8[userId].isMuted = true
			end

			if index then
				v9 = table.clone(p2.activeUserIds)
				table.remove(v9, index)
			end

			return cryo.Dictionary.join(p2, { participants = v8, activeUserIds = v9 })
		end,
		[participantWasUnmuted.name] = function(p2, p3)
			local userId = p3.payload.userId

			if p2.participants[userId] and p2.participants[userId].isMuted then
				local clone = table.clone(p2.participants)
				clone[userId].isMuted = false

				return cryo.Dictionary.join(p2, { participants = clone })
			end

			return p2
		end,
		[voiceChangerWasEnabled.name] = function(p2, p3)
			local userId = p3.payload.userId

			if not p2.participants[userId] then
				return p2
			end

			local clone = table.clone(p2.participants)
			local clone2 = table.clone(p2.participants[userId])

			clone2.isVoiceChangerActive = true
			clone[userId] = clone2

			return cryo.Dictionary.join(p2, { participants = clone })
		end,
		[voiceChangerWasDisabled.name] = function(p2, p3)
			local userId = p3.payload.userId

			if not p2.participants[userId] then
				return p2
			end

			local clone = table.clone(p2.participants)
			local clone2 = table.clone(p2.participants[userId])

			clone2.isVoiceChangerActive = false
			clone[userId] = clone2

			return cryo.Dictionary.join(p2, { participants = clone })
		end,
		[voicePackWasSet.name] = function(p2, p3)
			local userId = p3.payload.userId

			if not p2.participants[userId] then
				return p2
			end

			local clone = table.clone(p2.participants)
			local clone2 = table.clone(p2.participants[userId])

			clone2.selectedVoicePack = p3.payload.voicePackName or "None"
			clone[userId] = clone2

			return cryo.Dictionary.union(p2, { participants = clone })
		end,
		[voiceChangerFeedbackWasEnabled.name] = function(p2, p3)
			local userId = p3.payload.userId

			if not p2.participants[userId] then
				return p2
			end

			local clone = table.clone(p2.participants)
			local clone2 = table.clone(p2.participants[userId])

			clone2.isVoiceChangerHearMyselfActive = true
			clone[userId] = clone2

			return cryo.Dictionary.join(p2, { participants = clone })
		end,
		[voiceChangerFeedbackWasDisabled.name] = function(p2, p3)
			local userId = p3.payload.userId

			if not p2.participants[userId] then
				return p2
			end

			local clone = table.clone(p2.participants)
			local clone2 = table.clone(p2.participants[userId])

			clone2.isVoiceChangerHearMyselfActive = false
			clone[userId] = clone2

			return cryo.Dictionary.join(p2, { participants = clone })
		end,
		[participantIsActive.name] = function(p2, p3)
			local userId = p3.payload.userId
			local clone = table.clone(p2.activeUserIds)
			local index = table.find(clone, userId)

			if index then
				if index ~= #clone then
					table.remove(clone, index)
					table.insert(clone, userId)
				end
			else
				table.insert(clone, userId)
			end

			return cryo.Dictionary.join(p2, { activeUserIds = clone })
		end,
		[participantIsInactive.name] = function(p2, p3)
			local userId = p3.payload.userId
			local index = table.find(p2.activeUserIds, userId)

			if not index then
				return p2
			end

			local clone = table.clone(p2.activeUserIds)
			table.remove(clone, index)
			return cryo.Dictionary.join(p2, { activeUserIds = clone })
		end,
		[experienceJoined.name] = function(p2, p3)
			local payload = p3.payload

			if payload.participants and payload.activeUserIds then
				return cryo.Dictionary.join(p2, {
					participants = payload.participants,
					activeUserIds = payload.activeUserIds,
					publicVoiceFocusedUserIds = payload.publicVoiceFocusedUserIds
				})
			end

			return p2
		end,
		[restoreState.name] = function(p2, p3)
			if p3.payload.Participants then
				return cryo.Dictionary.join({}, p3.payload.Participants)
			end

			return p2
		end,
		[participantAudioFocusChanged.name] = function(p2, p3)
			local contextIds = p3.payload.contextIds

			local clone = table.clone(p2.publicVoiceFocusedUserIds)

			if contextIds then
				for k, contextId in pairs(contextIds) do
					local v8 = tonumber(k)

					if not v8 then
						continue
					end

					if contextId == 1 then
						clone[v8] = true
					else
						clone[v8] = nil
					end
				end
			end

			return cryo.Dictionary.join(p2, { publicVoiceFocusedUserIds = clone })
		end,
		[muteParticipant.name] = function(p2, p3)
			local userId = p3.payload.userId

			if p2.participants[userId] and not p2.participants[userId].isMutedLocally then
				local clone = table.clone(p2.participants)
				clone[userId].isMutedLocally = true

				return cryo.Dictionary.join(p2, { participants = clone })
			end

			return p2
		end,
		[unmuteParticipant.name] = function(p2, p3)
			local userId = p3.payload.userId

			if not p2.participants[userId] or p2.participants[userId].isMutedLocally ~= true then
				return p2
			end

			local clone = table.clone(p2.participants)
			clone[userId].isMutedLocally = false

			return cryo.Dictionary.join(p2, { participants = clone })
		end,
		[experienceLeft.name] = function()
			return {
				participants = {},
				activeUserIds = {},
				publicVoiceFocusedUserIds = {}
			}
		end
	})
end
