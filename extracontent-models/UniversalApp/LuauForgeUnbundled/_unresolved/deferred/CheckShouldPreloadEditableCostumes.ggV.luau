local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus

local module = require("@luauforge/bundled/dNQ")
local module2 = require("@luauforge/bundled/dMx")

local function CheckShouldPreloadEditableCostumes(p2): boolean
	if performFetch.GetStatus(p2, module2.OutfitsKey .. module.EditableCharacterKey) == retrievalStatus.Fetching then
		return false
	end

	local v5 = p2.AvatarExperience.AvatarEditor.PageFinished[module.CharacterKey]

	local v6 = p2.AvatarExperience.AvatarEditor.PageFinished[module.EditableCharacterKey]

	if v5 or v6 then
		return false
	end

	local ownedItemId = p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[module.EditableCharacterKey]

	if ownedItemId and #ownedItemId > module.MaxPreloadEditableCharacters then
		return false
	end

	return true
end

return CheckShouldPreloadEditableCostumes
