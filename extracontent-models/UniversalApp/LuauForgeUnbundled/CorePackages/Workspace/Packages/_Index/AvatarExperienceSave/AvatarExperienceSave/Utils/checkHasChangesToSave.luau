require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/AvatarSaveContext")
local getSaveDict = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Utils/getSaveDict")

local function checkHasChangesToSave(p2, p3): boolean
	local v5 = getSaveDict(p2, p3)

	for k, v6 in v5 do
		if v6 then
			return true
		end
	end

	return false
end

return checkHasChangesToSave
