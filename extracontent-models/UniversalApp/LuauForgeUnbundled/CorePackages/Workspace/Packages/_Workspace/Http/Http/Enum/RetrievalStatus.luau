local v5 = {}

local v6 = {
	NotStarted = "NotStarted",
	Fetching = "Fetching",
	Done = "Done",
	Failed = "Failed"
}

setmetatable(v5, {
	__newindex = function(p2, p3, p4) end,
	__index = function(p2, p3)
		assert(v6[p3] ~= nil, "RetrievalStatus Enum has no value: " .. tostring(p3))
		return v6[p3]
	end
})

return v5
