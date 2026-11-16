local parent = script.Parent.Parent

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local VoiceChatService = game:GetService("VoiceChatService")
local CoreGui = game:GetService("CoreGui")
local SharedFlags = require(parent.SharedFlags)
local FFlagUseAudioDeviceInputAddedSignal = SharedFlags.FFlagUseAudioDeviceInputAddedSignal

local Constants = require(script.Parent.Constants)
local Flags = script.Parent.Flags
local Promise = require(parent.Promise)
local PermissionsProtocol = require(parent.PermissionsProtocol)
local permissionsProtocol = PermissionsProtocol.PermissionsProtocol

local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagJoinWithoutMicPermissions = SharedFlags2.GetFFlagJoinWithoutMicPermissions
local SharedFlags3 = require(parent.SharedFlags)
local GetFFlagLocalMutedNilFix = SharedFlags3.GetFFlagLocalMutedNilFix
local GetFFlagDebugVoiceChatMicPermissionCliBypass = require(Flags.GetFFlagDebugVoiceChatMicPermissionCliBypass)
local SharedFlags4 = require(parent.SharedFlags)
local FFlagExpChatDictation = SharedFlags4.FFlagExpChatDictation
local GetFFlagUseAudioAnalyzerForLocalMetering2 = require(Flags.GetFFlagUseAudioAnalyzerForLocalMetering2)
local fFlagUseAudioAnalyzerForLocalMetering2 = GetFFlagUseAudioAnalyzerForLocalMetering2()
local GetFFlagMicConsumerRegistry = require(Flags.GetFFlagMicConsumerRegistry)
local FFlagMicRegistryIgnoreDefaultVoiceDevice = require(Flags.FFlagMicRegistryIgnoreDefaultVoiceDevice)

local PERMISSION_STATE = Constants.PERMISSION_STATE
local MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY = Constants.MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY

local _ = { VoiceChat = "VoiceChat", STT = "STT", DeveloperAudioDevice = "DeveloperAudioDevice" }

local MicInputManager = {}
MicInputManager.__index = MicInputManager

function MicInputManager.new(p)
	local object = setmetatable({}, MicInputManager)

	object.log = p.log
	object.callbacks = p.callbacks

	object.localMuted = nil
	object.isTalking = false
	local permissionState

	if GetFFlagJoinWithoutMicPermissions() then
		permissionState = PERMISSION_STATE.IDLE
	end

	object.permissionState = permissionState
	object.muteChanged = Instance.new("BindableEvent")
	object.talkingChanged = Instance.new("BindableEvent")

	object.permissionPromise = nil
	object.isPlayerWatchingAd = false
	object._connections = {}
	object.localMeteringTask = nil

	if not GetFFlagMicConsumerRegistry() then
		return object
	end

	object._consumers = {}
	object._consumerCount = 0
	object.hasConsumersChanged = Instance.new("BindableEvent")
	object._activeConsumerType = nil
	object._levelDetectionTask = nil
	object._hasShownPrivacyToast = false
	object._hasShownPermDeniedToast = false
	object._micIndicatorReady = false
	object._developerDeviceConnections = {}
	object._developerAudioInstancesFolder = nil
	object.levelChanged = Instance.new("BindableEvent")
	object._lastLevel = 0

	return object
end

local function isIgnoredAudioInput(instance) -- 3 equivalent calls inferred from this helper
	return instance:IsDescendantOf(CoreGui)
end

local function isLocalDefaultVoiceDevice(instance): boolean -- 1 equivalent call inferred from this helper
	local localPlayer = Players.LocalPlayer

	return localPlayer ~= nil
		and VoiceChatService.EnableDefaultVoice == true
		and localPlayer:FindFirstChildOfClass("AudioDeviceInput") == instance
end

function MicInputManager:SetMicActive(flag: boolean, context: string?)
	if self.localMuted == nil then
		self.log:trace("SetMicActive context: {} - Voice not connected yet", context)
		return
	end

	if self.localMuted == not flag then
		return
	end

	self.log:trace("SetMicActive active: {} context: {}", flag, context)

	if GetFFlagJoinWithoutMicPermissions() then
		if self.permissionState == PERMISSION_STATE.PENDING_MIC then
			self.log:debug("In pending mic mode, requesting permission")
			self.callbacks.emitGetPermissions(function(p)
				local permissionState

				if p.hasMicPermissions then
					permissionState = PERMISSION_STATE.LISTEN_AND_TALK
				else
					permissionState = PERMISSION_STATE.LISTEN_ONLY
				end

				self.permissionState = permissionState

				self.log:debug("Got permissions, setting state to {}", self.permissionState)
				self:SetMicActive(flag, context)
			end, { permissionsProtocol.Permissions.MICROPHONE_ACCESS }, false)
			return
		elseif self.permissionState == PERMISSION_STATE.LISTEN_ONLY then
			self.log:debug("User tried to unmute despite being in listen only mode")
			self.callbacks.emitOnPermissionRequested()
			return
		end
	end

	if self.isPlayerWatchingAd then
		self.log:trace("User is watching an ad, skipping mic state change")
		return
	end

	if VoiceChatService.UseNewAudioApi then
		self.localMuted = not flag
		self.log:trace("Setting self mute to {} context: {}", flag, context)
		local sendMuteEvent = self.callbacks.getSendMuteEvent()

		if sendMuteEvent then
			sendMuteEvent:FireServer(flag)
			local active = flag and (not GetFFlagMicConsumerRegistry() or self._micIndicatorReady)

			for k in self.callbacks.getAudioDevices() do
				if k.Player and k.Player == Players.LocalPlayer then
					k.Active = active
				end
			end

			if GetFFlagMicConsumerRegistry() then
				for _, consumer in self._consumers do
					if consumer.device and consumer.consumerType ~= "VoiceChat" then
						consumer.device.Active = active
					end
				end
			end

			self.muteChanged:Fire(self.localMuted)
		else
			self.log:error("Could not find SendMuteEvent")
		end
	else
		local service = self.callbacks.getService()
		self.log:trace("Setting self mute to {} context: {}", not flag, context)

		service:PublishPause(not flag)
		self.localMuted = not flag
		self.muteChanged:Fire(self.localMuted)
	end

	if self.localMuted then
		if GetFFlagMicConsumerRegistry() and self._lastLevel ~= 0 then
			self._lastLevel = 0
			self.levelChanged:Fire(0)
		end
	else
		self.talkingChanged:Fire(self.isTalking)
		self.callbacks.emitOnShowDataConsentToast()
	end

	if context then
		self.callbacks.reportVoiceMuteSelf(self.callbacks.getJoinWithVoiceMuteData({
			context = context,
			muted = self.localMuted
		}))
	end

	self:_assertDeviceStateConsistency()
end

function MicInputManager:SetLocalMuted(localMuted: boolean?)
	self.localMuted = localMuted
end

function MicInputManager:SyncLocalAudioDeviceActive()
	if not VoiceChatService.UseNewAudioApi then
		return
	end

	local active

	if self.localMuted == false then
		active = not GetFFlagMicConsumerRegistry() or self._micIndicatorReady
	else
		active = false
	end

	for k in self.callbacks.getAudioDevices() do
		if k.Player and k.Player == Players.LocalPlayer then
			k.Active = active
		end
	end

	self:_assertDeviceStateConsistency()
end

function MicInputManager:SetupEarlyAudioDeviceGuard()
	local function shouldDeactivate(instance) -- 3 equivalent calls inferred from this helper
		local v = VoiceChatService.UseNewAudioApi and not (FFlagExpChatDictation and isIgnoredAudioInput(instance)) -- inferred equivalent call

		if v then
			if instance.Player == Players.LocalPlayer then
				return instance.Active and self.localMuted == nil
			end

			return false
		end

		return v
	end

	local function guardDevice(instance)
		if shouldDeactivate(instance) then -- inferred equivalent call
			instance.Active = false
		end

		local playerChangedConnection = instance:GetPropertyChangedSignal("Player"):Connect(function()
			if shouldDeactivate(instance) then -- inferred equivalent call
				instance.Active = false
			end
		end)
		table.insert(self._connections, playerChangedConnection)

		local activeChangedConnection = instance:GetPropertyChangedSignal("Active"):Connect(function()
			if shouldDeactivate(instance) then -- inferred equivalent call
				instance.Active = false
			end
		end)
		table.insert(self._connections, activeChangedConnection)
	end

	local v

	if FFlagUseAudioDeviceInputAddedSignal then
		v = SoundService.AudioDeviceInputAdded:Connect(function(p)
			guardDevice(p)
		end)
	else
		v = SoundService.AudioInstanceAdded:Connect(function(audioDeviceInput)
			if audioDeviceInput:IsA("AudioDeviceInput") then
				guardDevice(audioDeviceInput)
			end
		end)
	end

	table.insert(self._connections, v)

	for _, audioDeviceInput in game:GetDescendants() do
		if audioDeviceInput:IsA("AudioDeviceInput") then
			guardDevice(audioDeviceInput)
		end
	end
end

function MicInputManager.SetAndSyncActive(p, p2, active: boolean)
	p2.Active = active
	local sendMuteEvent = p.callbacks.getSendMuteEvent()

	if sendMuteEvent and p2.Player == Players.LocalPlayer then
		sendMuteEvent:FireServer(active)
	end
end

function MicInputManager:RequestMicPermission()
	if GetFFlagDebugVoiceChatMicPermissionCliBypass() then
		self.permissionState = PERMISSION_STATE.LISTEN_AND_TALK
		return Promise.resolve()
	end

	if self.permissionPromise then
		self.log:trace("PermissionProtocol already invoked")
		return self.permissionPromise
	end

	local v = { permissionsProtocol.Permissions.MICROPHONE_ACCESS }

	self.permissionPromise = self.callbacks.requestPermissions(v):andThen(function(p)
		self.callbacks.recordExperienceJoinMicPerm(p)

		if p or p.status then
			self.log:debug("Permission status {}", p.status)

			local v2 = p.status == permissionsProtocol.Status.AUTHORIZED

			if self.callbacks.getPassInitErrorInPromiseReject() and not v2 then
				return Promise.reject({ code = "INIT_ERROR_PERM_NOT_GRANTED" })
			end

			return v2 and Promise.resolve() or Promise.reject()
		end

		self.log:debug("No permission response, rejecting access")
		self.callbacks.reportJoinFailed("noPermissionResponse", nil)

		if self.callbacks.getPassInitErrorInPromiseReject() then
			return Promise.reject({ code = "INIT_ERROR_NO_PERM_RESPONSE" })
		end

		return Promise.reject()
	end):andThen(function()
		self.callbacks.emitOnRequestMicPermissionResolved()
		return Promise.resolve()
	end):catch(function()
		self.callbacks.emitOnRequestMicPermissionRejected()

		if self.callbacks.getPassInitErrorInPromiseReject() then
			return Promise.reject({ code = "INIT_ERROR_MIC_PERM_REJECTED" })
		end

		return Promise.reject()
	end)

	return self.permissionPromise
end

function MicInputManager:UpdateLocalMetering()
	self.isTalking = self.callbacks.isSignalActive(Players.LocalPlayer.UserId)

	if self.localMuted == false then
		self.talkingChanged:Fire(self.isTalking)
	end
end

function MicInputManager:SetupMicActivityListener(object)
	if fFlagUseAudioAnalyzerForLocalMetering2 and VoiceChatService.UseNewAudioApi then
		if not self.localMeteringTask then
			self.localMeteringTask = task.spawn(function()
				while true do
					self:UpdateLocalMetering()
					task.wait()
				end
			end)
		end
	elseif MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY <= object:GetVoiceChatApiVersion() then
		local playerMicActivitySignalChangeConnection = object.PlayerMicActivitySignalChange:Connect(function(p)
			self.callbacks.onVoiceCapturedDuringVideoCapture(p.isActive)
			self.isTalking = p.isActive

			if GetFFlagLocalMutedNilFix() then
				if self.localMuted == false then
					self.talkingChanged:Fire(self.isTalking)
				end
			elseif not self.localMuted then
				self.talkingChanged:Fire(self.isTalking)
			end
		end)
		table.insert(self._connections, playerMicActivitySignalChangeConnection)
	end
end

function MicInputManager:SetAdMuteBlocked(isPlayerWatchingAd: boolean)
	self.isPlayerWatchingAd = isPlayerWatchingAd
end

function MicInputManager:RegisterConsumer(data): boolean
	if not GetFFlagMicConsumerRegistry() then
		return false
	end

	if self._consumers[data.id] then
		self.log:trace("Consumer already registered: {}", data.id)
		return true
	end

	local v = data.consumerType == "VoiceChat"

	if self.permissionState == PERMISSION_STATE.LISTEN_ONLY and v then
		self.log:debug("RegisterConsumer rejected for {}: voice chat permission denied", data.id)

		if not self._hasShownPermDeniedToast and self.callbacks.emitOnMicPermissionDeniedToast then
			self._hasShownPermDeniedToast = true
			self.callbacks.emitOnMicPermissionDeniedToast()
		end

		return false
	else
		local v2

		if v and data.device then
			local v3 = "dev_" .. tostring(data.device:GetDebugId())
			v2 = self._consumers[v3] ~= nil

			if v2 then
				self:UnregisterConsumer(v3, true)
			end
		else
			v2 = false
		end

		self._consumers[data.id] = data
		local consumerCount = self._consumerCount
		self._consumerCount += 1

		self:_updateActiveConsumerType()

		if consumerCount == 0 and not v2 then
			self._micIndicatorReady = false
		end

		self.hasConsumersChanged:Fire(self._consumerCount)

		if data.device then
			local active

			if self.localMuted == false then
				active = self._micIndicatorReady
			else
				active = false
			end

			if data.device.Active ~= active then
				data.device.Active = active
			end
		end

		self.log:trace("Consumer registered: {} type={} count={}", data.id, data.consumerType, self._consumerCount)
		self:_assertDeviceStateConsistency()
		return true
	end
end

function MicInputManager:UnregisterConsumer(p: string, flag: boolean?)
	if not GetFFlagMicConsumerRegistry() then
		return
	end

	local consumer = self._consumers[p]

	if not consumer then
		return
	end

	if consumer.wire then
		consumer.wire:Destroy()
	end

	if consumer.analyzer then
		consumer.analyzer:Destroy()
	end

	if consumer.device and consumer.device.Active then
		consumer.device.Active = false
	end

	self._consumers[p] = nil
	self._consumerCount -= 1

	self:_updateActiveConsumerType()

	if self._consumerCount == 0 and not flag then
		self.localMuted = nil
		self._micIndicatorReady = false
		self:_stopLevelDetectionTask()
	end

	if not flag then
		self.hasConsumersChanged:Fire(self._consumerCount)
	end

	self.log:trace("Consumer unregistered: {} count={}", p, self._consumerCount)
end

function MicInputManager:SetMicIndicatorReady(micIndicatorReady: boolean)
	if not GetFFlagMicConsumerRegistry() or self._micIndicatorReady == micIndicatorReady then
		return
	end

	self._micIndicatorReady = micIndicatorReady
	local active = micIndicatorReady and self.localMuted == false

	for _, consumer in self._consumers do
		if consumer.device and consumer.device.Active ~= active then
			consumer.device.Active = active
		end
	end

	self:_assertDeviceStateConsistency()
end

function MicInputManager:GetConsumerCount()
	if GetFFlagMicConsumerRegistry() then
		return self._consumerCount
	end

	return 0
end

function MicInputManager:HasConsumer(p: string): boolean
	if GetFFlagMicConsumerRegistry() then
		return self._consumers[p] ~= nil
	end

	return false
end

function MicInputManager:GetActiveConsumerType()
	if GetFFlagMicConsumerRegistry() then
		return self._activeConsumerType
	end

	return nil
end

function MicInputManager:_updateActiveConsumerType()
	self._activeConsumerType = nil

	for _, consumer in self._consumers do
		if consumer.consumerType == "VoiceChat" then
			self._activeConsumerType = "VoiceChat"
			self:_stopLevelDetectionTask()
			return
		elseif self._activeConsumerType == nil then
			self._activeConsumerType = consumer.consumerType
		end
	end

	if self._activeConsumerType and self._activeConsumerType ~= "VoiceChat" then
		self:_startLevelDetectionTask()
	end
end

function MicInputManager:_startLevelDetectionTask()
	if self._levelDetectionTask then
		return
	end

	self._levelDetectionTask = task.spawn(function()
		while true do
			self:_updateCustomLevelDetection()
			task.wait()
		end
	end)
end

function MicInputManager:_stopLevelDetectionTask()
	if self._levelDetectionTask then
		task.cancel(self._levelDetectionTask)
		self._levelDetectionTask = nil
	end
end

function MicInputManager:_updateCustomLevelDetection()
	if self.localMuted ~= false then
		return
	end

	local v = 0

	for _, consumer in self._consumers do
		if not consumer.analyzer then
			continue
		end

		local peakLevel = consumer.analyzer.PeakLevel

		if not (peakLevel > 0) then
			continue
		end

		local v2 = math.log10(peakLevel) * 20

		if not (v2 > -36) then
			continue
		end

		local v3 = math.clamp((v2 - -36) / 36, 0, 1)

		if v < v3 then
			v = v3
		end
	end

	local lastLevel = math.clamp(math.floor(v * 100 / 20 + 0.5) * 20, 0, 100)

	self.isTalking = lastLevel > 0
	self.talkingChanged:Fire(self.isTalking)

	if GetFFlagMicConsumerRegistry() and lastLevel ~= self._lastLevel then
		self._lastLevel = lastLevel
		self.levelChanged:Fire(lastLevel)
	end
end

function MicInputManager:_isVoiceChatDevice(device): boolean
	for _, consumer in self._consumers do
		if consumer.consumerType ~= "VoiceChat" then
			continue
		end

		if consumer.device == device then
			return true
		end

		if consumer.device == nil and device.Player == Players.LocalPlayer then
			consumer.device = device
			device.Active = self.localMuted == false and self._micIndicatorReady
			return true
		end
	end

	return false
end

function MicInputManager:_isDeveloperDevice(instance): boolean
	if
		isIgnoredAudioInput(instance) -- inferred equivalent call
		or self:_isVoiceChatDevice(instance)
		or FFlagMicRegistryIgnoreDefaultVoiceDevice and isLocalDefaultVoiceDevice(instance) -- inferred equivalent call
	then
		return false
	end

	return instance.Player == Players.LocalPlayer
end

function MicInputManager:_getDeveloperAudioInstancesFolder()
	if self._developerAudioInstancesFolder then
		return self._developerAudioInstancesFolder
	end

	local micConsumerRegistry = Instance.new("Folder")
	micConsumerRegistry.Name = "MicConsumerRegistry"
	micConsumerRegistry.Parent = CoreGui
	self._developerAudioInstancesFolder = micConsumerRegistry
	return micConsumerRegistry
end

function MicInputManager:_registerDeveloperDevice(sourceInstance)
	local id = "dev_" .. tostring(sourceInstance:GetDebugId())

	if self._consumers[id] then
		return
	end

	local developerAudioInstancesFolder = self:_getDeveloperAudioInstancesFolder()
	local audioAnalyzer = Instance.new("AudioAnalyzer")
	audioAnalyzer.Parent = developerAudioInstancesFolder

	local wire = Instance.new("Wire")
	wire.SourceInstance = sourceInstance
	wire.TargetInstance = audioAnalyzer
	wire.Parent = developerAudioInstancesFolder

	if not self:RegisterConsumer({
		id = id,
		consumerType = "DeveloperAudioDevice",
		device = sourceInstance,
		analyzer = audioAnalyzer,
		wire = wire
	}) then
		wire:Destroy()
		audioAnalyzer:Destroy()
	end
end

function MicInputManager:_unregisterDeveloperDevice(object)
	self:UnregisterConsumer("dev_" .. tostring(object:GetDebugId()))
end

function MicInputManager:SetupDeveloperDeviceTracking()
	if not GetFFlagMicConsumerRegistry() then
		return
	end

	local function onDeviceAdded(instance)
		if self._developerDeviceConnections[instance] or isIgnoredAudioInput(instance) then -- inferred equivalent call
			return
		end

		if self:_isDeveloperDevice(instance) then
			self:_registerDeveloperDevice(instance)
		end

		local connections = {}

		table.insert(connections, (instance:GetPropertyChangedSignal("Player"):Connect(function()
			if self:_isDeveloperDevice(instance) then
				self:_registerDeveloperDevice(instance)
			else
				self:_unregisterDeveloperDevice(instance)
			end
		end)))

		table.insert(connections, (instance.AncestryChanged:Connect(function(_, parent2)
			if parent2 == nil then
				self:_unregisterDeveloperDevice(instance)
				local developerDeviceConnection = self._developerDeviceConnections[instance]

				if developerDeviceConnection then
					for _, connection in developerDeviceConnection do
						connection:Disconnect()
					end

					self._developerDeviceConnections[instance] = nil
				end
			elseif FFlagMicRegistryIgnoreDefaultVoiceDevice then
				if self:_isDeveloperDevice(instance) then
					self:_registerDeveloperDevice(instance)
				else
					self:_unregisterDeveloperDevice(instance)
				end
			end
		end)))

		self._developerDeviceConnections[instance] = connections
	end

	local v

	if FFlagUseAudioDeviceInputAddedSignal then
		v = SoundService.AudioDeviceInputAdded:Connect(function(p)
			onDeviceAdded(p)
		end)
	else
		v = SoundService.AudioInstanceAdded:Connect(function(audioDeviceInput)
			if audioDeviceInput:IsA("AudioDeviceInput") then
				onDeviceAdded(audioDeviceInput)
			end
		end)
	end

	table.insert(self._connections, v)

	for _, audioDeviceInput in game:GetDescendants() do
		if audioDeviceInput:IsA("AudioDeviceInput") then
			onDeviceAdded(audioDeviceInput)
		end
	end
end

function MicInputManager:SetMicActiveForAllConsumers(flag: boolean, p: string?)
	if not GetFFlagMicConsumerRegistry() then
		return
	end

	if flag then
		if self.isPlayerWatchingAd then
			self.log:trace("SetMicActiveForAllConsumers: blocked by ad-mute")
			return
		end

		if GetFFlagJoinWithoutMicPermissions() then
			if self.permissionState == PERMISSION_STATE.LISTEN_ONLY then
				self.log:debug("SetMicActiveForAllConsumers: permission denied")

				if not self._hasShownPermDeniedToast and self.callbacks.emitOnMicPermissionDeniedToast then
					self._hasShownPermDeniedToast = true
					self.callbacks.emitOnMicPermissionDeniedToast()
				end

				return
			elseif self.permissionState == PERMISSION_STATE.PENDING_MIC then
				self.log:debug("SetMicActiveForAllConsumers: requesting permission")
				self.callbacks.emitGetPermissions(function(p2)
					local permissionState

					if p2.hasMicPermissions then
						permissionState = PERMISSION_STATE.LISTEN_AND_TALK
					else
						permissionState = PERMISSION_STATE.LISTEN_ONLY
					end

					self.permissionState = permissionState

					self:SetMicActiveForAllConsumers(flag, p)
				end, { permissionsProtocol.Permissions.MICROPHONE_ACCESS }, false)

				return
			end
		end
	end

	local micIndicatorReady = flag and self._micIndicatorReady

	for _, consumer in self._consumers do
		if consumer.device then
			consumer.device.Active = micIndicatorReady
		end
	end

	self.localMuted = not flag
	self.muteChanged:Fire(self.localMuted)

	if flag and not self._hasShownPrivacyToast then
		local v = false

		for _, consumer in self._consumers do
			if consumer.consumerType == "VoiceChat" then
				v = true
				break
			end
		end

		if not v and self.callbacks.emitOnMicFirstUnmutePrivacy then
			self._hasShownPrivacyToast = true
			self.callbacks.emitOnMicFirstUnmutePrivacy()
		end
	end

	if flag then
		self.talkingChanged:Fire(self.isTalking)
		self.callbacks.emitOnShowDataConsentToast()
	elseif self._lastLevel ~= 0 then
		self._lastLevel = 0
		self.levelChanged:Fire(0)
	end

	self:_assertDeviceStateConsistency()
end

function MicInputManager:Disconnect()
	for _, connection in self._connections do
		connection:Disconnect()
	end

	self._connections = {}

	if self.localMeteringTask then
		task.cancel(self.localMeteringTask)
		self.localMeteringTask = nil
	end

	if GetFFlagMicConsumerRegistry() then
		self:_stopLevelDetectionTask()

		for _, developerDeviceConnection in self._developerDeviceConnections do
			for _, connection in developerDeviceConnection do
				connection:Disconnect()
			end
		end

		self._developerDeviceConnections = {}

		for _, consumer in self._consumers do
			if consumer.wire then
				consumer.wire:Destroy()
			end

			if consumer.analyzer then
				consumer.analyzer:Destroy()
			end
		end

		self._consumers = {}
		self._consumerCount = 0

		if self._developerAudioInstancesFolder then
			self._developerAudioInstancesFolder:Destroy()
			self._developerAudioInstancesFolder = nil
		end
	end
end

function MicInputManager:_assertDeviceStateConsistency()
	local v

	if self.localMuted == false then
		v = not GetFFlagMicConsumerRegistry() or self._micIndicatorReady
	else
		v = false
	end

	for k in self.callbacks.getAudioDevices() do
		if k.Player and k.Player == Players.LocalPlayer and k.Active ~= v then
			self.log:warning(
				"MicManager consistency: device.Active={} expected={} localMuted={}",
				k.Active,
				v,
				self.localMuted
			)
		end
	end

	if GetFFlagMicConsumerRegistry() then
		for _, consumer in self._consumers do
			if consumer.device and consumer.device.Active ~= v then
				self.log:warning(
					"MicManager consistency (consumer {}): device.Active={} expected={} localMuted={}",
					consumer.id,
					consumer.device.Active,
					v,
					self.localMuted
				)
			end
		end

		if self._consumerCount == 0 and self.localMuted ~= nil then
			self.log:warning("MicManager consistency: no consumers but localMuted={}", self.localMuted)
		end
	end
end

return MicInputManager
