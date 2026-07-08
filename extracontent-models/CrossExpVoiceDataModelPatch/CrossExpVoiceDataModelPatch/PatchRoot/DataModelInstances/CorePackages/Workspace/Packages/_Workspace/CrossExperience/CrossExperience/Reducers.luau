local CrossExperience = script:FindFirstAncestor("CrossExperience")
local Rodux = require(CrossExperience.dependencies).Rodux
local Participants = require(script.Participants)
local Experience = require(script.Experience)

return function(p1) -- line: 9
	-- upvalues: Rodux (copy), Participants (copy), Experience (copy)
	local Participants2 = nil
	local Experience2 = nil

	if p1 and p1.Participants then
		Participants2 = p1.Participants
	end

	if p1 and p1.Experience then
		Experience2 = p1.Experience
	end

	return Rodux.combineReducers({
		Participants = Participants(Participants2),
		Experience = Experience(Experience2)
	})
end
