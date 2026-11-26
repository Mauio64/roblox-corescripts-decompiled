local Players = game:GetService("Players")
local VoiceChatService = game:GetService("VoiceChatService")

local module = require("@luauforge/deferred/fFm")
local module2 = require("@luauforge/deferred/fFb")
local getRouteKeyIsInNavigationState = require("@luauforge/deferred/fFf").getRouteKeyIsInNavigationState
local enableAudioPlaybackInApp = require("@luauforge/deferred/fFn").enableAudioPlaybackInApp
local experienceService = require("@luauforge/deferred/fFo").ExperienceService
local videoPlaybackCoordinator = require("@luauforge/deferred/fFp").VideoPlaybackCoordinator
local module3 = require("@luauforge/deferred/fFq")
local module4 = require("@luauforge/deferred/fEW")
local fFlagUseUIOverlayForCloudPlay = module4.FFlagUseUIOverlayForCloudPlay
local fFlagLuaAppStratusBugReportAfterConnect = module4.FFlagLuaAppStratusBugReportAfterConnect
local fFlagLuaAppVideoServerDisplayWakeLock = module4.FFlagLuaAppVideoServerDisplayWakeLock
local fFlagLuaAppWireAudioDeviceInputOnRequest = module4.FFlagLuaAppWireAudioDeviceInputOnRequest

local module5 = require("@luauforge/deferred/fFE")
local module6 = require("@luauforge/deferred/fFF")
local module7 = require("@luauforge/deferred/fFH")
local module8 = require("@luauforge/deferred/fFI")
local fFlagLuaAppCloudClientPlayButtonOffer = module4.FFlagLuaAppCloudClientPlayButtonOffer

local v5 = if fFlagLuaAppCloudClientPlayButtonOffer then require("@luauforge/deferred/fFJ") else nil

local engineFeature = game:GetEngineFeature("EnableGameStreamingResolutionReadySignal")
local engineFeature2 = game:GetEngineFeature("StratusReconcileResolutionOnConnect")

local module9 = require("@luauforge/deferred/fFj")

local v6 = module5 and engineFeature2

local v7 = v6 or engineFeature

local v8 = {}

local function isRouteInStack(p2, p3)
	if p2 == nil or p3 == nil then
		return true
	end

	return getRouteKeyIsInNavigationState(p2, p3)
end

local function disconnectConnection(connection)
	if connection then
		connection:Disconnect()
	end
end

local function cancelThread(p2)
	if p2 then
		task.cancel(p2)
	end
end

local function getCurrentView(p2)
	return p2.views[#p2.views]
end

local function updateSurfaceEnabled(p2)
	p2.surface.screenGui.Enabled = #p2.views > 0
end

local function paramsMatch(params, data): boolean
	if
		params.placeId ~= data.placeId
		or params.universeId ~= data.universeId
		or params.launchSource ~= data.launchSource
		or fFlagLuaAppCloudClientPlayButtonOffer
		and (params.reservationToken ~= data.reservationToken or params.offerKind ~= data.offerKind)
	then
		return false
	end

	local extraParams = params.extraParams
	local extraParams2 = data.extraParams

	if extraParams == extraParams2 then
		return true
	end

	if extraParams == nil or extraParams2 == nil then
		return false
	end

	for k, extraParam in pairs(extraParams) do
		if extraParams2[k] ~= extraParam then
			return false
		end
	end

	for k in pairs(extraParams2) do
		if extraParams[k] == nil then
			return false
		end
	end

	return true
end

local function requestNavigateBack(state)
	local view = state.views[#state.views]

	if state.disposed or view == nil or state.navigateBackRequested then
		return
	end

	local routeKey = state.routeKey
	local stackState = view.getStackState()

	if
		routeKey ~= nil
		and stackState ~= nil
		and not getRouteKeyIsInNavigationState(routeKey, stackState)
	then
		return
	end

	state.navigateBackRequested = true
	task.defer(function()
		state.navigateBackRequested = false
	end)
	view.navigateBack()
end

local function teardownWires(state)
	if state.videoWire then
		state.videoWire:Destroy()
		state.videoWire = nil
	end

	if state.audioWire then
		state.audioWire:Destroy()
		state.audioWire = nil
	end
end

local function setupWires(state)
	if state.videoWire then
		state.videoWire:Destroy()
		state.videoWire = nil
	end

	if state.audioWire then
		state.audioWire:Destroy()
		state.audioWire = nil
	end

	local surface = state.surface
	state.videoWire = module9.createWire(surface.realtimeMedia, surface.videoDisplay, surface.frame)
	state.audioWire = module9.createWire(surface.realtimeMedia, surface.audioDeviceOutput, surface.frame)
end

local function teardownAudioInput(state)
	if state.audioInputWire then
		state.audioInputWire:Destroy()
		state.audioInputWire = nil
	end

	if state.audioDeviceInput then
		state.audioDeviceInput:Destroy()
		state.audioDeviceInput = nil
	end

	if state.previousUseAudioApi ~= nil then
		VoiceChatService.UseAudioApi = state.previousUseAudioApi
		state.previousUseAudioApi = nil
	end
end

local function setupAudioInput(state)
	local surface = state.surface
	local realtimeMedia = surface.realtimeMedia
	local localPlayer = Players.LocalPlayer

	if not localPlayer then
		return
	end

	if state.audioDeviceInput and state.audioInputWire then
		state.audioDeviceInput.Active = realtimeMedia.AudioInputActive
		return
	end

	if VoiceChatService.UseAudioApi ~= Enum.AudioApiRollout.Enabled then
		state.previousUseAudioApi = VoiceChatService.UseAudioApi
		VoiceChatService.UseAudioApi = Enum.AudioApiRollout.Enabled
	end

	local audioDeviceInput = module9.createAudioDeviceInput(
		localPlayer,
		realtimeMedia.AudioInputActive,
		surface.frame
	)
	state.audioDeviceInput = audioDeviceInput
	state.audioInputWire = module9.createWire(audioDeviceInput, realtimeMedia, surface.frame)
end

local function cleanupAudioInputListeners(state)
	local audioInputRequestedConnection = state.audioInputRequestedConnection

	if audioInputRequestedConnection then
		audioInputRequestedConnection:Disconnect()
	end

	state.audioInputRequestedConnection = nil
	local audioInputActiveConnection = state.audioInputActiveConnection

	if audioInputActiveConnection then
		audioInputActiveConnection:Disconnect()
	end

	state.audioInputActiveConnection = nil
end

local function setupAudioInputListeners(state)
	local audioInputRequestedConnection = state.audioInputRequestedConnection

	if audioInputRequestedConnection then
		audioInputRequestedConnection:Disconnect()
	end

	state.audioInputRequestedConnection = nil
	local audioInputActiveConnection = state.audioInputActiveConnection

	if audioInputActiveConnection then
		audioInputActiveConnection:Disconnect()
	end

	state.audioInputActiveConnection = nil

	local realtimeMedia = state.surface.realtimeMedia
	state.audioInputRequestedConnection = realtimeMedia.AudioInputRequested:Connect(function()
		setupAudioInput(state)
	end)
	state.audioInputActiveConnection = realtimeMedia:GetPropertyChangedSignal("AudioInputActive"):Connect(function()
		if state.audioDeviceInput then
			state.audioDeviceInput.Active = realtimeMedia.AudioInputActive
		end
	end)
end

local launchFallback

local function cleanupIsConnectedListener(state)
	local isConnectedConnection = state.isConnectedConnection

	if isConnectedConnection then
		isConnectedConnection:Disconnect()
	end

	state.isConnectedConnection = nil
	local disconnectedConnection = state.disconnectedConnection

	if disconnectedConnection then
		disconnectedConnection:Disconnect()
	end

	state.disconnectedConnection = nil
	state.previousIsConnected = nil
end

local function setupIsConnectedListener(state)
	local isConnectedConnection = state.isConnectedConnection

	if isConnectedConnection then
		isConnectedConnection:Disconnect()
	end

	state.isConnectedConnection = nil
	local disconnectedConnection = state.disconnectedConnection

	if disconnectedConnection then
		disconnectedConnection:Disconnect()
	end

	state.disconnectedConnection = nil
	state.previousIsConnected = nil

	local realtimeMedia = state.surface.realtimeMedia

	if fFlagUseUIOverlayForCloudPlay then
		state.disconnectedConnection = realtimeMedia.Disconnected:Connect(function(p2, p3)
			local v9 = state
			local isConnectedConnection2 = v9.isConnectedConnection

			if isConnectedConnection2 then
				isConnectedConnection2:Disconnect()
			end

			v9.isConnectedConnection = nil
			local disconnectedConnection2 = v9.disconnectedConnection

			if disconnectedConnection2 then
				disconnectedConnection2:Disconnect()
			end

			v9.disconnectedConnection = nil
			v9.previousIsConnected = nil

			if state.stopWeakConnectionSnackbar then
				state.stopWeakConnectionSnackbar()
				state.stopWeakConnectionSnackbar = nil
			end

			if state.params.offerKind == "RobloxReality" and p3 == "peer_time_limit_reached" then
				module7(function()
					requestNavigateBack(state)
				end, true)
			elseif p2 then
				requestNavigateBack(state)
			elseif state.params.offerKind == "RobloxReality" then
				module7(function()
					requestNavigateBack(state)
				end)
			else
				module6(function()
					launchFallback(state)
				end, function()
					requestNavigateBack(state)
				end)
			end
		end)
		return
	end

	state.previousIsConnected = realtimeMedia.IsConnected
	state.isConnectedConnection = realtimeMedia:GetPropertyChangedSignal("IsConnected"):Connect(function()
		local isConnected = realtimeMedia.IsConnected

		if state.previousIsConnected == true and isConnected == false then
			requestNavigateBack(state)
		end

		state.previousIsConnected = isConnected
	end)
end

local function disconnectOrientationListener(p2)
	local orientationConnection = p2.orientationConnection

	if orientationConnection then
		orientationConnection:Disconnect()
	end

	p2.orientationConnection = nil
end

launchFallback = function(state, p2)
	state.fallbackThread = nil
	local view = state.views[#state.views]

	if not state.disposed and view ~= nil then
		local routeKey = state.routeKey
		local stackState = view.getStackState()

		if routeKey == nil or stackState == nil or getRouteKeyIsInNavigationState(routeKey, stackState) then
			local params = state.params
			local joined = {
				placeId = tonumber(params.placeId),
				referralPage = params.launchSource
			}

			if params.extraParams then
				joined = module.Dictionary.join(joined, params.extraParams)
			end

			if p2 then
				module3.markUnsuccessfulJoin()
			end

			experienceService:LaunchExperience(joined, params.launchSource)

			if v7 then
				module9.setInGameStreaming(false)
			end

			requestNavigateBack(state)
		end
	end
end

local function joinWithoutCloudPlay(state)
	local view = state.views[#state.views]

	if not state.disposed and view ~= nil then
		local routeKey = state.routeKey
		local stackState = view.getStackState()

		if routeKey == nil or stackState == nil or getRouteKeyIsInNavigationState(routeKey, stackState) then
			local isConnectedConnection = state.isConnectedConnection

			if isConnectedConnection then
				isConnectedConnection:Disconnect()
			end

			state.isConnectedConnection = nil
			local disconnectedConnection = state.disconnectedConnection

			if disconnectedConnection then
				disconnectedConnection:Disconnect()
			end

			state.disconnectedConnection = nil
			state.previousIsConnected = nil

			state.surface.realtimeMedia:Disconnect()
			local connectThread = state.connectThread

			if connectThread then
				task.cancel(connectThread)
			end

			state.connectThread = nil
			launchFallback(state)
		end
	end
end

local function connect(state)
	if state.videoWire then
		state.videoWire:Destroy()
		state.videoWire = nil
	end

	if state.audioWire then
		state.audioWire:Destroy()
		state.audioWire = nil
	end

	local surface = state.surface
	state.videoWire = module9.createWire(surface.realtimeMedia, surface.videoDisplay, surface.frame)
	state.audioWire = module9.createWire(surface.realtimeMedia, surface.audioDeviceOutput, surface.frame)

	local surface2 = state.surface
	local videoDisplay = surface2.videoDisplay
	local params = state.params
	local joined = { placeId = params.placeId, universeId = 0, width = 0, height = 0 }
	local v9 = if params.universeId then tostring(params.universeId) else nil
	joined.universeId = v9
	joined.width = videoDisplay.AbsoluteSize.X
	joined.height = videoDisplay.AbsoluteSize.Y

	if params.extraParams then
		joined = module.Dictionary.join(joined, params.extraParams)
	end

	if fFlagLuaAppCloudClientPlayButtonOffer and params.reservationToken ~= nil then
		joined = module.Dictionary.join(joined, {
			reservationToken = params.reservationToken
		})
	end

	state.setIsLoading(true)
	local thread = coroutine.create(function()
		state.connectStarted = true
		local success, result = pcall(function()
			return surface2.realtimeMedia:ConnectAsync("", joined)
		end)

		if state.disposed then
			return
		end

		state.connectThread = nil
		state.setIsLoading(false)

		if success and result then
			if fFlagLuaAppStratusBugReportAfterConnect then
				state.setIsConnected(true)
			end

			setupIsConnectedListener(state)
		else
			if fFlagLuaAppCloudClientPlayButtonOffer and params.reservationToken ~= nil then
				v5.getCloudClientServiceAdapter().releaseReservation(params.reservationToken)
			end

			state.fallbackThread = task.defer(
				launchFallback,
				state,
				fFlagUseUIOverlayForCloudPlay and true or nil
			)
		end
	end)
	state.connectThread = thread
	task.spawn(thread)
end

local function start(session)
	if fFlagUseUIOverlayForCloudPlay then
		session.stopWeakConnectionSnackbar = module8(session.surface.realtimeMedia, function()
			joinWithoutCloudPlay(session)
		end)
	end

	if fFlagLuaAppVideoServerDisplayWakeLock then
		session.displayWakeLock = module9.acquireDisplayWakeLock()
	end

	enableAudioPlaybackInApp()
	session.coordinator:forcePlayback("VideoServerStream", "VideoServerStream started")
	module9.setStatusBarHidden(true)
	module9.set3dRenderingEnabled(false)

	if fFlagLuaAppWireAudioDeviceInputOnRequest then
		setupAudioInputListeners(session)
	end

	if v6 then
		module9.setInGameStreaming(true)
		connect(session)
	else
		if not engineFeature then
			connect(session)

			return
		end

		session.orientationConnection = module9.connectGameStreamingResolutionReady(function()
			local v9 = session
			local orientationConnection = v9.orientationConnection

			if orientationConnection then
				orientationConnection:Disconnect()
			end

			v9.orientationConnection = nil

			connect(session)
		end)
		module9.setInGameStreaming(true)
	end
end

local function dispose(state)
	if state.disposed then
		return
	end

	state.disposed = true

	if fFlagUseUIOverlayForCloudPlay and state.stopWeakConnectionSnackbar then
		state.stopWeakConnectionSnackbar()
		state.stopWeakConnectionSnackbar = nil
	end

	table.clear(state.views)
	state.surface.screenGui.Enabled = #state.views > 0

	if state.routeKey ~= nil and v8[state.routeKey] == state then
		v8[state.routeKey] = nil
	end

	local pendingDisposeThread = state.pendingDisposeThread

	if pendingDisposeThread then
		task.cancel(pendingDisposeThread)
	end

	state.pendingDisposeThread = nil
	local fallbackThread = state.fallbackThread

	if fallbackThread then
		task.cancel(fallbackThread)
	end

	state.fallbackThread = nil

	local reservationToken = state.params.reservationToken

	if fFlagLuaAppCloudClientPlayButtonOffer and reservationToken ~= nil and not state.connectStarted then
		v5.getCloudClientServiceAdapter().releaseReservation(reservationToken)
	end

	local orientationConnection = state.orientationConnection

	if orientationConnection then
		orientationConnection:Disconnect()
	end

	state.orientationConnection = nil

	if fFlagUseUIOverlayForCloudPlay then
		local isConnectedConnection = state.isConnectedConnection

		if isConnectedConnection then
			isConnectedConnection:Disconnect()
		end

		state.isConnectedConnection = nil
		local disconnectedConnection = state.disconnectedConnection

		if disconnectedConnection then
			disconnectedConnection:Disconnect()
		end

		state.disconnectedConnection = nil
		state.previousIsConnected = nil
	end

	state.surface.realtimeMedia:Disconnect()
	local connectThread = state.connectThread

	if connectThread then
		task.cancel(connectThread)
	end

	state.connectThread = nil
	module9.setStatusBarHidden(false)
	module9.set3dRenderingEnabled(true)

	if v7 then
		module9.setInGameStreaming(false)
	end

	if not fFlagUseUIOverlayForCloudPlay then
		local isConnectedConnection = state.isConnectedConnection

		if isConnectedConnection then
			isConnectedConnection:Disconnect()
		end

		state.isConnectedConnection = nil
		local disconnectedConnection = state.disconnectedConnection

		if disconnectedConnection then
			disconnectedConnection:Disconnect()
		end

		state.disconnectedConnection = nil
		state.previousIsConnected = nil
	end

	if state.videoWire then
		state.videoWire:Destroy()
		state.videoWire = nil
	end

	if state.audioWire then
		state.audioWire:Destroy()
		state.audioWire = nil
	end

	if fFlagLuaAppWireAudioDeviceInputOnRequest then
		local audioInputRequestedConnection = state.audioInputRequestedConnection

		if audioInputRequestedConnection then
			audioInputRequestedConnection:Disconnect()
		end

		state.audioInputRequestedConnection = nil
		local audioInputActiveConnection = state.audioInputActiveConnection

		if audioInputActiveConnection then
			audioInputActiveConnection:Disconnect()
		end

		state.audioInputActiveConnection = nil

		if state.audioInputWire then
			state.audioInputWire:Destroy()
			state.audioInputWire = nil
		end

		if state.audioDeviceInput then
			state.audioDeviceInput:Destroy()
			state.audioDeviceInput = nil
		end

		if state.previousUseAudioApi ~= nil then
			VoiceChatService.UseAudioApi = state.previousUseAudioApi
			state.previousUseAudioApi = nil
		end
	end

	if fFlagLuaAppVideoServerDisplayWakeLock and state.displayWakeLock then
		state.displayWakeLock:Destroy()
		state.displayWakeLock = nil
	end

	state.coordinator:cancelPlayback("VideoServerStream", "VideoServerStream finished")
	state.surface.screenGui:Destroy()
end

local function createSession(p2, p3)
	local signal, v9 = module2.createSignal(false)
	local signal2, v10 = module2.createSignal(false)
	return {
		routeKey = p2,
		params = p3,
		surface = module9.createSurface(),
		coordinator = videoPlaybackCoordinator.new(),
		getIsLoading = signal,
		setIsLoading = v9,
		getIsConnected = signal2,
		setIsConnected = v10,
		views = {},
		disposed = false,
		pendingDisposeThread = nil,
		fallbackThread = nil,
		connectThread = nil,
		connectStarted = false,
		navigateBackRequested = false,
		videoWire = nil,
		audioWire = nil,
		isConnectedConnection = nil,
		disconnectedConnection = nil,
		previousIsConnected = nil,
		orientationConnection = nil,
		displayWakeLock = nil,
		audioDeviceInput = nil,
		audioInputWire = nil,
		previousUseAudioApi = nil,
		audioInputRequestedConnection = nil,
		audioInputActiveConnection = nil,
		stopWeakConnectionSnackbar = nil
	}
end

return {
	attach = function(p2, p3, p4)
		local v9 = if p2 ~= nil then v8[p2] else nil
		local stackState = p4.getStackState()

		if p2 == nil or stackState == nil or getRouteKeyIsInNavigationState(p2, stackState) then
			if v9 and not paramsMatch(v9.params, p3) then
				dispose(v9)
				v9 = nil
			end

			if v9 then
				local pendingDisposeThread = v9.pendingDisposeThread

				if pendingDisposeThread then
					task.cancel(pendingDisposeThread)
				end

				v9.pendingDisposeThread = nil

				if not table.find(v9.views, p4) then
					table.insert(v9.views, p4)
				end

				v9.surface.screenGui.Enabled = #v9.views > 0

				return v9
			else
				local session = createSession(p2, p3)

				if p2 ~= nil then
					v8[p2] = session
				end

				table.insert(session.views, p4)
				session.surface.screenGui.Enabled = #session.views > 0

				start(session)
				return session
			end
		else
			if v9 then
				dispose(v9)
			end

			return nil
		end
	end,
	detach = function(state, p2)
		local index = table.find(state.views, p2)

		if index == nil then
			return
		end

		table.remove(state.views, index)
		state.surface.screenGui.Enabled = #state.views > 0

		if #state.views > 0 then
			return
		end

		if state.routeKey ~= nil then
			local routeKey = state.routeKey
			local stackState = p2.getStackState()

			if
				routeKey == nil
				or stackState == nil
				or getRouteKeyIsInNavigationState(routeKey, stackState)
			then
				state.pendingDisposeThread = task.defer(function()
					state.pendingDisposeThread = nil
					dispose(state)
				end)
				return
			end
		end

		dispose(state)
	end,
	["requestNavigateBack"] = requestNavigateBack,
	_disposeAllForTesting = function()
		for k, v9 in table.clone(v8) do
			dispose(v9)
		end
	end
}
