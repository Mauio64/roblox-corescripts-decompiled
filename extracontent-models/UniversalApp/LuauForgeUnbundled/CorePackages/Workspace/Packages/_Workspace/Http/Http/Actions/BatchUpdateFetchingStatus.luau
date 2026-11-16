return require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Rodux").makeActionCreator("BatchUpdateFetchingStatus", function(p2, p3)
	return {
		fetchingStatuses = p2,
		shouldImmediatelyDispatch = p3 or false
	}
end)
