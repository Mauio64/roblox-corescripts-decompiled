local v5 = {
	Initiated = "Initiated",
	Pending = "Pending",
	Cancelled = "Cancelled",
	Failed = "Failed",
	Completed = "Completed"
}

local v6 = {
	[0] = v5.Initiated,
	[1] = v5.Pending,
	[2] = v5.Cancelled,
	[3] = v5.Failed,
	[4] = v5.Completed
}

function v5.fromValue(value)
	if value == nil then
		return nil
	end

	if type(value) == "number" then
		return v6[value]
	end

	if type(value) == "string" then
		for k, v7 in pairs(v5) do
			if v7 == value then
				return value
			end
		end
	end

	return nil
end

return v5
