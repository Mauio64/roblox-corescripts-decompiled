local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")

require(AvatarExperienceSave.Context.AvatarSaveContext)
local getSaveDict = require(script.Parent.getSaveDict)

local function checkHasChangesToSave(p, p2): boolean
	local saveDict = getSaveDict(p, p2)

	for _, save in saveDict do
		if save then
			return true
		end
	end

	return false
end

return checkHasChangesToSave
