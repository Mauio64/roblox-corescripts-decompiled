return function(p)
	local getStatus = require(script.getStatus)
	local v = { getStatus = getStatus(p), setStatus = 0, installReducer = 0, Enum = 0 }
	local setStatus = require(script.setStatus)
	v.setStatus = setStatus(p)
	local installReducer = require(script.installReducer)
	v.installReducer = installReducer(p)

	v.Enum = {
		Status = require(script.EnumNetworkStatus)
	}
	return v
end
