local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/dependencies").Rodux

local module = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Reducers/Participants")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Reducers/Experience")

return function(p2)
	local experience = nil
	local participants = if p2 and p2.Participants then p2.Participants else nil

	if p2 and p2.Experience then
		experience = p2.Experience
	end

	return rodux.combineReducers({
		Participants = module(participants),
		Experience = module2(experience)
	})
end
