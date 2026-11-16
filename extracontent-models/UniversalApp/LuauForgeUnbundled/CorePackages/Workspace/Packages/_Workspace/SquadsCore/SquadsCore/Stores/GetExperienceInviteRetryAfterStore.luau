local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Signals")

local createExperienceInviteRetryAfterStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Stores/GetExperienceInviteRetryAfterStore/createExperienceInviteRetryAfterStore")

return Signals.createComputed(function()
	return createExperienceInviteRetryAfterStore()
end)
