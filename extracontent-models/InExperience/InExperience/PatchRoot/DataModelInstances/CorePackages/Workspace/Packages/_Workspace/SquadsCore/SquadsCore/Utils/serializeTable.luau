local Parent = script:FindFirstAncestor("SquadsCore").Parent
local HttpService = game:GetService("HttpService")
local FFlagDebugSquadLogsEnabled = require(Parent.SharedFlags).FFlagDebugSquadLogsEnabled

return function(p1) -- line: 8
	-- upvalues: FFlagDebugSquadLogsEnabled (copy), HttpService (copy)
	if FFlagDebugSquadLogsEnabled then
		return HttpService:JSONEncode(p1)
	end

	return p1
end
