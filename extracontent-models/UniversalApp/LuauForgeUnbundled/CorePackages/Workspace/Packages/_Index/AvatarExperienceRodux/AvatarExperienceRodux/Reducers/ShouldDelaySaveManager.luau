local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux")

local AddSaveDelay = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/AddSaveDelay")
local RemoveSaveDelay = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/RemoveSaveDelay")

return Rodux.createReducer(false, {
	[AddSaveDelay.name] = function(p2, p3): boolean
		return true
	end,
	[RemoveSaveDelay.name] = function(p2, p3): boolean
		return false
	end
})
