local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local ExperienceService = game:GetService("ExperienceService")
local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")
local dependencies = require(CrossExperienceVoice.dependencies)
local Promise = dependencies.Promise
local CrossExperience = dependencies.CrossExperience
local Communication = CrossExperience.Communication
local SharedFlags = dependencies.SharedFlags
local LuauPolyfill = dependencies.LuauPolyfill
local Constants = require(CrossExperienceVoice.Common.Constants)
local CrossExperienceVoiceAnalytics = require(CrossExperienceVoice.CrossExperienceVoiceAnalytics)
local Logger = require(CrossExperienceVoice.Logger)
local Flags = require(CrossExperienceVoice.Flags)
local createPersistenceMiddleware = CrossExperience.Middlewares.createPersistenceMiddleware
local t1 = {}

t1.__index = t1

local getFFlagJoinCrossExpVoiceWithPartyId = SharedFlags.getFFlagJoinCrossExpVoiceWithPartyId
local getFFlagEnableCrossExpVoiceMemoryCheck = SharedFlags.getFFlagEnableCrossExpVoiceMemoryCheck
local GetFFlagEnableCrossExperienceVoiceCaptureMute = SharedFlags.GetFFlagEnableCrossExperienceVoiceCaptureMute
local FStringTimeoutLoadingLocalPlayerInBackgroundDM = SharedFlags.FStringTimeoutLoadingLocalPlayerInBackgroundDM
local EngineFeature = game:GetEngineFeature("AudioFocusManagement")
local EngineFeature2 = game:GetEngineFeature("RecordJoinAttemptIdForCEV")
local FIntPartyVoiceJoinRequestPulseCheckTimeout = SharedFlags.FIntPartyVoiceJoinRequestPulseCheckTimeout
local BACKGROUND_DM_STATUS = CrossExperience.Constants.BACKGROUND_DM_STATUS
local AUDIO_FOCUS_MANAGEMENT = CrossExperience.Constants.AUDIO_FOCUS_MANAGEMENT
local LOCAL_PLAYER_LOADING_TIMEOUT_ENUM = CrossExperience.Constants.LOCAL_PLAYER_LOADING_TIMEOUT_ENUM
local CEV_JOIN_ATTEMPT_ID_KEY = CrossExperience.Constants.CEV_JOIN_ATTEMPT_ID_KEY
local v30 = createPersistenceMiddleware({
	storeKey = CrossExperience.Constants.STORAGE_CEV_STORE_KEY
})
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout
local FFlagFixCrossExperienceVoiceExecutePrint = SharedFlags.FFlagFixCrossExperienceVoiceExecutePrint
local v34 = game:DefineFastString("CrossExpVoicePlaceId", (tostring(Constants.DEFAULT_EXPERIENCE_PLACE_ID)))

local function v35() -- line: 57
end

function t1.new() -- line: 135
	-- upvalues: CrossExperience (copy), CrossExperienceVoiceAnalytics (copy), t1 (copy)
	local t2 = {
		joinRequestPulseCheckId = nil,
		isInitialized = false,
		isConnected = false,
		shouldIgnoreMemoryWarning = false,
		hasExperienceStarted = false,
		observersInitialized = false,
		currentCevJoinAttemptId = nil,
		isActiveDM = true,
		connections = {},
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
		cevEventManager = CrossExperience.EventManager.new(if game.PlaceId ~= 0 then CrossExperience.Constants.EXPERIENCE_TYPE_UGC else CrossExperience.Constants.EXPERIENCE_TYPE_LUAAPP, false),
		voiceAnalytics = CrossExperienceVoiceAnalytics.default
	}

	setmetatable(t2, t1)

	return t2
end
function t1.logPartyVoiceTimeout(p1) -- line: 168
	p1.voiceAnalytics:logPartyVoiceTimeout(p1.currentPartyId)
end
function t1.initialize(p2) -- line: 172
	-- upvalues: ExperienceService (copy), CrossExperience (copy), Logger (copy), Flags (copy), FStringTimeoutLoadingLocalPlayerInBackgroundDM (copy), LOCAL_PLAYER_LOADING_TIMEOUT_ENUM (copy), Players (copy), getFFlagEnableCrossExpVoiceMemoryCheck (copy), NotificationService (copy)
	p2.voiceAnalytics:initialize(p2.cevEventManager)

	if p2.isInitialized == true then
		return
	end

	table.insert(p2.connections, ExperienceService:RegisterForExperienceJoin(function() -- line: 181
		-- upvalues: CrossExperience (copy), p2 (copy)
		if ((if game.PlaceId ~= 0 then CrossExperience.Constants.EXPERIENCE_TYPE_UGC else CrossExperience.Constants.EXPERIENCE_TYPE_LUAAPP)) == CrossExperience.Constants.EXPERIENCE_TYPE_LUAAPP then
			p2.isActiveDM = false
		end
	end))
	table.insert(p2.connections, ExperienceService:RegisterForExperienceLeave(function() -- line: 191
		-- upvalues: CrossExperience (copy), p2 (copy)
		if ((if game.PlaceId ~= 0 then CrossExperience.Constants.EXPERIENCE_TYPE_UGC else CrossExperience.Constants.EXPERIENCE_TYPE_LUAAPP)) == CrossExperience.Constants.EXPERIENCE_TYPE_LUAAPP then
			p2.isActiveDM = true
		end
	end))
	table.insert(p2.connections, ExperienceService.OnCrossExperienceStarted:Connect(function(_, _) -- line: 201
		-- upvalues: p2 (copy), Logger (copy), CrossExperience (copy), Flags (copy), FStringTimeoutLoadingLocalPlayerInBackgroundDM (copy), LOCAL_PLAYER_LOADING_TIMEOUT_ENUM (copy), Players (copy), getFFlagEnableCrossExpVoiceMemoryCheck (copy)
		p2.voiceAnalytics:logPartyVoiceOnCrossExperienceStartedSignalReceived(p2.hasExperienceStarted, p2.isActiveDM)

		if p2.hasExperienceStarted then
			return
		end

		if p2.observersInitialized then
			Logger:info("Observers already initialized, skipping duplicate setup")

			return
		end

		p2.observersInitialized = true
		Logger:info("Initializing observers for the first time")
		p2.cevEventManager:addObserver(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, function(p5) -- line: 221
			-- upvalues: p2 (copy), Flags (copy), CrossExperience (copy), FStringTimeoutLoadingLocalPlayerInBackgroundDM (copy), LOCAL_PLAYER_LOADING_TIMEOUT_ENUM (copy)
			p2.voiceAnalytics:logPartyVoiceStateChangeHandlerRun(p2.isActiveDM, p5)

			if not p2.isActiveDM then
				return
			end

			if Flags.FFlagFireErrorRCCTimeoutSignal and p5.status == CrossExperience.Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT then
				p2.voiceAnalytics:logPartyVoiceTimeout(p2.currentPartyId)
			elseif Flags.FFlagPartyVoiceLogActiveDM then
				local v114 = if not p2.isActiveDM then CrossExperience.Constants.EXPERIENCE_TYPE_UGC else CrossExperience.Constants.EXPERIENCE_TYPE_LUAAPP

				if p5.status == CrossExperience.Constants.VOICE_STATUS.VOICE_CONNECTED then
					p2.voiceAnalytics:logPartyVoiceConnectedState(p5, p2.currentPartyId, v114)
				end

				p2.voiceAnalytics:logPartyVoiceStatusChanged(p5, p2.currentPartyId, v114)
			else
				if p5.status == CrossExperience.Constants.VOICE_STATUS.VOICE_CONNECTED then
					p2.voiceAnalytics:logPartyVoiceConnectedState(p5, p2.currentPartyId, "")
				end

				p2.voiceAnalytics:logPartyVoiceStatusChanged(p5, p2.currentPartyId, "")
			end

			if FStringTimeoutLoadingLocalPlayerInBackgroundDM ~= LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable and p5.status == CrossExperience.Constants.VOICE_STATUS.ERROR_BACKGROUND_DM_LOAD_LOCALPLAYER_TIMEOUT or p5.status == CrossExperience.Constants.VOICE_STATUS.ERROR_VOICE_DISCONNECTED or Flags.FFlagFireErrorRCCTimeoutSignal and p5.status == CrossExperience.Constants.VOICE_STATUS.ERROR_RCC_TIMEOUT then
				p2:leave()
			end
		end)
		p2.cevEventManager:addObserver(CrossExperience.Constants.EVENTS.PARTY_VOICE_GAME_JOIN_FAILED, function(p6) -- line: 272
			-- upvalues: p2 (copy), Players (copy)
			p2.ExperienceJoinFailed:Fire()

			local v116 = not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId
			local s1 = "PARTY_VOICE_GAME_JOIN_FAILED:-1"

			if p6 and p6.state then
				s1 = "PARTY_VOICE_GAME_JOIN_FAILED:" .. tostring(p6.state)
			end

			p2.voiceAnalytics:logPartyVoiceJoinFailure(p2.currentPartyId, s1, v116)
		end)

		if getFFlagEnableCrossExpVoiceMemoryCheck() then
			p2.cevEventManager:addObserver(CrossExperience.Constants.EVENTS.PARTY_VOICE_MEMORY_LOW, function() -- line: 283
				-- upvalues: p2 (copy)
				p2:ignoreMemoryWarning()

				if not p2.shouldIgnoreMemoryWarning then
					p2.MemoryLow:Fire()
					p2.shouldIgnoreMemoryWarning = true
				end
			end)
		end

		p2.ExperienceJoined:Fire()
		p2.hasExperienceStarted = true
	end))
	table.insert(p2.connections, ExperienceService.OnCrossExperienceStopped:Connect(function(_, _) -- line: 298
		-- upvalues: p2 (copy)
		p2:disconnect()
		p2.ExperienceLeft:Fire()
		p2:resetCEVMemStorage()
	end))
	table.insert(p2.connections, NotificationService.RobloxEventReceived:Connect(function(p9) -- line: 310
		-- upvalues: p2 (copy)
		if p9.detailType == "SignOut" then
			p2:onUserLogout()
		end
	end))
	p2.isInitialized = true
end
function t1.onUserLogout(p10) -- line: 319
	if p10.hasExperienceStarted then
		p10:leave()
	end

	if p10.isConnected then
		p10:disconnect()
		p10.ExperienceLeft:Fire()
		p10:resetCEVMemStorage()
	end
end
function t1.getIsConnected(p11) -- line: 330
	return p11.isConnected
end
function t1.setAsDisconnected(p12) -- line: 334
	p12.isConnected = false
	p12.hasExperienceStarted = false

	if p12.ExperienceLeft then
		p12.ExperienceLeft:Fire()
	end
end
function t1.setAsConnected(p13) -- line: 342
	if not p13.isInitialized then
		p13:initialize()
	end

	p13.isConnected = true
	p13.hasExperienceStarted = true
	p13.ExperienceJoined:Fire()
end
function t1.getIsBackgroundDMActive(_) -- line: 351
	-- upvalues: Promise (copy), Communication (copy), CrossExperience (copy), BACKGROUND_DM_STATUS (copy)
	return Promise.new(function(resolve, reject) -- line: 352
		-- upvalues: Communication (copy), CrossExperience (copy), BACKGROUND_DM_STATUS (copy)
		Communication.execute(CrossExperience.Constants.COMMUNICATIONS.EXECUTE_GET_BACKGROUND_DM_STATE, {}, function(p15) -- line: 356
			-- upvalues: resolve (copy), BACKGROUND_DM_STATUS (copy)
			resolve(p15.status == BACKGROUND_DM_STATUS.ACTIVE or p15.status == BACKGROUND_DM_STATUS.BACKGROUND)
		end, function() -- line: 359
			-- upvalues: reject (copy)
			reject()
		end)
	end)
end
function t1.performJoinFeasibilityCheck(p16) -- line: 367
	-- upvalues: getFFlagEnableCrossExpVoiceMemoryCheck (copy), CrossExperience (copy), FFlagFixCrossExperienceVoiceExecutePrint (copy), Logger (copy)
	if not getFFlagEnableCrossExpVoiceMemoryCheck() then
		return true
	end

	local ok, result = pcall(function() -- line: 371
		return game:GetService("PerformanceControlService")
	end)

	if not ok or not result then
		p16.JoinFeasibilityCheckPerformed:Fire(false)

		return false
	end

	local ok2, result2 = pcall(function() -- line: 380
		-- upvalues: result (copy), CrossExperience (copy)
		return result:IsCrossExperienceLaunchFeasible(CrossExperience.Constants.EXPERIENCE_TYPE_VOICE)
	end)

	if not ok2 then
		if FFlagFixCrossExperienceVoiceExecutePrint then
			Logger:warning("performJoinFeasibilityCheck() - failed to check feasibility", result2)
		else
			Logger:warn("performJoinFeasibilityCheck() - failed to check feasibility", result2)
		end

		p16.JoinFeasibilityCheckPerformed:Fire(false)

		return false
	end

	p16.JoinFeasibilityCheckPerformed:Fire(result2)

	return result2
end
function t1.ignoreMemoryWarning(_) -- line: 400
	-- upvalues: getFFlagEnableCrossExpVoiceMemoryCheck (copy), Communication (copy), CrossExperience (copy), v35 (copy)
	if not getFFlagEnableCrossExpVoiceMemoryCheck() then
		return
	end

	Communication.execute(CrossExperience.Constants.COMMUNICATIONS.EXECUTE_PARTY_VOICE_IGNORE_LOW_MEMORY, {}, v35, v35)
end
function t1.join(t3: {[any]: any}, t4: {[any]: any}) -- line: 413
	-- upvalues: v34 (copy), FFlagFixCrossExperienceVoiceExecutePrint (copy), Logger (copy), HttpService (copy), MemStorageService (copy), CEV_JOIN_ATTEMPT_ID_KEY (copy), Players (copy), CrossExperience (copy), FIntPartyVoiceJoinRequestPulseCheckTimeout (copy), clearTimeout (copy), setTimeout (copy), getFFlagJoinCrossExpVoiceWithPartyId (copy), ExperienceService (copy), EngineFeature2 (copy)
	if t4.shouldIgnoreMemoryWarning then
		t3.shouldIgnoreMemoryWarning = true
	end

	if not t3.isInitialized then
		t3:initialize()
	end

	local num = tonumber(v34)

	if t3.isConnected and not t4.force then
		if FFlagFixCrossExperienceVoiceExecutePrint then
			Logger:info("CrossExperienceVoiceManager:join() - already connected, returning early.")
		else
			print("CrossExperienceVoiceManager:join() - already connected, returning early.")
		end

		t3.JoinRequestSubmitted:Fire(true)

		return
	end

	if game:GetEngineFeature("CEVGetBackgroundState") then
		local v53, v54 = t3:getIsBackgroundDMActive():await()

		if v53 and v54 and not t4.force then
			t3:setAsConnected()
			t3.JoinRequestSubmitted:Fire(true)

			return
		end
	end

	t3.currentCevJoinAttemptId = HttpService:GenerateGUID(false)
	pcall(function() -- line: 447
		-- upvalues: MemStorageService (copy), CEV_JOIN_ATTEMPT_ID_KEY (copy), t3 (copy)
		MemStorageService:SetItem(CEV_JOIN_ATTEMPT_ID_KEY, t3.currentCevJoinAttemptId)
	end)
	t3.voiceAnalytics:logPartyVoiceJoinAttempt({
		isConnected = t3.isConnected,
		targetPlaceId = num,
		partyId = t4.partyId,
		userId = not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId,
		activeDm = if not t3.isActiveDM then CrossExperience.Constants.EXPERIENCE_TYPE_UGC else CrossExperience.Constants.EXPERIENCE_TYPE_LUAAPP
	})
	t3.JoinRequested:Fire()

	if FIntPartyVoiceJoinRequestPulseCheckTimeout > 0 then
		if t3.joinRequestPulseCheckId then
			clearTimeout(t3.joinRequestPulseCheckId)
			t3.joinRequestPulseCheckId = nil
		end

		t3.joinRequestPulseCheckId = setTimeout(function() -- line: 467
			-- upvalues: t3 (copy)
			t3.JoinRequestPulseCheck:Fire()
		end, FIntPartyVoiceJoinRequestPulseCheckTimeout)
	end

	t3.isConnected = true

	if getFFlagJoinCrossExpVoiceWithPartyId() then
		if not t4 or not t4.partyId then
			if FFlagFixCrossExperienceVoiceExecutePrint then
				Logger:warning("CrossExperienceVoiceManager:join() - params.partyId is required to join cross experience voice")
			else
				Logger:warn("CrossExperienceVoiceManager:join() - params.partyId is required to join cross experience voice")
			end

			t3.isConnected = false
			t3.currentPartyId = nil
			t3.JoinRequestSubmitted:Fire(t3.isConnected)

			return
		end

		t3.currentPartyId = t4.partyId

		local ok, result = pcall(function() -- line: 492
			-- upvalues: Logger (copy), t4 (copy), ExperienceService (copy), CrossExperience (copy), num (copy), EngineFeature2 (copy), t3 (copy)
			Logger:info("CrossExperienceVoiceManager:join() - starting cross experience voice with partyId " .. t4.partyId)
			ExperienceService:StartCrossExperience(CrossExperience.Constants.EXPERIENCE_TYPE_VOICE, {
				partyId = t4.partyId,
				placeId = num,
				joinAttemptId = if not EngineFeature2 then nil else t3.currentCevJoinAttemptId
			})
		end)

		if not ok then
			if FFlagFixCrossExperienceVoiceExecutePrint then
				Logger:warning("Failed to join cross experience voice with partyId " .. t4.partyId, result)
			else
				Logger:warn("Failed to join cross experience voice with partyId " .. t4.partyId, result)
			end

			local v57 = not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId

			t3.voiceAnalytics:logPartyVoiceJoinFailure(t4.partyId, result, v57)
			t3.currentPartyId = nil
		end
	else
		local ok, result = pcall(function() -- line: 514
			-- upvalues: Logger (copy), ExperienceService (copy), CrossExperience (copy), num (copy), EngineFeature2 (copy), t3 (copy)
			Logger:info("CrossExperienceVoiceManager:join() - starting cross experience voice")
			ExperienceService:StartCrossExperience(CrossExperience.Constants.EXPERIENCE_TYPE_VOICE, {
				placeId = num,
				joinAttemptId = if not EngineFeature2 then nil else t3.currentCevJoinAttemptId
			})
		end)

		if not ok then
			if FFlagFixCrossExperienceVoiceExecutePrint then
				Logger:warning("Failed to join cross experience voice: ", result)
			else
				Logger:warn("Failed to join cross experience voice: ", result)
			end

			t3.isConnected = false
			t3.currentPartyId = nil
		end
	end

	t3.JoinRequestSubmitted:Fire(t3.isConnected)
end
function t1.changeInputDevice(_: {[any]: any}, s2: string, s3: string) -- line: 536
	-- upvalues: Communication (copy), CrossExperience (copy), v35 (copy)
	Communication.execute(CrossExperience.Constants.COMMUNICATIONS.EXECUTE_CHANGE_PARTY_VOICE_INPUT_DEVICE, {
		deviceName = s2,
		deviceGuid = s3
	}, v35, v35)
end
function t1.changeOutputDevice(_: {[any]: any}, s4: string, s5: string) -- line: 543
	-- upvalues: Communication (copy), CrossExperience (copy), v35 (copy)
	Communication.execute(CrossExperience.Constants.COMMUNICATIONS.EXECUTE_CHANGE_PARTY_VOICE_OUTPUT_DEVICE, {
		deviceName = s4,
		deviceGuid = s5
	}, v35, v35)
end
function t1.muteVoiceParticipant(t7: {[any]: any}, n1: number) -- line: 550
	-- upvalues: CrossExperience (copy)
	t7.cevEventManager:notify(CrossExperience.Constants.EVENTS.MUTE_PARTY_VOICE_PARTICIPANT, {
		userId = n1
	})
	t7.voiceAnalytics:logPartyVoiceMuteParticipant(t7.currentPartyId, n1)
end
function t1.unmuteVoiceParticipant(t8: {[any]: any}, n2: number) -- line: 558
	-- upvalues: CrossExperience (copy)
	t8.cevEventManager:notify(CrossExperience.Constants.EVENTS.UNMUTE_PARTY_VOICE_PARTICIPANT, {
		userId = n2
	})
	t8.voiceAnalytics:logPartyVoiceUnmuteParticipant(t8.currentPartyId, n2)
end
function t1.enableVoiceChanger(t9: {[any]: any}, n3: number) -- line: 566
	-- upvalues: CrossExperience (copy)
	t9.cevEventManager:notify(CrossExperience.Constants.EVENTS.ENABLE_PARTY_VOICE_CHANGER, {
		userId = n3
	})
end
function t1.disableVoiceChanger(t10: {[any]: any}, n4: number) -- line: 574
	-- upvalues: CrossExperience (copy)
	t10.cevEventManager:notify(CrossExperience.Constants.EVENTS.DISABLE_PARTY_VOICE_CHANGER, {
		userId = n4
	})
end
function t1.setVoicePack(t11: {[any]: any}, s6: string) -- line: 582
	-- upvalues: CrossExperience (copy)
	t11.cevEventManager:notify(CrossExperience.Constants.EVENTS.SET_PARTY_VOICE_PACK, {
		voicePackName = s6
	})
end
function t1.enableHearMyself(t12: {[any]: any}, n5: number) -- line: 590
	-- upvalues: CrossExperience (copy)
	t12.cevEventManager:notify(CrossExperience.Constants.EVENTS.ENABLE_PARTY_VOICE_CHANGER_FEEDBACK, {
		userId = n5
	})
end
function t1.disableHearMyself(t13: {[any]: any}, n6: number) -- line: 596
	-- upvalues: CrossExperience (copy)
	t13.cevEventManager:notify(CrossExperience.Constants.EVENTS.DISABLE_PARTY_VOICE_CHANGER_FEEDBACK, {
		userId = n6
	})
end
function t1.blockVoiceParticipant(t14: {[any]: any}, n7: number) -- line: 602
	-- upvalues: CrossExperience (copy)
	if t14.isConnected then
		t14.cevEventManager:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_BLOCK_PARTICIPANT, {
			userId = n7
		})
		t14.voiceAnalytics:logPartyVoiceBlockParticipant(t14.currentPartyId, n7)
	end
end
function t1.unblockVoiceParticipant(t15: {[any]: any}, n8: number) -- line: 612
	-- upvalues: CrossExperience (copy)
	if t15.isConnected then
		t15.cevEventManager:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_UNBLOCK_PARTICIPANT, {
			userId = n8
		})
		t15.voiceAnalytics:logPartyVoiceUnblockParticipant(t15.currentPartyId, n8)
	end
end
function t1.dumpDebugData(p18) -- line: 622
	-- upvalues: CrossExperience (copy)
	p18.cevEventManager:notify(CrossExperience.Constants.EVENTS.DEBUG_COMMAND, {
		name = "dump_session"
	})
end
function t1.leave(p19) -- line: 628
	-- upvalues: ExperienceService (copy), CrossExperience (copy), clearTimeout (copy)
	ExperienceService:StopCrossExperience(CrossExperience.Constants.EXPERIENCE_TYPE_VOICE, {})

	if p19.joinRequestPulseCheckId then
		clearTimeout(p19.joinRequestPulseCheckId)
		p19.joinRequestPulseCheckId = nil
	end

	p19.voiceAnalytics:reset()
end
function t1.rejoinVoice(p20) -- line: 639
	-- upvalues: CrossExperience (copy)
	p20.cevEventManager:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_RECONNECT_REQUESTED, {})
end
function t1.resetCEVMemStorage(p21) -- line: 643
	-- upvalues: MemStorageService (copy), CEV_JOIN_ATTEMPT_ID_KEY (copy)
	p21.currentCevJoinAttemptId = nil
	pcall(function() -- line: 645
		-- upvalues: MemStorageService (copy), CEV_JOIN_ATTEMPT_ID_KEY (copy)
		MemStorageService:RemoveItem(CEV_JOIN_ATTEMPT_ID_KEY)
	end)
end
function t1.disconnect(p22) -- line: 650
	-- upvalues: Logger (copy), clearTimeout (copy), v30 (copy)
	p22.isConnected = false
	p22.currentPartyId = nil
	p22.hasExperienceStarted = false
	p22.shouldIgnoreMemoryWarning = false
	Logger:info("Disconnecting, resetting observers")
	p22.observersInitialized = false

	if p22.joinRequestPulseCheckId then
		clearTimeout(p22.joinRequestPulseCheckId)
		p22.joinRequestPulseCheckId = nil
	end

	v30.clean()
end
function t1.getAudioFocusService(_) -- line: 668
	-- upvalues: EngineFeature (copy)
	if not EngineFeature then
		return nil
	end

	local ok, result = pcall(function() -- line: 674
		return game:GetService("AudioFocusService")
	end)

	if not ok or not result then
		return nil
	end

	return result
end
function t1.getCurrentAudioContext(p24) -- line: 684
	local v93 = p24:getAudioFocusService()

	if v93 == nil then
		return -1
	end

	return v93:GetFocusedContextId()
end
function t1.toggleAudioFocus(p25) -- line: 693
	-- upvalues: AUDIO_FOCUS_MANAGEMENT (copy)
	local v95 = p25:getAudioFocusService()

	if v95 == nil then
		return
	end

	local RegisteredContexts = v95:GetRegisteredContexts()
	local v97 = false
	local v98 = false

	for k, _ in pairs(RegisteredContexts) do
		if k == AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID then
			v97 = true
		end

		if k == AUDIO_FOCUS_MANAGEMENT.UGC.CONTEXT_ID then
			v98 = true
		end
	end

	if not v97 or not v98 then
		return
	end

	v95:AcquireFocus(v95:GetFocusedContextId() == AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID and AUDIO_FOCUS_MANAGEMENT.UGC.CONTEXT_ID or AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID)
end
function t1.muteAll(t16: {[any]: any}, s7: string?) -- line: 722
	-- upvalues: GetFFlagEnableCrossExperienceVoiceCaptureMute (copy), CrossExperience (copy)
	if not GetFFlagEnableCrossExperienceVoiceCaptureMute() then
		return
	end

	if t16.isConnected then
		t16.cevEventManager:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_MUTE_ALL, {
			context = s7
		})
	end
end
function t1.unmuteAll(t17: {[any]: any}, s8: string?) -- line: 733
	-- upvalues: GetFFlagEnableCrossExperienceVoiceCaptureMute (copy), CrossExperience (copy)
	if not GetFFlagEnableCrossExperienceVoiceCaptureMute() then
		return
	end

	if t17.isConnected then
		t17.cevEventManager:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_UNMUTE_ALL, {
			context = s8
		})
	end
end
function t1.signalCevReadinessSync(p26) -- line: 744
	-- upvalues: CrossExperience (copy)
	if not game:GetEngineFeature("CevReadinessSync") then
		return
	end

	p26.cevEventManager:notify(CrossExperience.Constants.EVENTS.FOREGROUND_UI_READY, {})
end

t1.default = t1.new()

return t1
