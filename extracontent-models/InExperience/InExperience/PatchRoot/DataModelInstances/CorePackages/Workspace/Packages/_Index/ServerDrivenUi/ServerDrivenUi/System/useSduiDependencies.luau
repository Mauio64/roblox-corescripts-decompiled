local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local LinkingProtocol = require(Parent.LinkingProtocol).LinkingProtocol
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local LocalizationRoactContext = require(Parent.Localization).LocalizationRoactContext
local useNavigation = require(Parent.Navigation).useNavigation
local Foundation = require(Parent.Foundation)
local useCursor = Foundation.Hooks.useCursor
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local RoactServiceTags = require(Parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local AppSessionService = RoactServiceTags.AppSessionService
local RoactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local RoactNetworking = RoactServiceTags.RoactNetworking
local SduiLogger = require(Parent.SduiCoreSystem).SduiLogger

local function useSduiDependencies(p1) -- line: 27
	-- upvalues: useDispatch (copy), useNavigation (copy), useRoactService (copy), RoactAnalytics (copy), RoactAnalyticsCommonGameEvents (copy), AppEventIngestService (copy), AppSessionService (copy), React (copy), RoactNetworking (copy), LocalizationRoactContext (copy), useCursor (copy), Foundation (copy), LinkingProtocol (copy), SduiLogger (copy)
	local v19 = useDispatch()
	local v20 = useNavigation()
	local v21 = useRoactService(RoactAnalytics)
	local v22 = useRoactService(RoactAnalyticsCommonGameEvents)
	local v23 = useRoactService(AppEventIngestService)
	local v24 = useRoactService(AppSessionService)
	local v25 = React.useRef(v20)

	v25.current = v20

	local v26 = React.useCallback(function() -- line: 38
		-- upvalues: v25 (copy)
		return v25.current
	end, { v25 })
	local v27 = useRoactService(RoactNetworking)
	local v28 = React.useContext(LocalizationRoactContext)
	local v29 = useCursor(Foundation.Enums.CursorType.RoundedRect)
	local v30 = React.useMemo(function() -- line: 45
		-- upvalues: v29 (copy)
		return {
			tileCursor = v29
		}
	end, { v29 })

	return (React.useMemo(function() -- line: 52
		-- upvalues: v19 (copy), v26 (copy), v21 (copy), v22 (copy), v23 (copy), v24 (copy), LinkingProtocol (copy), SduiLogger (copy), v30 (copy), p1 (copy), v28 (copy), v27 (copy)
		return {
			dispatch = v19,
			getNavigation = v26,
			appAnalytics = v21,
			gameAnalytics = v22,
			eventIngest = v23,
			sessionService = v24,
			linkingProtocol = LinkingProtocol.default,
			logger = SduiLogger,
			cursors = v30,
			instrumentation = p1,
			localization = v28,
			networking = v27
		}
	end, {
		v19,
		v26,
		v21,
		v22,
		v23,
		p1,
		v24,
		v28,
		v27,
		v30
	}))
end

return useSduiDependencies
