local parent = script:FindFirstAncestor("SquadsCore").Parent
local Signals = require(parent.Signals)

local createExperienceInviteRetryAfterStore = require(script.createExperienceInviteRetryAfterStore)

return Signals.createComputed(function()
	return createExperienceInviteRetryAfterStore()
end)
