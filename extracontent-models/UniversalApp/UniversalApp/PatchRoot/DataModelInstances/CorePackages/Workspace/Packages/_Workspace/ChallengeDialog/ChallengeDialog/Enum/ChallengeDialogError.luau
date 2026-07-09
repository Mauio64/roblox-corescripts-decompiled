local Parent = script:FindFirstAncestor("ChallengeDialog").Parent
local enumerate = require(Parent.enumerate)
local t1 = {
	Unknown = 1,
	TokenUnavailable = 2,
	StateNotUpdated = 3,
	InconsistentStateTransition = 4,
	BadRequest = 5
}

return (enumerate(script.Name, t1))
