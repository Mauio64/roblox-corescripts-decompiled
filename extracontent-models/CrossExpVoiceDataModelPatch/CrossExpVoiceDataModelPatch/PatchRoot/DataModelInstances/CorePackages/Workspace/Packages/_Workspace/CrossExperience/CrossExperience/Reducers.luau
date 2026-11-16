local CrossExperience = script:FindFirstAncestor("CrossExperience")
local dependencies = require(CrossExperience.dependencies)

local rodux = dependencies.Rodux

local Participants = require(script.Participants)
local Experience = require(script.Experience)

return function(p)
	local experience = nil
	local participants

	if p and p.Participants then
		participants = p.Participants
	end

	if p and p.Experience then
		experience = p.Experience
	end

	return rodux.combineReducers({
		Participants = Participants(participants),
		Experience = Experience(experience)
	})
end
