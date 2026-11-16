local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(p)
	return { reason_selection = p.reason_selection }
end)
