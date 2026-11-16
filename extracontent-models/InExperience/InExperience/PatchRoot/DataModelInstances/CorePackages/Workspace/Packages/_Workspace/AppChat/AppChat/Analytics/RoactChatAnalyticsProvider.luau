local parent = script.Parent.Parent.Parent
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local EventStreamActionList = require(script.Parent.EventStreamActionList)
local DiagActionList = require(script.Parent.DiagActionList)

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local RoactChatAnalyticsContext = require(script.Parent.RoactChatAnalyticsContext)
local Logger = require(script.Parent.Logger)

local SocialCommon = require(parent.SocialCommon)
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function(p)
	local entryPoint = p.entryPoint

	if not (entryPoint and ChatEntryPointNames[entryPoint]) then
		Logger:warning("entryPoint=" .. tostring(entryPoint) .. " is not a reigstered value.")
		entryPoint = ChatEntryPointNames.Unknown
	end

	local v

	if GetFFlagIsSquadEnabled() then
		v = useSelector(function(p2)
			local currentSquad = p2.Squad and p2.Squad.Squad and p2.Squad.Squad.currentSquad

			if currentSquad and currentSquad.squadId then
				return currentSquad.squadId
			end

			return nil
		end)
	else
		v = nil
	end

	local playSessionId = RbxAnalyticsService:GetPlaySessionId()

	local v2 = React.useMemo(function()
		local setUpAnalyticsFactory = AnalyticsFactory.setUpAnalyticsFactory
		local v2 = {
			eventLists = { EventStream = EventStreamActionList, Diag = DiagActionList },
			analyticsImpl = {
				EventStream = DefaultAnalyticsService.EventStream,
				Diag = DefaultAnalyticsService.Diag
			},
			staticInfoForAllEvents = 0
		}
		local squadId

		if GetFFlagIsSquadEnabled() then
			squadId = v
		end

		v2.staticInfoForAllEvents = {
			squadId = squadId,
			entryPoint = entryPoint,
			channelsApiEnabled = true,
			playSessionId = playSessionId
		}
		return setUpAnalyticsFactory(v2)()
	end, { v, entryPoint, playSessionId })

	return React.createElement(RoactChatAnalyticsContext.Provider, { value = v2 }, p.children)
end
