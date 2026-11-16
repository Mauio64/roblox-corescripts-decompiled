local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local linkingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/LinkingProtocol").LinkingProtocol
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RoactUtils").Hooks.RoactRodux.useDispatch
local localizationRoactContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Localization").LocalizationRoactContext
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Navigation").useNavigation
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local useCursor = Foundation.Hooks.useCursor
local feedbackManagerInjectionContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UIBlox").Core.Control.FeedbackManagerInjectionContext

local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RoactServiceTags")
local appEventIngestService = RoactServiceTags.AppEventIngestService
local appSessionService = RoactServiceTags.AppSessionService
local roactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local roactAnalytics = RoactServiceTags.RoactAnalytics
local roactNetworking = RoactServiceTags.RoactNetworking

local sduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem").SduiLogger

local fFlagLuaAppSduiGameTileFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiGameTileFeedback

local function useSduiDependencies(p2)
	local v5 = useDispatch()
	local v6 = useNavigation()
	local v7 = useRoactService(roactAnalytics)
	local v8 = useRoactService(roactAnalyticsCommonGameEvents)
	local v9 = useRoactService(appEventIngestService)
	local v10 = useRoactService(appSessionService)

	local ref = React.useRef(v6)
	ref.current = v6
	local v11 = React.useCallback(function()
		return ref.current
	end, { ref })

	local v12 = useRoactService(roactNetworking)
	local v13 = React.useContext(localizationRoactContext)
	local v14 = useCursor(Foundation.Enums.CursorType.RoundedRect)
	local v15 = React.useMemo(function()
		return { tileCursor = v14 }
	end, { v14 })
	local v16

	if fFlagLuaAppSduiGameTileFeedback then
		local v17 = React.useContext(feedbackManagerInjectionContext)
		local ref2 = React.useRef(v17)
		ref2.current = v17

		v16 = React.useCallback(function(p3, p4, p5, p6)
			return ref2.current(p3, p4, p5, p6)
		end, { ref2 })
	else
		v16 = nil
	end

	local function fn()
		return {
			dispatch = v5,
			getNavigation = v11,
			appAnalytics = v7,
			gameAnalytics = v8,
			eventIngest = v9,
			sessionService = v10,
			linkingProtocol = linkingProtocol.default,
			logger = sduiLogger,
			cursors = v15,
			instrumentation = p2,
			localization = v13,
			networking = v12,
			triggerFeedback = if fFlagLuaAppSduiGameTileFeedback then v16 else nil
		}
	end

	return (React.useMemo(fn, {
		v5,
		v11,
		v7,
		v8,
		v9,
		p2,
		v10,
		v13,
		v12,
		v15,
		if fFlagLuaAppSduiGameTileFeedback then v16 else nil
	}))
end

return useSduiDependencies
