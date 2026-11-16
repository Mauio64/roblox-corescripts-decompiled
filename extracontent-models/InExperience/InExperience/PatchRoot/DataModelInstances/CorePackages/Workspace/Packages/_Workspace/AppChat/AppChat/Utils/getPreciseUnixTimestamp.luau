local AppChat = script:FindFirstAncestor("AppChat")

local parseIsoDateUnixMillis = require(AppChat.Utils.parseIsoDateUnixMillis)

local function getPreciseUnixTimestamp(value)
	if typeof(value) == "DateTime" then
		return value.UnixTimestampMillis / 1000
	end

	if type(value) == "string" then
		local v = parseIsoDateUnixMillis(value)

		if v == nil then
			return nil
		end

		return v / 1000
	elseif type(value) == "table" and value.GetUnixTimestamp ~= nil then
		return value:GetUnixTimestamp()
	else
		return nil
	end
end

return getPreciseUnixTimestamp
