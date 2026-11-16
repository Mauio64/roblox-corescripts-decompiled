local v5 = {
	AMS = "Amsterdam",
	ATL = "Atlanta",
	BOM = "Mumbai",
	CDG = "Paris",
	DFW = "Dallas",
	FRA = "Frankfurt",
	GRU = "São Paulo",
	HKG = "Hong Kong",
	IAD = "Washington, DC",
	ICN = "Seoul",
	LAX = "Los Angeles",
	LHR = "London",
	NRT = "Tokyo",
	ORD = "Chicago",
	SEA = "Seattle",
	SFO = "San Francisco",
	SIN = "Singapore",
	SJC = "San Jose",
	SYD = "Sydney"
}

local function isReachablePing(value): boolean
	return type(value) == "number" and value >= 0 and value < 1e999
end

return {
	buildRoster = function(list, p2)
		local v6 = {}
		local roster = {}

		for i, item in ipairs(list) do
			local popCode = item.popCode

			if not (type(popCode) == "string" and popCode ~= "") then
				continue
			end

			local v7 = v6[popCode]
			local v8 = v7 or { popCode = popCode }

			if not v7 then
				v6[popCode] = v8
				table.insert(roster, v8)
			end

			local rttMs = item.rttMs
			local v9 = type(rttMs) == "number" and rttMs >= 0 and rttMs < 1e999

			if v9 and (v8.rttMs == nil or rttMs < v8.rttMs) then
				v8.rttMs = rttMs
			end
		end

		if p2 ~= "" and v6[p2] == nil then
			table.insert(roster, { popCode = p2 })
		end

		table.sort(roster, function(a, b): boolean
			if a.rttMs == nil or b.rttMs == nil then
				if a.rttMs ~= nil then
					return true
				end

				if b.rttMs == nil then
					return a.popCode < b.popCode
				end

				return false
			elseif a.rttMs == b.rttMs then
				return a.popCode < b.popCode
			else
				return a.rttMs < b.rttMs
			end
		end)

		return roster
	end,
	getDisplayCode = function(value)
		return string.upper(value)
	end,
	getLocationName = function(value)
		local v6 = string.upper(value)

		local v7 = string.match(v6, "^([A-Z][A-Z][A-Z])%d*$")

		if v7 then
			return v5[v7] or v6
		end

		return v6
	end,
	formatPing = function(value)
		if value == nil then
			return "Ping unavailable"
		end

		local v6 = type(value) == "number" and value >= 0 and value < 1e999

		if v6 then
			return (string.format("%.0f ms", (math.floor(value + 0.5))))
		end

		return "Ping unavailable"
	end,
	getVisibleRoster = function(list, p2, p3)
		if p3 then
			return table.clone(list)
		end

		local result = {}

		for i, item in ipairs(list) do
			if i <= 5 or item.popCode == p2 then
				table.insert(result, item)
			end
		end

		return result
	end
}
