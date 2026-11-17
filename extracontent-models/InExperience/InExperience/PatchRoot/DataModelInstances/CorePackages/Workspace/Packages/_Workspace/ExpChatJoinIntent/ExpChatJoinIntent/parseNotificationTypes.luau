local function trim(value: string) -- 2 equivalent calls inferred from this helper
	return (string.match(value, "^%s*(.-)%s*$"))
end

local function parseNotificationTypes(value: string)
	local notificationTypes = {}

	for _, v in string.split(value, ",") do
		local v2, v3 = string.match(v, "^([^=]*)=(.*)$")
		local v4 = trim(v2 or v) -- inferred equivalent call

		if v4 == "" then
			continue
		end

		local chatTarget = not v3 and "" or trim(v3) -- inferred equivalent call

		if chatTarget == "" then
			chatTarget = nil
		end

		notificationTypes[v4] = { chatTarget = chatTarget }
	end

	return notificationTypes
end

return parseNotificationTypes
