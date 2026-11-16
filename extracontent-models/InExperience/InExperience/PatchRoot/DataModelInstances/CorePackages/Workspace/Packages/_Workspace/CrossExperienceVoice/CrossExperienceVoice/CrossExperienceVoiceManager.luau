local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local ExperienceService = game:GetService("ExperienceService")
local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")
local dependencies = require(CrossExperienceVoice.dependencies)

local promise = dependencies.Promise

local crossExperience = dependencies.CrossExperience
local communication = crossExperience.Communication
local sharedFlags = dependencies.SharedFlags
local luauPolyfill = dependencies.LuauPolyfill
local Constants = require(CrossExperienceVoice.Common.Constants)
local CrossExperienceVoiceAnalytics = require(CrossExperienceVoice.CrossExperienceVoiceAnalytics)
local Logger = require(CrossExperienceVoice.Logger)
local Flags = require(CrossExperienceVoice.Flags)

local createPersistenceMiddleware = crossExperience.Middlewares.createPersistenceMiddleware

local CrossExperienceVoiceManager = {}
CrossExperienceVoiceManager.__index = CrossExperienceVoiceManager

local getFFlagJoinCrossExpVoiceWithPartyId = sharedFlags.getFFlagJoinCrossExpVoiceWithPartyId
local getFFlagEnableCrossExpVoiceMemoryCheck = sharedFlags.getFFlagEnableCrossExpVoiceMemoryCheck
local getFFlagEnableCrossExperienceVoiceCaptureMute = sharedFlags.GetFFlagEnableCrossExperienceVoiceCaptureMute
local fStringTimeoutLoadingLocalPlayerInBackgroundDM = sharedFlags.FStringTimeoutLoadingLocalPlayerInBackgroundDM
local engineFeature = game:GetEngineFeature("AudioFocusManagement")
local engineFeature2 = game:GetEngineFeature("RecordJoinAttemptIdForCEV")

local fIntPartyVoiceJoinRequestPulseCheckTimeout = sharedFlags.FIntPartyVoiceJoinRequestPulseCheckTimeout

local BACKGROUND_DM_STATUS = crossExperience.Constants.BACKGROUND_DM_STATUS
local AUDIO_FOCUS_MANAGEMENT = crossExperience.Constants.AUDIO_FOCUS_MANAGEMENT
local LOCAL_PLAYER_LOADING_TIMEOUT_ENUM = crossExperience.Constants.LOCAL_PLAYER_LOADING_TIMEOUT_ENUM

local CEV_JOIN_ATTEMPT_ID_KEY = crossExperience.Constants.CEV_JOIN_ATTEMPT_ID_KEY

local persistenceMiddleware = createPersistenceMiddleware({
	storeKey = crossExperience.Constants.STORAGE_CEV_STORE_KEY
})

local setTimeout = luauPolyfill.setTimeout
local clearTimeout = luauPolyfill.clearTimeout

local fFlagFixCrossExperienceVoiceExecutePrint = sharedFlags.FFlagFixCrossExperienceVoiceExecutePrint

local defineFastString = game:DefineFastString(
	"CrossExpVoicePlaceId",
	(tostring(Constants.DEFAULT_EXPERIENCE_PLACE_ID))
)

local function fn() end

local function fn2() -- 3 equivalent calls inferred from this helper
	if game.PlaceId == 0 then
		return crossExperience.Constants.EXPERIENCE_TYPE_LUAAPP
	end

	return crossExperience.Constants.EXPERIENCE_TYPE_UGC
end

function CrossExperienceVoiceManager.new()
	local v = {
		joinRequestPulseCheckId = nil,
		connections = {},
		isInitialized = false,
		isConnected = false,
		shouldIgnoreMemoryWarning = false,
		hasExperienceStarted = false,
		observersInitialized = false,
		currentCevJoinAttemptId = nil,
		ExperienceJoined = Instance.new("BindableEvent"),
		ExperienceJoinFailed = Instance.new("BindableEvent"),
		ExperienceLeft = Instance.new("BindableEvent"),
		JoinFeasibilityCheckPerformed = Instance.new("BindableEvent"),
		JoinRequestPulseCheck = Instance.new("BindableEvent"),
		JoinRequested = Instance.new("BindableEvent"),
		JoinRequestSubmitted = Instance.new("BindableEvent"),
		MemoryLow = Instance.new("BindableEvent"),
		VoiceEuModalConsented = Instance.new("BindableEvent"),
		VoiceEuModalRefused = Instance.new("BindableEvent"),
		cevEventManager = crossExperience.EventManager.new(fn2(), false), -- inferred equivalent call
		voiceAnalytics = CrossExperienceVoiceAnalytics.default,
		isActiveDM = true
	}

	setmetatable(v, CrossExperienceVoiceManager)
	return v
end

function CrossExperienceVoiceManager:logPartyVoiceTimeout()
	self.voiceAnalytics:logPartyVoiceTimeout(self.currentPartyId)
end

function CrossExperienceVoiceManager:initialize()
	self.voiceAnalytics:initialize(self.cevEventManager)

	if self.isInitialized == true then
		return
	end

	table.insert(self.connections, ExperienceService:RegisterForExperienceJoin(function()
		if fn2() == crossExperience.Constants.EXPERIENCE_TYPE_LUAAPP then -- inferred equivalent call
			self.isActiveDM = false
		end
	end))

	table.insert(self.connections, ExperienceService:RegisterForExperienceLeave(function()
		if fn2() == crossExperience.Constants.EXPERIENCE_TYPE_LUAAPP then -- inferred equivalent call
			self.isActiveDM = true
		end
	end))

	table.insert(self.connections, ExperienceService.OnCrossExperienceStarted:Connect(function(_, _)
		self.voiceAnalytics:logPartyVoiceOnCrossExperienceStartedSignalReceived(
			self.hasExperienceStarted,
			self.isActiveDM
		)

		if self.hasExperienceStarted then
			return
		end

		if self.observersInitialized then
			Logger:info("Observers already initialized, skipping duplicate setup")
			return
		end

		self.observersInitialized = true
		Logger:info("Initializing observers for the first time")

		self.cevEventManager:addObserver(crossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, function(p)
			self.voiceAnalytics:logPartyVoiceStateChangeHandlerRun(self.isActiveDM, p)

			if not self.isActiveDM then
				return
			end

			if
				Flags.FFlagFireErrorRCCTimeoutSignal
				and p.status == crossExperience.Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT
			then
				self.voiceAnalytics:logPartyVoiceTimeout(self.currentPartyId)
			elseif Flags.FFlagPartyVoiceLogActiveDM then
				local v

				if self.isActiveDM then
					v = crossExperience.Constants.EXPERIENCE_TYPE_LUAAPP
				else
					v = crossExperience.Constants.EXPERIENCE_TYPE_UGC
				end

				if p.status == crossExperience.Constants.VOICE_STATUS.VOICE_CONNECTED then
					self.voiceAnalytics:logPartyVoiceConnectedState(p, self.currentPartyId, v)
				end

				self.voiceAnalytics:logPartyVoiceStatusChanged(p, self.currentPartyId, v)
			else
				if p.status == crossExperience.Constants.VOICE_STATUS.VOICE_CONNECTED then
					self.voiceAnalytics:logPartyVoiceConnectedState(p, self.currentPartyId, "")
				end

				self.voiceAnalytics:logPartyVoiceStatusChanged(p, self.currentPartyId, "")
			end

			if
				fStringTimeoutLoadingLocalPlayerInBackgroundDM ~= LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable
				and p.status == crossExperience.Constants.VOICE_STATUS.ERROR_BACKGROUND_DM_LOAD_LOCALPLAYER_TIMEOUT
				or p.status == crossExperience.Constants.VOICE_STATUS.ERROR_VOICE_DISCONNECTED
				or Flags.FFlagFireErrorRCCTimeoutSignal
				and p.status == crossExperience.Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT
			then
				self:leave()
			end
		end)

		self.cevEventManager:addObserver(crossExperience.Constants.EVENTS.PARTY_VOICE_GAME_JOIN_FAILED, function(p)
			self.ExperienceJoinFailed:Fire()
			local v = not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId

			local v2 = not (p and p.state) and "PARTY_VOICE_GAME_JOIN_FAILED:-1"
				or "PARTY_VOICE_GAME_JOIN_FAILED:" .. tostring(p.state)

			self.voiceAnalytics:logPartyVoiceJoinFailure(self.currentPartyId, v2, v)
		end)

		if getFFlagEnableCrossExpVoiceMemoryCheck() then
			self.cevEventManager:addObserver(crossExperience.Constants.EVENTS.PARTY_VOICE_MEMORY_LOW, function()
				self:ignoreMemoryWarning()

				if not self.shouldIgnoreMemoryWarning then
					self.MemoryLow:Fire()
					self.shouldIgnoreMemoryWarning = true
				end
			end)
		end

		self.ExperienceJoined:Fire()
		self.hasExperienceStarted = true
	end))

	table.insert(self.connections, ExperienceService.OnCrossExperienceStopped:Connect(function(_, _)
		self:disconnect()
		self.ExperienceLeft:Fire()
		self:resetCEVMemStorage()
	end))

	table.insert(self.connections, NotificationService.RobloxEventReceived:Connect(function(p)
		if p.detailType == "SignOut" then
			self:onUserLogout()
		end
	end))

	self.isInitialized = true
end

function CrossExperienceVoiceManager:onUserLogout()
	if self.hasExperienceStarted then
		self:leave()
	end

	if self.isConnected then
		self:disconnect()
		self.ExperienceLeft:Fire()
		self:resetCEVMemStorage()
	end
end

function CrossExperienceVoiceManager.getIsConnected(p)
	return p.isConnected
end

function CrossExperienceVoiceManager:setAsDisconnected()
	self.isConnected = false
	self.hasExperienceStarted = false

	if self.ExperienceLeft then
		self.ExperienceLeft:Fire()
	end
end

function CrossExperienceVoiceManager:setAsConnected()
	if not self.isInitialized then
		self:initialize()
	end

	self.isConnected = true
	self.hasExperienceStarted = true
	self.ExperienceJoined:Fire()
end

function CrossExperienceVoiceManager:getIsBackgroundDMActive()
	return promise.new(function(callback, callback2)
		communication.execute(crossExperience.Constants.COMMUNICATIONS.EXECUTE_GET_BACKGROUND_DM_STATE, {}, function(p)
			callback(p.status == BACKGROUND_DM_STATUS.ACTIVE or p.status == BACKGROUND_DM_STATUS.BACKGROUND)
		end, function()
			callback2()
		end)
	end)
end

function CrossExperienceVoiceManager.getPartyVoiceDebugStats(_)
	if Flags.FFlagVoiceDebugConsoleV2 then
		return promise.new(function(callback, callback2)
			communication.execute(
				crossExperience.Constants.COMMUNICATIONS.EXECUTE_GET_PARTY_VOICE_DEBUG_STATS,
				{},
				function(p)
					callback(p)
				end,
				function()
					callback2()
				end
			)
		end)
	end

	return promise.resolve({})
end

function CrossExperienceVoiceManager.performJoinFeasibilityCheck(p)
	if not getFFlagEnableCrossExpVoiceMemoryCheck() then
		return true
	end

	local success, result = pcall(function()
		return game:GetService("PerformanceControlService")
	end)

	if not (success and result) then
		p.JoinFeasibilityCheckPerformed:Fire(false)
		return false
	end

	local success2, result2 = pcall(function()
		return result:IsCrossExperienceLaunchFeasible(crossExperience.Constants.EXPERIENCE_TYPE_VOICE)
	end)

	if success2 then
		p.JoinFeasibilityCheckPerformed:Fire(result2)
		return result2
	end

	if fFlagFixCrossExperienceVoiceExecutePrint then
		Logger:warning("performJoinFeasibilityCheck() - failed to check feasibility", result2)
	else
		Logger:warn("performJoinFeasibilityCheck() - failed to check feasibility", result2)
	end

	p.JoinFeasibilityCheckPerformed:Fire(false)
	return false
end

function CrossExperienceVoiceManager:ignoreMemoryWarning()
	if not getFFlagEnableCrossExpVoiceMemoryCheck() then
		return
	end

	communication.execute(crossExperience.Constants.COMMUNICATIONS.EXECUTE_PARTY_VOICE_IGNORE_LOW_MEMORY, {}, fn, fn)
end

function CrossExperienceVoiceManager:join(data)
	if data.shouldIgnoreMemoryWarning then
		self.shouldIgnoreMemoryWarning = true
	end

	if not self.isInitialized then
		self:initialize()
	end

	local v = tonumber(defineFastString)

	if self.isConnected and not data.force then
		if fFlagFixCrossExperienceVoiceExecutePrint then
			Logger:info("CrossExperienceVoiceManager:join() - already connected, returning early.")
		else
			print("CrossExperienceVoiceManager:join() - already connected, returning early.")
		end

		self.JoinRequestSubmitted:Fire(true)
	else
		if game:GetEngineFeature("CEVGetBackgroundState") then
			local v2, v3 = self:getIsBackgroundDMActive():await()

			if v2 and v3 and not data.force then
				self:setAsConnected()
				self.JoinRequestSubmitted:Fire(true)
				return
			end
		end

		self.currentCevJoinAttemptId = HttpService:GenerateGUID(false)

		pcall(function()
			MemStorageService:SetItem(CEV_JOIN_ATTEMPT_ID_KEY, self.currentCevJoinAttemptId)
		end)

		local voiceAnalytics = self.voiceAnalytics
		local v2 = {
			isConnected = self.isConnected,
			targetPlaceId = v,
			partyId = data.partyId,
			userId = not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId,
			activeDm = 0
		}
		local activeDm

		if self.isActiveDM then
			activeDm = crossExperience.Constants.EXPERIENCE_TYPE_LUAAPP
		else
			activeDm = crossExperience.Constants.EXPERIENCE_TYPE_UGC
		end

		v2.activeDm = activeDm
		voiceAnalytics:logPartyVoiceJoinAttempt(v2)

		self.JoinRequested:Fire()

		if fIntPartyVoiceJoinRequestPulseCheckTimeout > 0 then
			if self.joinRequestPulseCheckId then
				clearTimeout(self.joinRequestPulseCheckId)
				self.joinRequestPulseCheckId = nil
			end

			self.joinRequestPulseCheckId = setTimeout(function()
				self.JoinRequestPulseCheck:Fire()
			end, fIntPartyVoiceJoinRequestPulseCheckTimeout)
		end

		self.isConnected = true

		if getFFlagJoinCrossExpVoiceWithPartyId() then
			if data and data.partyId then
				self.currentPartyId = data.partyId
				local success, result = pcall(function()
					Logger:info("CrossExperienceVoiceManager:join() - starting cross experience voice with partyId " .. data.partyId)

					local EXPERIENCE_TYPE_VOICE = crossExperience.Constants.EXPERIENCE_TYPE_VOICE
					local v3 = { partyId = data.partyId, placeId = v, joinAttemptId = 0 }
					local joinAttemptId

					if engineFeature2 then
						joinAttemptId = self.currentCevJoinAttemptId
					end

					v3.joinAttemptId = joinAttemptId
					ExperienceService:StartCrossExperience(EXPERIENCE_TYPE_VOICE, v3)
				end)

				if not success then
					if fFlagFixCrossExperienceVoiceExecutePrint then
						Logger:warning("Failed to join cross experience voice with partyId " .. data.partyId, result)
					else
						Logger:warn("Failed to join cross experience voice with partyId " .. data.partyId, result)
					end

					local v3 = not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId
					self.voiceAnalytics:logPartyVoiceJoinFailure(data.partyId, result, v3)
					self.currentPartyId = nil
				end
			else
				if fFlagFixCrossExperienceVoiceExecutePrint then
					Logger:warning("CrossExperienceVoiceManager:join() - params.partyId is required to join cross experience voice")
				else
					Logger:warn("CrossExperienceVoiceManager:join() - params.partyId is required to join cross experience voice")
				end

				self.isConnected = false
				self.currentPartyId = nil
				self.JoinRequestSubmitted:Fire(self.isConnected)
				return
			end
		else
			local success, result = pcall(function()
				Logger:info("CrossExperienceVoiceManager:join() - starting cross experience voice")
				local EXPERIENCE_TYPE_VOICE = crossExperience.Constants.EXPERIENCE_TYPE_VOICE
				local v3 = { placeId = v, joinAttemptId = 0 }
				local joinAttemptId

				if engineFeature2 then
					joinAttemptId = self.currentCevJoinAttemptId
				end

				v3.joinAttemptId = joinAttemptId
				ExperienceService:StartCrossExperience(EXPERIENCE_TYPE_VOICE, v3)
			end)

			if not success then
				if fFlagFixCrossExperienceVoiceExecutePrint then
					Logger:warning("Failed to join cross experience voice: ", result)
				else
					Logger:warn("Failed to join cross experience voice: ", result)
				end

				self.isConnected = false
				self.currentPartyId = nil
			end
		end

		self.JoinRequestSubmitted:Fire(self.isConnected)
	end
end

function CrossExperienceVoiceManager.changeInputDevice(_, deviceName: string, deviceGuid: string)
	communication.execute(
		crossExperience.Constants.COMMUNICATIONS.EXECUTE_CHANGE_PARTY_VOICE_INPUT_DEVICE,
		{ deviceName = deviceName, deviceGuid = deviceGuid },
		fn,
		fn
	)
end

function CrossExperienceVoiceManager.changeOutputDevice(_, deviceName: string, deviceGuid: string)
	communication.execute(
		crossExperience.Constants.COMMUNICATIONS.EXECUTE_CHANGE_PARTY_VOICE_OUTPUT_DEVICE,
		{ deviceName = deviceName, deviceGuid = deviceGuid },
		fn,
		fn
	)
end

function CrossExperienceVoiceManager.muteVoiceParticipant(data, userId: number)
	data.cevEventManager:notify(crossExperience.Constants.EVENTS.MUTE_PARTY_VOICE_PARTICIPANT, {
		userId = userId
	})

	data.voiceAnalytics:logPartyVoiceMuteParticipant(data.currentPartyId, userId)
end

function CrossExperienceVoiceManager.unmuteVoiceParticipant(data, userId: number)
	data.cevEventManager:notify(crossExperience.Constants.EVENTS.UNMUTE_PARTY_VOICE_PARTICIPANT, {
		userId = userId
	})

	data.voiceAnalytics:logPartyVoiceUnmuteParticipant(data.currentPartyId, userId)
end

function CrossExperienceVoiceManager.enableVoiceChanger(p, userId: number)
	p.cevEventManager:notify(crossExperience.Constants.EVENTS.ENABLE_PARTY_VOICE_CHANGER, {
		userId = userId
	})
end

function CrossExperienceVoiceManager.disableVoiceChanger(p, userId: number)
	p.cevEventManager:notify(crossExperience.Constants.EVENTS.DISABLE_PARTY_VOICE_CHANGER, {
		userId = userId
	})
end

function CrossExperienceVoiceManager.setVoicePack(p, voicePackName: string)
	p.cevEventManager:notify(crossExperience.Constants.EVENTS.SET_PARTY_VOICE_PACK, {
		voicePackName = voicePackName
	})
end

function CrossExperienceVoiceManager.enableHearMyself(p, userId: number)
	p.cevEventManager:notify(crossExperience.Constants.EVENTS.ENABLE_PARTY_VOICE_CHANGER_FEEDBACK, {
		userId = userId
	})
end

function CrossExperienceVoiceManager.disableHearMyself(p, userId: number)
	p.cevEventManager:notify(crossExperience.Constants.EVENTS.DISABLE_PARTY_VOICE_CHANGER_FEEDBACK, {
		userId = userId
	})
end

function CrossExperienceVoiceManager.blockVoiceParticipant(data, userId: number)
	if data.isConnected then
		data.cevEventManager:notify(crossExperience.Constants.EVENTS.PARTY_VOICE_BLOCK_PARTICIPANT, {
			userId = userId
		})

		data.voiceAnalytics:logPartyVoiceBlockParticipant(data.currentPartyId, userId)
	end
end

function CrossExperienceVoiceManager.unblockVoiceParticipant(data, userId: number)
	if data.isConnected then
		data.cevEventManager:notify(crossExperience.Constants.EVENTS.PARTY_VOICE_UNBLOCK_PARTICIPANT, {
			userId = userId
		})

		data.voiceAnalytics:logPartyVoiceUnblockParticipant(data.currentPartyId, userId)
	end
end

function CrossExperienceVoiceManager.dumpDebugData(p)
	p.cevEventManager:notify(crossExperience.Constants.EVENTS.DEBUG_COMMAND, {
		name = "dump_session"
	})
end

function CrossExperienceVoiceManager:leave()
	ExperienceService:StopCrossExperience(crossExperience.Constants.EXPERIENCE_TYPE_VOICE, {})

	if self.joinRequestPulseCheckId then
		clearTimeout(self.joinRequestPulseCheckId)
		self.joinRequestPulseCheckId = nil
	end

	self.voiceAnalytics:reset()
end

function CrossExperienceVoiceManager.rejoinVoice(p)
	p.cevEventManager:notify(crossExperience.Constants.EVENTS.PARTY_VOICE_RECONNECT_REQUESTED, {})
end

function CrossExperienceVoiceManager:resetCEVMemStorage()
	self.currentCevJoinAttemptId = nil
	pcall(function()
		MemStorageService:RemoveItem(CEV_JOIN_ATTEMPT_ID_KEY)
	end)
end

function CrossExperienceVoiceManager:disconnect()
	self.isConnected = false
	self.currentPartyId = nil
	self.hasExperienceStarted = false
	self.shouldIgnoreMemoryWarning = false

	Logger:info("Disconnecting, resetting observers")
	self.observersInitialized = false

	if self.joinRequestPulseCheckId then
		clearTimeout(self.joinRequestPulseCheckId)
		self.joinRequestPulseCheckId = nil
	end

	persistenceMiddleware.clean()
end

function CrossExperienceVoiceManager:getAudioFocusService()
	if not engineFeature then
		return nil
	end

	local success, result = pcall(function()
		return game:GetService("AudioFocusService")
	end)
	return if success and result then result else nil
end

function CrossExperienceVoiceManager:getCurrentAudioContext()
	local audioFocusService = self:getAudioFocusService()

	if audioFocusService == nil then
		return -1
	end

	return audioFocusService:GetFocusedContextId()
end

function CrossExperienceVoiceManager:toggleAudioFocus()
	local audioFocusService = self:getAudioFocusService()

	if audioFocusService == nil then
		return
	end

	local registeredContexts = audioFocusService:GetRegisteredContexts()
	local v = false
	local v2 = false

	for k, _ in pairs(registeredContexts) do
		v = k == AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID or v

		if k == AUDIO_FOCUS_MANAGEMENT.UGC.CONTEXT_ID then
			v2 = true
		end
	end

	if v and v2 then
		audioFocusService:AcquireFocus(audioFocusService:GetFocusedContextId() == AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID and AUDIO_FOCUS_MANAGEMENT.UGC.CONTEXT_ID or AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID)
	end
end

function CrossExperienceVoiceManager.muteAll(p, context: string?)
	if not getFFlagEnableCrossExperienceVoiceCaptureMute() then
		return
	end

	if p.isConnected then
		p.cevEventManager:notify(crossExperience.Constants.EVENTS.PARTY_VOICE_MUTE_ALL, {
			context = context
		})
	end
end

function CrossExperienceVoiceManager.unmuteAll(p, context: string?)
	if not getFFlagEnableCrossExperienceVoiceCaptureMute() then
		return
	end

	if p.isConnected then
		p.cevEventManager:notify(crossExperience.Constants.EVENTS.PARTY_VOICE_UNMUTE_ALL, {
			context = context
		})
	end
end

function CrossExperienceVoiceManager.signalCevReadinessSync(p)
	if not game:GetEngineFeature("CevReadinessSync") then
		return
	end

	p.cevEventManager:notify(crossExperience.Constants.EVENTS.FOREGROUND_UI_READY, {})
end

CrossExperienceVoiceManager.default = CrossExperienceVoiceManager.new()
return CrossExperienceVoiceManager
