local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local VoiceChatService = game:GetService("VoiceChatService")
local CoreGui = game:GetService("CoreGui")
local fFlagUseAudioDeviceInputAddedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").FFlagUseAudioDeviceInputAddedSignal

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Constants")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/Promise")
local permissionsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/PermissionsProtocol").PermissionsProtocol

local getFFlagJoinWithoutMicPermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").GetFFlagJoinWithoutMicPermissions
local getFFlagLocalMutedNilFix = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").GetFFlagLocalMutedNilFix
local GetFFlagDebugVoiceChatMicPermissionCliBypass = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagDebugVoiceChatMicPermissionCliBypass")
local fFlagExpChatDictation = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").FFlagExpChatDictation
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagUseAudioAnalyzerForLocalMetering2")()
local GetFFlagMicConsumerRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagMicConsumerRegistry")
local FFlagMicSyncVoiceDeviceAcrossRejoin = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/FFlagMicSyncVoiceDeviceAcrossRejoin")
local FFlagMicPermissionCheckOnConsumerUnmute = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/FFlagMicPermissionCheckOnConsumerUnmute")
local FFlagMicRegistryIgnoreDefaultVoiceDevice = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/FFlagMicRegistryIgnoreDefaultVoiceDevice")

local PERMISSION_STATE = Constants.PERMISSION_STATE
local MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY = Constants.MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY

local v6 = {
	VoiceChat = "VoiceChat",
	STT = "STT",
	DeveloperAudioDevice = "DeveloperAudioDevice"
}

local class = {}
class.__index = class

function class.new(p2)
	local object = setmetatable({}, class)

	object.log = p2.log
	object.callbacks = p2.callbacks

	object.localMuted = nil
	object.isTalking = false
	local v7 = if getFFlagJoinWithoutMicPermissions() then PERMISSION_STATE.IDLE else nil
	object.permissionState = v7
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
	object._hasConsumerMicPermission = false
	object._isRequestingConsumerMicPermission = false

	return object
end

local function isIgnoredAudioInput(instance)
	return instance:IsDescendantOf(CoreGui)
end

local function isLocalDefaultVoiceDevice(p2): boolean
	local localPlayer = Players.LocalPlayer

	return localPlayer ~= nil
		and VoiceChatService.EnableDefaultVoice == true
		and localPlayer:FindFirstChildOfClass("AudioDeviceInput") == p2
end

function class:SetMicActive(p2, p3)
	if self.localMuted == nil then
		self.log:trace("SetMicActive context: {} - Voice not connected yet", p3)
		return
	end

	if self.localMuted == not p2 then
		return
	end

	self.log:trace("SetMicActive active: {} context: {}", p2, p3)

	if getFFlagJoinWithoutMicPermissions() then
		if self.permissionState == PERMISSION_STATE.PENDING_MIC then
			self.log:debug("In pending mic mode, requesting permission")
			local function fn(p4)
				local v7 = self
				local v8 = if p4.hasMicPermissions then PERMISSION_STATE.LISTEN_AND_TALK else PERMISSION_STATE.LISTEN_ONLY
				v7.permissionState = v8

				self.log:debug("Got permissions, setting state to {}", self.permissionState)
				self:SetMicActive(p2, p3)
			end
			self.callbacks.emitGetPermissions(
				fn,
				{ permissionsProtocol.Permissions.MICROPHONE_ACCESS },
				false
			)
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
		self.localMuted = not p2
		self.log:trace("Setting self mute to {} context: {}", p2, p3)
		local sendMuteEvent = self.callbacks.getSendMuteEvent()

		if sendMuteEvent then
			sendMuteEvent:FireServer(p2)
			local v7 = p2 and (not GetFFlagMicConsumerRegistry() or self._micIndicatorReady)

			for k in self.callbacks.getAudioDevices() do
				if k.Player and k.Player == Players.LocalPlayer then
					k.Active = v7
				end
			end

			if GetFFlagMicConsumerRegistry() then
				for k, consumer in self._consumers do
					if consumer.device and consumer.consumerType ~= "VoiceChat" then
						consumer.device.Active = v7
					end
				end
			end

			self.muteChanged:Fire(self.localMuted)
		else
			self.log:error("Could not find SendMuteEvent")
		end
	else
		local service = self.callbacks.getService()
		self.log:trace("Setting self mute to {} context: {}", not p2, p3)

		service:PublishPause(not p2)
		self.localMuted = not p2
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

	if p3 then
		self.callbacks.reportVoiceMuteSelf(self.callbacks.getJoinWithVoiceMuteData({
			context = p3,
			muted = self.localMuted
		}))
	end

	self:_assertDeviceStateConsistency()
end

function class:SetLocalMuted(localMuted)
	self.localMuted = localMuted
end

function class:SyncLocalAudioDeviceActive()
	if not VoiceChatService.UseNewAudioApi then
		return
	end

	if FFlagMicSyncVoiceDeviceAcrossRejoin then
		if self:_setLocalPlayerAudioDevicesActive(self:_shouldLocalAudioDeviceBeActive()) then
			self:_syncLocalAudioDeviceActiveToServer()
		end

		self:_assertDeviceStateConsistency()
	else
		local v7 = self.localMuted == false and (not GetFFlagMicConsumerRegistry() or self._micIndicatorReady)

		for k in self.callbacks.getAudioDevices() do
			if k.Player and k.Player == Players.LocalPlayer then
				k.Active = v7
			end
		end

		self:_assertDeviceStateConsistency()
	end
end

function class:_syncLocalAudioDeviceActiveToServer()
	task.spawn(function()
		local sendMuteEvent = self.callbacks.getSendMuteEvent()

		if not sendMuteEvent then
			return
		end

		local shouldLocalAudioDeviceBeActive = self:_shouldLocalAudioDeviceBeActive()

		if self:_setLocalPlayerAudioDevicesActive(shouldLocalAudioDeviceBeActive) then
			sendMuteEvent:FireServer(shouldLocalAudioDeviceBeActive)
		end
	end)
end

function class:_shouldLocalAudioDeviceBeActive()
	return self.localMuted == false and (not GetFFlagMicConsumerRegistry() or self._micIndicatorReady)
end

function class:_setLocalPlayerAudioDevicesActive(active)
	local v7 = false

	for k in self.callbacks.getAudioDevices() do
		if not (k.Player and k.Player == Players.LocalPlayer) then
			continue
		end

		k.Active = active
		v7 = true
	end

	return v7
end

function class:SetupEarlyAudioDeviceGuard()
	local function shouldDeactivate(instance)
		local v7 = VoiceChatService.UseNewAudioApi
			and not (fFlagExpChatDictation and instance:IsDescendantOf(CoreGui))

		if v7 then
			v7 = instance.Player == Players.LocalPlayer and (instance.Active and self.localMuted == nil)
		end

		return v7
	end

	local function guardDevice(instance)
		local v7 = VoiceChatService.UseNewAudioApi
			and not (fFlagExpChatDictation and instance:IsDescendantOf(CoreGui))

		if v7 then
			v7 = instance.Player == Players.LocalPlayer and (instance.Active and self.localMuted == nil)
		end

		if v7 then
			instance.Active = false
		end

		local playerChangedConnection = instance:GetPropertyChangedSignal("Player"):Connect(function()
			local v8 = instance
			local v9 = VoiceChatService.UseNewAudioApi
				and not (fFlagExpChatDictation and v8:IsDescendantOf(CoreGui))

			if v9 then
				v9 = v8.Player == Players.LocalPlayer and (v8.Active and self.localMuted == nil)
			end

			if v9 then
				instance.Active = false
			end
		end)
		table.insert(self._connections, playerChangedConnection)

		local activeChangedConnection = instance:GetPropertyChangedSignal("Active"):Connect(function()
			local v8 = instance
			local v9 = VoiceChatService.UseNewAudioApi
				and not (fFlagExpChatDictation and v8:IsDescendantOf(CoreGui))

			if v9 then
				v9 = v8.Player == Players.LocalPlayer and (v8.Active and self.localMuted == nil)
			end

			if v9 then
				instance.Active = false
			end
		end)
		table.insert(self._connections, activeChangedConnection)
	end

	local v7

	if fFlagUseAudioDeviceInputAddedSignal then
		v7 = SoundService.AudioDeviceInputAdded:Connect(function(p3)
			guardDevice(p3)
		end)
	else
		v7 = SoundService.AudioInstanceAdded:Connect(function(audioDeviceInput)
			if audioDeviceInput:IsA("AudioDeviceInput") then
				guardDevice(audioDeviceInput)
			end
		end)
	end

	table.insert(self._connections, v7)

	for i, audioDeviceInput in game:GetDescendants() do
		if audioDeviceInput:IsA("AudioDeviceInput") then
			guardDevice(audioDeviceInput)
		end
	end
end

function class:SetAndSyncActive(p3, active)
	p3.Active = active
	local sendMuteEvent = self.callbacks.getSendMuteEvent()

	if sendMuteEvent and p3.Player == Players.LocalPlayer then
		sendMuteEvent:FireServer(active)
	end
end

function class:RequestMicPermission()
	if GetFFlagDebugVoiceChatMicPermissionCliBypass() then
		self.permissionState = PERMISSION_STATE.LISTEN_AND_TALK
		return Promise.resolve()
	end

	if self.permissionPromise then
		self.log:trace("PermissionProtocol already invoked")
		return self.permissionPromise
	end

	local v7 = { permissionsProtocol.Permissions.MICROPHONE_ACCESS }

	self.permissionPromise = self.callbacks.requestPermissions(v7):andThen(function(p2)
		self.callbacks.recordExperienceJoinMicPerm(p2)

		if p2 or p2.status then
			self.log:debug("Permission status {}", p2.status)

			local v8 = p2.status == permissionsProtocol.Status.AUTHORIZED

			if self.callbacks.getPassInitErrorInPromiseReject() and not v8 then
				return Promise.reject({ code = "INIT_ERROR_PERM_NOT_GRANTED" })
			end

			return v8 and Promise.resolve() or Promise.reject()
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

function class:UpdateLocalMetering()
	self.isTalking = self.callbacks.isSignalActive(Players.LocalPlayer.UserId)

	if self.localMuted == false then
		self.talkingChanged:Fire(self.isTalking)
	end
end

function class:SetupMicActivityListener(object2)
	if v5 and VoiceChatService.UseNewAudioApi then
		if not self.localMeteringTask then
			self.localMeteringTask = task.spawn(function()
				while true do
					self:UpdateLocalMetering()
					task.wait()
				end
			end)
		end
	elseif MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY <= object2:GetVoiceChatApiVersion() then
		local playerMicActivitySignalChangeConnection = object2.PlayerMicActivitySignalChange:Connect(function(p2)
			self.callbacks.onVoiceCapturedDuringVideoCapture(p2.isActive)
			self.isTalking = p2.isActive

			if getFFlagLocalMutedNilFix() then
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

function class:SetAdMuteBlocked(isPlayerWatchingAd)
	self.isPlayerWatchingAd = isPlayerWatchingAd
end

function class:RegisterConsumer(data): boolean
	if not GetFFlagMicConsumerRegistry() then
		return false
	end

	if self._consumers[data.id] then
		self.log:trace("Consumer already registered: {}", data.id)
		return true
	end

	local v7 = data.consumerType == "VoiceChat"

	if self.permissionState == PERMISSION_STATE.LISTEN_ONLY and v7 then
		self.log:debug("RegisterConsumer rejected for {}: voice chat permission denied", data.id)

		if not self._hasShownPermDeniedToast and self.callbacks.emitOnMicPermissionDeniedToast then
			self._hasShownPermDeniedToast = true
			self.callbacks.emitOnMicPermissionDeniedToast()
		end

		return false
	else
		local v8

		if v7 and data.device then
			local v9 = "dev_" .. tostring(data.device:GetDebugId())
			v8 = self._consumers[v9] ~= nil

			if v8 then
				self:UnregisterConsumer(v9, true)
			end
		else
			v8 = false
		end

		self._consumers[data.id] = data
		local consumerCount = self._consumerCount
		self._consumerCount += 1

		self:_updateActiveConsumerType()

		if consumerCount == 0 and not v8 then
			self._micIndicatorReady = false
		end

		self.hasConsumersChanged:Fire(self._consumerCount)

		if data.device then
			local v9 = self.localMuted == false and self._micIndicatorReady

			if data.device.Active ~= v9 then
				data.device.Active = v9
			end
		end

		self.log:trace(
			"Consumer registered: {} type={} count={}",
			data.id,
			data.consumerType,
			self._consumerCount
		)
		self:_assertDeviceStateConsistency()
		return true
	end
end

function class:UnregisterConsumer(p2, p3)
	if not GetFFlagMicConsumerRegistry() then
		return
	end

	local consumer = self._consumers[p2]

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

	self._consumers[p2] = nil
	self._consumerCount -= 1

	self:_updateActiveConsumerType()

	if self._consumerCount == 0 and not p3 then
		self.localMuted = nil
		self._micIndicatorReady = false
		self:_stopLevelDetectionTask()
	end

	if not p3 then
		self.hasConsumersChanged:Fire(self._consumerCount)
	end

	self.log:trace("Consumer unregistered: {} count={}", p2, self._consumerCount)
end

function class:SetMicIndicatorReady(micIndicatorReady)
	if not GetFFlagMicConsumerRegistry() or self._micIndicatorReady == micIndicatorReady then
		return
	end

	self._micIndicatorReady = micIndicatorReady
	local v7 = micIndicatorReady and self.localMuted == false

	for k, consumer in self._consumers do
		if consumer.device and consumer.device.Active ~= v7 then
			consumer.device.Active = v7
		end
	end

	if FFlagMicSyncVoiceDeviceAcrossRejoin and VoiceChatService.UseNewAudioApi and self._activeConsumerType == "VoiceChat" then
		self:_syncLocalAudioDeviceActiveToServer()
	end

	self:_assertDeviceStateConsistency()
end

function class:GetConsumerCount()
	if GetFFlagMicConsumerRegistry() then
		return self._consumerCount
	end

	return 0
end

function class:HasConsumer(p3): boolean
	if GetFFlagMicConsumerRegistry() then
		return self._consumers[p3] ~= nil
	end

	return false
end

function class:GetActiveConsumerType()
	if GetFFlagMicConsumerRegistry() then
		return self._activeConsumerType
	end

	return nil
end

function class:_updateActiveConsumerType()
	self._activeConsumerType = nil

	for k, consumer in self._consumers do
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

function class:_startLevelDetectionTask()
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

function class:_stopLevelDetectionTask()
	if self._levelDetectionTask then
		task.cancel(self._levelDetectionTask)
		self._levelDetectionTask = nil
	end
end

function class:_updateCustomLevelDetection()
	if self.localMuted ~= false then
		return
	end

	local v7 = 0

	for k, consumer in self._consumers do
		if not consumer.analyzer then
			continue
		end

		local peakLevel = consumer.analyzer.PeakLevel

		if not (peakLevel > 0) then
			continue
		end

		local v8 = math.log10(peakLevel) * 20

		if not (v8 > -36) then
			continue
		end

		local v9 = math.clamp((v8 - -36) / 36, 0, 1)

		if v7 < v9 then
			v7 = v9
		end
	end

	local v8 = math.clamp((math.floor)(v7 * 100 / 20 + 0.5) * 20, 0, 100)

	self.isTalking = v8 > 0
	self.talkingChanged:Fire(self.isTalking)

	if GetFFlagMicConsumerRegistry() and v8 ~= self._lastLevel then
		self._lastLevel = v8
		self.levelChanged:Fire(v8)
	end
end

function class:_isVoiceChatDevice(device): boolean
	for k, consumer in self._consumers do
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

function class:_isDeveloperDevice(instance): boolean
	if instance:IsDescendantOf(CoreGui) or self:_isVoiceChatDevice(instance) then
		return false
	end

	if not FFlagMicRegistryIgnoreDefaultVoiceDevice then
		return instance.Player == Players.LocalPlayer
	end

	local localPlayer = Players.LocalPlayer
	local v7

	if localPlayer == nil or VoiceChatService.EnableDefaultVoice ~= true then
		v7 = false
	else
		v7 = localPlayer:FindFirstChildOfClass("AudioDeviceInput") == instance
	end

	if v7 then
		return false
	end

	return instance.Player == Players.LocalPlayer
end

function class:_getDeveloperAudioInstancesFolder()
	if self._developerAudioInstancesFolder then
		return self._developerAudioInstancesFolder
	end

	local micConsumerRegistry = Instance.new("Folder")
	micConsumerRegistry.Name = "MicConsumerRegistry"
	micConsumerRegistry.Parent = CoreGui
	self._developerAudioInstancesFolder = micConsumerRegistry
	return micConsumerRegistry
end

function class:_registerDeveloperDevice(sourceInstance)
	local v7 = "dev_" .. tostring(sourceInstance:GetDebugId())

	if self._consumers[v7] then
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
		id = v7,
		consumerType = "DeveloperAudioDevice",
		device = sourceInstance,
		analyzer = audioAnalyzer,
		wire = wire
	}) then
		wire:Destroy()
		audioAnalyzer:Destroy()
	end
end

function class:_unregisterDeveloperDevice(object2)
	self:UnregisterConsumer("dev_" .. tostring(object2:GetDebugId()))
end

function class:SetupDeveloperDeviceTracking()
	if not GetFFlagMicConsumerRegistry() then
		return
	end

	local function onDeviceAdded(instance)
		if self._developerDeviceConnections[instance] or instance:IsDescendantOf(CoreGui) then
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

		table.insert(connections, (instance.AncestryChanged:Connect(function(p2, parent)
			if parent == nil then
				self:_unregisterDeveloperDevice(instance)
				local developerDeviceConnection = self._developerDeviceConnections[instance]

				if developerDeviceConnection then
					for k, connection in developerDeviceConnection do
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

	local v7

	if fFlagUseAudioDeviceInputAddedSignal then
		v7 = SoundService.AudioDeviceInputAdded:Connect(function(p2)
			onDeviceAdded(p2)
		end)
	else
		v7 = SoundService.AudioInstanceAdded:Connect(function(audioDeviceInput)
			if audioDeviceInput:IsA("AudioDeviceInput") then
				onDeviceAdded(audioDeviceInput)
			end
		end)
	end

	table.insert(self._connections, v7)

	for i, audioDeviceInput in game:GetDescendants() do
		if audioDeviceInput:IsA("AudioDeviceInput") then
			onDeviceAdded(audioDeviceInput)
		end
	end
end

function class:SetMicActiveForAllConsumers(p2, p3)
	if not GetFFlagMicConsumerRegistry() then
		return
	end

	if p2 then
		if self.isPlayerWatchingAd then
			self.log:trace("SetMicActiveForAllConsumers: blocked by ad-mute")
			return
		end

		if FFlagMicPermissionCheckOnConsumerUnmute and not self._hasConsumerMicPermission then
			self:_requestConsumerMicPermission(p3)
			return
		end

		if not FFlagMicPermissionCheckOnConsumerUnmute and getFFlagJoinWithoutMicPermissions() then
			if self.permissionState == PERMISSION_STATE.LISTEN_ONLY then
				self.log:debug("SetMicActiveForAllConsumers: permission denied")

				if not self._hasShownPermDeniedToast and self.callbacks.emitOnMicPermissionDeniedToast then
					self._hasShownPermDeniedToast = true
					self.callbacks.emitOnMicPermissionDeniedToast()
				end

				return
			elseif self.permissionState == PERMISSION_STATE.PENDING_MIC then
				self.log:debug("SetMicActiveForAllConsumers: requesting permission")
				local function fn(p4)
					local v7 = self
					local v8 = if p4.hasMicPermissions then PERMISSION_STATE.LISTEN_AND_TALK else PERMISSION_STATE.LISTEN_ONLY
					v7.permissionState = v8

					self:SetMicActiveForAllConsumers(p2, p3)
				end
				self.callbacks.emitGetPermissions(
					fn,
					{ permissionsProtocol.Permissions.MICROPHONE_ACCESS },
					false
				)

				return
			end
		end
	end

	local micIndicatorReady = p2 and self._micIndicatorReady

	for k, consumer in self._consumers do
		if consumer.device then
			consumer.device.Active = micIndicatorReady
		end
	end

	self.localMuted = not p2
	self.muteChanged:Fire(self.localMuted)

	if p2 and not self._hasShownPrivacyToast then
		local v7 = false

		for k, consumer in self._consumers do
			if consumer.consumerType == "VoiceChat" then
				v7 = true
				break
			end
		end

		if not v7 and self.callbacks.emitOnMicFirstUnmutePrivacy then
			self._hasShownPrivacyToast = true
			self.callbacks.emitOnMicFirstUnmutePrivacy()
		end
	end

	if p2 then
		self.talkingChanged:Fire(self.isTalking)
		self.callbacks.emitOnShowDataConsentToast()
	elseif self._lastLevel ~= 0 then
		self._lastLevel = 0
		self.levelChanged:Fire(0)
	end

	self:_assertDeviceStateConsistency()
end

function class:_requestConsumerMicPermission(p2)
	if self._isRequestingConsumerMicPermission then
		return
	end

	self._isRequestingConsumerMicPermission = true

	local function onResult(p3)
		self._isRequestingConsumerMicPermission = false
		self.log:debug("Consumer mic permission status {}", p3)

		if p3 == permissionsProtocol.Status.AUTHORIZED or p3 == permissionsProtocol.Status.UNSUPPORTED then
			self._hasConsumerMicPermission = true

			if self._activeConsumerType ~= nil and self._activeConsumerType ~= "VoiceChat" then
				self:SetMicActiveForAllConsumers(true, p2)
			end
		elseif self.callbacks.emitOnMicPermissionDeniedToast then
			self.callbacks.emitOnMicPermissionDeniedToast()
		end
	end

	if GetFFlagDebugVoiceChatMicPermissionCliBypass() then
		onResult(permissionsProtocol.Status.AUTHORIZED)
	else
		self.callbacks.requestPermissions({ permissionsProtocol.Permissions.MICROPHONE_ACCESS }):andThen(
			function(p3)
				local v8 = if p3 then p3.status else nil
				onResult(v8)
			end,
			function(p3)
				self.log:warning("Consumer mic permission request failed: {}", (tostring(p3)))
				onResult(nil)
			end
		)
	end
end

function class:Disconnect()
	for k, connection in self._connections do
		connection:Disconnect()
	end

	self._connections = {}

	if self.localMeteringTask then
		task.cancel(self.localMeteringTask)
		self.localMeteringTask = nil
	end

	if GetFFlagMicConsumerRegistry() then
		self:_stopLevelDetectionTask()

		for k, developerDeviceConnection in self._developerDeviceConnections do
			for k2, connection in developerDeviceConnection do
				connection:Disconnect()
			end
		end

		self._developerDeviceConnections = {}

		for k, consumer in self._consumers do
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

function class:_assertDeviceStateConsistency()
	local v7 = self.localMuted == false and (not GetFFlagMicConsumerRegistry() or self._micIndicatorReady)

	for k in self.callbacks.getAudioDevices() do
		if k.Player and k.Player == Players.LocalPlayer and k.Active ~= v7 then
			self.log:warning(
				"MicManager consistency: device.Active={} expected={} localMuted={}",
				k.Active,
				v7,
				self.localMuted
			)
		end
	end

	if GetFFlagMicConsumerRegistry() then
		for k, consumer in self._consumers do
			if consumer.device and consumer.device.Active ~= v7 then
				self.log:warning(
					"MicManager consistency (consumer {}): device.Active={} expected={} localMuted={}",
					consumer.id,
					consumer.device.Active,
					v7,
					self.localMuted
				)
			end
		end

		if self._consumerCount == 0 and self.localMuted ~= nil then
			self.log:warning("MicManager consistency: no consumers but localMuted={}", self.localMuted)
		end
	end
end

return class
