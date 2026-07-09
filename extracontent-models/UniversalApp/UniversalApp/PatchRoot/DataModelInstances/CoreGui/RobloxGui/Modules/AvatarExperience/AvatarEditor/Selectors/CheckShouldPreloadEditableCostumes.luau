local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)

local function CheckShouldPreloadEditableCostumes(p1) -- line: 14
	-- upvalues: PerformFetch (copy), Constants2 (copy), Constants (copy), RetrievalStatus (copy)
	if PerformFetch.GetStatus(p1, Constants2.OutfitsKey .. Constants.EditableCharacterKey) == RetrievalStatus.Fetching then
		return false
	end

	local v9 = p1.AvatarExperience.AvatarEditor.PageFinished[Constants.CharacterKey]
	local v10 = p1.AvatarExperience.AvatarEditor.PageFinished[Constants.EditableCharacterKey]

	if v9 then
		return false
	end

	if v10 then
		return false
	end

	local v11 = p1.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[Constants.EditableCharacterKey]

	if v11 and #v11 > Constants.MaxPreloadEditableCharacters then
		return false
	end

	return true
end

return CheckShouldPreloadEditableCostumes
