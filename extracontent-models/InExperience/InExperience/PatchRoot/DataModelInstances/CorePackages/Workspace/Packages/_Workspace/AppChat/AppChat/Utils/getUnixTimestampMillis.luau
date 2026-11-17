local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local parseIsoDateUnixMillis = require(AppChat.Utils.parseIsoDateUnixMillis)

local function getUnixTimestampMillis(value)
	if typeof(value) == "DateTime" then
		return value.UnixTimestampMillis
	end

	if type(value) == "string" then
		return parseIsoDateUnixMillis(value)
	end

	if type(value) == "table" and value.GetUnixTimestamp ~= nil then
		return (math.round(value:GetUnixTimestamp() * 1000))
	end

	return nil
end

return getUnixTimestampMillis
