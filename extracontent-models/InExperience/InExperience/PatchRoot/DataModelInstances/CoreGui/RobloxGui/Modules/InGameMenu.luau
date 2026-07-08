local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local GuiService = game:GetService("GuiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local UIBlox = InGameMenuDependencies.UIBlox
local FeedbackManagerInjectionContextProvider = require(CorePackages.Workspace.Packages.InteractionFeedback).FeedbackManagerInjectionContextProvider
local AppInteractionFeedbackProvider = require(CorePackages.Workspace.Packages.RobloxAppInteractionFeedbackConfig).AppInteractionFeedbackProvider
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
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
local BindableEvent = Instance.new("BindableEvent")
local BindableEvent2 = Instance.new("BindableEvent")
local v38 = createStore()

return {
	mountInGameMenu = function() -- line: 56
		-- upvalues: registerSetCores (copy), v38 (copy), bindMenuActions (copy), requestGameNameAndDescription (copy), GlobalConfig (copy), Roact (copy), BindableEvent (copy), BindableEvent2 (copy), Localization (copy), LocalizationService (copy), SetLocaleId (copy), SetInspectMenuEnabled (copy), GuiService (copy), initVoiceChatStore (copy), renderWithCoreScriptsStyleProvider (copy), LocalizationProvider (copy), SelectionCursorProvider (copy), GetFFlagIGMGamepadSelectionHistory (copy), FocusHandlerContextProvider (copy), App (copy), AppInteractionFeedbackProvider (copy), FeedbackManagerInjectionContextProvider (copy), Constants (copy), SetScreenSize (copy), RoactRodux (copy), InGameMenuPolicy (copy), CoreGui (copy)
		registerSetCores(v38)
		bindMenuActions(v38)
		requestGameNameAndDescription(v38)

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

		v38.changed:connect(function(p1, p2) -- line: 72
			-- upvalues: BindableEvent (copy), BindableEvent2 (copy)
			if p1.isMenuOpen ~= p2.isMenuOpen then
				BindableEvent:Fire(p1.isMenuOpen)
			end

			local enabled = p1.respawn.enabled
			local enabled2 = p2.respawn.enabled
			local customCallback = p1.respawn.customCallback
			local customCallback2 = p2.respawn.customCallback

			if enabled ~= enabled2 and customCallback ~= customCallback2 then
				BindableEvent2:Fire(enabled, customCallback)
			end
		end)

		local v39 = Localization.new(LocalizationService.RobloxLocaleId)

		v38:dispatch(SetLocaleId(LocalizationService.RobloxLocaleId))
		LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(function() -- line: 90
			-- upvalues: v39 (copy), LocalizationService (copy), v38 (copy), SetLocaleId (copy)
			v39:SetLocale(LocalizationService.RobloxLocaleId)
			v38:dispatch(SetLocaleId(LocalizationService.RobloxLocaleId))
		end)
		v38:dispatch(SetInspectMenuEnabled(GuiService:GetInspectMenuEnabled()))
		GuiService.InspectMenuEnabledChangedSignal:Connect(function(p3) -- line: 96
			-- upvalues: v38 (copy), SetInspectMenuEnabled (copy)
			v38:dispatch(SetInspectMenuEnabled(p3))
		end)
		initVoiceChatStore(v38)

		local v40 = renderWithCoreScriptsStyleProvider({
			LocalizationProvider = Roact.createElement(LocalizationProvider, {
				localization = v39
			}, {
				CursorProvider = Roact.createElement(SelectionCursorProvider, {}, {
					FocusHandlerContextProvider = GetFFlagIGMGamepadSelectionHistory() and Roact.createElement(FocusHandlerContextProvider, {}, {
						InGameMenu = Roact.createElement(App)
					}) or nil,
					InGameMenu = not GetFFlagIGMGamepadSelectionHistory() and Roact.createElement(App) or nil
				})
			})
		})
		local v41 = Roact.createElement(AppInteractionFeedbackProvider, {}, {
			tree = Roact.createElement(FeedbackManagerInjectionContextProvider, nil, {
				tree = v40
			})
		})
		local v42 = Roact.createElement("ScreenGui", {
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			DisplayOrder = Constants.DisplayOrder.RootMenu,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			AutoLocalize = false,
			[Roact.Change.AbsoluteSize] = function(p4) -- line: 128
				-- upvalues: v38 (copy), SetScreenSize (copy)
				v38:dispatch(SetScreenSize(p4.AbsoluteSize))
			end
		}, {
			StoreProvider = Roact.createElement(RoactRodux.StoreProvider, {
				store = v38
			}, {
				PolicyProvider = Roact.createElement(InGameMenuPolicy.Provider, {
					policy = { InGameMenuPolicy.Mapper }
				}, {
					ThemeProvider = v41
				})
			})
		})

		Roact.mount(v42, CoreGui, "InGameMenu")
	end,
	openInGameMenu = function(p5) -- line: 145
		-- upvalues: v38 (copy), OpenMenu (copy), Constants (copy)
		v38:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.TopbarButton, p5))
	end,
	closeInGameMenu = function() -- line: 149
		-- upvalues: CloseMenu (copy), v38 (copy)
		CloseMenu(v38)
	end,
	openReportDialog = function(p6, p7) -- line: 153
		-- upvalues: v38 (copy), OpenMenu (copy), Constants (copy), TrustAndSafety (copy)
		v38:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.ReportAbuseTriggered, Constants.ReportDialogKey))

		local v46 = if p7 == nil then Constants.AnalyticsInGameMenuName else p7

		TrustAndSafety.openReportDialogForPlayer(p6, v46)
	end,
	openGameSettingsPage = function() -- line: 159
		-- upvalues: v38 (copy), OpenMenu (copy), Constants (copy), SetCurrentPage (copy)
		v38:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.SettingsTriggered))
		v38:dispatch(SetCurrentPage("GameSettings"))
	end,
	openGameLeavePage = function() -- line: 164
		-- upvalues: v38 (copy), OpenMenu (copy), Constants (copy), SetCurrentPage (copy)
		v38:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.GamepadLeaveGame))
		v38:dispatch(SetCurrentPage(Constants.LeaveGamePromptPageKey))
	end,
	openCharacterResetPage = function() -- line: 169
		-- upvalues: v38 (copy), OpenMenu (copy), Constants (copy), SetCurrentPage (copy), SetRespawning (copy)
		v38:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.GamepadResetCharacter))
		v38:dispatch(SetCurrentPage(Constants.MainPagePageKey))
		v38:dispatch(SetRespawning(true))
	end,
	openPlayersPage = function() -- line: 175
		-- upvalues: v38 (copy), OpenMenu (copy), Constants (copy), SetCurrentPage (copy)
		v38:dispatch(OpenMenu(Constants.AnalyticsMenuOpenTypes.PlayersTriggered))
		v38:dispatch(SetCurrentPage("Players"))
	end,
	getOpenChangedEvent = function() -- line: 180
		-- upvalues: BindableEvent (copy)
		return BindableEvent
	end,
	getOpen = function() -- line: 184
		-- upvalues: v38 (copy)
		return v38:getState().isMenuOpen
	end,
	getRespawnBehaviour = function() -- line: 188
		-- upvalues: v38 (copy)
		local v47 = v38:getState()

		return v47.respawn.enabled, v47.respawn.customCallback
	end,
	getRespawnBehaviourChangedEvent = function() -- line: 193
		-- upvalues: BindableEvent2 (copy)
		return BindableEvent2
	end,
	setMenuIconTooltipOpen = function(p8) -- line: 197
		-- upvalues: v38 (copy), SetMenuIconTooltipOpen (copy)
		v38:dispatch(SetMenuIconTooltipOpen(p8))
	end
}
