local HttpService = game:GetService("HttpService")

local function serializeParticipantIdsForTelemetry(t1: {[any]: any}?, n1: number?) -- line: 10
	-- upvalues: HttpService (copy)
	local t2 = {}

	for _, v7 in t1 or {} do
		local num = tonumber(if typeof(v7) ~= "table" then v7 else v7.id)

		if num ~= nil and num ~= n1 then
			table.insert(t2, num)
		end
	end

	local ok, result = pcall(function() -- line: 21
		-- upvalues: HttpService (copy), t2 (copy)
		return HttpService:JSONEncode(t2)
	end)

	if ok then
		return result
	end

	return "[]"
end

return serializeParticipantIdsForTelemetry
