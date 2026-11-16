local function getTransferRequestInternalId(value)
	if value == nil or value == "" then
		return ""
	end

	if #value >= 4 and string.lower((string.sub(value, 1, 4))) == "rxt-" then
		return (string.sub(value, 5))
	end

	return value
end

return getTransferRequestInternalId
