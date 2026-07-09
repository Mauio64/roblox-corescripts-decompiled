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
local v11 = game:DefineFastFlag("EnableCrossExpEventLogging", false)
local SharedFlags = dependencies.SharedFlags
local FFlagPartyVoiceBlockSync = SharedFlags.FFlagPartyVoiceBlockSync
local FFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua
local Cryo = dependencies.Cryo
local n1 = 0
local guid = HttpService:GenerateGUID(false)
local t1 = {}

t1.__index = t1

function t1.new(p1, b1: boolean) -- line: 105
	-- upvalues: EventQueue (copy), t1 (copy)
	local t2 = {
		isSubscribed = false,
		observers = {},
		experienceType = p1,
		eventQueue = EventQueue.new(b1)
	}

	setmetatable(t2, t1)

	return t2
end
function t1.notify(_, p3, p4) -- line: 123
	-- upvalues: n1 (ref), guid (copy), Communication (copy)
	if not p4 then
		p4 = {}
	end

	n1 += 1
	p4._seq = n1
	p4._origin = guid
	Communication.notify(p3, p4)
end
function t1.removeObserver(t3: {[any]: any}, s1: string, p5) -- line: 134
	-- upvalues: Communication (copy)
	Communication.removeObserver(t3.experienceType, p5, s1)
end
function t1.addObserver(t4: {[any]: any}, p6, p7: ((...any) -> ...any)) -- line: 138
	-- upvalues: Communication (copy)
	local v33 = Communication.addObserver(t4.experienceType, p6, function(p8) -- line: 139
		-- upvalues: t4 (copy), p6 (copy), p7 (copy)
		t4.eventQueue:process(p6, p8, p7)
	end)

	table.insert(t4.observers, {
		id = v33,
		event = p6
	})
end

local v19 = createPersistenceMiddleware({
	storeKey = Constants.STORAGE_CEV_STORE_KEY
})

function t1.subscribe(p9, p10, p11) -- line: 154
	-- upvalues: v11 (copy), Constants (copy), Actions (copy), Cryo (copy), Models (copy), FFlagEnablePartyVoiceChangersInLua (copy), FFlagPartyVoiceBlockSync (copy)
	if p9.isSubscribed then
		return
	end

	p9.isSubscribed = true

	if p11 and v11 then
		p11:info("{}: Subscribing to the CEV Store", p9.experienceType)
	end

	p9:addObserver(Constants.EVENTS.PARTY_VOICE_GAME_JOIN_FAILED, function(p12) -- line: 167
		-- upvalues: p11 (copy), v11 (copy), p9 (copy), p10 (copy), Actions (copy), Constants (copy)
		if p11 and v11 then
			p11:info("{}: Experience Party Voice Game Join Failed: {}", p9.experienceType, p12.state)
		end

		p10:dispatch(Actions.VoiceStatusChanged({
			status = Constants.VOICE_STATUS.ERROR_RCC_CONNECTING
		}))
	end)
	p9:addObserver(Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, function(p13) -- line: 180
		-- upvalues: p11 (copy), v11 (copy), p9 (copy), Constants (copy), p10 (copy), Actions (copy)
		if p11 and v11 then
			p11:info("{}: Experience Voice Status Changed: {}, {}, {}, {}", p9.experienceType, p13.status, p13.detail, p13.voiceChannelId, p13.voiceSessionId)
		end

		if p13.status == Constants.VOICE_STATUS.VOICE_CONNECTED then
			if not p13.voiceChannelId and p11 then
				p11:warning("Voice channel id is expected")
			end

			if not p13.voiceSessionId then
				p11:warning("Voice session id is expected")
			end
		end

		p10:dispatch(Actions.VoiceStatusChanged({
			status = p13.status,
			voiceChannelId = p13.voiceChannelId,
			voiceSessionId = p13.voiceSessionId
		}))
	end)
	p9:addObserver(Constants.EVENTS.PARTY_VOICE_EXPERIENCE_JOINED, function(p14) -- line: 212
		-- upvalues: p11 (copy), v11 (copy), p9 (copy), Cryo (copy), p10 (copy), Actions (copy)
		if p11 and v11 then
			p11:info("{}: Experience joined JobID: {}, GameID: {}, PlaceId: {}", p9.experienceType, p14.jobId, p14.gameId, p14.placeId)
		end

		local v52 = p9:getBackgroundStateSnapshot()

		if v52 and v52.Participants then
			p14 = Cryo.Dictionary.join(p14, v52.Participants)
		end

		p10:dispatch(Actions.ExperienceJoined(p14))
	end)
	p9:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_AUDIO_FOCUS_CHANGED, function(p15) -- line: 234
		-- upvalues: p11 (copy), v11 (copy), p9 (copy), p10 (copy), Actions (copy)
		if p11 and v11 then
			p11:info("{}: Participant Audio Focus Changed {} = {}", p9.experienceType, p15.userId, p15.contextId)
		end

		p10:dispatch(Actions.ParticipantAudioFocusChanged({
			userId = p15.userId,
			contextId = p15.contextId,
			contextIds = p15.contextIds
		}))
	end)
	p9:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_ADDED, function(p16) -- line: 254
		-- upvalues: p11 (copy), v11 (copy), p9 (copy), Models (copy), FFlagEnablePartyVoiceChangersInLua (copy), p10 (copy), Actions (copy)
		if p11 and v11 then
			p11:info("{}: Participant added {}", p9.experienceType, p16.userId)
		end

		local v55 = Models.ParticipantModel.format({
			isActive = false,
			isMuted = false,
			isMutedLocally = false,
			userId = p16.userId,
			isLocalUser = p16.isLocalUser,
			username = p16.username,
			displayname = p16.displayname,
			isVoiceChangerActive = not FFlagEnablePartyVoiceChangersInLua and nil,
			isVoiceChangerHearMyselfActive = not FFlagEnablePartyVoiceChangersInLua and nil,
			selectedVoicePack = if not FFlagEnablePartyVoiceChangersInLua then nil else p16.selectedVoicePack
		})

		p10:dispatch(Actions.ParticipantAdded(v55))
	end)
	p9:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_REMOVED, function(p17) -- line: 276
		-- upvalues: p11 (copy), v11 (copy), p9 (copy), p10 (copy), Actions (copy)
		if p11 and v11 then
			p11:info("{}: Participant removed {}", p9.experienceType, p17.userId)
		end

		p10:dispatch(Actions.ParticipantRemoved({
			userId = tonumber(p17.userId) or -1,
			isLocalUser = p17.isLocalUser
		}))
	end)
	p9:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_IS_ACTIVE, function(p18) -- line: 286
		-- upvalues: p11 (copy), v11 (copy), p9 (copy), p10 (copy), Actions (copy)
		if p11 and v11 then
			p11:info("{}: Participant is active {}", p9.experienceType, p18.userId)
		end

		p10:dispatch(Actions.ParticipantIsActive({
			userId = tonumber(p18.userId) or -1,
			isLocalUser = p18.isLocalUser
		}))
	end)
	p9:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_IS_INACTIVE, function(p19) -- line: 296
		-- upvalues: p11 (copy), v11 (copy), p9 (copy), p10 (copy), Actions (copy)
		if p11 and v11 then
			p11:info("{}: Participant is inactive {}", p9.experienceType, p19.userId)
		end

		p10:dispatch(Actions.ParticipantIsInactive({
			userId = tonumber(p19.userId) or -1,
			isLocalUser = p19.isLocalUser
		}))
	end)
	p9:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_WAS_MUTED, function(p20) -- line: 306
		-- upvalues: p11 (copy), v11 (copy), p9 (copy), p10 (copy), Actions (copy)
		if p11 and v11 then
			p11:info("{}: Participant is was muted {}", p9.experienceType, p20.userId)
		end

		p10:dispatch(Actions.ParticipantWasMuted({
			userId = tonumber(p20.userId) or -1,
			isLocalUser = p20.isLocalUser
		}))
	end)
	p9:addObserver(Constants.EVENTS.PARTY_VOICE_PARTICIPANT_WAS_UNMUTED, function(p21) -- line: 316
		-- upvalues: p11 (copy), v11 (copy), p9 (copy), p10 (copy), Actions (copy)
		if p11 and v11 then
			p11:info("{}: Participant is was unmuted {}", p9.experienceType, p21.userId)
		end

		p10:dispatch(Actions.ParticipantWasUnmuted({
			userId = tonumber(p21.userId) or -1,
			isLocalUser = p21.isLocalUser
		}))
	end)

	if FFlagEnablePartyVoiceChangersInLua then
		p9:addObserver(Constants.EVENTS.PARTY_VOICE_CHANGER_WAS_ENABLED, function(p22) -- line: 327
			-- upvalues: p11 (copy), v11 (copy), p9 (copy), p10 (copy), Actions (copy)
			if p11 and v11 then
				p11:info("{}: Participant voice changer was enabled {}", p9.experienceType, p22.userId)
			end

			p10:dispatch(Actions.VoiceChangerWasEnabled({
				userId = tonumber(p22.userId) or -1,
				isLocalUser = p22.isLocalUser
			}))
		end)
		p9:addObserver(Constants.EVENTS.PARTY_VOICE_CHANGER_WAS_DISABLED, function(p23) -- line: 337
			-- upvalues: p11 (copy), v11 (copy), p9 (copy), p10 (copy), Actions (copy)
			if p11 and v11 then
				p11:info("{}: Participant voice changer was disabled {}", p9.experienceType, p23.userId)
			end

			p10:dispatch(Actions.VoiceChangerWasDisabled({
				userId = tonumber(p23.userId) or -1,
				isLocalUser = p23.isLocalUser
			}))
		end)
		p9:addObserver(Constants.EVENTS.PARTY_VOICE_PACK_WAS_SET, function(p24) -- line: 347
			-- upvalues: p11 (copy), v11 (copy), p9 (copy), p10 (copy), Actions (copy)
			if p11 and v11 then
				p11:info("{}: Participant {} voice pack was set to {}", p9.experienceType, p24.userId, p24.voicePackName)
			end

			p10:dispatch(Actions.VoicePackWasSet({
				userId = tonumber(p24.userId) or -1,
				isLocalUser = p24.isLocalUser,
				voicePackName = p24.voicePackName
			}))
		end)
		p9:addObserver(Constants.EVENTS.PARTY_VOICE_CHANGER_FEEDBACK_WAS_ENABLED, function(p25) -- line: 366
			-- upvalues: p11 (copy), v11 (copy), p9 (copy), p10 (copy), Actions (copy)
			if p11 and v11 then
				p11:info("{}: Participant voice changer feedback was enabled {}", p9.experienceType, p25.userId)
			end

			p10:dispatch(Actions.VoiceChangerFeedbackWasEnabled({
				userId = tonumber(p25.userId) or -1,
				isLocalUser = p25.isLocalUser
			}))
		end)
		p9:addObserver(Constants.EVENTS.PARTY_VOICE_CHANGER_FEEDBACK_WAS_DISABLED, function(p26) -- line: 380
			-- upvalues: p11 (copy), v11 (copy), p9 (copy), p10 (copy), Actions (copy)
			if p11 and v11 then
				p11:info("{}: Participant voice changer feedback was disabled {}", p9.experienceType, p26.userId)
			end

			p10:dispatch(Actions.VoiceChangerFeedbackWasDisabled({
				userId = tonumber(p26.userId) or -1,
				isLocalUser = p26.isLocalUser
			}))
		end)
	end

	p9:addObserver(Constants.EVENTS.MUTE_PARTY_VOICE_PARTICIPANT, function(p27) -- line: 395
		-- upvalues: p11 (copy), v11 (copy), p9 (copy), p10 (copy), Actions (copy)
		if p11 and v11 then
			p11:info("{}: Participant is muted locally {}", p9.experienceType, p27.userId)
		end

		p10:dispatch(Actions.MuteParticipant({
			userId = tonumber(p27.userId) or -1,
			isLocalUser = p27.isLocalUser
		}))
	end)
	p9:addObserver(Constants.EVENTS.UNMUTE_PARTY_VOICE_PARTICIPANT, function(p28) -- line: 405
		-- upvalues: p11 (copy), v11 (copy), p9 (copy), p10 (copy), Actions (copy)
		if p11 and v11 then
			p11:info("{}: Participant is unmuted locally {}", p9.experienceType, p28.userId)
		end

		p10:dispatch(Actions.UnmuteParticipant({
			userId = tonumber(p28.userId) or -1,
			isLocalUser = p28.isLocalUser
		}))
	end)

	if FFlagPartyVoiceBlockSync then
		p9:addObserver(Constants.EVENTS.PARTY_VOICE_BLOCK_PARTICIPANT, function(p29) -- line: 416
			-- upvalues: p11 (copy), v11 (copy), p9 (copy)
			if p11 and v11 then
				p11:info("{}: Participant was blocked {} from party voice", p9.experienceType, p29.userId)
			end
		end)
		p9:addObserver(Constants.EVENTS.PARTY_VOICE_UNBLOCK_PARTICIPANT, function(p30) -- line: 425
			-- upvalues: p11 (copy), v11 (copy), p9 (copy)
			if p11 and v11 then
				p11:info("{}: Participant was unblocked {} from party voice", p9.experienceType, p30.userId)
			end
		end)
	end
end
function t1.getBackgroundStateSnapshot(_) -- line: 434
	-- upvalues: v19 (copy), Utils (copy)
	local v38 = v19.restore()

	if v38 and (v38.Squad and v38.Squad.CrossExperienceVoice) then
		return {
			Experience = v38.Squad.CrossExperienceVoice.Experience,
			Participants = {
				participants = Utils.stringMapToNumberMap(v38.Squad.CrossExperienceVoice.Participants.participants),
				activeUserIds = v38.Squad.CrossExperienceVoice.Participants.activeUserIds,
				publicVoiceFocusedUserIds = Utils.stringMapToNumberMap(v38.Squad.CrossExperienceVoice.Participants.publicVoiceFocusedUserIds)
			}
		}
	end

	return nil
end
function t1.restoreStateFromBackground(p32, p33, p34) -- line: 452
	-- upvalues: v11 (copy), HttpService (copy), Actions (copy)
	local v42 = p32:getBackgroundStateSnapshot()

	if v42 then
		if p34 and v11 then
			p34:info("{}: Restoring state from background {}", p32.experienceType, HttpService:JSONEncode(v42))
		end

		p33:dispatch(Actions.RestoreState(v42))
	end
end
function t1.unsubscribe(p35, p36, p37) -- line: 462
	-- upvalues: v11 (copy), Actions (copy)
	if p37 and v11 then
		p37:info("{}: Unsubscribing from the CEV Store", p35.experienceType)
	end

	p36:dispatch(Actions.ExperienceLeft())

	for _, v in ipairs(p35.observers) do
		p35:removeObserver(v.id, v.event)
	end

	p35.isSubscribed = false
	p35.observers = {}
	p35.eventQueue:reset()
end

return t1
