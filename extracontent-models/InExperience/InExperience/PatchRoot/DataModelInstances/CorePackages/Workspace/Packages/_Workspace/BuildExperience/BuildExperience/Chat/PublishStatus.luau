local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore
local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)

local useSessionSummary = require(script.Parent.useSessionSummary)
local PublishStatus = {}

function PublishStatus.isPublishLatest(flag: boolean, flag2: boolean)
	return flag or flag2
end

function PublishStatus.usePublishStatus(data)
	local v = React.useMemo(function()
		return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(data.universeId)
	end, { data.universeId })
	local v2 = SignalsReact.useSignalState(v.data)
	local v3

	if FFlagBuildExperienceModelPicker then
		v3 = SignalsReact.useSignalState(localUserIdStore.getCurrentUserId)
	end

	local hasPublishedTurn = useSessionSummary((React.useMemo(function()
		return CreatorAgentChat.getCreatorAgentChatStore().getSessionForProject(
			data.universeId,
			data.placeId,
			data.sessionId
		)
	end, { data.universeId, data.placeId, data.sessionId, v3 }))).hasPublishedTurn
	local hasPublishedVersion = not (v2 == nil) and v2.isActive

	return {
		hasPublishedTurn = hasPublishedTurn,
		hasPublishedVersion = hasPublishedVersion,
		isPublishLatest = hasPublishedVersion or hasPublishedTurn
	}
end

return PublishStatus
