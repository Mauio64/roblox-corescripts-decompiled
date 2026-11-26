return require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Rodux").makeActionCreator("OnFormLoaded", function(data)
	return {
		context = data.context,
		place_id = data.place_id,
		accumulated_time_ms = data.accumulated_time_ms
	}
end)
