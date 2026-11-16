local parent = script:FindFirstAncestor("FetchStatusRodux").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(fetchNamespace, fetchKey, fetchStatus)
	return { fetchNamespace = fetchNamespace, fetchKey = fetchKey, fetchStatus = fetchStatus }
end)
