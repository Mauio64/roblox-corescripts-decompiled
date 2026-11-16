local HttpService = game:GetService("HttpService")

local CrossExperience = script:FindFirstAncestor("CrossExperience")
local dependencies = require(CrossExperience.dependencies)

require(CrossExperience.Types)
local Communication = require(CrossExperience.Communication)
local Constants = require(CrossExperience.Constants)
local Actions = require(CrossExperience.Actions)
local Models = require(CrossExperience.Models)
local Utils = require(CrossExperience.Utils)
local EventQueue = require(CrossExperience.Utils.EventQueue)

local createPersistenceMiddleware = require(CrossExperience.Middlewares.createPersistenceMiddleware)

local defineFastFlag = game:DefineFastFlag("EnableCrossExpEventLogging", false)

local sharedFlags = dependencies.SharedFlags
local fFlagPartyVoiceBlockSync = sharedFlags.FFlagPartyVoiceBlockSync
local fFlagEnablePartyVoiceChangersInLua = sharedFlags.FFlagEnablePartyVoiceChangersInLua

local cryo = dependencies.Cryo

local count = 0
local guid = HttpService:GenerateGUID(false)

local EventManager = {}
EventManager.__index = EventManager

function EventManager.new(experienceType, flag: boolean)
	local v = {
		observers = {},
		experienceType = experienceType,
		isSubscribed = false,
		eventQueue = EventQueue.new(flag)
	}

	setmetatable(v, EventManager)
	return v
end

function EventManager.notify(_, p, options)
	options = options or {}

	count += 1
	options._seq = count
	options._origin = guid
	Communication.notify(p, options)
end

function EventManager.removeObserver(p, p2: string, p3)
	Communication.removeObserver(p.experienceType, p3, p2)
end

function EventManager.addObserver(data, event, callback)
	local id = Communication.addObserver(data.experienceType, event, function(p)
		data.eventQueue:process(event, p, callback)
	end)

	table.insert(data.observers, { id = id, event = event })
end

local persistenceMiddleware = createPersistenceMiddleware({
	storeKey = Constants.STORAGE_CEV_STORE_KEY
})

local function fn(p) -- 11 equivalent calls inferred from this helper
	return {
		userId = tonumber(p.userId) or -1,
		isLocalUser = p.isLocalUser
	}
end

function EventManager:subscribe(object, object2)
	if self.isSubscribed then
		return
	end

	self.isSubscribed = true

	if object2 and defineFastFlag then
		object2:info("{}: Subscribing to the CEV Store", self.experienceType)
	end

	self:addObserver(Constants.EVENTS.PARTY_VOICE_GAME_JOIN_FAILED, function(p)
		if object2 and defineFastFlag then
			object2:info("{}: Experience Party Voice Game Join Failed: {}", self.experienceType, p.state)
		end

		object:dispatch(Actions.VoiceStatusChanged({
			status = Constants.VOICE_STATUS.ERROR_RCC_CONNECTING
		}))
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, function(data)
		if object2 and defineFastFlag then
			object2:info(
				"{}: Experience Voice Status Changed: {}, {}, {}, {}",
				self.experienceType,
				data.status,
				data.detail,
				data.voiceChannelId,
				data.voiceSessionId
			)
		end

		if data.status == Constants.VOICE_STATUS.VOICE_CONNECTED then
			if not data.voiceChannelId and object2 then
				object2:warning("Voice channel id is expected")
			end

			if not data.voiceSessionId then
				object2:warning("Voice session id is expected")
			end
		end

		object:dispatch(Actions.VoiceStatusChanged({
			status = data.status,
			voiceChannelId = data.voiceChannelId,
			voiceSessionId = data.voiceSessionId
		}))
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_EXPERIENCE_JOINED, function(data)
		if object2 and defineFastFlag then
			object2:info(
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

		object:dispatch(Actions.ExperienceJoined(data))
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_AUDIO_FOCUS_CHANGED, function(data)
		if object2 and defineFastFlag then
			object2:info(
				"{}: Participant Audio Focus Changed {} = {}",
				self.experienceType,
				data.userId,
				data.contextId
			)
		end

		object:dispatch(Actions.ParticipantAudioFocusChanged({
			userId = data.userId,
			contextId = data.contextId,
			contextIds = data.contextIds
		}))
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_ADDED, function(data)
		if object2 and defineFastFlag then
			object2:info("{}: Participant added {}", self.experienceType, data.userId)
		end

		local format = Models.ParticipantModel.format
		local v = {
			userId = data.userId,
			isLocalUser = data.isLocalUser,
			username = data.username,
			displayname = data.displayname,
			isActive = false,
			isMuted = false,
			isMutedLocally = false,
			isVoiceChangerActive = not fFlagEnablePartyVoiceChangersInLua and nil,
			isVoiceChangerHearMyselfActive = not fFlagEnablePartyVoiceChangersInLua and nil,
			selectedVoicePack = 0
		}
		local selectedVoicePack

		if fFlagEnablePartyVoiceChangersInLua then
			selectedVoicePack = data.selectedVoicePack
		end

		v.selectedVoicePack = selectedVoicePack
		local v2 = format(v)

		object:dispatch(Actions.ParticipantAdded(v2))
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_REMOVED, function(p)
		if object2 and defineFastFlag then
			object2:info("{}: Participant removed {}", self.experienceType, p.userId)
		end

		object:dispatch(Actions.ParticipantRemoved(fn(p))) -- inferred equivalent call
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_IS_ACTIVE, function(p)
		if object2 and defineFastFlag then
			object2:info("{}: Participant is active {}", self.experienceType, p.userId)
		end

		object:dispatch(Actions.ParticipantIsActive(fn(p))) -- inferred equivalent call
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_IS_INACTIVE, function(p)
		if object2 and defineFastFlag then
			object2:info("{}: Participant is inactive {}", self.experienceType, p.userId)
		end

		object:dispatch(Actions.ParticipantIsInactive(fn(p))) -- inferred equivalent call
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_WAS_MUTED, function(p)
		if object2 and defineFastFlag then
			object2:info("{}: Participant is was muted {}", self.experienceType, p.userId)
		end

		object:dispatch(Actions.ParticipantWasMuted(fn(p))) -- inferred equivalent call
	end)

	self:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_WAS_UNMUTED, function(p)
		if object2 and defineFastFlag then
			object2:info("{}: Participant is was unmuted {}", self.experienceType, p.userId)
		end

		object:dispatch(Actions.ParticipantWasUnmuted(fn(p))) -- inferred equivalent call
	end)

	if fFlagEnablePartyVoiceChangersInLua then
		self:addObserver(Constants.EVENTS.PARTY_VOICE_CHANGER_WAS_ENABLED, function(p)
			if object2 and defineFastFlag then
				object2:info("{}: Participant voice changer was enabled {}", self.experienceType, p.userId)
			end

			object:dispatch(Actions.VoiceChangerWasEnabled(fn(p))) -- inferred equivalent call
		end)

		self:addObserver(Constants.EVENTS.PARTY_VOICE_CHANGER_WAS_DISABLED, function(p)
			if object2 and defineFastFlag then
				object2:info("{}: Participant voice changer was disabled {}", self.experienceType, p.userId)
			end

			object:dispatch(Actions.VoiceChangerWasDisabled(fn(p))) -- inferred equivalent call
		end)

		self:addObserver(Constants.EVENTS.PARTY_VOICE_PACK_WAS_SET, function(data)
			if object2 and defineFastFlag then
				object2:info(
					"{}: Participant {} voice pack was set to {}",
					self.experienceType,
					data.userId,
					data.voicePackName
				)
			end

			object:dispatch(Actions.VoicePackWasSet({
				userId = tonumber(data.userId) or -1,
				isLocalUser = data.isLocalUser,
				voicePackName = data.voicePackName
			}))
		end)

		self:addObserver(Constants.EVENTS.PARTY_VOICE_CHANGER_FEEDBACK_WAS_ENABLED, function(p)
			if object2 and defineFastFlag then
				object2:info("{}: Participant voice changer feedback was enabled {}", self.experienceType, p.userId)
			end

			object:dispatch(Actions.VoiceChangerFeedbackWasEnabled(fn(p))) -- inferred equivalent call
		end)

		self:addObserver(Constants.EVENTS.PARTY_VOICE_CHANGER_FEEDBACK_WAS_DISABLED, function(p)
			if object2 and defineFastFlag then
				object2:info("{}: Participant voice changer feedback was disabled {}", self.experienceType, p.userId)
			end

			object:dispatch(Actions.VoiceChangerFeedbackWasDisabled(fn(p))) -- inferred equivalent call
		end)
	end

	self:addObserver(Constants.EVENTS.MUTE_PARTY_VOICE_PARTICIPANT, function(p)
		if object2 and defineFastFlag then
			object2:info("{}: Participant is muted locally {}", self.experienceType, p.userId)
		end

		object:dispatch(Actions.MuteParticipant(fn(p))) -- inferred equivalent call
	end)

	self:addObserver(Constants.EVENTS.UNMUTE_PARTY_VOICE_PARTICIPANT, function(p)
		if object2 and defineFastFlag then
			object2:info("{}: Participant is unmuted locally {}", self.experienceType, p.userId)
		end

		object:dispatch(Actions.UnmuteParticipant(fn(p))) -- inferred equivalent call
	end)

	if fFlagPartyVoiceBlockSync then
		self:addObserver(Constants.EVENTS.PARTY_VOICE_BLOCK_PARTICIPANT, function(p)
			if object2 and defineFastFlag then
				object2:info("{}: Participant was blocked {} from party voice", self.experienceType, p.userId)
			end
		end)

		self:addObserver(Constants.EVENTS.PARTY_VOICE_UNBLOCK_PARTICIPANT, function(p)
			if object2 and defineFastFlag then
				object2:info("{}: Participant was unblocked {} from party voice", self.experienceType, p.userId)
			end
		end)
	end
end

function EventManager:getBackgroundStateSnapshot()
	local v = persistenceMiddleware.restore()

	if v and v.Squad and v.Squad.CrossExperienceVoice then
		return {
			Experience = v.Squad.CrossExperienceVoice.Experience,
			Participants = {
				participants = Utils.stringMapToNumberMap(v.Squad.CrossExperienceVoice.Participants.participants),
				activeUserIds = v.Squad.CrossExperienceVoice.Participants.activeUserIds,
				publicVoiceFocusedUserIds = Utils.stringMapToNumberMap(v.Squad.CrossExperienceVoice.Participants.publicVoiceFocusedUserIds)
			}
		}
	end

	return nil
end

function EventManager:restoreStateFromBackground(object, object2)
	local backgroundStateSnapshot = self:getBackgroundStateSnapshot()

	if backgroundStateSnapshot then
		if object2 and defineFastFlag then
			object2:info(
				"{}: Restoring state from background {}",
				self.experienceType,
				HttpService:JSONEncode(backgroundStateSnapshot)
			)
		end

		object:dispatch(Actions.RestoreState(backgroundStateSnapshot))
	end
end

function EventManager:unsubscribe(object, object2)
	if object2 and defineFastFlag then
		object2:info("{}: Unsubscribing from the CEV Store", self.experienceType)
	end

	object:dispatch(Actions.ExperienceLeft())

	for _, observer in ipairs(self.observers) do
		self:removeObserver(observer.id, observer.event)
	end

	self.isSubscribed = false
	self.observers = {}
	self.eventQueue:reset()
end

return EventManager
