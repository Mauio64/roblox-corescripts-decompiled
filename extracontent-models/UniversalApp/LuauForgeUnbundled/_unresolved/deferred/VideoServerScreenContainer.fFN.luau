local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VideoService = game:GetService("VideoService")
local VoiceChatService = game:GetService("VoiceChatService")
local Players = game:GetService("Players")

local enableAudioPlaybackInApp = require("@luauforge/deferred/fFn").enableAudioPlaybackInApp
require("@luauforge/deferred/fEH")
local overlayScreen = require("@luauforge/deferred/fEJ").OverlayScreen
local module = require("@luauforge/deferred/fFk")
local useDeviceType = require("@luauforge/deferred/fEV").useDeviceType
local notificationType = module.NotificationType
local module2 = require("@luauforge/deferred/fFm")
local module3 = require("@luauforge/deferred/fEZ")
local module4 = require("@luauforge/deferred/fEI")
local useDispatch = require("@luauforge/deferred/fFd").Hooks.RoactRodux.useDispatch
local experienceService = require("@luauforge/deferred/fFo").ExperienceService
local navigateBack = require("@luauforge/deferred/fFe").Thunks.NavigateBack
local useNavigation = require("@luauforge/deferred/fFf").useNavigation
local androidTVExitButtonManager = require("@luauforge/deferred/fFg").AndroidTVExitButtonManager
local useAppPolicy = require("@luauforge/deferred/fFO").useAppPolicy
local videoPlaybackCoordinator = require("@luauforge/deferred/fFp").VideoPlaybackCoordinator
local module5 = require("@luauforge/deferred/fFL")
local module6 = require("@luauforge/deferred/fFq")
local module7 = require("@luauforge/deferred/fEW")
local fFlagUseUIOverlayForCloudPlay = module7.FFlagUseUIOverlayForCloudPlay
local fFlagInternalOnlyStratusBugReportEnabled = module7.FFlagInternalOnlyStratusBugReportEnabled
local fFlagLuaAppStratusBugReportAfterConnect = require("@luauforge/deferred/fEW").FFlagLuaAppStratusBugReportAfterConnect
local fFlagLuaAppVideoServerDisplayWakeLock = require("@luauforge/deferred/fEW").FFlagLuaAppVideoServerDisplayWakeLock
local fFlagLuaAppWireAudioDeviceInputOnRequest = require("@luauforge/deferred/fEW").FFlagLuaAppWireAudioDeviceInputOnRequest
local fFlagLuaAppStratusPassUniverseId = require("@luauforge/deferred/fEW").FFlagLuaAppStratusPassUniverseId
local DeviceDisplayService

if fFlagLuaAppVideoServerDisplayWakeLock then
	DeviceDisplayService = game:GetService("DeviceDisplayService")
else
	DeviceDisplayService = nil
end

local engineFeature = game:GetEngineFeature("EnableGameStreamingResolutionReadySignal")
local engineFeature2 = game:GetEngineFeature("StratusReconcileResolutionOnConnect")

local module8 = require("@luauforge/deferred/fFE")
local fFlagAndroidTVExitWithB = require("@luauforge/deferred/fEW").FFlagAndroidTVExitWithB
local module9 = require("@luauforge/deferred/fFh")
local module10 = require("@luauforge/deferred/fFM")
local fFlagSignalsNavP3Dispatch = require("@luauforge/deferred/fEW").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/deferred/fFi").NavigationCommands else nil

local v5 = {
	[Enum.KeyCode.Escape] = "NavigateBack",
	[Enum.KeyCode.ButtonB] = "NavigateBack",
	[Enum.KeyCode.ButtonY] = "Search",
	[Enum.KeyCode.Slash] = "Search",
	[Enum.KeyCode.PageUp] = "ScrollUp",
	[Enum.KeyCode.PageDown] = "ScrollDown",
	[Enum.KeyCode.LeftBracket] = "ScrollUp",
	[Enum.KeyCode.RightBracket] = "ScrollDown"
}

local function useUAHotkeySuppressionImpl(p2, p3)
	local v6 = module5.useEventMap(v5, p2)
	local v7 = module4.useMemo(function()
		local result = {}

		for k, v8 in v5 do
			result[v8] = {
				handler = function(p4)
					p4.cancelled = true
				end
			}
		end

		return result
	end, {})
	local v8 = module5.useEventHandlerMap(v7, v6)

	module4.useEffect(function()
		local current = p3.current
		local current2 = p2.current

		if not (current and current2) then
			return
		end

		current2.SelectionGroup = true
		current2.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
		current2.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
		current2.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
		current2.SelectionBehaviorRight = Enum.SelectionBehavior.Stop

		local selectedCoreObject = GuiService.SelectedCoreObject

		if current:IsDescendantOf(CoreGui) then
			GuiService.SelectedCoreObject = current
		end

		local selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
			if GuiService.SelectedCoreObject == nil and current:IsDescendantOf(CoreGui) then
				GuiService.SelectedCoreObject = current
			end
		end)

		return function()
			selectedCoreObjectChangedConnection:Disconnect()

			if GuiService.SelectedCoreObject == current then
				if selectedCoreObject and selectedCoreObject:IsDescendantOf(CoreGui) then
					GuiService.SelectedCoreObject = selectedCoreObject
				else
					GuiService.SelectedCoreObject = nil
				end
			end
		end
	end, {})

	return v8
end

local function useFrameRefPassthrough(p2, p3)
	return p2
end

if module10 then
	useFrameRefPassthrough = useUAHotkeySuppressionImpl
end

local module11 = require("@luauforge/deferred/fEY")
local module12 = require("@luauforge/deferred/fFF")
local module13 = require("@luauforge/deferred/fFI")

local function setNativeStatusBarHidden(p2)
	GuiService:BroadcastNotification(
		HttpService:JSONEncode({ hidden = p2 }),
		notificationType.SET_STATUS_BAR_STYLE
	)
end

local function setNativeInGameStreaming(p2)
	GuiService:BroadcastNotification(
		HttpService:JSONEncode({ inGameStreaming = p2 }),
		notificationType.GAME_STREAMING_STATUS_CHANGED
	)
end

local function disconnectRef(p2)
	if p2.current then
		p2.current:Disconnect()
		p2.current = nil
	end
end

local function DeviceOverlayScreen()
	local v6 = useDeviceType()

	return module4.createElement(overlayScreen, { device = v6 })
end

local function VideoServerScreenContainer()
	local v6 = useNavigation()
	local param = v6.getParam("placeId")

	local v7 = if fFlagLuaAppStratusPassUniverseId then v6.getParam("universeId") else nil

	local param2 = v6.getParam("launchSource")
	local param3 = v6.getParam("extraParams")
	local v8 = useDispatch()

	local state, setState = module4.useState(false)
	local state2, setState2

	if fFlagLuaAppStratusBugReportAfterConnect then
		state2, setState2 = module4.useState(false)
	else
		setState2 = function(p2) end

		state2 = false
	end

	local v9, v10 = module4.useBinding(0)

	local v11 = module4.useMemo(function()
		return videoPlaybackCoordinator.new()
	end, {})

	local ref = module4.useRef(nil)
	local ref2 = module4.useRef(nil)
	local ref3 = module4.useRef(nil)
	local ref4 = module4.useRef(nil)
	local ref5 = module4.useRef(nil)

	local ref6 = module4.useRef(nil)
	local ref7 = module4.useRef(nil)
	local v12, v13, v14, v15, v16

	if fFlagLuaAppWireAudioDeviceInputOnRequest then
		v12 = module4.useRef(nil)
		v13 = module4.useRef(nil)
		v14 = module4.useRef(nil)
		v15 = module4.useRef(nil)
		v16 = module4.useRef(nil)
	else
		v13 = { current = nil }
		v12 = { current = nil }

		v14 = { current = nil }
		v15 = { current = nil }
		v16 = { current = nil }
	end

	local ref8 = module4.useRef(nil)

	local v17 = not fFlagUseUIOverlayForCloudPlay and { current = nil } or module4.useRef(nil)
	local ref9 = module4.useRef(nil)
	local ref10 = module4.useRef(nil)
	local ref11 = module4.useRef(0)
	local ref12 = module4.useRef(nil)
	local ref13 = module4.useRef(nil)
	local ref14 = module4.useRef(nil)
	local ref15 = module4.useRef(nil)
	local ref16 = module4.useRef(nil)

	local v18 = not fFlagUseUIOverlayForCloudPlay and { current = nil } or module4.useRef(nil)

	local v19 = useAppPolicy(function(p2)
		return p2.getThrottleFramerate()
	end)

	local v20 = module4.useCallback(function()
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.back(true)
		else
			v8(navigateBack(true))
		end
	end, { v8 })

	local v21 = module4.useCallback(function()
		if ref6.current then
			ref6.current:Destroy()
			ref6.current = nil
		end

		if ref7.current then
			ref7.current:Destroy()
			ref7.current = nil
		end
	end, {})

	local v22 = module4.useCallback(function()
		local current = ref.current
		local current2 = ref3.current
		local current3 = ref4.current
		local current4 = ref5.current

		if not (current and current2 and current3 and current4) then
			return
		end

		v21()
		local wire = Instance.new("Wire")
		wire.SourceInstance = current2
		wire.TargetInstance = current3
		wire.SourceName = "Output"
		wire.TargetName = "Input"
		wire.Parent = current
		ref6.current = wire
		local wire2 = Instance.new("Wire")
		wire2.SourceInstance = current2
		wire2.TargetInstance = current4
		wire2.SourceName = "Output"
		wire2.TargetName = "Input"
		wire2.Parent = current
		ref7.current = wire2
	end, { v21 })
	local v23, v24, v25

	if fFlagLuaAppWireAudioDeviceInputOnRequest then
		v23 = module4.useCallback(function()
			if v13.current then
				v13.current:Destroy()
				v13.current = nil
			end

			if v12.current then
				v12.current:Destroy()
				v12.current = nil
			end

			if v14.current ~= nil then
				VoiceChatService.UseAudioApi = v14.current
				v14.current = nil
			end
		end, {})

		local v26 = module4.useCallback(function()
			local current = ref.current
			local current2 = ref3.current
			local localPlayer = Players.LocalPlayer

			if not (current and current2 and localPlayer) then
				return
			end

			if v12.current and v13.current then
				v12.current.Active = current2.AudioInputActive
				return
			end

			if VoiceChatService.UseAudioApi ~= Enum.AudioApiRollout.Enabled then
				v14.current = VoiceChatService.UseAudioApi
				VoiceChatService.UseAudioApi = Enum.AudioApiRollout.Enabled
			end

			local audioDeviceInput = Instance.new("AudioDeviceInput")
			audioDeviceInput.Player = localPlayer
			audioDeviceInput.Active = current2.AudioInputActive
			audioDeviceInput.Parent = current
			v12.current = audioDeviceInput
			local wire = Instance.new("Wire")
			wire.SourceInstance = audioDeviceInput
			wire.TargetInstance = current2
			wire.SourceName = "Output"
			wire.TargetName = "Input"
			wire.Parent = current
			v13.current = wire
		end, {})

		v24 = module4.useCallback(function()
			local v27 = v15

			if v27.current then
				v27.current:Disconnect()
				v27.current = nil
			end

			local v28 = v16

			if v28.current then
				v28.current:Disconnect()
				v28.current = nil
			end
		end, {})

		v25 = module4.useCallback(function()
			v24()
			local current = ref3.current

			if not current then
				return
			end

			v15.current = current.AudioInputRequested:Connect(v26)
			v16.current = current:GetPropertyChangedSignal("AudioInputActive"):Connect(function()
				if v12.current then
					v12.current.Active = current.AudioInputActive
				end
			end)
		end, { v26, v24 })
	else
		v24 = function() end

		v23 = function() end

		v25 = function() end
	end

	local v26 = module4.useCallback(function()
		if ref8.current then
			ref8.current:Disconnect()
			ref8.current = nil
		end

		if v17.current then
			v17.current:Disconnect()
			v17.current = nil
		end

		ref9.current = nil
	end, {})

	local v27 = module4.useCallback(function()
		if ref13.current then
			ref13.current:Disconnect()
			ref13.current = nil
		end

		if fFlagAndroidTVExitWithB and ref14.current then
			ref14.current()
			ref14.current = nil
		end
	end, {})

	local v28 = module4.useCallback(function()
		v27()
		ref13.current = GuiService.ShowLeaveConfirmation:Connect(function()
			v20()
		end)

		if fFlagAndroidTVExitWithB then
			ref14.current = androidTVExitButtonManager.register(v20)
		end
	end, { v27, v20 })

	local fn = not engineFeature and function() end or module4.useCallback(function()
		if ref15.current then
			ref15.current:Disconnect()
			ref15.current = nil
		end
	end, {})

	local v29 = module4.useCallback(function()
		if ref12.current then
			task.cancel(ref12.current)
			ref12.current = nil
		end
	end, {})

	local v30 = module4.useCallback(function()
		if ref10.current then
			if ref3.current then
				ref3.current:Disconnect()
			end

			task.cancel(ref10.current)
			ref10.current = nil
		end
	end, {})
	local v31

	if fFlagUseUIOverlayForCloudPlay then
		v31 = module4.useCallback(function()
			v26()
			v30()

			if ref3.current then
				ref3.current:Disconnect()
			end

			local joined = { placeId = tonumber(param), referralPage = param2 }

			if param3 then
				joined = module2.Dictionary.join(joined, param3)
			end

			experienceService:LaunchExperience(joined, param2)

			if module8 and engineFeature2 or engineFeature then
				GuiService:BroadcastNotification(
					HttpService:JSONEncode({ inGameStreaming = false }),
					notificationType.GAME_STREAMING_STATUS_CHANGED
				)
			end

			v20()
		end, { param, param2, param3, v20 })
	else
		v31 = nil
	end

	local v33 = module4.useCallback(function()
		v26()
		local current = ref3.current

		if not current then
			return
		end

		if fFlagUseUIOverlayForCloudPlay then
			v17.current = current.Disconnected:Connect(function(p2)
				v26()

				if v18.current then
					v18.current()
					v18.current = nil
				end

				if p2 then
					v20()
				else
					module12(v31, v20)
				end
			end)
			return
		end

		ref9.current = current.IsConnected
		ref8.current = current:GetPropertyChangedSignal("IsConnected"):Connect(function()
			local isConnected = current.IsConnected

			if ref9.current == true and isConnected == false then
				v20()
			end

			ref9.current = isConnected
		end)
	end, { v26, v20, v31 })

	local function fn2(): boolean
		if not (ref3.current and ref4.current) then
			return false
		end

		v22()
		local current = ref4.current
		local joined = { placeId = param, universeId = 0, width = 0, height = 0 }

		local v34 = if v7 then tostring(v7) else nil
		joined.universeId = v34
		joined.width = current.AbsoluteSize.X
		joined.height = current.AbsoluteSize.Y

		if param3 then
			joined = module2.Dictionary.join(joined, param3)
		end

		v30()

		ref11.current += 1
		local current2 = ref11.current
		setState(true)
		ref10.current = task.spawn(function()
			local v36 = ref3.current:ConnectAsync("", joined)

			if ref11.current ~= current2 then
				return
			end

			ref10.current = nil

			if v36 then
				setState(false)

				if fFlagLuaAppStratusBugReportAfterConnect then
					setState2(true)
				end

				v33()
			else
				setState(false)

				if fFlagUseUIOverlayForCloudPlay then
					task.defer(function()
						module6.markUnsuccessfulJoin()

						v31()
					end)
					return
				end

				local function launchFallback()
					local joined2 = { placeId = tonumber(param), referralPage = param2 }

					if param3 then
						joined2 = module2.Dictionary.join(joined2, param3)
					end

					experienceService:LaunchExperience(joined2, param2)

					if module8 and engineFeature2 or engineFeature then
						GuiService:BroadcastNotification(
							HttpService:JSONEncode({ inGameStreaming = false }),
							notificationType.GAME_STREAMING_STATUS_CHANGED
						)
					end

					v20()
				end

				task.defer(launchFallback)
			end
		end)

		return true
	end

	local v36 = module4.useCallback(fn2, {
		v22,
		v30,
		v20,
		v33,
		param,
		if fFlagLuaAppStratusPassUniverseId then v7 else nil,
		param2,
		param3,
		v31
	})

	local useCallback2 = module4.useCallback
	local function fn3()
		if engineFeature then
			fn()
		end

		v27()
		v29()

		if fFlagUseUIOverlayForCloudPlay then
			v26()
		end

		v30()

		if ref3.current then
			ref3.current:Disconnect()
		end

		GuiService:BroadcastNotification(
			HttpService:JSONEncode({ hidden = false }),
			notificationType.SET_STATUS_BAR_STYLE
		)

		RunService:Set3dRenderingEnabled(true)

		if module8 and engineFeature2 or engineFeature then
			GuiService:BroadcastNotification(
				HttpService:JSONEncode({ inGameStreaming = false }),
				notificationType.GAME_STREAMING_STATUS_CHANGED
			)
		end

		if not fFlagUseUIOverlayForCloudPlay then
			v26()
		end

		v21()

		if fFlagLuaAppWireAudioDeviceInputOnRequest then
			v24()
			v23()
		end

		if fFlagLuaAppVideoServerDisplayWakeLock and ref16.current then
			ref16.current:Destroy()
			ref16.current = nil
		end

		v11:cancelPlayback("VideoServerStream", "VideoServerStream finished")
	end

	local v38 = if engineFeature then fn else nil
	local v39 = if fFlagLuaAppWireAudioDeviceInputOnRequest then v24 else nil
	local v41 = useCallback2(fn3, {
		v38,
		v27,
		v29,
		v30,
		v26,
		v21,
		v39,
		if fFlagLuaAppWireAudioDeviceInputOnRequest then v23 else nil,
		v19,
		v11
	})

	module4.useEffect(function()
		if not state then
			return
		end

		local v42 = 0
		local heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
			v42 = (v42 + dt * 180) % 360
			v10(v42)
		end)
		return function()
			heartbeatConnection:Disconnect()
		end
	end, { state })

	local useEffect = module4.useEffect
	local function fn4()
		if fFlagLuaAppVideoServerDisplayWakeLock then
			ref16.current = DeviceDisplayService:AcquireWakeLock("VideoServer")
		end

		enableAudioPlaybackInApp()
		v11:forcePlayback("VideoServerStream", "VideoServerStream started")
		GuiService:BroadcastNotification(
			HttpService:JSONEncode({ hidden = true }),
			notificationType.SET_STATUS_BAR_STYLE
		)

		RunService:Set3dRenderingEnabled(false)
		v28()

		if fFlagLuaAppWireAudioDeviceInputOnRequest then
			v25()
		end

		if module8 and engineFeature2 then
			GuiService:BroadcastNotification(
				HttpService:JSONEncode({ inGameStreaming = true }),
				notificationType.GAME_STREAMING_STATUS_CHANGED
			)

			if not v36() then
				v29()
				ref12.current = task.defer(function()
					ref12.current = nil
					v36()
				end)
			end
		elseif engineFeature then
			local function connectWhenReady()
				if not v36() then
					v29()
					ref12.current = task.defer(function()
						ref12.current = nil
						v36()
					end)
				end
			end

			fn()
			ref15.current = VideoService.GameStreamingResolutionReady:Connect(function()
				fn()

				if not v36() then
					v29()
					ref12.current = task.defer(function()
						ref12.current = nil
						v36()
					end)
				end
			end)
			GuiService:BroadcastNotification(
				HttpService:JSONEncode({ inGameStreaming = true }),
				notificationType.GAME_STREAMING_STATUS_CHANGED
			)
		elseif not v36() then
			v29()
			ref12.current = task.defer(function()
				ref12.current = nil
				v36()
			end)
		end

		return v41
	end

	local v43 = if engineFeature then fn else nil
	useEffect(fn4, {
		v28,
		v36,
		v43,
		v29,
		v41,
		if fFlagLuaAppWireAudioDeviceInputOnRequest then v25 else nil,
		v19,
		v11
	})

	local v45 = useFrameRefPassthrough(ref, ref2)

	if fFlagUseUIOverlayForCloudPlay then
		module4.useEffect(function()
			local current = ref3.current
			local v46

			if current then
				v46 = module13(current, v31)
				v18.current = v46
			else
				v46 = nil
			end

			return function()
				v18.current = nil

				if v46 then
					v46()
				end
			end
		end, { v31 })
	end

	local createElement = module3.createElement
	local v47 = {
		DisplayOrder = 200,
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.None,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}

	local createElement2 = module3.createElement
	local v50 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		ref = v45
	}

	local v51 = {
		RealtimeMedia = module3.createElement("RealtimeMedia", {
			ForwardInput = true,
			ref = ref3
		}),
		VideoDisplay = module3.createElement("VideoDisplay", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 2,
			ref = ref4
		}),
		AudioDeviceOutput = module3.createElement("AudioDeviceOutput", { ref = ref5 }),
		InputBlocker = module3.createElement("ImageButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 3,
			AutoButtonColor = false,
			Modal = not module9,
			ref = ref2
		}),
		LoadingSpinner = state and module3.createElement("ImageLabel", {
			Image = "rbxasset://textures/ui/LoadingScreen/LoadingSpinner.png",
			Size = UDim2.fromOffset(48, 48),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 4,
			Rotation = v9
		}) or nil,
		BugReport = 0
	}

	if not fFlagLuaAppStratusBugReportAfterConnect then
		state2 = fFlagInternalOnlyStratusBugReportEnabled
	end

	v51.BugReport = state2 and module3.createElement(module11) or nil
	local element = createElement("ScreenGui", v47, {
		VideoServerScreenView = createElement2("Frame", v50, v51)
	})

	if fFlagUseUIOverlayForCloudPlay then
		return module3.createElement(module4.Fragment, {}, {
			VideoServerScreen = element,
			OverlayScreen = module3.createElement(DeviceOverlayScreen)
		})
	end

	return element
end

return VideoServerScreenContainer
