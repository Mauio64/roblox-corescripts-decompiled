return {
	Priority = { Default = 1, Overlay = 2, Elevated = 3, Immediate = 4 },
	new = function(id, priority, p)
		return { ["id"] = id, priority = priority, createdAt = tick(), data = p }
	end
}
