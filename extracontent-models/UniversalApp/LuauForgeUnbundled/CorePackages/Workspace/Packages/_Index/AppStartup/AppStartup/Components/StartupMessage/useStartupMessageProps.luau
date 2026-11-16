local LocalizationService = game:GetService("LocalizationService")

local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/Dash")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/React")

local appLinking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/RoactServiceTags").AppLinking
local appLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/RoactServiceTags").AppLogging
local appAppLifecycleObserverService = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/RoactServiceTags").AppAppLifecycleObserverService
local appStartupMessageService = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/RoactServiceTags").AppStartupMessageService
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/RobloxAppHooks").useRoactService
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/Localization").Hooks.useLocalization
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/Style").useDesignTokens
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/RobloxAppNavigation").NavigationCommands else nil

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/FocusNavigationUtils")
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot

local defineFastFlag = game:DefineFastFlag("ShowStartupMessageOnUnhide", false)
local engineFeature = game:GetEngineFeature("StartupMessageActionButtonEnabled")

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function useStartupMessageProps()
	local v5 = useRoactService(appLinking)
	local v6 = useRoactService(appLogging)

	local v7 = if defineFastFlag then useRoactService(appAppLifecycleObserverService) else nil

	local v8 = useRoactService(appStartupMessageService)
	local v9 = useSelector(selectScreenSize)
	local v10 = useDispatch()
	local v11 = useDesignTokens(function(p2)
		return p2.Color.Common.Scrim
	end)

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local v12

	if defineFastFlag then
		v12 = React.useCallback(function()
			setState(false)
			setState2(false)
		end, {})
	else
		v12 = nil
	end

	if defineFastFlag then
		React.useEffect(function()
			if not v7 then
				return
			end

			local onUnhideConnection = v7.OnUnhide:Connect(v12)
			return function()
				if onUnhideConnection then
					onUnhideConnection:Disconnect()
				end
			end
		end, { v7, v12 })
	end

	local startupMessage = v8:getStartupMessage()
	local v13 = startupMessage and not state and true or false
	local v14 = startupMessage or {}
	local titleLocalizationKey = v14.titleLocalizationKey
	local bodyLocalizationKey = v14.bodyLocalizationKey

	local actionButtonLocalizationKey = if engineFeature then v14.actionButtonLocalizationKey else nil

	local loggingEventName = v14.loggingEventName
	local links = v14.links or {}

	local v15 = useLocalization(Dash.map(links, function(p2)
		return p2.localizationKey
	end))

	local reduced = Dash.reduce(links, function(p2, p3, p4)
		return Dash.append(p2, {
			{ label = v15[p4], url = p3.url }
		})
	end, {})

	local v16 = v14.date

	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local date = tonumber(v14.date)

	if date then
		v16 = DateTime.fromUnixTimestamp(date):FormatUniversalTime("LL", robloxLocaleId)
	end

	local v17 = useLocalization({
		titleText = titleLocalizationKey,
		bodyText = bodyLocalizationKey and {
			bodyLocalizationKey,
			date = v16
		},
		buttonText = "CommonUI.Messages.Action.Dismiss",
		actionButtonText = actionButtonLocalizationKey
	})

	local v18 = React.useCallback(function()
		setState(true)
	end, {})

	local function onActionButtonActivated()
		v8:executeActionButton()
	end

	local v19 = React.useCallback(function(p2, p3)
		v5:isURLRegistered(p2):andThen(function(p4)
			if p4 then
				if not v5:isInternalDlicEnabled() then
					v5:detectURL(p2)
					return
				end

				v5:detectDeeplinkIntent((v5:createInternalDlic(p2, v5.DeepLinkSource.LuaInternal)))
			else
				local v20 = {
					name = appPage.GenericWebPage,
					detail = p2,
					extraProps = { title = p3 }
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v20))
				else
					v10(navigateDown(v20))
				end
			end
		end)
	end, { v10, v5 })

	local v20 = useAppFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isAutoFocusRoot = true,
		isFocusable = not state
	})

	React.useEffect(function()
		if not state2 and v13 and loggingEventName then
			v6:logEphemeralCounterEvent({
				eventName = loggingEventName,
				backends = { "EphemeralCounter" },
				lastUpdated = { 24, 2, 18 },
				description = "Startup Message Displayed Event"
			})

			setState2(true)
		end
	end, { state2, v13, loggingEventName })

	local v21 = {
		displayStartupMessage = v13,
		screenSize = v9,
		message = v14,
		localizedStrings = v17,
		localizedLinks = reduced,
		overlayColor = v11,
		onDismissed = v18,
		onOpenUrl = v19,
		onActionButtonActivated = nil,
		focusNavRef = nil
	}

	if not engineFeature then
		onActionButtonActivated = nil
	end

	v21.onActionButtonActivated = onActionButtonActivated

	v21.focusNavRef = v20
	return v21
end

return useStartupMessageProps
