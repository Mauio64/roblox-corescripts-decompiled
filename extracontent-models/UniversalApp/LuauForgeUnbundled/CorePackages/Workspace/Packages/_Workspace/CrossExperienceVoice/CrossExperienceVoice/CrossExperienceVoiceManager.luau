local ExperienceService = game:GetService("ExperienceService")
local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies")

local promise = dependencies.Promise

local crossExperience = dependencies.CrossExperience
local communication = crossExperience.Communication
local sharedFlags = dependencies.SharedFlags
local luauPolyfill = dependencies.LuauPolyfill
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Common/Constants")
local CrossExperienceVoiceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/CrossExperienceVoiceAnalytics")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Logger")
local Flags = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Flags")

local createPersistenceMiddleware = crossExperience.Middlewares.createPersistenceMiddleware

local class = {}
class.__index = class

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

function class.new()
	local v5 = {
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
		cevEventManager = 0,
		voiceAnalytics = 0,
		isActiveDM = true
	}
	local new = crossExperience.EventManager.new
	local v6

	if game.PlaceId == 0 then
		v6 = crossExperience.Constants.EXPERIENCE_TYPE_LUAAPP
	else
		v6 = crossExperience.Constants.EXPERIENCE_TYPE_UGC
	end

	v5.cevEventManager = new(v6, false)
	v5.voiceAnalytics = CrossExperienceVoiceAnalytics.default

	setmetatable(v5, class)
	return v5
end

function class:logPartyVoiceTimeout()
	self.voiceAnalytics:logPartyVoiceTimeout(self.currentPartyId)
end

function class:initialize()
	self.voiceAnalytics:initialize(self.cevEventManager)

	if self.isInitialized == true then
		return
	end

	table.insert(self.connections, ExperienceService:RegisterForExperienceJoin(function()
		local v5

		if game.PlaceId == 0 then
			v5 = crossExperience.Constants.EXPERIENCE_TYPE_LUAAPP
		else
			v5 = crossExperience.Constants.EXPERIENCE_TYPE_UGC
		end

		if v5 == crossExperience.Constants.EXPERIENCE_TYPE_LUAAPP then
			self.isActiveDM = false
		end
	end))

	table.insert(self.connections, ExperienceService:RegisterForExperienceLeave(function()
		local v5

		if game.PlaceId == 0 then
			v5 = crossExperience.Constants.EXPERIENCE_TYPE_LUAAPP
		else
			v5 = crossExperience.Constants.EXPERIENCE_TYPE_UGC
		end

		if v5 == crossExperience.Constants.EXPERIENCE_TYPE_LUAAPP then
			self.isActiveDM = true
		end
	end))

	table.insert(self.connections, ExperienceService.OnCrossExperienceStarted:Connect(function(p2, p3)
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

		self.cevEventManager:addObserver(
			crossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED,
			function(p4)
				self.voiceAnalytics:logPartyVoiceStateChangeHandlerRun(self.isActiveDM, p4)

				if not self.isActiveDM then
					return
				end

				if
					Flags.FFlagFireErrorRCCTimeoutSignal
					and p4.status == crossExperience.Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT
				then
					self.voiceAnalytics:logPartyVoiceTimeout(self.currentPartyId)
				elseif Flags.FFlagPartyVoiceLogActiveDM then
					local v5

					if self.isActiveDM then
						v5 = crossExperience.Constants.EXPERIENCE_TYPE_LUAAPP
					else
						v5 = crossExperience.Constants.EXPERIENCE_TYPE_UGC
					end

					if p4.status == crossExperience.Constants.VOICE_STATUS.VOICE_CONNECTED then
						self.voiceAnalytics:logPartyVoiceConnectedState(p4, self.currentPartyId, v5)
					end

					self.voiceAnalytics:logPartyVoiceStatusChanged(p4, self.currentPartyId, v5)
				else
					if p4.status == crossExperience.Constants.VOICE_STATUS.VOICE_CONNECTED then
						self.voiceAnalytics:logPartyVoiceConnectedState(p4, self.currentPartyId, "")
					end

					self.voiceAnalytics:logPartyVoiceStatusChanged(p4, self.currentPartyId, "")
				end

				if
					fStringTimeoutLoadingLocalPlayerInBackgroundDM ~= LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable
					and p4.status == crossExperience.Constants.VOICE_STATUS.ERROR_BACKGROUND_DM_LOAD_LOCALPLAYER_TIMEOUT
					or p4.status == crossExperience.Constants.VOICE_STATUS.ERROR_VOICE_DISCONNECTED
					or Flags.FFlagFireErrorRCCTimeoutSignal
					and p4.status == crossExperience.Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT
				then
					self:leave()
				end
			end
		)

		self.cevEventManager:addObserver(
			crossExperience.Constants.EVENTS.PARTY_VOICE_GAME_JOIN_FAILED,
			function(p4)
				self.ExperienceJoinFailed:Fire()
				local v5 = not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId

				local v6 = not (p4 and p4.state) and "PARTY_VOICE_GAME_JOIN_FAILED:-1"
					or "PARTY_VOICE_GAME_JOIN_FAILED:" .. tostring(p4.state)

				self.voiceAnalytics:logPartyVoiceJoinFailure(self.currentPartyId, v6, v5)
			end
		)

		if getFFlagEnableCrossExpVoiceMemoryCheck() then
			self.cevEventManager:addObserver(
				crossExperience.Constants.EVENTS.PARTY_VOICE_MEMORY_LOW,
				function()
					self:ignoreMemoryWarning()

					if not self.shouldIgnoreMemoryWarning then
						self.MemoryLow:Fire()
						self.shouldIgnoreMemoryWarning = true
					end
				end
			)
		end

		self.ExperienceJoined:Fire()
		self.hasExperienceStarted = true
	end))

	table.insert(self.connections, ExperienceService.OnCrossExperienceStopped:Connect(function(p2, p3)
		self:disconnect()
		self.ExperienceLeft:Fire()
		self:resetCEVMemStorage()
	end))

	table.insert(self.connections, NotificationService.RobloxEventReceived:Connect(function(p2)
		if p2.detailType == "SignOut" then
			self:onUserLogout()
		end
	end))

	self.isInitialized = true
end

function class:onUserLogout()
	if self.hasExperienceStarted then
		self:leave()
	end

	if self.isConnected then
		self:disconnect()
		self.ExperienceLeft:Fire()
		self:resetCEVMemStorage()
	end
end

function class.getIsConnected(p2)
	return p2.isConnected
end

function class:setAsDisconnected()
	self.isConnected = false
	self.hasExperienceStarted = false

	if self.ExperienceLeft then
		self.ExperienceLeft:Fire()
	end
end

function class:setAsConnected()
	if not self.isInitialized then
		self:initialize()
	end

	self.isConnected = true
	self.hasExperienceStarted = true
	self.ExperienceJoined:Fire()
end

function class:getIsBackgroundDMActive()
	return promise.new(function(callback, callback2)
		communication.execute(
			crossExperience.Constants.COMMUNICATIONS.EXECUTE_GET_BACKGROUND_DM_STATE,
			{},
			function(p3)
				callback(p3.status == BACKGROUND_DM_STATUS.ACTIVE or p3.status == BACKGROUND_DM_STATUS.BACKGROUND)
			end,
			function()
				callback2()
			end
		)
	end)
end

function class.getPartyVoiceDebugStats(p2)
	if Flags.FFlagVoiceDebugConsoleV2 then
		return promise.new(function(callback, callback2)
			communication.execute(
				crossExperience.Constants.COMMUNICATIONS.EXECUTE_GET_PARTY_VOICE_DEBUG_STATS,
				{},
				function(p3)
					callback(p3)
				end,
				function()
					callback2()
				end
			)
		end)
	end

	return promise.resolve({})
end

function class:performJoinFeasibilityCheck()
	if not getFFlagEnableCrossExpVoiceMemoryCheck() then
		return true
	end

	local success, result = pcall(function()
		return game:GetService("PerformanceControlService")
	end)

	if not (success and result) then
		self.JoinFeasibilityCheckPerformed:Fire(false)
		return false
	end

	local success2, result2 = pcall(function()
		return result:IsCrossExperienceLaunchFeasible(crossExperience.Constants.EXPERIENCE_TYPE_VOICE)
	end)

	if success2 then
		self.JoinFeasibilityCheckPerformed:Fire(result2)
		return result2
	end

	if fFlagFixCrossExperienceVoiceExecutePrint then
		Logger:warning("performJoinFeasibilityCheck() - failed to check feasibility", result2)
	else
		Logger:warn("performJoinFeasibilityCheck() - failed to check feasibility", result2)
	end

	self.JoinFeasibilityCheckPerformed:Fire(false)
	return false
end

function class:ignoreMemoryWarning()
	if not getFFlagEnableCrossExpVoiceMemoryCheck() then
		return
	end

	communication.execute(
		crossExperience.Constants.COMMUNICATIONS.EXECUTE_PARTY_VOICE_IGNORE_LOW_MEMORY,
		{},
		fn,
		fn
	)
end

function class:join(data)
	if data.shouldIgnoreMemoryWarning then
		self.shouldIgnoreMemoryWarning = true
	end

	if not self.isInitialized then
		self:initialize()
	end

	local v5 = tonumber(defineFastString)

	if self.isConnected and not data.force then
		if fFlagFixCrossExperienceVoiceExecutePrint then
			Logger:info("CrossExperienceVoiceManager:join() - already connected, returning early.")
		else
			print("CrossExperienceVoiceManager:join() - already connected, returning early.")
		end

		self.JoinRequestSubmitted:Fire(true)
	else
		if game:GetEngineFeature("CEVGetBackgroundState") then
			local v6, v7 = self:getIsBackgroundDMActive():await()

			if v6 and v7 and not data.force then
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
		local v6 = {
			isConnected = self.isConnected,
			targetPlaceId = v5,
			partyId = data.partyId,
			userId = not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId,
			activeDm = 0
		}
		local v7 = if self.isActiveDM then crossExperience.Constants.EXPERIENCE_TYPE_LUAAPP else crossExperience.Constants.EXPERIENCE_TYPE_UGC
		v6.activeDm = v7
		voiceAnalytics:logPartyVoiceJoinAttempt(v6)

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
					local v9 = {
						partyId = data.partyId,
						placeId = v5,
						joinAttemptId = 0
					}

					local v10 = if engineFeature2 then self.currentCevJoinAttemptId else nil
					v9.joinAttemptId = v10
					ExperienceService:StartCrossExperience(EXPERIENCE_TYPE_VOICE, v9)
				end)

				if not success then
					if fFlagFixCrossExperienceVoiceExecutePrint then
						Logger:warning(
							"Failed to join cross experience voice with partyId " .. data.partyId,
							result
						)
					else
						Logger:warn(
							"Failed to join cross experience voice with partyId " .. data.partyId,
							result
						)
					end

					local v8 = not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId
					self.voiceAnalytics:logPartyVoiceJoinFailure(data.partyId, result, v8)
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
				local v9 = { placeId = v5, joinAttemptId = 0 }

				local v10 = if engineFeature2 then self.currentCevJoinAttemptId else nil
				v9.joinAttemptId = v10
				ExperienceService:StartCrossExperience(EXPERIENCE_TYPE_VOICE, v9)
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

function class.changeInputDevice(p2, p3, p4)
	communication.execute(
		crossExperience.Constants.COMMUNICATIONS.EXECUTE_CHANGE_PARTY_VOICE_INPUT_DEVICE,
		{ deviceName = p3, deviceGuid = p4 },
		fn,
		fn
	)
end

function class.changeOutputDevice(p2, p3, p4)
	communication.execute(
		crossExperience.Constants.COMMUNICATIONS.EXECUTE_CHANGE_PARTY_VOICE_OUTPUT_DEVICE,
		{ deviceName = p3, deviceGuid = p4 },
		fn,
		fn
	)
end

function class:muteVoiceParticipant(p2)
	self.cevEventManager:notify(crossExperience.Constants.EVENTS.MUTE_PARTY_VOICE_PARTICIPANT, {
		userId = p2
	})

	self.voiceAnalytics:logPartyVoiceMuteParticipant(self.currentPartyId, p2)
end

function class:unmuteVoiceParticipant(p2)
	self.cevEventManager:notify(crossExperience.Constants.EVENTS.UNMUTE_PARTY_VOICE_PARTICIPANT, {
		userId = p2
	})

	self.voiceAnalytics:logPartyVoiceUnmuteParticipant(self.currentPartyId, p2)
end

function class:enableVoiceChanger(p3)
	self.cevEventManager:notify(crossExperience.Constants.EVENTS.ENABLE_PARTY_VOICE_CHANGER, {
		userId = p3
	})
end

function class:disableVoiceChanger(p3)
	self.cevEventManager:notify(crossExperience.Constants.EVENTS.DISABLE_PARTY_VOICE_CHANGER, {
		userId = p3
	})
end

function class:setVoicePack(p3)
	self.cevEventManager:notify(crossExperience.Constants.EVENTS.SET_PARTY_VOICE_PACK, {
		voicePackName = p3
	})
end

function class:enableHearMyself(p3)
	self.cevEventManager:notify(crossExperience.Constants.EVENTS.ENABLE_PARTY_VOICE_CHANGER_FEEDBACK, {
		userId = p3
	})
end

function class:disableHearMyself(p3)
	self.cevEventManager:notify(crossExperience.Constants.EVENTS.DISABLE_PARTY_VOICE_CHANGER_FEEDBACK, {
		userId = p3
	})
end

function class:blockVoiceParticipant(p2)
	if self.isConnected then
		self.cevEventManager:notify(crossExperience.Constants.EVENTS.PARTY_VOICE_BLOCK_PARTICIPANT, {
			userId = p2
		})

		self.voiceAnalytics:logPartyVoiceBlockParticipant(self.currentPartyId, p2)
	end
end

function class:unblockVoiceParticipant(p2)
	if self.isConnected then
		self.cevEventManager:notify(crossExperience.Constants.EVENTS.PARTY_VOICE_UNBLOCK_PARTICIPANT, {
			userId = p2
		})

		self.voiceAnalytics:logPartyVoiceUnblockParticipant(self.currentPartyId, p2)
	end
end

function class:dumpDebugData()
	self.cevEventManager:notify(crossExperience.Constants.EVENTS.DEBUG_COMMAND, {
		name = "dump_session"
	})
end

function class:leave()
	ExperienceService:StopCrossExperience(crossExperience.Constants.EXPERIENCE_TYPE_VOICE, {})

	if self.joinRequestPulseCheckId then
		clearTimeout(self.joinRequestPulseCheckId)
		self.joinRequestPulseCheckId = nil
	end

	self.voiceAnalytics:reset()
end

function class:rejoinVoice()
	self.cevEventManager:notify(crossExperience.Constants.EVENTS.PARTY_VOICE_RECONNECT_REQUESTED, {})
end

function class:resetCEVMemStorage()
	self.currentCevJoinAttemptId = nil
	pcall(function()
		MemStorageService:RemoveItem(CEV_JOIN_ATTEMPT_ID_KEY)
	end)
end

function class:disconnect()
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

function class:getAudioFocusService()
	if not engineFeature then
		return nil
	end

	local success, result = pcall(function()
		return game:GetService("AudioFocusService")
	end)

	if success and result then
		return result
	end

	return nil
end

function class:getCurrentAudioContext()
	local audioFocusService = self:getAudioFocusService()

	if audioFocusService == nil then
		return -1
	end

	return audioFocusService:GetFocusedContextId()
end

function class:toggleAudioFocus()
	local audioFocusService = self:getAudioFocusService()

	if audioFocusService == nil then
		return
	end

	local registeredContexts = audioFocusService:GetRegisteredContexts()
	local v5 = false
	local v6 = false

	for k, registeredContext in pairs(registeredContexts) do
		v5 = k == AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID or v5

		if k == AUDIO_FOCUS_MANAGEMENT.UGC.CONTEXT_ID then
			v6 = true
		end
	end

	if v5 and v6 then
		audioFocusService:AcquireFocus(audioFocusService:GetFocusedContextId() == AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID and AUDIO_FOCUS_MANAGEMENT.UGC.CONTEXT_ID or AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID)
	end
end

function class:muteAll(p3)
	if not getFFlagEnableCrossExperienceVoiceCaptureMute() then
		return
	end

	if self.isConnected then
		self.cevEventManager:notify(crossExperience.Constants.EVENTS.PARTY_VOICE_MUTE_ALL, {
			context = p3
		})
	end
end

function class:unmuteAll(p3)
	if not getFFlagEnableCrossExperienceVoiceCaptureMute() then
		return
	end

	if self.isConnected then
		self.cevEventManager:notify(crossExperience.Constants.EVENTS.PARTY_VOICE_UNMUTE_ALL, {
			context = p3
		})
	end
end

function class:signalCevReadinessSync()
	if not game:GetEngineFeature("CevReadinessSync") then
		return
	end

	self.cevEventManager:notify(crossExperience.Constants.EVENTS.FOREGROUND_UI_READY, {})
end

class.default = class.new()
return class
