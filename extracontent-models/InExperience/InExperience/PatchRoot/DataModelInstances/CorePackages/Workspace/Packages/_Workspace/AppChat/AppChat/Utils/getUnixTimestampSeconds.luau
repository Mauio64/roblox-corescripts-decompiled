local parent = script:FindFirstAncestor("AppChat").Parent

local function getUnixTimestampSeconds(value)
	if typeof(value) == "DateTime" then
		return value.UnixTimestamp
	end

	if type(value) == "table" and value.GetUnixTimestamp ~= nil then
		return value:GetUnixTimestamp()
	end

	return nil
end

return getUnixTimestampSeconds
