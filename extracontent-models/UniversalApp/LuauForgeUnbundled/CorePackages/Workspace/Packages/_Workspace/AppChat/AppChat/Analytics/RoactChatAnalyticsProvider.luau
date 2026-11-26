local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialLuaAnalytics")
local analyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local defaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local EventStreamActionList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/EventStreamActionList")
local DiagActionList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/DiagActionList")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagIsSquadEnabled
local RoactChatAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/RoactChatAnalyticsContext")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/Logger")

local chatEntryPointNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCommon").Enums.ChatEntryPointNames

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector

return function(p2)
	local v5 = p2.entryPoint

	if not (v5 and chatEntryPointNames[v5]) then
		Logger:warning("entryPoint=" .. tostring(v5) .. " is not a reigstered value.")
		v5 = chatEntryPointNames.Unknown
	end

	local v6

	if getFFlagIsSquadEnabled() then
		v6 = useSelector(function(p3)
			local currentSquad = p3.Squad and p3.Squad.Squad and p3.Squad.Squad.currentSquad

			if currentSquad and currentSquad.squadId then
				return currentSquad.squadId
			end

			return nil
		end)
	else
		v6 = nil
	end

	local playSessionId = RbxAnalyticsService:GetPlaySessionId()

	local v7 = React.useMemo(function()
		local setUpAnalyticsFactory = analyticsFactory.setUpAnalyticsFactory
		local v8 = {
			eventLists = { EventStream = EventStreamActionList, Diag = DiagActionList },
			analyticsImpl = {
				EventStream = defaultAnalyticsService.EventStream,
				Diag = defaultAnalyticsService.Diag
			},
			staticInfoForAllEvents = 0
		}

		local v10 = if getFFlagIsSquadEnabled() then v6 else nil
		v8.staticInfoForAllEvents = {
			squadId = v10,
			entryPoint = v5,
			channelsApiEnabled = true,
			playSessionId = playSessionId
		}
		return setUpAnalyticsFactory(v8)()
	end, { v6, v5, playSessionId })

	return React.createElement(RoactChatAnalyticsContext.Provider, { value = v7 }, p2.children)
end
