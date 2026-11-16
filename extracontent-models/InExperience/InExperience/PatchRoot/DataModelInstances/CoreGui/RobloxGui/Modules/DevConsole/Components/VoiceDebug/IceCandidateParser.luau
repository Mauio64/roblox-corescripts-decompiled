local v = { candidateType = nil, protocol = nil, priority = nil, component = nil }

local function parseIceCandidate(value: string?)
	if value == nil or value == "" then
		return v
	end

	local v2 = {}

	for k in string.gmatch(value, "%S+") do
		table.insert(v2, k)
	end

	local candidateType = nil

	for k, v3 in v2 do
		if v3 == "typ" then
			candidateType = v2[k + 1]
			break
		end
	end

	if candidateType == nil then
		return v
	end

	return { candidateType = candidateType, protocol = v2[3], priority = v2[4], component = v2[2] }
end

return parseIceCandidate
