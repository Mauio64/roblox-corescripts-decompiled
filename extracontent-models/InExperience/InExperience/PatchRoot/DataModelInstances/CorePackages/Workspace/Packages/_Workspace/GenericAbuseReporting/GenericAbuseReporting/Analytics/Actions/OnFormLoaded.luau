local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 15
	return {
		context = t1.context,
		place_id = t1.place_id,
		accumulated_time_ms = t1.accumulated_time_ms
	}
end)
