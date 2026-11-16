local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local GuiService = game:GetService("GuiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = InGameMenuDependencies.UIBlox

local InteractionFeedback = require(CorePackages.Workspace.Packages.InteractionFeedback)
local FeedbackManagerInjectionContextProvider = InteractionFeedback.FeedbackManagerInjectionContextProvider

local RobloxAppInteractionFeedbackConfig = require(CorePackages.Workspace.Packages.RobloxAppInteractionFeedbackConfig)
local AppInteractionFeedbackProvider = RobloxAppInteractionFeedbackConfig.AppInteractionFeedbackProvider

local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(CorePackages.Workspace.Packages.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider

local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)

local bindMenuActions = require(script.SetupFunctions.bindMenuActions)
local registerSetCores = require(script.SetupFunctions.registerSetCores)
local requestGameNameAndDescription = require(script.SetupFunctions.requestGameNameAndDescription)
local createStore = require(script.createStore)

local App = require(script.Components.App)
local FocusHandlerContextProvider = require(script.Components.Connection.FocusHandlerUtils.FocusHandlerContextProvider)
local initVoiceChatStore = require(RobloxGui.Modules.VoiceChat.initVoiceChatStore)
local TrustAndSafety = require(RobloxGui.Modules.TrustAndSafety)

local SetLocaleId = require(script.Actions.SetLocaleId)
local SetInspectMenuEnabled = require(script.Actions.SetInspectMenuEnabled)
local SetCurrentPage = require(script.Actions.SetCurrentPage)
local SetScreenSize = require(script.Actions.SetScreenSize)
local SetMenuIconTooltipOpen = require(script.Actions.SetMenuIconTooltipOpen)
local SetRespawning = require(script.Actions.SetRespawning)
local OpenMenu = require(script.Thunks.OpenMenu)
local CloseMenu = require(script.Thunks.CloseMenu)
local InGameMenuPolicy = require(script.InGameMenuPolicy)

local GlobalConfig = require(script.GlobalConfig)
local Constants = require(script.Resources.Constants)

local GetFFlagIGMGamepadSelectionHistory = require(script.Flags.GetFFlagIGMGamepadSelectionHistory)

local bindableEvent = Instance.new("BindableEvent")
local bindableEvent2 = Instance.new("BindableEvent")

local store = createStore()
local InGameMenu = {}

function InGameMenu.mountInGameMenu()
	registerSetCores(store)
	bindMenuActions(store)
	requestGameNameAndDescription(store)

	if GlobalConfig.propValidation then
		Roact.setGlobalConfig({ propValidation = true })
	end

	if GlobalConfig.elementTracing then
		Roact.setGlobalConfig({ elementTracing = true })
	end

	store.changed:connect(function(p, p2)
		if p.isMenuOpen ~= p2.isMenuOpen then
			bindableEvent:Fire(p.isMenuOpen)
		end

		local enabled = p.respawn.enabled
		local enabled2 = p2.respawn.enabled

		local customCallback = p.respawn.customCallback
		local customCallback2 = p2.respawn.customCallback

		if enabled ~= enabled2 and customCallback ~= customCallback2 then
			bindableEvent2:Fire(enabled, customCallback)
		end
	end)

	local localization = Localization.new(LocalizationService.RobloxLocaleId)
	store:dispatch(SetLocaleId(LocalizationService.RobloxLocaleId))
	LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(function()
		localization:SetLocale(LocalizationService.RobloxLocaleId)
		store:dispatch(SetLocaleId(LocalizationService.RobloxLocaleId))
	end)

	store:dispatch(SetInspectMenuEnabled(GuiService:GetInspectMenuEnabled()))
	GuiService.InspectMenuEnabledChangedSignal:Connect(function(p)
		store:dispatch(SetInspectMenuEnabled(p))
	end)

	initVoiceChatStore(store)

	local createElement = Roact.createElement

	local createElement2 = Roact.createElement
	local v = {
		FocusHandlerContextProvider = GetFFlagIGMGamepadSelectionHistory() and Roact.createElement(FocusHandlerContextProvider, {}, {
			InGameMenu = Roact.createElement(App)
		}) or nil,
		InGameMenu = 0
	}
	local inGameMenu

	if not GetFFlagIGMGamepadSelectionHistory() then
		inGameMenu = Roact.createElement(App) or nil
	end

	v.InGameMenu = inGameMenu
	local tree = renderWithCoreScriptsStyleProvider({
		LocalizationProvider = createElement(LocalizationProvider, { localization = localization }, {
			CursorProvider = createElement2(SelectionCursorProvider, {}, v)
		})
	})

	local element = Roact.createElement(AppInteractionFeedbackProvider, {}, {
		tree = Roact.createElement(FeedbackManagerInjectionContextProvider, nil, { tree = tree })
	})

	local element2 = Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = Constants.DisplayOrder.RootMenu,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		AutoLocalize = false,
		[Roact.Change.AbsoluteSize] = function(p)
			store:dispatch(SetScreenSize(p.AbsoluteSize))
		end
	}, {
		StoreProvider = Roact.createElement(RoactRodux.StoreProvider, { store = store }, {
			PolicyProvider = Roact.createElement(InGameMenuPolicy.Provider, {
				policy = { InGameMenuPolicy.Mapper }
			}, { ThemeProvider = element })
		})
	})

	Roact.mount(element2, CoreGui, "InGameMenu")
end

function InGameMenu.openInGameMenu(p)
	store:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.TopbarButton, p))
end

function InGameMenu.closeInGameMenu()
	CloseMenu(store)
end

function InGameMenu.openReportDialog(p, p2)
	store:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.ReportAbuseTriggered, Constants.ReportDialogKey))

	if p2 == nil then
		p2 = Constants.AnalyticsInGameMenuName
	end

	TrustAndSafety.openReportDialogForPlayer(p, p2)
end

function InGameMenu.openGameSettingsPage()
	store:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.SettingsTriggered))
	store:dispatch(SetCurrentPage("GameSettings"))
end

function InGameMenu.openGameLeavePage()
	store:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.GamepadLeaveGame))
	store:dispatch(SetCurrentPage(Constants.LeaveGamePromptPageKey))
end

function InGameMenu.openCharacterResetPage()
	store:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.GamepadResetCharacter))
	store:dispatch(SetCurrentPage(Constants.MainPagePageKey))
	store:dispatch(SetRespawning(true))
end

function InGameMenu.openPlayersPage()
	store:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.PlayersTriggered))
	store:dispatch(SetCurrentPage("Players"))
end

function InGameMenu.getOpenChangedEvent()
	return bindableEvent
end

function InGameMenu.getOpen()
	return store:getState().isMenuOpen
end

function InGameMenu.getRespawnBehaviour()
	local state = store:getState()
	return state.respawn.enabled, state.respawn.customCallback
end

function InGameMenu.getRespawnBehaviourChangedEvent()
	return bindableEvent2
end

function InGameMenu.setMenuIconTooltipOpen(p)
	store:dispatch(SetMenuIconTooltipOpen(p))
end

return InGameMenu
