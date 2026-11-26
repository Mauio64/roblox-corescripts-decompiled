local function trim(value)
	return string.match(value, "^%s*(.-)%s*$")
end

local function parseNotificationTypes(value)
	local notificationTypes = {}

	for k, v5 in string.split(value, ",") do
		local v6, v7 = string.match(v5, "^([^=]*)=(.*)$")
		local v8 = string.match(v6 or v5, "^%s*(.-)%s*$")

		if v8 == "" then
			continue
		end

		local v9 = not v7 and "" or string.match(v7, "^%s*(.-)%s*$")

		if v9 == "" then
			v9 = nil
		end

		notificationTypes[v8] = { chatTarget = v9 }
	end

	return notificationTypes
end

return parseNotificationTypes
