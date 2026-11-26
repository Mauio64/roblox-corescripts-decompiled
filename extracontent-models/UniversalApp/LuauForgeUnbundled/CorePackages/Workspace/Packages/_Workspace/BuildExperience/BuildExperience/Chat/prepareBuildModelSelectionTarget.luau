require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local GetBuildModelSelectionStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildModelSelectionStore")

local function prepareBuildModelSelectionTarget(data)
	if data.isNewGameTarget ~= true or data.universeId ~= nil and data.universeId > 0 then
		return data
	end

	local v5 = GetBuildModelSelectionStore(false)

	if data.modelSelectionDraftId ~= nil and v5.getDraft(data.modelSelectionDraftId) ~= nil then
		return data
	end

	local clone = table.clone(data)
	clone.modelSelectionDraftId = v5.createDraft()
	return clone
end

return prepareBuildModelSelectionTarget
