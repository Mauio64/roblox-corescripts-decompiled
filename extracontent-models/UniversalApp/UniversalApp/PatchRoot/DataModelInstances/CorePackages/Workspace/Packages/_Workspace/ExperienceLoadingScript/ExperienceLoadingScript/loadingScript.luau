local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local ExperienceLoadingScriptParent = ExperienceLoadingScript.Parent
local Players = require(ExperienceLoadingScriptParent.MockableProxyServices).Players
local ReplicatedFirst = require(ExperienceLoadingScriptParent.MockableProxyServices).ReplicatedFirst
local RunService = require(ExperienceLoadingScriptParent.MockableProxyServices).RunService
local VRService = require(ExperienceLoadingScriptParent.MockableProxyServices).VRService
local SplashScreenManager = require(ExperienceLoadingScriptParent.SplashScreenManager).SplashScreenManager
local IsVRAppBuild = require(ExperienceLoadingScriptParent.AppCommonLib).IsVRAppBuild
local CoreGui = game:GetService("CoreGui")
local game2 = require(ExperienceLoadingScriptParent.MockableProxyServices).game
local waitProxy = require(ExperienceLoadingScriptParent.MockableProxyServices).waitProxy
local settingsProxy = require(ExperienceLoadingScriptParent.MockableProxyServices).settingsProxy

game:DefineFastInt("FPSAwareSplashScreenTimeout", 30)

local v13 = game:DefineFastFlag("ExperienceLoadingScreenFixStyleLink", false)
local UIBlox = require(ExperienceLoadingScriptParent.UIBlox)
local UIBloxInGameConfig = require(ExperienceLoadingScriptParent.CoreScriptsInitializer).UIBloxInGameConfig

UIBlox.init(UIBloxInGameConfig)

local Constants = UIBlox.App.Style.Constants
local UiModeStyleProvider = require(ExperienceLoadingScriptParent.Style).UiModeStyleProvider
local Create = require(ExperienceLoadingScriptParent.AppCommonLib).Create
local LoadingScreen = require(ExperienceLoadingScript.LoadingScreen)
local LoadingScreenReducer = require(ExperienceLoadingScript.Reducers.LoadingScreenReducer)
local LoggingProtocol = require(ExperienceLoadingScriptParent.LoggingProtocol)

local function GenerateDevGUIBlackoutCurtain() -- line: 37
	-- upvalues: Create (copy), CoreGui (copy)
	local v23 = Create("ScreenGui")({
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
		Parent = v23
	})
	v23.Parent = CoreGui

	return v23
end

return function(p1, p2) -- line: 61
	-- upvalues: GenerateDevGUIBlackoutCurtain (copy), ExperienceLoadingScriptParent (copy), LoadingScreenReducer (copy), LoadingScreen (copy), UiModeStyleProvider (copy), Constants (copy), v13 (copy), CoreGui (copy), RunService (copy), waitProxy (copy), SplashScreenManager (copy), ExperienceLoadingScript (copy), Players (copy), game2 (copy), VRService (copy), IsVRAppBuild (copy), settingsProxy (copy), ReplicatedFirst (copy), LoggingProtocol (copy)
	local u26 = true
	local u27 = false
	local u28 = false
	local u29 = nil
	local u30 = nil
	local u31 = GenerateDevGUIBlackoutCurtain()
	local Roact = nil

	local function v33(n1: number) -- line: 124
		-- upvalues: u26 (ref), Roact (ref), waitProxy (copy), u30 (ref), SplashScreenManager (copy), u29 (ref), u31 (ref), ExperienceLoadingScript (copy)
		u26 = false

		if Roact then
			waitProxy(0.6)

			if u30 ~= nil then
				Roact.unmount(u30)
				u30 = nil
			end
		end

		SplashScreenManager.initialize(n1 / 2, game:GetFastInt("FPSAwareSplashScreenTimeout"), n1)
		SplashScreenManager.addStatusChangeListener(function(p3) -- line: 130
			-- upvalues: u26 (ref), u29 (ref)
			u26 = p3

			if u26 and u29 then
				u29()
			end
		end)
		u31.Enabled = true
		require(ExperienceLoadingScript.LoadingScreen3D).Parent = u31
	end
	local function v34() -- line: 156
		-- upvalues: game2 (copy), Players (copy), u27 (ref), u29 (ref)
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

			u27 = true

			if u29 then
				u29()

				return
			end
		else
			local u45 = nil

			u45 = game2.Loaded:Connect(function() -- line: 165
				-- upvalues: u45 (ref), Players (copy), u27 (ref), u29 (ref)
				u45:Disconnect()
				u45 = nil

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

				u27 = true

				if u29 then
					u29()
				end
			end)
		end
	end

	if VRService.VREnabled or IsVRAppBuild() then
		v33(p2)
	else
		VRService:GetPropertyChangedSignal("VREnabled"):Connect(function() -- line: 181
			-- upvalues: VRService (copy), v33 (copy), p2 (copy)
			if VRService.VREnabled then
				v33(p2)
			end
		end)
		u30 = (function(p4) -- line: 82
			-- upvalues: Roact (ref), ExperienceLoadingScriptParent (copy), LoadingScreenReducer (copy), LoadingScreen (copy), UiModeStyleProvider (copy), Constants (copy), v13 (copy), CoreGui (copy), RunService (copy), u31 (ref)
			Roact = require(ExperienceLoadingScriptParent.Roact)

			local Rodux = require(ExperienceLoadingScriptParent.Rodux)
			local RoactRodux = require(ExperienceLoadingScriptParent.RoactRodux)
			local v38 = Rodux.Store.new(LoadingScreenReducer, {}, { Rodux.thunkMiddleware })
			local v39 = Roact.createElement(LoadingScreen, {
				placeId = p4
			})
			local v40 = Roact.createElement(RoactRodux.StoreProvider, {
				store = v38
			}, { Roact.createElement(UiModeStyleProvider, {
				style = {
					themeName = Constants.ThemeName.Dark,
					fontName = Constants.FontName.Gotham
				}
			}, {
				loadingScreenUI = v39
			}) })

			if v13 then
				v40 = Roact.createElement("Folder", nil, v40)
			end

			local v41 = Roact.mount(v40, CoreGui, "RobloxLoadingGUI")

			RunService.Heartbeat:Wait()
			u31.Enabled = false

			return v41
		end)(p1)
	end

	function u29() -- line: 191
		-- upvalues: VRService (copy), u26 (ref), settingsProxy (copy), u31 (ref), ReplicatedFirst (copy), LoggingProtocol (copy), u27 (ref), u28 (ref), Roact (ref), waitProxy (copy), u30 (ref)
		if VRService.VREnabled then
			if u26 or settingsProxy().Rendering.QualityLevel ~= Enum.QualityLevel.Automatic then
				if u31 then
					u31.Enabled = false
					u31:Destroy()
					u31 = nil
				end

				ReplicatedFirst:SetDefaultLoadingGuiRemoved()
				LoggingProtocol.default:logEventOnce("first_experience_interactive")

				return
			end
		elseif u27 or u28 then
			if Roact then
				waitProxy(0.6)

				if u30 ~= nil then
					Roact.unmount(u30)
					u30 = nil
				end
			end

			if u31 then
				u31.Enabled = false
				u31:Destroy()
				u31 = nil
			end

			ReplicatedFirst:SetDefaultLoadingGuiRemoved()
			LoggingProtocol.default:logEventOnce("first_experience_interactive")
		end
	end

	ReplicatedFirst.FinishedReplicating:Connect(v34)

	if ReplicatedFirst:IsFinishedReplicating() then
		v34()
	end

	ReplicatedFirst.RemoveDefaultLoadingGuiSignal:Connect(function() -- line: 221
		-- upvalues: u28 (ref), u29 (ref)
		u28 = true

		if u29 then
			u29()
		end
	end)

	if ReplicatedFirst:IsDefaultLoadingGuiRemoved() then
		u28 = true

		if u29 then
			u29()
		end
	end
end
