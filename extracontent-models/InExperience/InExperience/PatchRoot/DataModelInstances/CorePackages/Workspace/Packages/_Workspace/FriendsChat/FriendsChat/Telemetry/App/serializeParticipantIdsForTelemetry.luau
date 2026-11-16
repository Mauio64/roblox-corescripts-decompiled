local HttpService = game:GetService("HttpService")

local function serializeParticipantIdsForTelemetry(options, p: number?)
	local v = {}

	for _, id in options or {} do
		if typeof(id) == "table" then
			id = id.id
		end

		local v2 = tonumber(id)

		if v2 ~= nil and v2 ~= p then
			table.insert(v, v2)
		end
	end

	local success, result = pcall(function()
		return HttpService:JSONEncode(v)
	end)
	return if success then result else "[]"
end

return serializeParticipantIdsForTelemetry
