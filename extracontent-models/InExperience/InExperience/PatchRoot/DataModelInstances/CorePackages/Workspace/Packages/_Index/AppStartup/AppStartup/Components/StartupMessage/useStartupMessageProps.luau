local LocalizationService = game:GetService("LocalizationService")
local parent = script:FindFirstAncestor("AppStartup").Parent
local Dash = require(parent.Dash)
local React = require(parent.React)

local RoactServiceTags = require(parent.RoactServiceTags)
local AppLinking = RoactServiceTags.AppLinking
local RoactServiceTags2 = require(parent.RoactServiceTags)
local AppLogging = RoactServiceTags2.AppLogging
local RoactServiceTags3 = require(parent.RoactServiceTags)
local AppAppLifecycleObserverService = RoactServiceTags3.AppAppLifecycleObserverService
local RoactServiceTags4 = require(parent.RoactServiceTags)
local AppStartupMessageService = RoactServiceTags4.AppStartupMessageService
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot

local defineFastFlag = game:DefineFastFlag("ShowStartupMessageOnUnhide", false)
local engineFeature = game:GetEngineFeature("StartupMessageActionButtonEnabled")

local function selectScreenSize(p)
	return p.ScreenSize
end

local function useStartupMessageProps()
	local v = useRoactService(AppLinking)
	local v2 = useRoactService(AppLogging)
	local v3

	if defineFastFlag then
		v3 = useRoactService(AppAppLifecycleObserverService)
	else
		v3 = nil
	end

	local v4 = useRoactService(AppStartupMessageService)
	local screenSize = useSelector(selectScreenSize)
	local v5 = useDispatch()
	local overlayColor = useDesignTokens(function(p)
		return p.Color.Common.Scrim
	end)

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local v6

	if defineFastFlag then
		v6 = React.useCallback(function()
			setState(false)
			setState2(false)
		end, {})
	else
		v6 = nil
	end

	if defineFastFlag then
		React.useEffect(function()
			if not v3 then
				return
			end

			local onUnhideConnection = v3.OnUnhide:Connect(v6)
			return function()
				if onUnhideConnection then
					onUnhideConnection:Disconnect()
				end
			end
		end, { v3, v6 })
	end

	local startupMessage = v4:getStartupMessage()
	local displayStartupMessage = startupMessage and not state and true or false
	local message = startupMessage or {}
	local titleLocalizationKey = message.titleLocalizationKey
	local bodyLocalizationKey = message.bodyLocalizationKey
	local actionButtonLocalizationKey

	if engineFeature then
		actionButtonLocalizationKey = message.actionButtonLocalizationKey
	end

	local loggingEventName = message.loggingEventName
	local links = message.links or {}

	local v7 = useLocalization(Dash.map(links, function(p)
		return p.localizationKey
	end))

	local reduced = Dash.reduce(links, function(p, p2, p3)
		return Dash.append(p, {
			{ label = v7[p3], url = p2.url }
		})
	end, {})

	local date2 = message.date

	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local date = tonumber(message.date)

	if date then
		date2 = DateTime.fromUnixTimestamp(date):FormatUniversalTime("LL", robloxLocaleId)
	end

	local localizedStrings = useLocalization({
		titleText = titleLocalizationKey,
		bodyText = bodyLocalizationKey and {
			bodyLocalizationKey,
			date = date2
		},
		buttonText = "CommonUI.Messages.Action.Dismiss",
		actionButtonText = actionButtonLocalizationKey
	})

	local onDismissed = React.useCallback(function()
		setState(true)
	end, {})

	local function onActionButtonActivated()
		v4:executeActionButton()
	end

	local onOpenUrl = React.useCallback(function(detail: string, title: string)
		v:isURLRegistered(detail):andThen(function(p)
			if p then
				if v:isInternalDlicEnabled() then
					v:detectDeeplinkIntent((v:createInternalDlic(detail, v.DeepLinkSource.LuaInternal)))
				else
					v:detectURL(detail)
				end
			else
				local v8 = {
					name = AppPage.GenericWebPage,
					detail = detail,
					extraProps = { title = title }
				}

				if FFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v8))
				else
					v5(NavigateDown(v8))
				end
			end
		end)
	end, { v5, v })

	local focusNavRef = useAppFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isAutoFocusRoot = true,
		isFocusable = not state
	})

	React.useEffect(function()
		if not state2 and displayStartupMessage and loggingEventName then
			v2:logEphemeralCounterEvent({
				eventName = loggingEventName,
				backends = { "EphemeralCounter" },
				lastUpdated = { 24, 2, 18 },
				description = "Startup Message Displayed Event"
			})

			setState2(true)
		end
	end, { state2, displayStartupMessage, loggingEventName })

	local v8 = {
		displayStartupMessage = displayStartupMessage,
		screenSize = screenSize,
		message = message,
		localizedStrings = localizedStrings,
		localizedLinks = reduced,
		overlayColor = overlayColor,
		onDismissed = onDismissed,
		onOpenUrl = onOpenUrl,
		onActionButtonActivated = nil,
		focusNavRef = nil
	}

	if not engineFeature then
		onActionButtonActivated = nil
	end

	v8.onActionButtonActivated = onActionButtonActivated

	v8.focusNavRef = focusNavRef
	return v8
end

return useStartupMessageProps
