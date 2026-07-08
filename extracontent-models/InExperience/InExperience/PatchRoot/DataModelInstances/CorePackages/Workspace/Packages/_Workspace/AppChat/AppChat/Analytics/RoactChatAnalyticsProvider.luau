local ParentParent = script.Parent.Parent.Parent
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local SocialLuaAnalytics = require(ParentParent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local EventStreamActionList = require(script.Parent.EventStreamActionList)
local DiagActionList = require(script.Parent.DiagActionList)
local React = require(ParentParent.React)
local GetFFlagIsSquadEnabled = require(ParentParent.SharedFlags).GetFFlagIsSquadEnabled
local RoactChatAnalyticsContext = require(script.Parent.RoactChatAnalyticsContext)
local Logger = require(script.Parent.Logger)
local ChatEntryPointNames = require(ParentParent.SocialCommon).Enums.ChatEntryPointNames
local useSelector = require(ParentParent.RoactUtils).Hooks.RoactRodux.useSelector

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: ChatEntryPointNames (copy), Logger (copy), GetFFlagIsSquadEnabled (copy), useSelector (copy), RbxAnalyticsService (copy), React (copy), AnalyticsFactory (copy), EventStreamActionList (copy), DiagActionList (copy), DefaultAnalyticsService (copy), RoactChatAnalyticsContext (copy)
	local entryPoint = t1.entryPoint

	if not entryPoint or not ChatEntryPointNames[entryPoint] then
		Logger:warning("entryPoint=" .. tostring(entryPoint) .. " is not a reigstered value.")
		entryPoint = ChatEntryPointNames.Unknown
	end

	local v16 = if not GetFFlagIsSquadEnabled() then nil else useSelector(function(p1) -- line: 36
		local v20 = p1.Squad and (p1.Squad.Squad and p1.Squad.Squad.currentSquad)

		if v20 and v20.squadId then
			return v20.squadId
		end

		return nil
	end)
	local PlaySessionId = RbxAnalyticsService:GetPlaySessionId()
	local v18 = React.useMemo(function() -- line: 44
		-- upvalues: AnalyticsFactory (copy), EventStreamActionList (copy), DiagActionList (copy), DefaultAnalyticsService (copy), GetFFlagIsSquadEnabled (copy), v16 (copy), entryPoint (ref), PlaySessionId (copy)
		return AnalyticsFactory.setUpAnalyticsFactory({
			eventLists = {
				EventStream = EventStreamActionList,
				Diag = DiagActionList
			},
			analyticsImpl = {
				EventStream = DefaultAnalyticsService.EventStream,
				Diag = DefaultAnalyticsService.Diag
			},
			staticInfoForAllEvents = {
				channelsApiEnabled = true,
				squadId = if not GetFFlagIsSquadEnabled() then nil else v16,
				entryPoint = entryPoint,
				playSessionId = PlaySessionId
			}
		})()
	end, {
		v16,
		entryPoint,
		PlaySessionId
	})

	return React.createElement(RoactChatAnalyticsContext.Provider, {
		value = v18
	}, t1.children)
end
