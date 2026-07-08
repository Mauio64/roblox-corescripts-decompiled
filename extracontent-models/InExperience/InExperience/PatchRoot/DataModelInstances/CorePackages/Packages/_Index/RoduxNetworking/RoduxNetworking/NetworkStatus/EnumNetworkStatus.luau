local t1 = {}
local t2 = {
	NotStarted = "NotStarted",
	Fetching = "Fetching",
	Done = "Done",
	Failed = "Failed"
}

setmetatable(t1, {
	__newindex = function(_, _, _) -- line: 12
	end,
	__index = function(_, p5) -- line: 14
		-- upvalues: t2 (copy)
		assert(t2[p5] ~= nil, "EnumNetworkStatus has no value: " .. tostring(p5))

		return t2[p5]
	end
})

return t1
