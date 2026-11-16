local parent = script:FindFirstAncestor("Http").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(fetchingStatuses, flag: boolean?)
	return {
		fetchingStatuses = fetchingStatuses,
		shouldImmediatelyDispatch = flag or false
	}
end)
