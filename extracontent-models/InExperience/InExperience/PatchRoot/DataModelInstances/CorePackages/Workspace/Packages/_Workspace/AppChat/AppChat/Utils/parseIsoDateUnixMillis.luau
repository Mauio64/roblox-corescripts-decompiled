local function parseIsoDateUnixMillis(p: string?)
	if p == nil then
		return nil
	end

	local success, result = pcall(DateTime.fromIsoDate, p)

	if success and result ~= nil then
		return result.UnixTimestampMillis
	end

	return nil
end

return parseIsoDateUnixMillis
