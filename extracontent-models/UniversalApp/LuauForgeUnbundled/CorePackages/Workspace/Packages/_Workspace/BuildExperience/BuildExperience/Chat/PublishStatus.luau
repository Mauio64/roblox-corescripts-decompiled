local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local UniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/LocalUserIdStore").LocalUserIdStore
local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")

local useSessionSummary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useSessionSummary")

return {
	isPublishLatest = function(p2, p3)
		return p2 or p3
	end,
	usePublishStatus = function(data)
		local v5 = React.useMemo(function()
			return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(data.universeId)
		end, { data.universeId })
		local v6 = SignalsReact.useSignalState(v5.data)

		local v7 = if FFlagBuildExperienceModelPicker then SignalsReact.useSignalState(localUserIdStore.getCurrentUserId) else nil

		local hasPublishedTurn = useSessionSummary((React.useMemo(function()
			return CreatorAgentChat.getCreatorAgentChatStore().getSessionForProject(
				data.universeId,
				data.placeId,
				data.sessionId
			)
		end, { data.universeId, data.placeId, data.sessionId, v7 }))).hasPublishedTurn
		local v9 = not (v6 == nil) and v6.isActive

		return {
			hasPublishedTurn = hasPublishedTurn,
			hasPublishedVersion = v9,
			isPublishLatest = v9 or hasPublishedTurn
		}
	end
}
