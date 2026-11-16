local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local parent = ExperienceLoadingScript.Parent

local Foundation = require(parent.Foundation)
local ColorMode = Foundation.Enums.ColorMode

local MockableProxyServices = require(parent.MockableProxyServices)
local Players = MockableProxyServices.Players
local MockableProxyServices2 = require(parent.MockableProxyServices)
local ReplicatedFirst = MockableProxyServices2.ReplicatedFirst
local MockableProxyServices3 = require(parent.MockableProxyServices)
local RunService = MockableProxyServices3.RunService
local MockableProxyServices4 = require(parent.MockableProxyServices)
local VRService = MockableProxyServices4.VRService
local SplashScreenManager = require(parent.SplashScreenManager)
local splashScreenManager = SplashScreenManager.SplashScreenManager
local AppCommonLib = require(parent.AppCommonLib)
local IsVRAppBuild = AppCommonLib.IsVRAppBuild

local LoadingScreenMilestones = require(parent.ProgressLoading.LoadingScreenMilestones)
local AbortReason = LoadingScreenMilestones.AbortReason
local SharedFlags = require(parent.SharedFlags)
local FFlagLoadingScreenMilestones = SharedFlags.FFlagLoadingScreenMilestones
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLoadingScreenControlMilestones = SharedFlags2.FFlagLoadingScreenControlMilestones
local SharedFlags3 = require(parent.SharedFlags)
local FFlagTiltLoadingScreenEnterExitHold = SharedFlags3.FFlagTiltLoadingScreenEnterExitHold

local SharedFlags4 = require(parent.SharedFlags)
local FFlagEnableTiltLoadingScreen = SharedFlags4.FFlagEnableTiltLoadingScreen

local CoreGui = game:GetService("CoreGui")

local MockableProxyServices5 = require(parent.MockableProxyServices)
local Game = MockableProxyServices5.game
local MockableProxyServices6 = require(parent.MockableProxyServices)
local waitProxy = MockableProxyServices6.waitProxy
local MockableProxyServices7 = require(parent.MockableProxyServices)
local settingsProxy = MockableProxyServices7.settingsProxy

game:DefineFastInt("FPSAwareSplashScreenTimeout", 30)

local UIBlox = require(parent.UIBlox)
local CoreScriptsInitializer = require(parent.CoreScriptsInitializer)
local UIBloxInGameConfig = CoreScriptsInitializer.UIBloxInGameConfig
UIBlox.init(UIBloxInGameConfig)

local Constants = UIBlox.App.Style.Constants

local Style = require(parent.Style)
local UiModeStyleProvider = Style.UiModeStyleProvider

local AppCommonLib2 = require(parent.AppCommonLib)
local Create = AppCommonLib2.Create
local LoadingScreen = require(ExperienceLoadingScript.LoadingScreen)
local LoadingScreenReducer = require(ExperienceLoadingScript.Reducers.LoadingScreenReducer)
local LoggingProtocol = require(parent.LoggingProtocol)

local function GenerateDevGUIBlackoutCurtain()
	local devGUIBlackoutCurtain = Create("ScreenGui")({
		Name = "DevGUIBlackoutCurtain",
		DisplayOrder = 8,
		IgnoreGuiInset = true
	})

	Create("Frame")({
		Name = "BlackFrame",
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0,
		Size = UDim2.fromScale(10, 10),
		Position = UDim2.fromOffset(0, 0),
		Active = true,
		Parent = devGUIBlackoutCurtain
	})

	devGUIBlackoutCurtain.Parent = CoreGui

	return devGUIBlackoutCurtain
end

local function mountTiltLoadingScreen(placeId, cleanUpTilt, p)
	local React = require(parent.React)
	local ReactRoblox = require(parent.ReactRoblox)
	local ProgressLoading = require(parent.ProgressLoading)
	local tiltLoadingScreen = ProgressLoading.TiltLoadingScreen

	local robloxLoadingGUI = Instance.new("Folder")
	robloxLoadingGUI.Name = "RobloxLoadingGUI"
	robloxLoadingGUI.Parent = CoreGui

	local root = ReactRoblox.createRoot(robloxLoadingGUI)
	local v = false
	local function unmount() -- 1 equivalent call inferred from this helper
		if FFlagLoadingScreenMilestones and p then
			p.abort(AbortReason.Unmounted)
		end

		root:unmount()
		robloxLoadingGUI:Destroy()
	end
	local function onCancel(flag: boolean?, flag2: boolean?)
		if v or flag2 and Game:IsLoaded() then
			return
		end

		v = true

		if FFlagLoadingScreenMilestones and p then
			p.abort(AbortReason.Cancelled)
		end

		if flag then
			LoggingProtocol.default:logEventOnce("first_experience_cancelled")
		end

		Game:Shutdown()
	end

	local createElement = React.createElement
	local milestones

	if FFlagLoadingScreenMilestones then
		milestones = p
	end

	root:render(createElement(tiltLoadingScreen, {
		milestones = milestones,
		placeId = placeId,
		onCancel = onCancel,
		onDismissComplete = function()
			unmount() -- inferred equivalent call
			cleanUpTilt()
			LoggingProtocol.default:logEventOnce("first_experience_interactive")
		end
	}))

	return unmount
end

local function fn(placeId, p)
	local v = true
	local v2 = false
	local v3 = false

	local fn2
	local v4 = nil
	local v5 = nil

	local parent2 = GenerateDevGUIBlackoutCurtain()

	local v6 = nil

	local function fn3(placeId2)
		local Roact = require(parent.Roact)
		v6 = Roact
		local Rodux = require(parent.Rodux)
		local RoactRodux = require(parent.RoactRodux)
		local store = Rodux.Store.new(LoadingScreenReducer, {}, { Rodux.thunkMiddleware })

		local createElement = v6.createElement
		local milestones

		if FFlagLoadingScreenControlMilestones then
			milestones = v5
		end

		local element = createElement(LoadingScreen, { placeId = placeId2, milestones = milestones })

		local element2 = v6.createElement(RoactRodux.StoreProvider, { store = store }, {
			v6.createElement(UiModeStyleProvider, {
				style = { themeName = ColorMode.Dark, fontName = Constants.FontName.Gotham }
			}, { loadingScreenUI = element })
		})

		local element3 = v6.createElement("Folder", nil, element2)
		local v7 = v6.mount(element3, CoreGui, "RobloxLoadingGUI")

		RunService.Heartbeat:Wait()
		parent2.Enabled = false
		return v7
	end

	local function fn4() -- 2 equivalent calls inferred from this helper
		if v6 then
			waitProxy(0.6)

			if v4 ~= nil then
				if FFlagLoadingScreenControlMilestones and v5 then
					v5.record(LoadingScreenMilestones.Milestone.ScreenHidden)
					v5.complete()
				end

				v6.unmount(v4)
				v4 = nil
			end
		end
	end

	local function fn5(p2: number)
		v = false
		fn4() -- inferred equivalent call
		splashScreenManager.initialize(p2 / 2, game:GetFastInt("FPSAwareSplashScreenTimeout"), p2)
		splashScreenManager.addStatusChangeListener(function(p3)
			v = p3

			if v and fn2 then
				fn2()
			end
		end)
		parent2.Enabled = true

		local LoadingScreen3D = require(ExperienceLoadingScript.LoadingScreen3D)
		LoadingScreen3D.Parent = parent2
	end

	local function fn6() -- 2 equivalent calls inferred from this helper
		if Players.CharacterAutoLoads then
			local localPlayer = Players.LocalPlayer

			if not localPlayer then
				Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
				localPlayer = Players.LocalPlayer
			end

			if not localPlayer.Character then
				localPlayer.CharacterAdded:Wait()
			end
		end
	end

	local function onFinishedReplicating()
		if Game:IsLoaded() then
			if FFlagLoadingScreenControlMilestones and v5 then
				v5.dismissRequested(LoadingScreenMilestones.DismissSource.NormalReady)
			end

			fn6() -- inferred equivalent call
			v2 = true

			if fn2 then
				fn2()
			end
		else
			local loadedConnection = nil
			loadedConnection = Game.Loaded:Connect(function()
				loadedConnection:Disconnect()
				loadedConnection = nil

				if FFlagLoadingScreenControlMilestones and v5 then
					v5.dismissRequested(LoadingScreenMilestones.DismissSource.NormalReady)
				end

				fn6() -- inferred equivalent call
				v2 = true

				if fn2 then
					fn2()
				end
			end)
		end
	end

	local function fn7() -- 4 equivalent calls inferred from this helper
		if parent2 then
			parent2.Enabled = false
			parent2:Destroy()
			parent2 = nil
		end
	end

	if VRService.VREnabled or IsVRAppBuild() then
		fn5(p)
	elseif FFlagEnableTiltLoadingScreen then
		if ReplicatedFirst:IsDefaultLoadingGuiRemoved() then
			fn7() -- inferred equivalent call
			ReplicatedFirst:SetDefaultLoadingGuiRemoved()
			LoggingProtocol.default:logEventOnce("first_experience_interactive")
			return
		else
			local vREnabledChangedConnection = nil
			local flag = true
			local function cleanUpTilt() -- 1 equivalent call inferred from this helper
				flag = false

				if vREnabledChangedConnection then
					vREnabledChangedConnection:Disconnect()
					vREnabledChangedConnection = nil
				end

				fn7() -- inferred equivalent call
			end

			local v7

			if FFlagLoadingScreenMilestones then
				local start = LoadingScreenMilestones.start
				local v8 = {
					page = LoadingScreenMilestones.Page.TiltLoadingScreen,
					holdEnabled = FFlagTiltLoadingScreenEnterExitHold,
					reducedMotion = 0
				}

				local UserGameSettings = UserSettings():GetService("UserGameSettings")
				v8.reducedMotion = UserGameSettings.ReducedMotion
				v7 = start(v8)
			else
				v7 = nil
			end

			local v8 = mountTiltLoadingScreen(placeId, cleanUpTilt, v7)

			local function transitionToVR() -- 2 equivalent calls inferred from this helper
				if not flag then
					return
				end

				if FFlagLoadingScreenMilestones and v7 then
					v7.abort(AbortReason.VRHandoff)
				end

				cleanUpTilt() -- inferred equivalent call
				v8()
				fn(placeId, p)
			end

			vREnabledChangedConnection = VRService:GetPropertyChangedSignal("VREnabled"):Connect(function()
				if VRService.VREnabled then
					transitionToVR() -- inferred equivalent call
				end
			end)

			if VRService.VREnabled then
				transitionToVR() -- inferred equivalent call
			end

			if flag then
				RunService.Heartbeat:Wait()

				if flag then
					parent2.Enabled = false
				end
			end

			return
		end
	else
		VRService:GetPropertyChangedSignal("VREnabled"):Connect(function()
			if VRService.VREnabled then
				if FFlagLoadingScreenControlMilestones and v5 then
					v5.abort(AbortReason.VRHandoff)
				end

				fn5(p)
			end
		end)

		if FFlagLoadingScreenControlMilestones and not ReplicatedFirst:IsDefaultLoadingGuiRemoved() then
			local start = LoadingScreenMilestones.start
			local v7 = {
				page = LoadingScreenMilestones.Page.LoadingScreenView,
				holdEnabled = false,
				reducedMotion = 0
			}

			local UserGameSettings = UserSettings():GetService("UserGameSettings")
			v7.reducedMotion = UserGameSettings.ReducedMotion
			v5 = start(v7)
		end

		v4 = fn3(placeId)
	end

	fn2 = function()
		if VRService.VREnabled then
			if v or settingsProxy().Rendering.QualityLevel ~= Enum.QualityLevel.Automatic then
				fn7() -- inferred equivalent call
				ReplicatedFirst:SetDefaultLoadingGuiRemoved()
				LoggingProtocol.default:logEventOnce("first_experience_interactive")
			end
		elseif v2 or v3 then
			fn4() -- inferred equivalent call
			fn7() -- inferred equivalent call
			ReplicatedFirst:SetDefaultLoadingGuiRemoved()
			LoggingProtocol.default:logEventOnce("first_experience_interactive")
		end
	end

	ReplicatedFirst.FinishedReplicating:Connect(onFinishedReplicating)

	if ReplicatedFirst:IsFinishedReplicating() then
		onFinishedReplicating()
	end

	ReplicatedFirst.RemoveDefaultLoadingGuiSignal:Connect(function()
		if FFlagLoadingScreenControlMilestones and v5 then
			v5.dismissRequested(LoadingScreenMilestones.DismissSource.DeveloperOverride)
		end

		v3 = true

		if fn2 then
			fn2()
		end
	end)

	if ReplicatedFirst:IsDefaultLoadingGuiRemoved() then
		if FFlagLoadingScreenControlMilestones and v5 then
			v5.dismissRequested(LoadingScreenMilestones.DismissSource.DeveloperOverride)
		end

		v3 = true

		if fn2 then
			fn2()
		end
	end
end

return fn
