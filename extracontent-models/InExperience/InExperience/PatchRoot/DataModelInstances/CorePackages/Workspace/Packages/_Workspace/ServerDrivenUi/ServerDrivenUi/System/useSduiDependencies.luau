local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(parent.React)
local LinkingProtocol = require(parent.LinkingProtocol)
local linkingProtocol = LinkingProtocol.LinkingProtocol
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Localization = require(parent.Localization)
local LocalizationRoactContext = Localization.LocalizationRoactContext
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Foundation = require(parent.Foundation)
local useCursor = Foundation.Hooks.useCursor
local UIBlox = require(parent.UIBlox)
local FeedbackManagerInjectionContext = UIBlox.Core.Control.FeedbackManagerInjectionContext

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local AppSessionService = RoactServiceTags.AppSessionService
local RoactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local RoactNetworking = RoactServiceTags.RoactNetworking

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiLogger = SduiCoreSystem.SduiLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiGameTileFeedback = SharedFlags.FFlagLuaAppSduiGameTileFeedback

local function useSduiDependencies(instrumentation)
	local dispatch = useDispatch()
	local current = useNavigation()
	local appAnalytics = useRoactService(RoactAnalytics)
	local gameAnalytics = useRoactService(RoactAnalyticsCommonGameEvents)
	local eventIngest = useRoactService(AppEventIngestService)
	local sessionService = useRoactService(AppSessionService)

	local ref = React.useRef(current)
	ref.current = current
	local getNavigation = React.useCallback(function()
		return ref.current
	end, { ref })

	local networking = useRoactService(RoactNetworking)
	local localization = React.useContext(LocalizationRoactContext)
	local tileCursor = useCursor(Foundation.Enums.CursorType.RoundedRect)
	local cursors = React.useMemo(function()
		return { tileCursor = tileCursor }
	end, { tileCursor })
	local v

	if FFlagLuaAppSduiGameTileFeedback then
		local current2 = React.useContext(FeedbackManagerInjectionContext)
		local ref2 = React.useRef(current2)
		ref2.current = current2

		v = React.useCallback(function(p: string, p2, p3: string?, p4)
			return ref2.current(p, p2, p3, p4)
		end, { ref2 })
	else
		v = nil
	end

	local useMemo = React.useMemo
	local function fn()
		local v2 = {
			dispatch = dispatch,
			getNavigation = getNavigation,
			appAnalytics = appAnalytics,
			gameAnalytics = gameAnalytics,
			eventIngest = eventIngest,
			sessionService = sessionService,
			linkingProtocol = linkingProtocol.default,
			logger = SduiLogger,
			cursors = cursors,
			instrumentation = instrumentation,
			localization = localization,
			networking = networking,
			triggerFeedback = 0
		}
		local triggerFeedback

		if FFlagLuaAppSduiGameTileFeedback then
			triggerFeedback = v
		end

		v2.triggerFeedback = triggerFeedback
		return v2
	end

	local v2

	if FFlagLuaAppSduiGameTileFeedback then
		v2 = v
	end

	return (useMemo(fn, {
		dispatch,
		getNavigation,
		appAnalytics,
		gameAnalytics,
		eventIngest,
		instrumentation,
		sessionService,
		localization,
		networking,
		cursors,
		v2
	}))
end

return useSduiDependencies
