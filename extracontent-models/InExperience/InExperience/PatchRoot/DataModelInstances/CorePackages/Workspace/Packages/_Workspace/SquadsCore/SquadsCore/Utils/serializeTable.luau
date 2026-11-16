local parent = script:FindFirstAncestor("SquadsCore").Parent

local HttpService = game:GetService("HttpService")

local SharedFlags = require(parent.SharedFlags)
local FFlagDebugSquadLogsEnabled = SharedFlags.FFlagDebugSquadLogsEnabled

return function(p)
	if FFlagDebugSquadLogsEnabled then
		return HttpService:JSONEncode(p)
	end

	return p
end
