local HttpService = game:GetService("HttpService")

local fFlagDebugSquadLogsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SharedFlags").FFlagDebugSquadLogsEnabled

return function(p2)
	if fFlagDebugSquadLogsEnabled then
		return HttpService:JSONEncode(p2)
	end

	return p2
end
