local Parent = script:FindFirstAncestor("BuildExperience").Parent
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)
local UniverseConfiguration = require(Parent.DataHydration.UniverseConfiguration)
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local useSessionSummary = require(script.Parent.useSessionSummary)

return {
	isPublishLatest = function(b1: boolean, b2: boolean) -- line: 27
		return b1 or b2
	end,
	usePublishStatus = function(t1: {[any]: any}) -- line: 31
		-- upvalues: React (copy), UniverseConfiguration (copy), SignalsReact (copy), CreatorAgentChat (copy), useSessionSummary (copy)
		local v10 = React.useMemo(function() -- line: 32
			-- upvalues: UniverseConfiguration (copy), t1 (copy)
			return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(t1.universeId)
		end, { t1.universeId })
		local v11 = SignalsReact.useSignalState(v10.data)
		local v12 = React.useMemo(function() -- line: 36
			-- upvalues: CreatorAgentChat (copy), t1 (copy)
			return CreatorAgentChat.getCreatorAgentChatStore().getSessionForProject(t1.universeId, t1.placeId, t1.sessionId)
		end, {
			t1.universeId,
			t1.placeId,
			t1.sessionId
		})
		local hasPublishedTurn = useSessionSummary(v12).hasPublishedTurn
		local v14 = v11 ~= nil and v11.isActive

		return {
			hasPublishedTurn = hasPublishedTurn,
			hasPublishedVersion = v14,
			isPublishLatest = v14 or hasPublishedTurn
		}
	end
}
