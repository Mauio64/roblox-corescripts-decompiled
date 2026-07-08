local t1 = {}
local t2 = {
	NotStarted = "NotStarted",
	Fetching = "Fetching",
	Done = "Done",
	Failed = "Failed"
}

setmetatable(t1, {
	__newindex = function(_, _, _) -- line: 11
	end,
	__index = function(_, p5) -- line: 12
		-- upvalues: t2 (copy)
		assert(t2[p5] ~= nil, "RetrievalStatus Enum has no value: " .. tostring(p5))

		return t2[p5]
	end
})

return t1
