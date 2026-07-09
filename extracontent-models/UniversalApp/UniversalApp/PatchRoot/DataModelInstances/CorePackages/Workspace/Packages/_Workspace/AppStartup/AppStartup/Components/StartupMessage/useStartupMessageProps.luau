local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("AppStartup").Parent
local Dash = require(Parent.Dash)
local React = require(Parent.React)
local AppLinking = require(Parent.RoactServiceTags).AppLinking
local AppLogging = require(Parent.RoactServiceTags).AppLogging
local AppAppLifecycleObserverService = require(Parent.RoactServiceTags).AppAppLifecycleObserverService
local AppStartupMessageService = require(Parent.RoactServiceTags).AppStartupMessageService
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useDesignTokens = require(Parent.Style).useDesignTokens
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v17 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local v21 = game:DefineFastFlag("ShowStartupMessageOnUnhide", false)
local EngineFeature = game:GetEngineFeature("StartupMessageActionButtonEnabled")

local function selectScreenSize(p1) -- line: 30
	return p1.ScreenSize
end
local function useStartupMessageProps() -- line: 34
	-- upvalues: useRoactService (copy), AppLinking (copy), AppLogging (copy), v21 (copy), AppAppLifecycleObserverService (copy), AppStartupMessageService (copy), useSelector (copy), selectScreenSize (copy), useDispatch (copy), useDesignTokens (copy), React (copy), EngineFeature (copy), useLocalization (copy), Dash (copy), LocalizationService (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v17 (copy), NavigateDown (copy), useAppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v26 = useRoactService(AppLinking)
	local v27 = useRoactService(AppLogging)
	local v28 = if not v21 then nil else useRoactService(AppAppLifecycleObserverService)
	local v29 = useRoactService(AppStartupMessageService)
	local v30 = useSelector(selectScreenSize)
	local v31 = useDispatch()
	local v32 = useDesignTokens(function(p2) -- line: 43
		return p2.Color.Common.Scrim
	end)
	local v33, v34 = React.useState(false)
	local v35, v36 = React.useState(false)
	local v37 = if not v21 then nil else React.useCallback(function() -- line: 50
		-- upvalues: v34 (copy), v36 (copy)
		v34(false)
		v36(false)
	end, {})

	if v21 then
		React.useEffect(function() -- line: 57
			-- upvalues: v28 (copy), v37 (copy)
			if not v28 then
				return
			end

			local connection = v28.OnUnhide:Connect(v37)

			return function() -- line: 63
				-- upvalues: connection (copy)
				if connection then
					connection:Disconnect()
				end
			end
		end, {
			v28,
			v37
		})
	end

	local v38 = v29:getStartupMessage()
	local v39 = not not v38 and (not v33 or false)
	local v40 = v38 or {}
	local titleLocalizationKey = v40.titleLocalizationKey
	local bodyLocalizationKey = v40.bodyLocalizationKey
	local v43 = if not EngineFeature then nil else v40.actionButtonLocalizationKey
	local loggingEventName = v40.loggingEventName
	local v45 = v40.links or {}
	local v46 = useLocalization(Dash.map(v45, function(p3) -- line: 83
		return p3.localizationKey
	end))
	local v47 = Dash.reduce(v45, function(p4, p5, p6) -- line: 86
		-- upvalues: Dash (copy), v46 (copy)
		return Dash.append(p4, {{
			label = v46[p6],
			url = p5.url
		}})
	end, {})
	local date = v40.date
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local num = tonumber(v40.date)

	if num then
		date = DateTime.fromUnixTimestamp(num):FormatUniversalTime("LL", RobloxLocaleId)
	end

	local v51 = useLocalization({
		buttonText = "CommonUI.Messages.Action.Dismiss",
		titleText = titleLocalizationKey,
		bodyText = bodyLocalizationKey and {
			bodyLocalizationKey,
			date = date
		},
		actionButtonText = v43
	})
	local v52 = React.useCallback(function() -- line: 109
		-- upvalues: v34 (copy)
		v34(true)
	end, {})

	local function onActionButtonActivated() -- line: 113
		-- upvalues: v29 (copy)
		v29:executeActionButton()
	end

	local v54 = React.useCallback(function(s1: string, s2: string) -- line: 117
		-- upvalues: v26 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v17 (copy), v31 (copy), NavigateDown (copy)
		v26:isURLRegistered(s1):andThen(function(p7) -- line: 118
			-- upvalues: v26 (copy), s1 (copy), AppPage (copy), s2 (copy), FFlagSignalsNavP3Dispatch (copy), v17 (copy), v31 (copy), NavigateDown (copy)
			if p7 then
				v26:detectURL(s1)

				return
			end

			local t1 = {
				name = AppPage.GenericWebPage,
				detail = s1,
				extraProps = {
					title = s2
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v17.down(v17.fromLegacyPage(t1))

				return
			end

			v31(NavigateDown(t1))
		end)
	end, {
		v31,
		v26
	})
	local v55 = useAppFocusRoot({
		isAutoFocusRoot = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isFocusable = not v33
	})

	React.useEffect(function() -- line: 144
		-- upvalues: v35 (copy), v39 (copy), loggingEventName (copy), v27 (copy), v36 (copy)
		if not v35 and (v39 and loggingEventName) then
			v27:logEphemeralCounterEvent({
				description = "Startup Message Displayed Event",
				eventName = loggingEventName,
				backends = { "EphemeralCounter" },
				lastUpdated = {
					24,
					2,
					18
				}
			})
			v36(true)
		end
	end, {
		v35,
		v39,
		loggingEventName
	})

	return {
		displayStartupMessage = v39,
		screenSize = v30,
		message = v40,
		localizedStrings = v51,
		localizedLinks = v47,
		overlayColor = v32,
		onDismissed = v52,
		onOpenUrl = v54,
		onActionButtonActivated = if not EngineFeature then nil else onActionButtonActivated,
		focusNavRef = v55
	}
end

return useStartupMessageProps
