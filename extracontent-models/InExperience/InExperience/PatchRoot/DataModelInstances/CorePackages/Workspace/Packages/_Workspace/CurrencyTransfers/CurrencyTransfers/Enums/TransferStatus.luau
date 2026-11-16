local TransferStatus = {
	Initiated = "Initiated",
	Pending = "Pending",
	Cancelled = "Cancelled",
	Failed = "Failed",
	Completed = "Completed"
}

local v = {
	[0] = TransferStatus.Initiated,
	[1] = TransferStatus.Pending,
	[2] = TransferStatus.Cancelled,
	[3] = TransferStatus.Failed,
	[4] = TransferStatus.Completed
}

function TransferStatus.fromValue(value)
	if value == nil then
		return nil
	end

	if type(value) == "number" then
		return v[value]
	end

	if type(value) == "string" then
		for _, v2 in pairs(TransferStatus) do
			if v2 == value then
				return value
			end
		end
	end

	return nil
end

return TransferStatus
