local t1 = {}
local t2 = {
	NotStarted = "NotStarted",
	Fetching = "Fetching",
	Done = "Done",
	Failed = "Failed",
	Removed = "Removed"
}

setmetatable(t1, {
	__newindex = function(_, _, _) -- line: 12
	end,
	__index = function(_, p5) -- line: 13
		-- upvalues: t2 (copy)
		assert(t2[p5] ~= nil, "SearchRetrievalStatus Enum has no value: " .. tostring(p5))

		return t2[p5]
	end
})

return t1
