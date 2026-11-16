local RetrievalStatus = {}

local v = { NotStarted = "NotStarted", Fetching = "Fetching", Done = "Done", Failed = "Failed" }

setmetatable(RetrievalStatus, {
	__newindex = function(_, _, _) end,
	__index = function(_, p)
		assert(v[p] ~= nil, "RetrievalStatus Enum has no value: " .. tostring(p))
		return v[p]
	end
})

return RetrievalStatus
