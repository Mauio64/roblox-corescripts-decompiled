local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local IXPService = game:GetService("IXPService")
local LocalizationService = game:GetService("LocalizationService")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagBuildExperienceInGameShell = SharedFlags.FFlagBuildExperienceInGameShell
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local shouldSkipHistoricalMessage = ExpChat.shouldSkipHistoricalMessage

local FFlagAddTopBarScrim = require(script.Flags.FFlagAddTopBarScrim)

local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local Style = require(CorePackages.Workspace.Packages.Style)
local DesignTokenProvider = Style.DesignTokenProvider
local CrossExperienceVoice = require(CorePackages.Workspace.Packages.CrossExperienceVoice)
local ReactSceneUnderstanding = require(CorePackages.Packages.ReactSceneUnderstanding)

local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Signals

if FFlagBuildExperienceInGameShell then
	Signals = require(CorePackages.Packages.Signals)
end

local UIBlox = require(CorePackages.Packages.UIBlox)

local Foundation = require(CorePackages.Packages.Foundation)
local ColorMode = Foundation.Enums.ColorMode

local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy
local AppFeaturePolicies = UniversalAppPolicy.AppFeaturePolicies

local Constants = UIBlox.App.Style.Constants
local Display = require(CorePackages.Workspace.Packages.Display)
local Style2 = require(CorePackages.Workspace.Packages.Style)
local UiModeStyleProvider = Style2.UiModeStyleProvider
local VoiceStateContext = require(RobloxGui.Modules.VoiceChat.VoiceStateContext)

local Utility = require(RobloxGui.Modules.Settings.Utility)
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local isNewInGameMenuEnabled = require(RobloxGui.Modules.isNewInGameMenuEnabled)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local enabled = Chrome.Enabled()
local Service, TopBarScrim

if enabled then
	Service = require(RobloxGui.Modules.Chrome.Service)
	TopBarScrim = require(script.Components.TopBarScrim)
else
	Service = nil
	TopBarScrim = nil
end

local Constants2 = require(script.Constants)
local MenuNavigationPromptTokenMapper = require(script.TokenMappers.MenuNavigationPromptTokenMapper)

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local InExperienceTopBar = require(CorePackages.Workspace.Packages.InExperienceTopBar)
local FFlagTopBarSignalizeSetCores = InExperienceTopBar.Flags.FFlagTopBarSignalizeSetCores
local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon.Flags.FFlagTopBarSignalizeMenuOpen
local FFlagTopBarDeprecateGameInfoRodux = require(script.Flags.FFlagTopBarDeprecateGameInfoRodux)

local FFlagTopBarDeprecateGamepadNavigationDialogRodux = require(script.Flags.FFlagTopBarDeprecateGamepadNavigationDialogRodux)

local CoreScriptsErrorBoundary = require(CorePackages.Workspace.Packages.CoreScriptsErrorBoundary)
local coreScriptsErrorBoundary = CoreScriptsErrorBoundary.CoreScriptsErrorBoundary
local Surfaces = CoreScriptsErrorBoundary.Surfaces

local FFlagCoreScriptsReactTreeCrashCounter = CoreScriptsErrorBoundary.Flags.FFlagCoreScriptsReactTreeCrashCounter

local FFlagTopBarDeprecateChatRodux = require(script.Flags.FFlagTopBarDeprecateChatRodux)
local FFlagTopBarDeprecateDisplayOptionsRodux = require(script.Flags.FFlagTopBarDeprecateDisplayOptionsRodux)
local InExperienceTopBar2 = require(CorePackages.Workspace.Packages.InExperienceTopBar)
local FFlagTopBarRefactor = InExperienceTopBar2.Flags.FFlagTopBarRefactor
local FFlagEnablePlaytestModeUnibar = SharedFlags.FFlagEnablePlaytestModeUnibar

local disposeGlobalGuiInsetEffect = nil

if enabled then
	if FFlagBuildExperienceInGameShell then
		local displayStore = Display.GetDisplayStore(false)
		displayStore.setGuiInset(function(data)
			return {
				left = data.left,
				top = Constants2.ApplyDisplayScale(Constants2.TopBarHeight),
				right = data.right,
				bottom = data.bottom
			}
		end)

		disposeGlobalGuiInsetEffect = Signals.createEffect(function(p)
			local guiInset = displayStore.getGuiInset(p)
			GuiService:SetGlobalGuiInset(guiInset.left, guiInset.top, guiInset.right, guiInset.bottom)
		end)
	else
		local function SetGlobalGuiInset()
			local guiInset, v = GuiService:GetGuiInset()
			GuiService:SetGlobalGuiInset(guiInset.X, Constants2.ApplyDisplayScale(Constants2.TopBarHeight), v.X, v.Y)

			Display.GetDisplayStore().setGuiInset({
				left = guiInset.X,
				top = Constants2.ApplyDisplayScale(Constants2.TopBarHeight),
				right = v.X,
				bottom = v.Y
			})
		end
		SetGlobalGuiInset()
	end
end

local TopBarApp

if FFlagTopBarRefactor then
	TopBarApp = require(script.ComponentsV2.TopBarApp)
else
	TopBarApp = require(script.Components.TopBarApp)
end

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
local FFlagShowGameAgeRating = SharedFlags.FFlagShowGameAgeRating
local FFlagGamepadNavigationDialogABTest = require(script.Flags.FFlagGamepadNavigationDialogABTest)

local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local Component = CrossExperienceVoice.Component

local ftux = RobloxGui.Modules.FTUX
local GetFFlagEnableVRFTUXExperience = require(ftux.Flags.GetFFlagEnableVRFTUXExperience)
local GetFFlagDebugEnableVRFTUXExperienceInStudio = require(ftux.Flags.GetFFlagDebugEnableVRFTUXExperienceInStudio)
local PlatformEnum = require(ftux.Enums.PlatformEnum)
local IsFTUXExperience = require(ftux.Utility.IsFTUXExperience)
local FTUX = require(script.Parent.FTUX)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isRunningInStudio = AppCommonLib.isRunningInStudio
local AppCommonLib2 = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib2.isSpatial
local AppCommonLib3 = require(CorePackages.Workspace.Packages.AppCommonLib)
local connectToIsSpatialChanged = AppCommonLib3.connectToIsSpatialChanged
local FFlagStudioDeviceSimVRSwitchFixes = SharedFlags.FFlagStudioDeviceSimVRSwitchFixes

local function SpatialRemountGate()
	local state, setState = React.useState(isSpatial())
	React.useEffect(function()
		local connection = connectToIsSpatialChanged(setState, true)
		return function()
			connection:Disconnect()
		end
	end, {})

	return React.createElement(React.Fragment, {
		key = state and "spatial" or "flat"
	}, { TopBarApp = React.createElement(TopBarApp) })
end

local class = {}
class.__index = class

if FFlagBuildExperienceInGameShell then
	class._disposeGlobalGuiInsetEffect = disposeGlobalGuiInsetEffect
end

function class.new()
	local object = setmetatable({}, class)

	if GlobalConfig.propValidation then
		Roact.setGlobalConfig({ propValidation = true })
	end

	if GlobalConfig.elementTracing then
		Roact.setGlobalConfig({ elementTracing = true })
	end

	if not (TenFootInterface:IsEnabled() or enabled) then
		GuiService:SetGlobalGuiInset(0, Constants2.TopBarHeight, 0, 0)
	end

	if FFlagEnablePlaytestModeUnibar then
		local initPlaytestMode = require(script.initPlaytestMode)
		initPlaytestMode()
	end

	object.store = Rodux.Store.new(Reducer, nil, { Rodux.thunkMiddleware })

	if not FFlagTopBarSignalizeSetCores then
		registerSetCores(object.store)
	end

	if not FFlagTopBarDeprecateChatRodux then
		object.store:dispatch(GetCanChat)
	end

	if not FFlagTopBarDeprecateGameInfoRodux then
		object.store:dispatch(GetGameName)
	end

	if GetFFlagDebugEnableVRFTUXExperienceInStudio() and isRunningInStudio() then
		FTUX.mountFtuxMenu(PlatformEnum.QuestVR)
	end

	if GetFFlagEnableVRFTUXExperience() and IsFTUXExperience(PlatformEnum.QuestVR) then
		FTUX.mountFtuxMenu(PlatformEnum.QuestVR)
	end

	if isNewInGameMenuEnabled() then
		local InGameMenuInit = require(RobloxGui.Modules.InGameMenuInit)
		InGameMenuInit.mountInGameMenu()
	end

	if not FFlagTopBarDeprecateDisplayOptionsRodux then
		coroutine.wrap(function()
			object.store:dispatch(SetSmallTouchDevice(Utility:IsSmallTouchScreen()))
		end)()
	end

	local style = { themeName = ColorMode.Dark, fontName = Constants.FontName.Gotham }

	local function wrapWithUiModeStyleProvider(p)
		return {
			UiModeStyleProvider = Roact.createElement(UiModeStyleProvider, { style = style }, p)
		}
	end

	local topBarApp

	if FFlagStudioDeviceSimVRSwitchFixes then
		topBarApp = Roact.createElement(SpatialRemountGate)
	else
		topBarApp = Roact.createElement(TopBarApp)
	end

	if FFlagAddMenuNavigationToggleDialog or FFlagGamepadNavigationDialogABTest then
		local createElement = Roact.createElement
		local menuNavigationPrompt

		if FFlagGamepadNavigationDialogABTest then
			menuNavigationPrompt = MenuNavigationPromptTokenMapper
		end

		topBarApp = createElement(DesignTokenProvider, {
			tokenMappers = { MenuNavigationPrompt = menuNavigationPrompt }
		}, { TopBarApp = topBarApp })
	end

	local topBarScrim = Service
		and FFlagAddTopBarScrim
		and React.createElement(
			"ScreenGui",
			{
				IgnoreGuiInset = true,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = -2
			},
			{
				TopBarScrim = React.createElement(TopBarScrim)
			}
		)

	local createElement = Roact.createElement
	local storeProvider = RoactRodux.StoreProvider
	local v = { store = object.store }

	local createElement2 = Roact.createElement
	local provider

	if FFlagTopBarRefactor or FFlagShowGameAgeRating then
		provider = RoactAppPolicy.Provider
	else
		provider = TopBarAppPolicy.Provider
	end

	local policy

	if FFlagTopBarRefactor or FFlagShowGameAgeRating then
		policy = { AppFeaturePolicies }
	else
		policy = { TopBarAppPolicy.Mapper }
	end

	object.root = createElement(storeProvider, v, {
		PolicyProvider = createElement2(provider, { policy = policy }, wrapWithUiModeStyleProvider({
			LocalizationProvider = Roact.createElement(
				LocalizationProvider,
				{
					localization = Localization.new(LocalizationService.RobloxLocaleId)
				},
				{
					ExperimentProvider = Roact.createFragment({
						RoactAppExperimentProvider = Roact.createElement(
							RoactAppExperiment.Provider,
							{ value = IXPService },
							{ TopBarApp = topBarApp, TopBarScrim = topBarScrim }
						),
						CrossExperienceVoice = GetFFlagEnableCrossExpVoice() and Roact.createElement(Component) or nil
					})
				}
			)
		}))
	})

	object.root = Roact.createElement(ReactSceneUnderstanding.SceneAnalysisProvider, nil, object.root)

	object.root = Roact.createElement(VoiceStateContext.Provider, nil, object.root)

	object.root = Roact.createElement("Folder", { Name = "TopBarApp" }, object.root)

	if FFlagCoreScriptsReactTreeCrashCounter then
		object.root = Roact.createElement(coreScriptsErrorBoundary, { surface = Surfaces.TopBar }, object.root)
	end

	local teamCreateUtils = require(CorePackages.Workspace.Packages.BuildExperiencePlaytestLaunch.teamCreateUtils)

	if not teamCreateUtils.isViewer() then
		object.element = Roact.mount(object.root, CoreGui, "TopBar")
	end

	if not FFlagTopBarDeprecateChatRodux then
		local TextChatService = game:GetService("TextChatService")
		TextChatService.MessageReceived:Connect(function(p)
			if shouldSkipHistoricalMessage(p) then
				return
			end

			object.store:dispatch(UpdateUnreadMessagesBadge(1))
		end)
	end

	if FFlagGamepadNavigationDialogABTest and not FFlagTopBarDeprecateGamepadNavigationDialogRodux then
		local UserInputService = game:GetService("UserInputService")
		local gamepadConnectedConnection = nil
		local function disconnectGamepadConnected() -- 1 equivalent call inferred from this helper
			if gamepadConnectedConnection then
				gamepadConnectedConnection:Disconnect()
				gamepadConnectedConnection = nil
			end
		end

		if UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) then
			object:setGamepadNavigationDialogOpen(true)
		else
			gamepadConnectedConnection = UserInputService.GamepadConnected:Connect(function()
				object:setGamepadNavigationDialogOpen(true)
				disconnectGamepadConnected() -- inferred equivalent call
			end)
		end

		GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(disconnectGamepadConnected)
	end

	return object
end

function class.setInspectMenuOpen(p, p2)
	if FFlagTopBarSignalizeMenuOpen then
		return
	end

	p.store:dispatch(SetInspectMenuOpen(p2))
end

function class.setGamepadMenuOpen(p, p2)
	p.store:dispatch(SetGamepadMenuOpen(p2))
end

function class:setGamepadNavigationDialogOpen(p)
	if not FFlagTopBarDeprecateDisplayOptionsRodux then
		self.store:dispatch(SetGamepadNavigationDialogOpen(p))
	end
end

return class.new()
