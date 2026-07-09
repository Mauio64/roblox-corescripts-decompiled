local function getTransferRequestInternalId(s1: string?) -- line: 6
	if s1 == nil or s1 == "" then
		return ""
	end

	if #s1 >= 4 and string.lower((string.sub(s1, 1, 4))) == "rxt-" then
		return (string.sub(s1, 5))
	end

	return s1
end

return getTransferRequestInternalId
