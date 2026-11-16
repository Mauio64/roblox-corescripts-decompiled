local function parseIsoDateUnixMillis(p2)
	if p2 == nil then
		return nil
	end

	local success, result = pcall(DateTime.fromIsoDate, p2)

	if success and result ~= nil then
		return result.UnixTimestampMillis
	end

	return nil
end

return parseIsoDateUnixMillis
