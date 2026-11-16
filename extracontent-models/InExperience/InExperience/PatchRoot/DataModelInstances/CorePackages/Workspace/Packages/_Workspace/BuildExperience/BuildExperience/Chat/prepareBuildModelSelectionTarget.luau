local BuildExperience = script:FindFirstAncestor("BuildExperience")

require(BuildExperience.Chat.chatTypes)
local GetBuildModelSelectionStore = require(BuildExperience.Stores.GetBuildModelSelectionStore)

local function prepareBuildModelSelectionTarget(data)
	if data.isNewGameTarget ~= true or data.universeId ~= nil and data.universeId > 0 then
		return data
	end

	local buildModelSelectionStore = GetBuildModelSelectionStore(false)

	if data.modelSelectionDraftId ~= nil and buildModelSelectionStore.getDraft(data.modelSelectionDraftId) ~= nil then
		return data
	end

	local clone = table.clone(data)
	clone.modelSelectionDraftId = buildModelSelectionStore.createDraft()
	return clone
end

return prepareBuildModelSelectionTarget
