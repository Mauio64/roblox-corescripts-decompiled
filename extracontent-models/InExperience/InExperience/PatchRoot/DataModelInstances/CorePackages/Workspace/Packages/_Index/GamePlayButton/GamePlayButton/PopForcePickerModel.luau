local v = {
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

local function isReachablePing(value): boolean -- 2 equivalent calls inferred from this helper
	return type(value) == "number" and value >= 0 and value < 1e999
end

local function getDisplayCode(value: string) -- 1 equivalent call inferred from this helper
	return string.upper(value)
end

local PopForcePickerModel = {}

function PopForcePickerModel.buildRoster(list, popCode2: string)
	local v2 = {}
	local roster = {}

	for _, item in ipairs(list) do
		local popCode = item.popCode

		if not (type(popCode) == "string" and popCode ~= "") then
			continue
		end

		local v3 = v2[popCode]
		local v4 = v3 or { popCode = popCode }

		if not v3 then
			v2[popCode] = v4
			table.insert(roster, v4)
		end

		local rttMs = item.rttMs

		if isReachablePing(rttMs) and (v4.rttMs == nil or rttMs < v4.rttMs) then -- inferred equivalent call
			v4.rttMs = rttMs
		end
	end

	if popCode2 ~= "" and v2[popCode2] == nil then
		table.insert(roster, { popCode = popCode2 })
	end

	table.sort(roster, function(a, b): boolean
		if a.rttMs == nil or b.rttMs == nil then
			return a.rttMs ~= nil or b.rttMs == nil and a.popCode < b.popCode
		elseif a.rttMs == b.rttMs then
			return a.popCode < b.popCode
		else
			return a.rttMs < b.rttMs
		end
	end)

	return roster
end

PopForcePickerModel.getDisplayCode = getDisplayCode

function PopForcePickerModel.getLocationName(value: string)
	local displayCode = getDisplayCode(value) -- inferred equivalent call
	local v2 = string.match(displayCode, "^([A-Z][A-Z][A-Z])%d*$")

	if v2 then
		return v[v2] or displayCode
	end

	return displayCode
end

function PopForcePickerModel.formatPing(value: number?)
	if value ~= nil and isReachablePing(value) then -- inferred equivalent call
		return (string.format("%.0f ms", (math.floor(value + 0.5))))
	end

	return "Ping unavailable"
end

function PopForcePickerModel.getVisibleRoster(list, p: string, flag: boolean)
	if flag then
		return table.clone(list)
	end

	local result = {}

	for i, item in ipairs(list) do
		if i <= 5 or item.popCode == p then
			table.insert(result, item)
		end
	end

	return result
end

return PopForcePickerModel
