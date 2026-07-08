local function normalizeParticipants(p1) -- line: 1
	if type(p1) ~= "table" then
		return p1
	end

	local t1 = {}

	for v5, v6 in p1 do
		t1[v5] = if type(v6) ~= "table" then {
			id = tostring(v6)
		} else v6
	end

	return t1
end
local function normalizeConversationForTelemetry(p2) -- line: 18
	-- upvalues: normalizeParticipants (copy)
	local v8 = table.clone(p2)

	v8.participants = normalizeParticipants(p2.participants)

	return v8
end

return normalizeConversationForTelemetry
