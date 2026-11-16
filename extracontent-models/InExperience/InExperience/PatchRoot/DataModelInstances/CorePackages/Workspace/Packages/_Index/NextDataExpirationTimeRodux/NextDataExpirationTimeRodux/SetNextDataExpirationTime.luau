local parent = script:FindFirstAncestor("NextDataExpirationTimeRodux").Parent
local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(value: string, value2: number, namespace: string?)
	assert(type(value) == "string", "SetNextDataExpirationTime: key must be a string!")

	local v = type(value2) == "number" and value2 > 0
	assert(v, "SetNextDataExpirationTime: nextDataExpirationTime must be a positive number!")

	return { key = value, nextDataExpirationTime = value2, namespace = namespace }
end)
