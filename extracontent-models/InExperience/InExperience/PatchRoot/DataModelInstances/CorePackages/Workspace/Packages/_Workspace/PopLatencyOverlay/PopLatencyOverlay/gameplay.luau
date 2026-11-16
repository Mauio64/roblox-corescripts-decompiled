local format = require(script.Parent.format)

local function regionOf(popCode: string) -- 3 equivalent calls inferred from this helper
	return string.upper((string.sub(popCode, 1, 3)))
end

local function median(p) -- 2 equivalent calls inferred from this helper
	return format.historyMedian(p)
end

local function pooledHistory(items)
	local maxValue = 0

	for _, item in items do
		maxValue = math.max(maxValue, #item)
	end

	local result = table.create(maxValue, -1)

	for i = 0, maxValue - 1 do
		local v = {}

		for _, item in items do
			local v2 = item[#item - i]

			if v2 ~= nil and v2 >= 0 then
				table.insert(v, v2)
			end
		end

		result[maxValue - i] = median(v) or -1 -- inferred equivalent call
	end

	return result
end

local function statsByRegion(items)
	local v = {}
	local v2 = {}

	for _, item in items do
		if typeof(item.popCode) ~= "string" then
			continue
		end

		local v3 = regionOf(item.popCode) -- inferred equivalent call
		v[v3] = v[v3] or {}
		v2[v3] = v2[v3] or {}
		local committedHistory = format.committedHistory(item.history or {})
		local v4 = false

		for _, v5 in committedHistory do
			if not (v5 >= 0) then
				continue
			end

			table.insert(v[v3], v5)
			v4 = true
		end

		if not v4 and typeof(item.rttMs) == "number" and item.rttMs >= 0 then
			table.insert(v[v3], item.rttMs)
		end

		if #committedHistory > 0 then
			table.insert(v2[v3], committedHistory)
		end
	end

	local result = {}

	for k, v3 in v do
		local medianMs = median(v3) -- inferred equivalent call

		if not medianMs then
			continue
		end

		local _, _, jitterMs = format.historyStats(v3)

		if not (#v3 >= 2) then
			jitterMs = nil
		end

		result[k] = { medianMs = medianMs, jitterMs = jitterMs, history = pooledHistory(v2[k]) }
	end

	return result
end

local function msText(p: number?) -- 8 equivalent calls inferred from this helper
	if p == nil or p < 0 then
		return format.colorTag(format.COLOR_RED, "—")
	end

	return format.colorTag(format.rttColor(p), string.format("%.0f ms", p))
end

local function jitterText(p: number?) -- 2 equivalent calls inferred from this helper
	if p then
		return (format.colorTag(format.COLOR_DIM, string.format(" ±%.0f ms jitter", p)))
	end

	return ""
end

local function alternatives(items, p: string?)
	local result = {}

	for k, item in items do
		if k ~= p then
			table.insert(result, { region = k, medianMs = item.medianMs, jitterMs = item.jitterMs })
		end
	end

	table.sort(result, function(a, b): boolean
		return a.medianMs < b.medianMs
	end)

	while #result > 3 do
		table.remove(result)
	end

	return result
end

local function dim(p: string) -- 12 equivalent calls inferred from this helper
	return format.colorTag(format.COLOR_DIM, p)
end

local v = string.rep(" ", 24)

local function deltaText(p: number?, p2: number?) -- 2 equivalent calls inferred from this helper
	if p and p2 then
		return (format.colorTag(format.COLOR_DIM, string.format("%+.0f ms", p - p2)))
	end

	return nil
end

local v2 = { Server = "Server", Automatic = "Client (Automatic)" }

local function addPingLines(list, data)
	local v3

	if data.lastMs == nil or data.serverMs == nil then
		v3 = false
	else
		v3 = data.clientMs ~= nil
	end

	table.insert(list, "  Data Ping (RCC)       " .. msText(data.dataMs)) -- inferred equivalent call

	if v3 then
		table.insert(list, "  Last ping             " .. msText(data.lastMs)) -- inferred equivalent call
		table.insert(list, "    server              " .. msText(data.serverMs)) -- inferred equivalent call
		table.insert(list, "    client              " .. msText(data.clientMs)) -- inferred equivalent call
		table.insert(list, "    network (RakNet)    " .. msText(data.splitRakMs)) -- inferred equivalent call
		local v4

		if data.lastMs and data.serverMs and data.clientMs and data.splitRakMs then
			v4 = data.lastMs - (data.serverMs + data.clientMs + data.splitRakMs)
		end

		if v4 and v4 < -10 then
			table.insert(list, "    unaccounted         " .. dim("stages out of sync")) -- inferred equivalent call
		elseif v4 and v4 > 10 then
			table.insert(list, "    unaccounted         " .. dim(string.format("+%.0f ms", v4))) -- inferred equivalent call
		end
	end

	if not (data.fps and data.fps > 0) then
		return v3
	end

	local v4 = string.format("%.0f fps", data.fps)
	table.insert(list, "  Client frame rate     " .. v4 .. dim(string.format(" · %.1f ms/frame", 1000 / data.fps))) -- inferred equivalent call

	if not data.worstFrameMs then
		return v3
	end

	local v5 = string.format("worst frame %.0f ms", data.worstFrameMs)
	local v6

	if data.worstFrameMs >= 100 then
		v6 = format.colorTag(format.COLOR_RED, v5)
	else
		v6 = dim(v5) -- inferred equivalent call
	end

	table.insert(list, v .. v6)

	return v3
end

local function addProbeLines(list, data, data2)
	local v3

	if data2 then
		v3 = data2.medianMs
	end

	local v4 = msText(v3) -- inferred equivalent call
	local v5

	if data2 then
		v5 = data2.jitterMs
	end

	table.insert(list, "  PoP probe             " .. v4 .. jitterText(v5)) -- inferred equivalent call

	if data2 and #data2.history > 0 then
		table.insert(list, v .. format.sparkline(data2.history))
	end

	if data.probeIntervalMs and data.probeIntervalMs > 0 then
		local probeTargets = data.probeTargets or {}

		local v6 = string.format("  Probe rate            %.0f/s", 1000 / data.probeIntervalMs)
		table.insert(
			list,
			v6 .. dim(string.format( -- inferred equivalent call
				" · every %.0f ms · %d PoP%s",
				data.probeIntervalMs,
				#probeTargets,
				#probeTargets == 1 and "" or "s"
			))
		)
	end

	if data.probeDown then
		table.insert(list, "  Probe loss (1 s)      " .. dim("no replies · probe server may be draining")) -- inferred equivalent call
	elseif data.probeLoss then
		local v6 = string.format("%.0f %%", data.probeLoss * 100)
		local probeSilentPops = data.probeSilentPops

		if data.probeLoss > 0 then
			v6 = format.colorTag(format.COLOR_RED, v6)
		end

		table.insert(
			list,
			"  Probe loss (1 s)      " .. v6 .. dim(not (probeSilentPops and #probeSilentPops > 0) and " · your link to the edge" or " · " .. format.escapeRich(table.concat(probeSilentPops, ", ")) .. " not answering") -- inferred equivalent call
		)
	end
end

local function addPeerLines(list, data)
	if data.peerStatsInvalid then
		table.insert(list, "  RakNet peer stats     " .. dim("unavailable")) -- inferred equivalent call
	end

	if data.loss then
		local v3 = string.format("%.1f %%", data.loss * 100)

		if data.loss >= 0.01 then
			v3 = format.colorTag(format.COLOR_RED, v3)
		end

		table.insert(list, "  Packet loss           " .. v3)
	end

	if data.resendMsgs then
		local resendMsgs = data.resendMsgs
		local v3 = data.resendMsgs == 1 and "msg" or "msgs"
		local v4

		if data.resendBytes then
			v4 = dim(string.format(" · %.1f KB", data.resendBytes / 1024)) -- inferred equivalent call
		else
			v4 = ""
		end

		table.insert(list, string.format("  Resend queue          %d %s%s", resendMsgs, v3, v4))
	end

	if data.sendKbps or data.receiveKbps then
		table.insert(
			list,
			string.format(
				"  Bandwidth             ↑ %.0f kB/s · ↓ %.0f kB/s",
				data.sendKbps or 0,
				data.receiveKbps or 0
			)
		)
	end

	if data.congested ~= nil then
		table.insert(
			list,
			"  Congestion limited    " .. (not data.congested and "no" or format.colorTag(format.COLOR_RED, "<b>YES</b>"))
		)
	end
end

local function locationText(data, p: string?)
	if data == nil then
		return "Connecting…"
	end

	if data.localServer == true then
		return "LOCAL RCC" .. dim(" · this machine, region not applicable") -- inferred equivalent call
	end

	if not p then
		return format.escapeRich(string.format("unknown location (DC %s)", (tostring(data.dataCenterId or "?"))))
	end

	local escapeRich = format.escapeRich

	if data.popCode then
		p = string.upper(data.popCode)
	end

	return escapeRich(p)
end

local Gameplay = {}

function Gameplay.render(data, p, p2, p3: string?)
	local v3 = statsByRegion(p)
	local v4

	if not (data == nil or data.localServer or not data.popCode) then
		v4 = regionOf(data.popCode) -- inferred equivalent call
	end

	local v5

	if v4 then
		v5 = v3[v4]
	end

	local v6

	if data == nil then
		v6 = false
	else
		v6 = data.localServer == true
	end

	local v7 = {}
	table.insert(v7, dim("CONNECTED TO"))
	table.insert(v7, "<b>" .. locationText(data, v4) .. "</b>")

	if data and data.udmuxEndpoint then
		table.insert(v7, "  Edge (UDMUX)          " .. dim(format.escapeRich(data.udmuxEndpoint))) -- inferred equivalent call
	end

	if data and data.rccEndpoint then
		table.insert(v7, "  RCC                   " .. dim(format.escapeRich(data.rccEndpoint))) -- inferred equivalent call
	end

	if data and data.ipVersion then
		table.insert(v7, "  IP version            IPv" .. tostring(data.ipVersion))
	end

	if p3 then
		table.insert(v7, "  Authority             " .. format.escapeRich(v2[p3] or p3))
	end

	local v8 = addPingLines(v7, p2)

	table.insert(v7, "")
	table.insert(v7, dim("CONNECTION"))
	table.insert(v7, "  RakPing               " .. msText(p2.rakMs)) -- inferred equivalent call

	if not v6 then
		addProbeLines(v7, p2, v5)
	end

	if not v8 then
		local v9 = deltaText(p2.dataMs, p2.rakMs) -- inferred equivalent call

		if v9 then
			table.insert(v7, "  Replication overhead  " .. v9)
		end
	end

	local v9

	if not v6 then
		local rakMs = p2.rakMs
		local v10

		if v5 then
			v10 = v5.medianMs
		end

		v9 = deltaText(rakMs, v10) -- inferred equivalent call
	end

	if v9 then
		table.insert(v7, "  RakPing vs probe      " .. v9)
	end

	addPeerLines(v7, p2)

	local v10 = alternatives(v3, v4)

	if #v10 > 0 then
		table.insert(v7, "")
		table.insert(v7, dim(v6 and "PoP REGIONS · probe only" or "OTHER REGIONS · probe only"))

		for _, v11 in v10 do
			local escapeRich = format.escapeRich(v11.region)
			table.insert(v7, string.format("  %-20s  %s%s", escapeRich, msText(v11.medianMs), jitterText(v11.jitterMs))) -- inferred equivalent call
		end
	end

	return table.concat(v7, "\n")
end

function Gameplay.peerStatsPlausible(p: number?, p2: number?): boolean
	return not (p and (p < 0 or p > 1)) and not (p2 and (p2 < 0 or p2 > 1000000))
end

Gameplay.statsByRegion = statsByRegion

function Gameplay.currentRegion(p)
	if p == nil or p.localServer then
		return nil
	end

	if p.popCode then
		return regionOf(p.popCode)
	end

	return nil
end

function Gameplay.recentProbe(items, p: string, p2: number)
	local count = 0
	local total = 0
	local total2 = 0
	local v3 = {}
	local popCodes = {}

	for _, item in items do
		if not (typeof(item.popCode) == "string" and regionOf(item.popCode) == p) then -- inferred equivalent call
			continue
		end

		count += 1
		local committedHistory = format.committedHistory(item.history or {})
		local v4 = {}

		for i = math.max(1, #committedHistory - p2 + 1), #committedHistory do
			table.insert(v4, committedHistory[i])
		end

		local v5 = {}

		for _, v6 in v4 do
			if v6 >= 0 then
				table.insert(v5, v6)
			end
		end

		if p2 <= #v4 and #v5 == 0 then
			table.insert(popCodes, item.popCode)
		else
			total += #v4
			total2 += #v4 - #v5

			for _, v6 in v5 do
				table.insert(v3, v6)
			end
		end
	end

	local loss

	if total > 0 then
		loss = total2 / total
	end

	return {
		loss = loss,
		medianMs = format.historyMedian(v3),
		silentPops = popCodes,
		allSilent = count > 0 and #popCodes == count
	}
end

return Gameplay
