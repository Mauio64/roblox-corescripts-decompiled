local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local parseIsoDateUnixMillis = require(AppChat.Utils.parseIsoDateUnixMillis)

local function parseIsoDate(value: string?) -- 2 equivalent calls inferred from this helper
	if type(value) ~= "string" then
		return nil
	end

	local v = parseIsoDateUnixMillis(value)

	if v == nil then
		return nil
	end

	return (DateTime.fromUnixTimestampMillis(v))
end

local function getMessageSentDateTime(data)
	local sent = data.sent

	if sent == nil then
		return parseIsoDate(data.created_at or data.createdAt) -- inferred equivalent call
	end

	if type(sent) ~= "string" then
		return sent
	end

	return parseIsoDate(sent) -- inferred equivalent call
end

return getMessageSentDateTime
