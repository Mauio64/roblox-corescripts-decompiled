local EnumNetworkStatus = {}

local v = { NotStarted = "NotStarted", Fetching = "Fetching", Done = "Done", Failed = "Failed" }

setmetatable(EnumNetworkStatus, {
	__newindex = function(_, _, _) end,
	__index = function(_, p)
		assert(v[p] ~= nil, "EnumNetworkStatus has no value: " .. tostring(p))
		return v[p]
	end
})

return EnumNetworkStatus
