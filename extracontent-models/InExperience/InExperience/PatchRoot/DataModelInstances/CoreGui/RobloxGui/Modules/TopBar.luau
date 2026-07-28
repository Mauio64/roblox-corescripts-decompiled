local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local IXPService = game:GetService("IXPService")
local LocalizationService = game:GetService("LocalizationService")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAddTopBarScrim = require(script.Flags.FFlagAddTopBarScrim)
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
local DesignTokenProvider = require(CorePackages.Workspace.Packages.Style).DesignTokenProvider
local CrossExperienceVoice = require(CorePackages.Workspace.Packages.CrossExperienceVoice)
local ReactSceneUnderstanding = require(CorePackages.Packages.ReactSceneUnderstanding)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy
local AppFeaturePolicies = UniversalAppPolicy.AppFeaturePolicies
local Constants = UIBlox.App.Style.Constants
local Display = require(CorePackages.Workspace.Packages.Display)
local UiModeStyleProvider = require(CorePackages.Workspace.Packages.Style).UiModeStyleProvider
local Songbird = require(CorePackages.Workspace.Packages.Songbird)
local VoiceStateContext = require(RobloxGui.Modules.VoiceChat.VoiceStateContext)
local Utility = require(RobloxGui.Modules.Settings.Utility)
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local isNewInGameMenuEnabled = require(RobloxGui.Modules.isNewInGameMenuEnabled)
local v30 = require(CorePackages.Workspace.Packages.Chrome).Enabled()
local Service = nil
local TopBarScrim = nil

if v30 then
	Service = require(RobloxGui.Modules.Chrome.Service)
	TopBarScrim = require(script.Components.TopBarScrim)
end

local Constants2 = require(script.Constants)
local MenuNavigationPromptTokenMapper = require(script.TokenMappers.MenuNavigationPromptTokenMapper)
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeSetCores = require(CorePackages.Workspace.Packages.InExperienceTopBar).Flags.FFlagTopBarSignalizeSetCores
local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon.Flags.FFlagTopBarSignalizeMenuOpen
local FFlagTopBarDeprecateGameInfoRodux = require(script.Flags.FFlagTopBarDeprecateGameInfoRodux)
local FFlagTopBarDeprecateGamepadNavigationDialogRodux = require(script.Flags.FFlagTopBarDeprecateGamepadNavigationDialogRodux)
local FFlagTopBarDeprecateChatRodux = require(script.Flags.FFlagTopBarDeprecateChatRodux)
local FFlagTopBarDeprecateDisplayOptionsRodux = require(script.Flags.FFlagTopBarDeprecateDisplayOptionsRodux)
local FFlagTopBarRefactor = require(CorePackages.Workspace.Packages.InExperienceTopBar).Flags.FFlagTopBarRefactor
local FFlagAddTopBarPoliciesToUniversalPolicies = SharedFlags.FFlagAddTopBarPoliciesToUniversalPolicies
local FFlagEnablePlaytestModeUnibar = SharedFlags.FFlagEnablePlaytestModeUnibar

if v30 then
	local function SetGlobalGuiInset() -- line: 64
		-- upvalues: GuiService (copy), Constants2 (copy), Display (copy)
		local v71, v72 = GuiService:GetGuiInset()

		GuiService:SetGlobalGuiInset(v71.X, Constants2.ApplyDisplayScale(Constants2.TopBarHeight), v72.X, v72.Y)
		Display.GetDisplayStore().setGuiInset({
			left = v71.X,
			top = Constants2.ApplyDisplayScale(Constants2.TopBarHeight),
			right = v72.X,
			bottom = v72.Y
		})
	end

	SetGlobalGuiInset()
end

local v46 = if not FFlagTopBarRefactor then require(script.Components.TopBarApp) else require(script.ComponentsV2.TopBarApp)
local Reducer = require(script.Reducer)
local TopBarAppPolicy = require(script.TopBarAppPolicy)
local SetSmallTouchDevice = require(script.Actions.SetSmallTouchDevice)
local SetInspectMenuOpen = require(script.Actions.SetInspectMenuOpen)
local SetGamepadMenuOpen = require(script.Actions.SetGamepadMenuOpen)
local SetGamepadNavigationDialogOpen = require(script.Actions.SetGamepadNavigationDialogOpen)
local UpdateUnreadMessagesBadge = require(script.Actions.UpdateUnreadMessagesBadge)
local GetCanChat = require(script.Thunks.GetCanChat)
local GetGameName = require(script.Thunks.GetGameName)
local registerSetCores = require(script.registerSetCores)
local GlobalConfig = require(script.GlobalConfig)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local FFlagAddMenuNavigationToggleDialog = SharedFlags.FFlagAddMenuNavigationToggleDialog
local FFlagGamepadNavigationDialogABTest = require(script.Flags.FFlagGamepadNavigationDialogABTest)
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local Component = CrossExperienceVoice.Component
local FTUX = RobloxGui.Modules.FTUX
local GetFFlagEnableVRFTUXExperience = require(FTUX.Flags.GetFFlagEnableVRFTUXExperience)
local GetFFlagDebugEnableVRFTUXExperienceInStudio = require(FTUX.Flags.GetFFlagDebugEnableVRFTUXExperienceInStudio)
local PlatformEnum = require(FTUX.Enums.PlatformEnum)
local IsFTUXExperience = require(FTUX.Utility.IsFTUXExperience)
local FTUX2 = require(script.Parent.FTUX)
local isRunningInStudio = require(CorePackages.Workspace.Packages.AppCommonLib).isRunningInStudio
local t1 = {}

t1.__index = t1

function t1.new() -- line: 120
	-- upvalues: t1 (copy), GlobalConfig (copy), Roact (copy), TenFootInterface (copy), v30 (copy), GuiService (copy), Constants2 (copy), FFlagEnablePlaytestModeUnibar (copy), Rodux (copy), Reducer (copy), FFlagTopBarSignalizeSetCores (copy), registerSetCores (copy), FFlagTopBarDeprecateChatRodux (copy), GetCanChat (copy), FFlagTopBarDeprecateGameInfoRodux (copy), GetGameName (copy), GetFFlagDebugEnableVRFTUXExperienceInStudio (copy), isRunningInStudio (copy), FTUX2 (copy), PlatformEnum (copy), GetFFlagEnableVRFTUXExperience (copy), IsFTUXExperience (copy), isNewInGameMenuEnabled (copy), RobloxGui (copy), FFlagTopBarDeprecateDisplayOptionsRodux (copy), SetSmallTouchDevice (copy), Utility (copy), Constants (copy), UiModeStyleProvider (copy), v46 (copy), FFlagAddMenuNavigationToggleDialog (copy), FFlagGamepadNavigationDialogABTest (copy), DesignTokenProvider (copy), MenuNavigationPromptTokenMapper (copy), Service (ref), FFlagAddTopBarScrim (copy), React (copy), TopBarScrim (ref), RoactRodux (copy), FFlagTopBarRefactor (copy), FFlagAddTopBarPoliciesToUniversalPolicies (copy), RoactAppPolicy (copy), TopBarAppPolicy (copy), AppFeaturePolicies (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), RoactAppExperiment (copy), IXPService (copy), GetFFlagEnableCrossExpVoice (copy), Component (copy), ReactSceneUnderstanding (copy), Songbird (copy), VoiceStateContext (copy), CoreGui (copy), UpdateUnreadMessagesBadge (copy), FFlagTopBarDeprecateGamepadNavigationDialogRodux (copy)
	local self = setmetatable({}, t1)

	if GlobalConfig.propValidation then
		Roact.setGlobalConfig({
			propValidation = true
		})
	end

	if GlobalConfig.elementTracing then
		Roact.setGlobalConfig({
			elementTracing = true
		})
	end

	if not TenFootInterface:IsEnabled() and not v30 then
		GuiService:SetGlobalGuiInset(0, Constants2.TopBarHeight, 0, 0)
	end

	if FFlagEnablePlaytestModeUnibar then
		require(script.initPlaytestMode)()
	end

	self.store = Rodux.Store.new(Reducer, nil, { Rodux.thunkMiddleware })

	if not FFlagTopBarSignalizeSetCores then
		registerSetCores(self.store)
	end

	if not FFlagTopBarDeprecateChatRodux then
		self.store:dispatch(GetCanChat)
	end

	if not FFlagTopBarDeprecateGameInfoRodux then
		self.store:dispatch(GetGameName)
	end

	if GetFFlagDebugEnableVRFTUXExperienceInStudio() and isRunningInStudio() then
		FTUX2.mountFtuxMenu(PlatformEnum.QuestVR)
	end

	if GetFFlagEnableVRFTUXExperience() and IsFTUXExperience(PlatformEnum.QuestVR) then
		FTUX2.mountFtuxMenu(PlatformEnum.QuestVR)
	end

	if isNewInGameMenuEnabled() then
		require(RobloxGui.Modules.InGameMenuInit).mountInGameMenu()
	end

	if not FFlagTopBarDeprecateDisplayOptionsRodux then
		coroutine.wrap(function() -- line: 177
			-- upvalues: self (copy), SetSmallTouchDevice (copy), Utility (copy)
			self.store:dispatch(SetSmallTouchDevice(Utility:IsSmallTouchScreen()))
		end)()
	end

	local t2 = {
		themeName = Constants.ThemeName.Dark,
		fontName = Constants.FontName.Gotham
	}

	local function wrapWithUiModeStyleProvider(p1) -- line: 187
		-- upvalues: Roact (copy), UiModeStyleProvider (copy), t2 (copy)
		return {
			UiModeStyleProvider = Roact.createElement(UiModeStyleProvider, {
				style = t2
			}, p1)
		}
	end

	local v76 = Roact.createElement(v46)

	if FFlagAddMenuNavigationToggleDialog or FFlagGamepadNavigationDialogABTest then
		v76 = Roact.createElement(DesignTokenProvider, {
			tokenMappers = {
				MenuNavigationPrompt = if not FFlagGamepadNavigationDialogABTest then nil else MenuNavigationPromptTokenMapper
			}
		}, {
			TopBarApp = v76
		})
	end

	local v77 = Service and (FFlagAddTopBarScrim and React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		DisplayOrder = -2,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		TopBarScrim = React.createElement(TopBarScrim)
	}))

	self.root = Roact.createElement(RoactRodux.StoreProvider, {
		store = self.store
	}, {
		PolicyProvider = Roact.createElement(if not FFlagTopBarRefactor or not FFlagAddTopBarPoliciesToUniversalPolicies then TopBarAppPolicy.Provider else RoactAppPolicy.Provider, {
			policy = if not FFlagTopBarRefactor or not FFlagAddTopBarPoliciesToUniversalPolicies then { TopBarAppPolicy.Mapper } else { AppFeaturePolicies }
		}, (wrapWithUiModeStyleProvider({
			LocalizationProvider = Roact.createElement(LocalizationProvider, {
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			}, {
				ExperimentProvider = Roact.createFragment({
					RoactAppExperimentProvider = Roact.createElement(RoactAppExperiment.Provider, {
						value = IXPService
					}, {
						TopBarApp = v76,
						TopBarScrim = v77
					}),
					CrossExperienceVoice = GetFFlagEnableCrossExpVoice() and Roact.createElement(Component) or nil
				})
			})
		})))
	})
	self.root = Roact.createElement(ReactSceneUnderstanding.SceneAnalysisProvider, nil, self.root)
	self.root = Roact.createElement(Songbird.ReportAudioPopupContext.Provider, nil, self.root)
	self.root = Roact.createElement(VoiceStateContext.Provider, nil, self.root)
	self.root = Roact.createElement("Folder", {
		Name = "TopBarApp"
	}, self.root)
	self.element = Roact.mount(self.root, CoreGui, "TopBar")

	if not FFlagTopBarDeprecateChatRodux then
		game:GetService("TextChatService").MessageReceived:Connect(function() -- line: 268
			-- upvalues: self (copy), UpdateUnreadMessagesBadge (copy)
			self.store:dispatch(UpdateUnreadMessagesBadge(1))
		end)
	end

	if FFlagGamepadNavigationDialogABTest and not FFlagTopBarDeprecateGamepadNavigationDialogRodux then
		local UserInputService = game:GetService("UserInputService")
		local u79 = nil

		local function disconnectGamepadConnected() -- line: 276
			-- upvalues: u79 (ref)
			if u79 then
				u79:Disconnect()
				u79 = nil
			end
		end

		if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
			self:setGamepadNavigationDialogOpen(true)
		else
			u79 = UserInputService.GamepadConnected:Connect(function() -- line: 285
				-- upvalues: self (copy), u79 (ref)
				self:setGamepadNavigationDialogOpen(true)

				if u79 then
					u79:Disconnect()
					u79 = nil
				end
			end)
		end

		GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(disconnectGamepadConnected)
	end

	return self
end
function t1.setInspectMenuOpen(p2, p3) -- line: 297
	-- upvalues: FFlagTopBarSignalizeMenuOpen (copy), SetInspectMenuOpen (copy)
	if FFlagTopBarSignalizeMenuOpen then
		return
	end

	p2.store:dispatch(SetInspectMenuOpen(p3))
end
function t1.setGamepadMenuOpen(p4, p5) -- line: 304
	-- upvalues: SetGamepadMenuOpen (copy)
	p4.store:dispatch(SetGamepadMenuOpen(p5))
end
function t1.setGamepadNavigationDialogOpen(p6, p7) -- line: 308
	-- upvalues: FFlagTopBarDeprecateDisplayOptionsRodux (copy), SetGamepadNavigationDialogOpen (copy)
	if not FFlagTopBarDeprecateDisplayOptionsRodux then
		p6.store:dispatch(SetGamepadNavigationDialogOpen(p7))
	end
end

return t1.new()
