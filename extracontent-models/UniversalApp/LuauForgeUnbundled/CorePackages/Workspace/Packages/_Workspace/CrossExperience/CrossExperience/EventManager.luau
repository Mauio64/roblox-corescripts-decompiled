local HttpService = game:GetService("HttpService")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/dependencies")

require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Types")
local Communication = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Communication")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Constants")
local Actions = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Actions")
local Models = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Models")
local Utils = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Utils")
local EventQueue = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Utils/EventQueue")

local createPersistenceMiddleware = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Middlewares/createPersistenceMiddleware")

local defineFastFlag = game:DefineFastFlag("EnableCrossExpEventLogging", false)

local sharedFlags = dependencies.SharedFlags
local fFlagPartyVoiceBlockSync = sharedFlags.FFlagPartyVoiceBlockSync
local fFlagEnablePartyVoiceChangersInLua = sharedFlags.FFlagEnablePartyVoiceChangersInLua

local cryo = dependencies.Cryo

local count = 0
local guid = HttpService:GenerateGUID(false)

local class = {}
class.__index = class

function class.new(p2, p3)
	local v5 = {
		observers = {},
		experienceType = p2,
		isSubscribed = false,
		eventQueue = EventQueue.new(p3)
	}

	setmetatable(v5, class)
	return v5
end

function class.notify(p2, p3, options)
	local v5 = options or {}

	count += 1
	v5._seq = count
	v5._origin = guid
	Communication.notify(p3, v5)
end

function class.removeObserver(p2, p3, p4)
	Communication.removeObserver(p2.experienceType, p4, p3)
end

function class.addObserver(data, p2, p3)
	local v5 = Communication.addObserver(data.experienceType, p2, function(p4)
		data.eventQueue:process(p2, p4, p3)
	end)

	table.insert(data.observers, { id = v5, event = p2 })
end

local v5 = createPersistenceMiddleware({ storeKey = Constants.STORAGE_CEV_STORE_KEY })

function class:subscribe(object2, object3)
	if self.isSubscribed then
		return
	end

	self.isSubscribed = true

	if object3 and defineFastFlag then
		object3:info("{}: Subscribing to the CEV Store", self.experienceType)
	end

	self:addObserver(Constants.EVENTS.PARTY_VOICE_GAME_JOIN_FAILED, function(p2)
		if object3 and defineFastFlag then
			object3:info("{}: Experience Party Voice Game Join Failed: {}", self.experienceType, p2.state)
		end

		object2:dispatch(Actions.VoiceStatusChanged({
			status = Constants.VOICE_STATUS.ERROR_RCC_CONNECTING
		}))
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, function(data)
		if object3 and defineFastFlag then
			object3:info(
				"{}: Experience Voice Status Changed: {}, {}, {}, {}",
				self.experienceType,
				data.status,
				data.detail,
				data.voiceChannelId,
				data.voiceSessionId
			)
		end

		if data.status == Constants.VOICE_STATUS.VOICE_CONNECTED then
			if not data.voiceChannelId and object3 then
				object3:warning("Voice channel id is expected")
			end

			if not data.voiceSessionId then
				object3:warning("Voice session id is expected")
			end
		end

		object2:dispatch(Actions.VoiceStatusChanged({
			status = data.status,
			voiceChannelId = data.voiceChannelId,
			voiceSessionId = data.voiceSessionId
		}))
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_EXPERIENCE_JOINED, function(data)
		if object3 and defineFastFlag then
			object3:info(
				"{}: Experience joined JobID: {}, GameID: {}, PlaceId: {}",
				self.experienceType,
				data.jobId,
				data.gameId,
				data.placeId
			)
		end

		local backgroundStateSnapshot = self:getBackgroundStateSnapshot()

		if backgroundStateSnapshot and backgroundStateSnapshot.Participants then
			data = cryo.Dictionary.join(data, backgroundStateSnapshot.Participants)
		end

		object2:dispatch(Actions.ExperienceJoined(data))
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_AUDIO_FOCUS_CHANGED, function(data)
		if object3 and defineFastFlag then
			object3:info(
				"{}: Participant Audio Focus Changed {} = {}",
				self.experienceType,
				data.userId,
				data.contextId
			)
		end

		object2:dispatch(Actions.ParticipantAudioFocusChanged({
			userId = data.userId,
			contextId = data.contextId,
			contextIds = data.contextIds
		}))
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_ADDED, function(data)
		if object3 and defineFastFlag then
			object3:info("{}: Participant added {}", self.experienceType, data.userId)
		end

		local format = Models.ParticipantModel.format
		local v6 = {
			userId = data.userId,
			isLocalUser = data.isLocalUser,
			username = data.username,
			displayname = data.displayname,
			isActive = false,
			isMuted = false,
			isMutedLocally = false,
			isVoiceChangerActive = if fFlagEnablePartyVoiceChangersInLua then false else nil,
			isVoiceChangerHearMyselfActive = if fFlagEnablePartyVoiceChangersInLua then false else nil,
			selectedVoicePack = 0
		}

		local v9 = if fFlagEnablePartyVoiceChangersInLua then data.selectedVoicePack else nil
		v6.selectedVoicePack = v9
		local v10 = format(v6)

		object2:dispatch(Actions.ParticipantAdded(v10))
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_REMOVED, function(p2)
		if object3 and defineFastFlag then
			object3:info("{}: Participant removed {}", self.experienceType, p2.userId)
		end

		object2:dispatch(Actions.ParticipantRemoved({
			userId = tonumber(p2.userId) or -1,
			isLocalUser = p2.isLocalUser
		}))
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_IS_ACTIVE, function(p2)
		if object3 and defineFastFlag then
			object3:info("{}: Participant is active {}", self.experienceType, p2.userId)
		end

		object2:dispatch(Actions.ParticipantIsActive({
			userId = tonumber(p2.userId) or -1,
			isLocalUser = p2.isLocalUser
		}))
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_IS_INACTIVE, function(p2)
		if object3 and defineFastFlag then
			object3:info("{}: Participant is inactive {}", self.experienceType, p2.userId)
		end

		object2:dispatch(Actions.ParticipantIsInactive({
			userId = tonumber(p2.userId) or -1,
			isLocalUser = p2.isLocalUser
		}))
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_WAS_MUTED, function(p2)
		if object3 and defineFastFlag then
			object3:info("{}: Participant is was muted {}", self.experienceType, p2.userId)
		end

		object2:dispatch(Actions.ParticipantWasMuted({
			userId = tonumber(p2.userId) or -1,
			isLocalUser = p2.isLocalUser
		}))
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_WAS_UNMUTED, function(p2)
		if object3 and defineFastFlag then
			object3:info("{}: Participant is was unmuted {}", self.experienceType, p2.userId)
		end

		object2:dispatch(Actions.ParticipantWasUnmuted({
			userId = tonumber(p2.userId) or -1,
			isLocalUser = p2.isLocalUser
		}))
	end)

	if fFlagEnablePartyVoiceChangersInLua then
		self:addObserver(Constants.EVENTS.PARTY_VOICE_CHANGER_WAS_ENABLED, function(p2)
			if object3 and defineFastFlag then
				object3:info("{}: Participant voice changer was enabled {}", self.experienceType, p2.userId)
			end

			object2:dispatch(Actions.VoiceChangerWasEnabled({
				userId = tonumber(p2.userId) or -1,
				isLocalUser = p2.isLocalUser
			}))
		end)

		self:addObserver(Constants.EVENTS.PARTY_VOICE_CHANGER_WAS_DISABLED, function(p2)
			if object3 and defineFastFlag then
				object3:info(
					"{}: Participant voice changer was disabled {}",
					self.experienceType,
					p2.userId
				)
			end

			object2:dispatch(Actions.VoiceChangerWasDisabled({
				userId = tonumber(p2.userId) or -1,
				isLocalUser = p2.isLocalUser
			}))
		end)

		self:addObserver(Constants.EVENTS.PARTY_VOICE_PACK_WAS_SET, function(data)
			if object3 and defineFastFlag then
				object3:info(
					"{}: Participant {} voice pack was set to {}",
					self.experienceType,
					data.userId,
					data.voicePackName
				)
			end

			object2:dispatch(Actions.VoicePackWasSet({
				userId = tonumber(data.userId) or -1,
				isLocalUser = data.isLocalUser,
				voicePackName = data.voicePackName
			}))
		end)

		self:addObserver(Constants.EVENTS.PARTY_VOICE_CHANGER_FEEDBACK_WAS_ENABLED, function(p2)
			if object3 and defineFastFlag then
				object3:info(
					"{}: Participant voice changer feedback was enabled {}",
					self.experienceType,
					p2.userId
				)
			end

			object2:dispatch(Actions.VoiceChangerFeedbackWasEnabled({
				userId = tonumber(p2.userId) or -1,
				isLocalUser = p2.isLocalUser
			}))
		end)

		self:addObserver(Constants.EVENTS.PARTY_VOICE_CHANGER_FEEDBACK_WAS_DISABLED, function(p2)
			if object3 and defineFastFlag then
				object3:info(
					"{}: Participant voice changer feedback was disabled {}",
					self.experienceType,
					p2.userId
				)
			end

			object2:dispatch(Actions.VoiceChangerFeedbackWasDisabled({
				userId = tonumber(p2.userId) or -1,
				isLocalUser = p2.isLocalUser
			}))
		end)
	end

	self:addObserver(Constants.EVENTS.MUTE_PARTY_VOICE_PARTICIPANT, function(p2)
		if object3 and defineFastFlag then
			object3:info("{}: Participant is muted locally {}", self.experienceType, p2.userId)
		end

		object2:dispatch(Actions.MuteParticipant({
			userId = tonumber(p2.userId) or -1,
			isLocalUser = p2.isLocalUser
		}))
	end)

	self:addObserver(Constants.EVENTS.UNMUTE_PARTY_VOICE_PARTICIPANT, function(p2)
		if object3 and defineFastFlag then
			object3:info("{}: Participant is unmuted locally {}", self.experienceType, p2.userId)
		end

		object2:dispatch(Actions.UnmuteParticipant({
			userId = tonumber(p2.userId) or -1,
			isLocalUser = p2.isLocalUser
		}))
	end)

	if fFlagPartyVoiceBlockSync then
		self:addObserver(Constants.EVENTS.PARTY_VOICE_BLOCK_PARTICIPANT, function(p2)
			if object3 and defineFastFlag then
				object3:info(
					"{}: Participant was blocked {} from party voice",
					self.experienceType,
					p2.userId
				)
			end
		end)

		self:addObserver(Constants.EVENTS.PARTY_VOICE_UNBLOCK_PARTICIPANT, function(p2)
			if object3 and defineFastFlag then
				object3:info(
					"{}: Participant was unblocked {} from party voice",
					self.experienceType,
					p2.userId
				)
			end
		end)
	end
end

function class:getBackgroundStateSnapshot()
	local v6 = v5.restore()

	if v6 and v6.Squad and v6.Squad.CrossExperienceVoice then
		return {
			Experience = v6.Squad.CrossExperienceVoice.Experience,
			Participants = {
				participants = Utils.stringMapToNumberMap(v6.Squad.CrossExperienceVoice.Participants.participants),
				activeUserIds = v6.Squad.CrossExperienceVoice.Participants.activeUserIds,
				publicVoiceFocusedUserIds = Utils.stringMapToNumberMap(v6.Squad.CrossExperienceVoice.Participants.publicVoiceFocusedUserIds)
			}
		}
	end

	return nil
end

function class:restoreStateFromBackground(object2, object3)
	local backgroundStateSnapshot = self:getBackgroundStateSnapshot()

	if backgroundStateSnapshot then
		if object3 and defineFastFlag then
			object3:info(
				"{}: Restoring state from background {}",
				self.experienceType,
				HttpService:JSONEncode(backgroundStateSnapshot)
			)
		end

		object2:dispatch(Actions.RestoreState(backgroundStateSnapshot))
	end
end

function class:unsubscribe(object2, object3)
	if object3 and defineFastFlag then
		object3:info("{}: Unsubscribing from the CEV Store", self.experienceType)
	end

	object2:dispatch(Actions.ExperienceLeft())

	for i, observer in ipairs(self.observers) do
		self:removeObserver(observer.id, observer.event)
	end

	self.isSubscribed = false
	self.observers = {}
	self.eventQueue:reset()
end

return class
