local parseIsoDateUnixMillis = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/parseIsoDateUnixMillis")

local function parseIsoDate(value)
	if type(value) ~= "string" then
		return nil
	end

	local v5 = parseIsoDateUnixMillis(value)

	if v5 == nil then
		return nil
	end

	return (DateTime.fromUnixTimestampMillis(v5))
end

local function getMessageSentDateTime(data)
	local sent = data.sent

	if sent == nil then
		local created_at = data.created_at or data.createdAt

		if type(created_at) ~= "string" then
			return nil
		end

		local v5 = parseIsoDateUnixMillis(created_at)

		if v5 == nil then
			return nil
		end

		return (DateTime.fromUnixTimestampMillis(v5))
	else
		if type(sent) ~= "string" then
			return sent
		end

		if type(sent) ~= "string" then
			return nil
		end

		local v5 = parseIsoDateUnixMillis(sent)

		if v5 == nil then
			return nil
		end

		return (DateTime.fromUnixTimestampMillis(v5))
	end
end

return getMessageSentDateTime
