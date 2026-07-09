local t1 = {
	Initiated = "Initiated",
	Pending = "Pending",
	Cancelled = "Cancelled",
	Failed = "Failed",
	Completed = "Completed"
}
local t2 = {
	[0] = t1.Initiated,
	[1] = t1.Pending,
	[2] = t1.Cancelled,
	[3] = t1.Failed,
	[4] = t1.Completed
}

function t1.fromValue(p1) -- line: 21
	-- upvalues: t2 (copy), t1 (copy)
	if p1 == nil then
		return nil
	end

	if type(p1) == "number" then
		return t2[p1]
	end

	if type(p1) == "string" then
		for _, v in pairs(t1) do
			if v == p1 then
				return p1
			end
		end
	end

	return nil
end

return t1
