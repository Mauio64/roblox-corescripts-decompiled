local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")

require(AvatarExperienceSave.Context.AvatarSaveContext)

local getSaveDict = require(script.Parent.getSaveDict)

local function checkHasChangesToSave(p1, p2) -- line: 6
	-- upvalues: getSaveDict (copy)
	for _, v7 in (getSaveDict(p1, p2)) do
		if v7 then
			return true
		end
	end

	return false
end

return checkHasChangesToSave
