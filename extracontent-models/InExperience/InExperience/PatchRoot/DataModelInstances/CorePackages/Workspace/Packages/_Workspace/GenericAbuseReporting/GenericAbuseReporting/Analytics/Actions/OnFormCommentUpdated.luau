local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(p)
	return { comment_added = p.comment_added }
end)
