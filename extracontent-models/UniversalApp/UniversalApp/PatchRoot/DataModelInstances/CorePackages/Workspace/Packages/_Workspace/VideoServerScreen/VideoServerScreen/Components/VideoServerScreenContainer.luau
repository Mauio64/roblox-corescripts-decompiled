local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VideoService = game:GetService("VideoService")
local Parent = script:FindFirstAncestor("VideoServerScreen").Parent
local enableAudioPlaybackInApp = require(Parent.MediaPlayback).enableAudioPlaybackInApp
local NotificationType = require(Parent.RobloxAppEnums).NotificationType
local Cryo = require(Parent.Cryo)
local Roact = require(Parent.Roact)
local React = require(Parent.React)
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local ExperienceService = require(Parent.ExperienceService).ExperienceService
local NavigateBack = require(Parent.NavigationRodux).Thunks.NavigateBack
local useNavigation = require(Parent.Navigation).useNavigation
local AndroidTVExitButtonManager = require(Parent.RobloxAppNavigationCore).AndroidTVExitButtonManager
local useAppPolicy = require(Parent.UniversalAppPolicy).useAppPolicy
local VideoPlaybackCoordinator = require(Parent.VideoUtils).VideoPlaybackCoordinator
local FFlagLuaAppVideoPlaybackRefCount = require(Parent.SharedFlags).FFlagLuaAppVideoPlaybackRefCount
local FFlagInternalOnlyStratusBugReportEnabled = require(Parent.SharedFlags).FFlagInternalOnlyStratusBugReportEnabled
local FFlagLuaAppStratusBugReportAfterConnect = require(Parent.SharedFlags).FFlagLuaAppStratusBugReportAfterConnect
local EngineFeature = game:GetEngineFeature("EnableGameStreamingResolutionReadySignal")
local FFlagLuaAppStratusDisable3dRendering = require(Parent.SharedFlags).FFlagLuaAppStratusDisable3dRendering
local FFlagLuaAppStratusLoadingSpinner = require(Parent.SharedFlags).FFlagLuaAppStratusLoadingSpinner
local FFlagAndroidTVExitWithB = require(Parent.SharedFlags).FFlagAndroidTVExitWithB
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v26 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local StratusBugReportPanel = require(script.Parent.StratusBugReportPanel)

local function setNativeStatusBarHidden(b1: boolean) -- line: 38
	-- upvalues: GuiService (copy), HttpService (copy), NotificationType (copy)
	GuiService:BroadcastNotification(HttpService:JSONEncode({
		hidden = b1
	}), NotificationType.SET_STATUS_BAR_STYLE)
end
local function setNativeInGameStreaming(b2: boolean) -- line: 42
	-- upvalues: GuiService (copy), HttpService (copy), NotificationType (copy)
	GuiService:BroadcastNotification(HttpService:JSONEncode({
		inGameStreaming = b2
	}), NotificationType.GAME_STREAMING_STATUS_CHANGED)
end
local function VideoServerScreenContainer() -- line: 51
	-- upvalues: useNavigation (copy), useDispatch (copy), React (copy), FFlagLuaAppStratusBugReportAfterConnect (copy), FFlagLuaAppVideoPlaybackRefCount (copy), VideoPlaybackCoordinator (copy), useAppPolicy (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), NavigateBack (copy), FFlagAndroidTVExitWithB (copy), GuiService (copy), AndroidTVExitButtonManager (copy), EngineFeature (copy), Cryo (copy), FFlagLuaAppStratusLoadingSpinner (copy), ExperienceService (copy), HttpService (copy), NotificationType (copy), FFlagLuaAppStratusDisable3dRendering (copy), RunService (copy), enableAudioPlaybackInApp (copy), VideoService (copy), Roact (copy), FFlagInternalOnlyStratusBugReportEnabled (copy), StratusBugReportPanel (copy)
	local v33 = useNavigation()
	local v34 = v33.getParam("placeId")
	local v35 = v33.getParam("launchSource")
	local v36 = v33.getParam("extraParams")
	local v37 = useDispatch()
	local v38, v39 = React.useState(false)
	local v40 = false

	local function u41(_: boolean) -- line: 59
	end

	if FFlagLuaAppStratusBugReportAfterConnect then
		local v42

		v40, v42 = React.useState(false)
		u41 = v42
	end

	local v43, v44 = React.useBinding(0)
	local v45 = if not FFlagLuaAppVideoPlaybackRefCount then VideoPlaybackCoordinator.default else React.useMemo(function() -- line: 66
		-- upvalues: VideoPlaybackCoordinator (copy)
		return VideoPlaybackCoordinator.new()
	end, {})
	local v46 = React.useRef(nil)
	local v47 = React.useRef(nil)
	local v48 = React.useRef(nil)
	local v49 = React.useRef(nil)
	local v50 = React.useRef(nil)
	local v51 = React.useRef(nil)
	local v52 = React.useRef(nil)
	local v53 = React.useRef(nil)
	local v54 = React.useRef(nil)
	local v55 = React.useRef(0)
	local v56 = React.useRef(nil)
	local v57 = React.useRef(nil)
	local v58 = React.useRef(nil)
	local v59 = React.useRef(nil)
	local v60 = useAppPolicy(function(p1) -- line: 90
		return p1.getThrottleFramerate()
	end)
	local v61 = React.useCallback(function() -- line: 94
		-- upvalues: FFlagSignalsNavP3Dispatch (copy), v26 (copy), v37 (copy), NavigateBack (copy)
		if FFlagSignalsNavP3Dispatch then
			v26.back(true)

			return
		end

		v37(NavigateBack(true))
	end, { v37 })
	local v62 = React.useCallback(function() -- line: 102
		-- upvalues: v50 (copy), v51 (copy)
		if v50.current then
			v50.current:Destroy()
			v50.current = nil
		end

		if v51.current then
			v51.current:Destroy()
			v51.current = nil
		end
	end, {})
	local v63 = React.useCallback(function() -- line: 113
		-- upvalues: v46 (copy), v47 (copy), v48 (copy), v49 (copy), v62 (copy), v50 (copy), v51 (copy)
		local current = v46.current
		local current2 = v47.current
		local current3 = v48.current
		local current4 = v49.current

		if not current or (not current2 or not current3 or not current4) then
			return
		end

		v62()

		local Wire = Instance.new("Wire")

		Wire.SourceInstance = current2
		Wire.TargetInstance = current3
		Wire.SourceName = "Output"
		Wire.TargetName = "Input"
		Wire.Parent = current
		v50.current = Wire

		local Wire2 = Instance.new("Wire")

		Wire2.SourceInstance = current2
		Wire2.TargetInstance = current4
		Wire2.SourceName = "Output"
		Wire2.TargetName = "Input"
		Wire2.Parent = current
		v51.current = Wire2
	end, { v62 })
	local v64 = React.useCallback(function() -- line: 138
		-- upvalues: v52 (copy), v53 (copy)
		if v52.current then
			v52.current:Disconnect()
			v52.current = nil
		end

		v53.current = nil
	end, {})
	local v65 = React.useCallback(function() -- line: 146
		-- upvalues: v64 (copy), v47 (copy), v53 (copy), v52 (copy), v61 (copy)
		v64()

		local current = v47.current

		if not current then
			return
		end

		v53.current = current.IsConnected
		v52.current = current:GetPropertyChangedSignal("IsConnected"):Connect(function() -- line: 153
			-- upvalues: current (copy), v53 (copy), v61 (copy)
			local IsConnected = current.IsConnected

			if v53.current == true and IsConnected == false then
				v61()
			end

			v53.current = IsConnected
		end)
	end, {
		v64,
		v61
	})
	local v66 = React.useCallback(function() -- line: 162
		-- upvalues: v57 (copy), FFlagAndroidTVExitWithB (copy), v58 (copy)
		if v57.current then
			v57.current:Disconnect()
			v57.current = nil
		end

		if FFlagAndroidTVExitWithB and v58.current then
			v58.current()
			v58.current = nil
		end
	end, {})
	local v67 = React.useCallback(function() -- line: 173
		-- upvalues: v66 (copy), v57 (copy), GuiService (copy), v61 (copy), FFlagAndroidTVExitWithB (copy), v58 (copy), AndroidTVExitButtonManager (copy)
		v66()
		v57.current = GuiService.ShowLeaveConfirmation:Connect(function() -- line: 175
			-- upvalues: v61 (copy)
			v61()
		end)

		if FFlagAndroidTVExitWithB then
			v58.current = AndroidTVExitButtonManager.register(v61)
		end
	end, {
		v66,
		v61
	})
	local v68 = not EngineFeature and function() -- line: 190
	end or React.useCallback(function() -- line: 184
		-- upvalues: v59 (copy)
		if v59.current then
			v59.current:Disconnect()
			v59.current = nil
		end
	end, {})
	local v69 = React.useCallback(function() -- line: 192
		-- upvalues: v56 (copy)
		if v56.current then
			task.cancel(v56.current)
			v56.current = nil
		end
	end, {})
	local v70 = React.useCallback(function() -- line: 199
		-- upvalues: v54 (copy), v47 (copy)
		if v54.current then
			if v47.current then
				v47.current:Disconnect()
			end

			task.cancel(v54.current)
			v54.current = nil
		end
	end, {})
	local v71 = React.useCallback(function() -- line: 210
		-- upvalues: v47 (copy), v48 (copy), v63 (copy), v34 (copy), v36 (copy), Cryo (copy), v70 (copy), v55 (copy), FFlagLuaAppStratusLoadingSpinner (copy), v39 (copy), v54 (copy), v35 (copy), ExperienceService (copy), EngineFeature (copy), GuiService (copy), HttpService (copy), NotificationType (copy), v61 (copy), FFlagLuaAppStratusBugReportAfterConnect (copy), u41 (ref), v65 (copy)
		if not v47.current or not v48.current then
			return false
		end

		v63()

		local current = v48.current
		local t1 = {
			placeId = v34,
			width = current.AbsoluteSize.X,
			height = current.AbsoluteSize.Y
		}

		if v36 then
			t1 = Cryo.Dictionary.join(t1, v36)
		end

		v70()

		local v84 = v55

		v84.current = v84.current + 1

		local current5 = v55.current

		if FFlagLuaAppStratusLoadingSpinner then
			v39(true)
		end

		v54.current = task.spawn(function() -- line: 235
			-- upvalues: v47 (copy), t1 (ref), v55 (copy), current5 (copy), v54 (copy), v34 (copy), v35 (copy), v36 (copy), Cryo (copy), ExperienceService (copy), EngineFeature (copy), GuiService (copy), HttpService (copy), NotificationType (copy), v61 (copy), FFlagLuaAppStratusLoadingSpinner (copy), v39 (copy), FFlagLuaAppStratusBugReportAfterConnect (copy), u41 (ref), v65 (copy)
			local v90 = v47.current:ConnectAsync("", t1)

			if v55.current ~= current5 then
				return
			end

			v54.current = nil

			if not v90 then
				local function launchFallback() -- line: 244
					-- upvalues: v34 (copy), v35 (copy), v36 (copy), Cryo (copy), ExperienceService (copy), EngineFeature (copy), GuiService (copy), HttpService (copy), NotificationType (copy), v61 (copy)
					local t2 = {
						placeId = tonumber(v34),
						referralPage = v35
					}

					if v36 then
						t2 = Cryo.Dictionary.join(t2, v36)
					end

					ExperienceService:LaunchExperience(t2, v35)

					if EngineFeature then
						GuiService:BroadcastNotification(HttpService:JSONEncode({
							inGameStreaming = false
						}), NotificationType.GAME_STREAMING_STATUS_CHANGED)
					end

					v61()
				end

				if FFlagLuaAppStratusLoadingSpinner then
					v39(false)
					task.defer(launchFallback)

					return
				end

				launchFallback()

				return
			end

			if FFlagLuaAppStratusLoadingSpinner then
				v39(false)
			end

			if FFlagLuaAppStratusBugReportAfterConnect then
				u41(true)
			end

			v65()
		end)

		return true
	end, {
		v63,
		v70,
		v61,
		v65,
		v34,
		v35,
		v36
	})
	local v72 = React.useCallback(function() -- line: 289
		-- upvalues: EngineFeature (copy), v68 (copy), v66 (copy), v69 (copy), v70 (copy), v47 (copy), GuiService (copy), HttpService (copy), NotificationType (copy), FFlagLuaAppStratusDisable3dRendering (copy), RunService (copy), v64 (copy), v62 (copy), FFlagLuaAppVideoPlaybackRefCount (copy), v45 (copy), v60 (copy)
		if EngineFeature then
			v68()
		end

		v66()
		v69()
		v70()

		if v47.current then
			v47.current:Disconnect()
		end

		GuiService:BroadcastNotification(HttpService:JSONEncode({
			hidden = false
		}), NotificationType.SET_STATUS_BAR_STYLE)

		if FFlagLuaAppStratusDisable3dRendering then
			RunService:Set3dRenderingEnabled(true)
		end

		if EngineFeature then
			GuiService:BroadcastNotification(HttpService:JSONEncode({
				inGameStreaming = false
			}), NotificationType.GAME_STREAMING_STATUS_CHANGED)
		end

		v64()
		v62()

		if FFlagLuaAppVideoPlaybackRefCount then
			v45:cancelPlayback("VideoServerStream", "VideoServerStream finished")

			return
		end

		if v60 then
			RunService:setThrottleFramerateEnabled(true)
		end
	end, {
		if not EngineFeature then nil else v68,
		v66,
		v69,
		v70,
		v64,
		v62,
		v60,
		if not FFlagLuaAppVideoPlaybackRefCount then nil else v45
	})

	React.useEffect(function() -- line: 328
		-- upvalues: v38 (copy), RunService (copy), v44 (copy)
		if not v38 then
			return
		end

		local n1 = 0
		local connection = RunService.Heartbeat:Connect(function(dt) -- line: 333
			-- upvalues: n1 (ref), v44 (copy)
			n1 = (n1 + dt * 180) % 360
			v44(n1)
		end)

		return function() -- line: 337
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v38 })
	React.useEffect(function() -- line: 343
		-- upvalues: enableAudioPlaybackInApp (copy), FFlagLuaAppVideoPlaybackRefCount (copy), v45 (copy), v60 (copy), RunService (copy), GuiService (copy), HttpService (copy), NotificationType (copy), FFlagLuaAppStratusDisable3dRendering (copy), v67 (copy), EngineFeature (copy), v71 (copy), v69 (copy), v56 (copy), v68 (copy), v59 (copy), VideoService (copy), v72 (copy)
		enableAudioPlaybackInApp()

		if FFlagLuaAppVideoPlaybackRefCount then
			v45:forcePlayback("VideoServerStream", "VideoServerStream started")
		elseif v60 then
			RunService:setThrottleFramerateEnabled(false)
		end

		GuiService:BroadcastNotification(HttpService:JSONEncode({
			hidden = true
		}), NotificationType.SET_STATUS_BAR_STYLE)

		if FFlagLuaAppStratusDisable3dRendering then
			RunService:Set3dRenderingEnabled(false)
		end

		v67()

		if EngineFeature then
			local function connectWhenReady() -- line: 359
				-- upvalues: v71 (copy), v69 (copy), v56 (copy)
				if not v71() then
					v69()
					v56.current = task.defer(function() -- line: 362
						-- upvalues: v56 (copy), v71 (copy)
						v56.current = nil
						v71()
					end)
				end
			end

			v68()
			v59.current = VideoService.GameStreamingResolutionReady:Connect(function() -- line: 375
				-- upvalues: v68 (copy), v71 (copy), v69 (copy), v56 (copy)
				v68()

				if not v71() then
					v69()
					v56.current = task.defer(function() -- line: 362
						-- upvalues: v56 (copy), v71 (copy)
						v56.current = nil
						v71()
					end)
				end
			end)
			GuiService:BroadcastNotification(HttpService:JSONEncode({
				inGameStreaming = true
			}), NotificationType.GAME_STREAMING_STATUS_CHANGED)
		elseif not v71() then
			v69()
			v56.current = task.defer(function() -- line: 383
				-- upvalues: v56 (copy), v71 (copy)
				v56.current = nil
				v71()
			end)
		end

		return v72
	end, {
		v67,
		v71,
		if not EngineFeature then nil else v68,
		v69,
		v72,
		v60,
		if not FFlagLuaAppVideoPlaybackRefCount then nil else v45
	})

	return Roact.createElement("ScreenGui", {
		DisplayOrder = 200,
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ScreenInsets = Enum.ScreenInsets.None,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		VideoServerScreenView = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(0, 0, 0),
			ref = v46
		}, {
			RealtimeMedia = Roact.createElement("RealtimeMedia", {
				ForwardInput = true,
				ref = v47
			}),
			VideoDisplay = Roact.createElement("VideoDisplay", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1),
				ref = v48
			}),
			AudioDeviceOutput = Roact.createElement("AudioDeviceOutput", {
				ref = v49
			}),
			InputBlocker = Roact.createElement("ImageButton", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 3,
				AutoButtonColor = false,
				Modal = true,
				Size = UDim2.fromScale(1, 1)
			}),
			LoadingSpinner = FFlagLuaAppStratusLoadingSpinner and (not not v38 and Roact.createElement("ImageLabel", {
				Image = "rbxasset://textures/ui/LoadingScreen/LoadingSpinner.png",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 4,
				Size = UDim2.fromOffset(48, 48),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Rotation = v43
			})) or nil,
			BugReport = ((if not FFlagLuaAppStratusBugReportAfterConnect then FFlagInternalOnlyStratusBugReportEnabled else v40)) and Roact.createElement(StratusBugReportPanel) or nil
		})
	})
end

return VideoServerScreenContainer
