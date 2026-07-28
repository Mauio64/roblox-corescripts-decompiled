local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local ExperienceLoadingScriptParent = ExperienceLoadingScript.Parent
local Players = require(ExperienceLoadingScriptParent.MockableProxyServices).Players
local ReplicatedFirst = require(ExperienceLoadingScriptParent.MockableProxyServices).ReplicatedFirst
local RunService = require(ExperienceLoadingScriptParent.MockableProxyServices).RunService
local VRService = require(ExperienceLoadingScriptParent.MockableProxyServices).VRService
local SplashScreenManager = require(ExperienceLoadingScriptParent.SplashScreenManager).SplashScreenManager
local IsVRAppBuild = require(ExperienceLoadingScriptParent.AppCommonLib).IsVRAppBuild
local FFlagEnableTiltLoadingScreen = require(ExperienceLoadingScriptParent.SharedFlags).FFlagEnableTiltLoadingScreen
local CoreGui = game:GetService("CoreGui")
local game2 = require(ExperienceLoadingScriptParent.MockableProxyServices).game
local waitProxy = require(ExperienceLoadingScriptParent.MockableProxyServices).waitProxy
local settingsProxy = require(ExperienceLoadingScriptParent.MockableProxyServices).settingsProxy

game:DefineFastInt("FPSAwareSplashScreenTimeout", 30)

local v14 = game:DefineFastFlag("ExperienceLoadingScreenFixStyleLink", false)
local UIBlox = require(ExperienceLoadingScriptParent.UIBlox)
local UIBloxInGameConfig = require(ExperienceLoadingScriptParent.CoreScriptsInitializer).UIBloxInGameConfig

UIBlox.init(UIBloxInGameConfig)

local Constants = UIBlox.App.Style.Constants
local UiModeStyleProvider = require(ExperienceLoadingScriptParent.Style).UiModeStyleProvider
local Create = require(ExperienceLoadingScriptParent.AppCommonLib).Create
local LoadingScreen = require(ExperienceLoadingScript.LoadingScreen)
local LoadingScreenReducer = require(ExperienceLoadingScript.Reducers.LoadingScreenReducer)
local LoggingProtocol = require(ExperienceLoadingScriptParent.LoggingProtocol)

local function GenerateDevGUIBlackoutCurtain() -- line: 39
	-- upvalues: Create (copy), CoreGui (copy)
	local v26 = Create("ScreenGui")({
		Name = "DevGUIBlackoutCurtain",
		DisplayOrder = 8,
		IgnoreGuiInset = true
	})

	Create("Frame")({
		Name = "BlackFrame",
		BackgroundTransparency = 0,
		Active = true,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.fromScale(10, 10),
		Position = UDim2.fromOffset(0, 0),
		Parent = v26
	})
	v26.Parent = CoreGui

	return v26
end
local function mountTiltLoadingScreen(p1, p2: ((...any) -> ...any)) -- line: 60
	-- upvalues: ExperienceLoadingScriptParent (copy), CoreGui (copy), game2 (copy), LoggingProtocol (copy)
	local React = require(ExperienceLoadingScriptParent.React)
	local ReactRoblox = require(ExperienceLoadingScriptParent.ReactRoblox)
	local TiltLoadingScreen = require(ExperienceLoadingScriptParent.ProgressLoading).TiltLoadingScreen
	local Folder = Instance.new("Folder")

	Folder.Name = "RobloxLoadingGUI"
	Folder.Parent = CoreGui

	local v33 = ReactRoblox.createRoot(Folder)
	local u34 = false

	local function unmount() -- line: 71
		-- upvalues: v33 (copy), Folder (copy)
		v33:unmount()
		Folder:Destroy()
	end

	v33:render(React.createElement(TiltLoadingScreen, {
		placeId = p1,
		onCancel = function(b1: boolean?) -- line: 75
			-- upvalues: u34 (ref), game2 (copy), LoggingProtocol (copy)
			if u34 or game2:IsLoaded() then
				return
			end

			u34 = true

			if b1 then
				LoggingProtocol.default:logEventOnce("first_experience_cancelled")
			end

			game2:Shutdown()
		end,
		onDismissComplete = function() -- line: 89
			-- upvalues: v33 (copy), Folder (copy), p2 (copy), LoggingProtocol (copy)
			v33:unmount()
			Folder:Destroy()
			p2()
			LoggingProtocol.default:logEventOnce("first_experience_interactive")
		end
	}))

	return unmount
end
local function u25(p3, p4) -- line: 103
	-- upvalues: GenerateDevGUIBlackoutCurtain (copy), ExperienceLoadingScriptParent (copy), LoadingScreenReducer (copy), LoadingScreen (copy), UiModeStyleProvider (copy), Constants (copy), v14 (copy), CoreGui (copy), RunService (copy), waitProxy (copy), SplashScreenManager (copy), ExperienceLoadingScript (copy), Players (copy), game2 (copy), VRService (copy), IsVRAppBuild (copy), FFlagEnableTiltLoadingScreen (copy), ReplicatedFirst (copy), LoggingProtocol (copy), mountTiltLoadingScreen (copy), u25 (ref), settingsProxy (copy)
	local u38 = true
	local u39 = false
	local u40 = false
	local u41 = nil
	local u42 = nil
	local u43 = GenerateDevGUIBlackoutCurtain()
	local Roact = nil

	local function v45(n1: number) -- line: 166
		-- upvalues: u38 (ref), Roact (ref), waitProxy (copy), u42 (ref), SplashScreenManager (copy), u41 (ref), u43 (ref), ExperienceLoadingScript (copy)
		u38 = false

		if Roact then
			waitProxy(0.6)

			if u42 ~= nil then
				Roact.unmount(u42)
				u42 = nil
			end
		end

		SplashScreenManager.initialize(n1 / 2, game:GetFastInt("FPSAwareSplashScreenTimeout"), n1)
		SplashScreenManager.addStatusChangeListener(function(p5) -- line: 172
			-- upvalues: u38 (ref), u41 (ref)
			u38 = p5

			if u38 and u41 then
				u41()
			end
		end)
		u43.Enabled = true
		require(ExperienceLoadingScript.LoadingScreen3D).Parent = u43
	end
	local function v46() -- line: 198
		-- upvalues: game2 (copy), Players (copy), u39 (ref), u41 (ref)
		if game2:IsLoaded() then
			if Players.CharacterAutoLoads then
				local LocalPlayer = Players.LocalPlayer

				if not LocalPlayer then
					Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
					LocalPlayer = Players.LocalPlayer
				end

				if not LocalPlayer.Character then
					LocalPlayer.CharacterAdded:Wait()
				end
			end

			u39 = true

			if u41 then
				u41()

				return
			end
		else
			local u63 = nil

			u63 = game2.Loaded:Connect(function() -- line: 207
				-- upvalues: u63 (ref), Players (copy), u39 (ref), u41 (ref)
				u63:Disconnect()
				u63 = nil

				if Players.CharacterAutoLoads then
					local LocalPlayer = Players.LocalPlayer

					if not LocalPlayer then
						Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
						LocalPlayer = Players.LocalPlayer
					end

					if not LocalPlayer.Character then
						LocalPlayer.CharacterAdded:Wait()
					end
				end

				u39 = true

				if u41 then
					u41()
				end
			end)
		end
	end

	if VRService.VREnabled or IsVRAppBuild() then
		v45(p4)
	else
		if FFlagEnableTiltLoadingScreen then
			if ReplicatedFirst:IsDefaultLoadingGuiRemoved() then
				if u43 then
					u43.Enabled = false
					u43:Destroy()
					u43 = nil
				end

				ReplicatedFirst:SetDefaultLoadingGuiRemoved()
				LoggingProtocol.default:logEventOnce("first_experience_interactive")

				return
			end

			local u47 = nil
			local u48 = true

			local function cleanUpTilt() -- line: 230
				-- upvalues: u48 (ref), u47 (ref), u43 (ref)
				u48 = false

				if u47 then
					u47:Disconnect()
					u47 = nil
				end

				if u43 then
					u43.Enabled = false
					u43:Destroy()
					u43 = nil
				end
			end

			local v50 = mountTiltLoadingScreen(p3, cleanUpTilt)

			local function transitionToVR() -- line: 240
				-- upvalues: u48 (ref), u47 (ref), u43 (ref), v50 (copy), u25 (ref), p3 (copy), p4 (copy)
				if not u48 then
					return
				end

				u48 = false

				if u47 then
					u47:Disconnect()
					u47 = nil
				end

				if u43 then
					u43.Enabled = false
					u43:Destroy()
					u43 = nil
				end

				v50()
				u25(p3, p4)
			end

			u47 = VRService:GetPropertyChangedSignal("VREnabled"):Connect(function() -- line: 249
				-- upvalues: VRService (copy), u48 (ref), u47 (ref), u43 (ref), v50 (copy), u25 (ref), p3 (copy), p4 (copy)
				if VRService.VREnabled then
					if not u48 then
						return
					end

					u48 = false

					if u47 then
						u47:Disconnect()
						u47 = nil
					end

					if u43 then
						u43.Enabled = false
						u43:Destroy()
						u43 = nil
					end

					v50()
					u25(p3, p4)
				end
			end)

			if VRService.VREnabled and u48 then
				u48 = false

				if u47 then
					u47:Disconnect()
					u47 = nil
				end

				if u43 then
					u43.Enabled = false
					u43:Destroy()
					u43 = nil
				end

				v50()
				u25(p3, p4)
			end

			if u48 then
				RunService.Heartbeat:Wait()

				if u48 then
					u43.Enabled = false
				end
			end

			return
		end

		VRService:GetPropertyChangedSignal("VREnabled"):Connect(function() -- line: 269
			-- upvalues: VRService (copy), v45 (copy), p4 (copy)
			if VRService.VREnabled then
				v45(p4)
			end
		end)
		u42 = (function(p6) -- line: 124
			-- upvalues: Roact (ref), ExperienceLoadingScriptParent (copy), LoadingScreenReducer (copy), LoadingScreen (copy), UiModeStyleProvider (copy), Constants (copy), v14 (copy), CoreGui (copy), RunService (copy), u43 (ref)
			Roact = require(ExperienceLoadingScriptParent.Roact)

			local Rodux = require(ExperienceLoadingScriptParent.Rodux)
			local RoactRodux = require(ExperienceLoadingScriptParent.RoactRodux)
			local v56 = Rodux.Store.new(LoadingScreenReducer, {}, { Rodux.thunkMiddleware })
			local v57 = Roact.createElement(LoadingScreen, {
				placeId = p6
			})
			local v58 = Roact.createElement(RoactRodux.StoreProvider, {
				store = v56
			}, { Roact.createElement(UiModeStyleProvider, {
				style = {
					themeName = Constants.ThemeName.Dark,
					fontName = Constants.FontName.Gotham
				}
			}, {
				loadingScreenUI = v57
			}) })

			if v14 then
				v58 = Roact.createElement("Folder", nil, v58)
			end

			local v59 = Roact.mount(v58, CoreGui, "RobloxLoadingGUI")

			RunService.Heartbeat:Wait()
			u43.Enabled = false

			return v59
		end)(p3)
	end

	function u41() -- line: 279
		-- upvalues: VRService (copy), u38 (ref), settingsProxy (copy), u43 (ref), ReplicatedFirst (copy), LoggingProtocol (copy), u39 (ref), u40 (ref), Roact (ref), waitProxy (copy), u42 (ref)
		if VRService.VREnabled then
			if u38 or settingsProxy().Rendering.QualityLevel ~= Enum.QualityLevel.Automatic then
				if u43 then
					u43.Enabled = false
					u43:Destroy()
					u43 = nil
				end

				ReplicatedFirst:SetDefaultLoadingGuiRemoved()
				LoggingProtocol.default:logEventOnce("first_experience_interactive")

				return
			end
		elseif u39 or u40 then
			if Roact then
				waitProxy(0.6)

				if u42 ~= nil then
					Roact.unmount(u42)
					u42 = nil
				end
			end

			if u43 then
				u43.Enabled = false
				u43:Destroy()
				u43 = nil
			end

			ReplicatedFirst:SetDefaultLoadingGuiRemoved()
			LoggingProtocol.default:logEventOnce("first_experience_interactive")
		end
	end

	ReplicatedFirst.FinishedReplicating:Connect(v46)

	if ReplicatedFirst:IsFinishedReplicating() then
		v46()
	end

	ReplicatedFirst.RemoveDefaultLoadingGuiSignal:Connect(function() -- line: 309
		-- upvalues: u40 (ref), u41 (ref)
		u40 = true

		if u41 then
			u41()
		end
	end)

	if ReplicatedFirst:IsDefaultLoadingGuiRemoved() then
		u40 = true

		if u41 then
			u41()
		end
	end
end

return u25
