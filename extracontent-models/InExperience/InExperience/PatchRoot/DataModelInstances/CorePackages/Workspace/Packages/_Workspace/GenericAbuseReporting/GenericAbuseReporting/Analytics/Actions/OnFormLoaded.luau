local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(data)
	return {
		context = data.context,
		place_id = data.place_id,
		accumulated_time_ms = data.accumulated_time_ms
	}
end)
