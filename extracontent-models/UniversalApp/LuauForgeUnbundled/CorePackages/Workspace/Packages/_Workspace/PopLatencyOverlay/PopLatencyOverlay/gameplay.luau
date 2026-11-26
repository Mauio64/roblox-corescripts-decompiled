local module = require("@game/CorePackages/Workspace/Packages/_Workspace/PopLatencyOverlay/PopLatencyOverlay/format")

local function regionOf(popCode)
	return string.upper((string.sub(popCode, 1, 3)))
end

local function median(p2)
	return module.historyMedian(p2)
end

local function pooledHistory(items)
	local maxValue = 0

	for k, item in items do
		maxValue = math.max(maxValue, #item)
	end

	local result = table.create(maxValue, -1)

	for i = 0, maxValue - 1 do
		local v5 = {}

		for k, item in items do
			local v6 = item[#item - i]

			if v6 ~= nil and v6 >= 0 then
				table.insert(v5, v6)
			end
		end

		result[maxValue - i] = module.historyMedian(v5) or -1
	end

	return result
end

local function statsByRegion(items)
	local v5 = {}
	local v6 = {}

	for k, item in items do
		if typeof(item.popCode) ~= "string" then
			continue
		end

		local popCode = item.popCode
		local v7 = string.upper((string.sub(popCode, 1, 3)))

		v5[v7] = v5[v7] or {}
		v6[v7] = v6[v7] or {}
		local committedHistory = module.committedHistory(item.history or {})
		local v8 = false

		for k2, v9 in committedHistory do
			if not (v9 >= 0) then
				continue
			end

			table.insert(v5[v7], v9)
			v8 = true
		end

		if not v8 and typeof(item.rttMs) == "number" and item.rttMs >= 0 then
			table.insert(v5[v7], item.rttMs)
		end

		if #committedHistory > 0 then
			table.insert(v6[v7], committedHistory)
		end
	end

	local result = {}

	for k, v7 in v5 do
		local historyMedian = module.historyMedian(v7)

		if not historyMedian then
			continue
		end

		local historyStats, v8, v9 = module.historyStats(v7)

		if not (#v7 >= 2) then
			v9 = nil
		end

		result[k] = {
			medianMs = historyMedian,
			jitterMs = v9,
			history = pooledHistory(v6[k])
		}
	end

	return result
end

local function msText(p2)
	if p2 == nil or p2 < 0 then
		return module.colorTag(module.COLOR_RED, "—")
	end

	return module.colorTag(module.rttColor(p2), string.format("%.0f ms", p2))
end

local function jitterText(p2)
	if p2 then
		return (module.colorTag(module.COLOR_DIM, string.format(" ±%.0f ms jitter", p2)))
	end

	return ""
end

local function alternatives(items, p2)
	local result = {}

	for k, item in items do
		if k ~= p2 then
			table.insert(result, {
				region = k,
				medianMs = item.medianMs,
				jitterMs = item.jitterMs
			})
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

local function dim(p2)
	return module.colorTag(module.COLOR_DIM, p2)
end

local v5 = string.rep(" ", 24)

local function deltaText(p2, p3)
	if p2 and p3 then
		return (module.colorTag(module.COLOR_DIM, string.format("%+.0f ms", p2 - p3)))
	end

	return nil
end

local v6 = { Server = "Server", Automatic = "Client (Automatic)" }

local function addPingLines(list, data)
	local v7 = not (data.lastMs == nil or data.serverMs == nil) and data.clientMs ~= nil
	local dataMs = data.dataMs
	local v9 = if dataMs == nil or dataMs < 0 then module.colorTag(module.COLOR_RED, "—") else module.colorTag(
		module.rttColor(dataMs),
		string.format("%.0f ms", dataMs)
	)
	table.insert(list, "  Data Ping (RCC)       " .. v9)

	if v7 then
		local lastMs = data.lastMs
		local v11 = if lastMs == nil or lastMs < 0 then module.colorTag(module.COLOR_RED, "—") else module.colorTag(
			module.rttColor(lastMs),
			string.format("%.0f ms", lastMs)
		)
		table.insert(list, "  Last ping             " .. v11)
		local serverMs = data.serverMs
		local v13 = if serverMs == nil or serverMs < 0 then module.colorTag(module.COLOR_RED, "—") else module.colorTag(
			module.rttColor(serverMs),
			string.format("%.0f ms", serverMs)
		)
		table.insert(list, "    server              " .. v13)
		local clientMs = data.clientMs
		local v15 = if clientMs == nil or clientMs < 0 then module.colorTag(module.COLOR_RED, "—") else module.colorTag(
			module.rttColor(clientMs),
			string.format("%.0f ms", clientMs)
		)
		table.insert(list, "    client              " .. v15)
		local splitRakMs = data.splitRakMs
		local v17 = if splitRakMs == nil or splitRakMs < 0 then module.colorTag(module.COLOR_RED, "—") else module.colorTag(
			module.rttColor(splitRakMs),
			string.format("%.0f ms", splitRakMs)
		)
		table.insert(list, "    network (RakNet)    " .. v17)
		local v18

		if data.lastMs and data.serverMs and data.clientMs and data.splitRakMs then
			v18 = data.lastMs - (data.serverMs + data.clientMs + data.splitRakMs)
		end

		if v18 and v18 < -10 then
			table.insert(
				list,
				"    unaccounted         " .. module.colorTag(module.COLOR_DIM, "stages out of sync")
			)
		elseif v18 and v18 > 10 then
			local v19 = string.format("+%.0f ms", v18)
			table.insert(list, "    unaccounted         " .. module.colorTag(module.COLOR_DIM, v19))
		end
	end

	if not (data.fps and data.fps > 0) then
		return v7
	end

	local v10 = string.format("%.0f fps", data.fps)
	local v11 = string.format(" · %.1f ms/frame", 1000 / data.fps)
	table.insert(list, "  Client frame rate     " .. v10 .. module.colorTag(module.COLOR_DIM, v11))

	if data.worstFrameMs then
		local v12 = string.format("worst frame %.0f ms", data.worstFrameMs)
		local v14 = if data.worstFrameMs >= 100 then module.colorTag(module.COLOR_RED, v12) else module.colorTag(module.COLOR_DIM, v12)
		table.insert(list, v5 .. v14)
	end

	return v7
end

local function addProbeLines(list, data, data2)
	local medianMs = if data2 then data2.medianMs else nil
	local v8

	if medianMs == nil or medianMs < 0 then
		v8 = module.colorTag(module.COLOR_RED, "—")
	else
		v8 = module.colorTag(module.rttColor(medianMs), string.format("%.0f ms", medianMs))
	end

	local jitterMs = if data2 then data2.jitterMs else nil
	table.insert(
		list,
		"  PoP probe             " .. v8 .. (not jitterMs and "" or module.colorTag(
			module.COLOR_DIM,
			string.format(" ±%.0f ms jitter", jitterMs)
		))
	)

	if data2 and #data2.history > 0 then
		table.insert(list, v5 .. module.sparkline(data2.history))
	end

	if data.probeIntervalMs and data.probeIntervalMs > 0 then
		local probeTargets = data.probeTargets or {}

		local v9 = string.format("  Probe rate            %.0f/s", 1000 / data.probeIntervalMs)

		local v10 = string.format(
			" · every %.0f ms · %d PoP%s",
			data.probeIntervalMs,
			#probeTargets,
			#probeTargets == 1 and "" or "s"
		)
		table.insert(list, v9 .. module.colorTag(module.COLOR_DIM, v10))
	end

	if data.probeDown then
		table.insert(
			list,
			"  Probe loss (1 s)      " .. module.colorTag(
				module.COLOR_DIM,
				"no replies · probe server may be draining"
			)
		)
	elseif data.probeLoss then
		local v9 = string.format("%.0f %%", data.probeLoss * 100)
		local probeSilentPops = data.probeSilentPops

		if data.probeLoss > 0 then
			v9 = module.colorTag(module.COLOR_RED, v9)
		end

		local v11 = not (probeSilentPops and #probeSilentPops > 0) and " · your link to the edge"
			or " · " .. module.escapeRich(table.concat(probeSilentPops, ", ")) .. " not answering"
		table.insert(list, "  Probe loss (1 s)      " .. v9 .. module.colorTag(module.COLOR_DIM, v11))
	end
end

local function addPeerLines(list, data)
	if data.peerStatsInvalid then
		table.insert(list, "  RakNet peer stats     " .. module.colorTag(module.COLOR_DIM, "unavailable"))
	end

	if data.loss then
		local v7 = string.format("%.1f %%", data.loss * 100)

		if data.loss >= 0.01 then
			v7 = module.colorTag(module.COLOR_RED, v7)
		end

		table.insert(list, "  Packet loss           " .. v7)
	end

	if data.resendMsgs then
		local format = string.format

		local resendMsgs = data.resendMsgs
		local v8 = data.resendMsgs == 1 and "msg" or "msgs"
		local v9

		if data.resendBytes then
			local v10 = string.format(" · %.1f KB", data.resendBytes / 1024)
			v9 = module.colorTag(module.COLOR_DIM, v10)
		else
			v9 = ""
		end

		table.insert(list, format("  Resend queue          %d %s%s", resendMsgs, v8, v9))
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
			"  Congestion limited    " .. (not data.congested and "no" or module.colorTag(module.COLOR_RED, "<b>YES</b>"))
		)
	end
end

local function locationText(data, p2)
	if data == nil then
		return "Connecting…"
	end

	if data.localServer == true then
		return "LOCAL RCC" .. module.colorTag(module.COLOR_DIM, " · this machine, region not applicable")
	end

	if not p2 then
		return module.escapeRich(string.format(
			"unknown location (DC %s)",
			(tostring(data.dataCenterId or "?"))
		))
	end

	local escapeRich = module.escapeRich

	if data.popCode then
		p2 = string.upper(data.popCode)
	end

	return escapeRich(p2)
end

return {
	render = function(data, p2, p3, p4)
		local v7 = statsByRegion(p2)
		local v8

		if not (data == nil or data.localServer or not data.popCode) then
			local popCode = data.popCode
			v8 = string.upper((string.sub(popCode, 1, 3)))
		end

		local v9 = if v8 then v7[v8] else nil
		local v10 = not (data == nil) and data.localServer == true

		local v11 = {}
		table.insert(v11, dim("CONNECTED TO"))
		table.insert(v11, "<b>" .. locationText(data, v8) .. "</b>")

		if data and data.udmuxEndpoint then
			local escapeRich = module.escapeRich(data.udmuxEndpoint)
			table.insert(v11, "  Edge (UDMUX)          " .. module.colorTag(module.COLOR_DIM, escapeRich))
		end

		if data and data.rccEndpoint then
			local escapeRich = module.escapeRich(data.rccEndpoint)
			table.insert(v11, "  RCC                   " .. module.colorTag(module.COLOR_DIM, escapeRich))
		end

		if data and data.ipVersion then
			table.insert(v11, "  IP version            IPv" .. tostring(data.ipVersion))
		end

		if p4 then
			table.insert(v11, "  Authority             " .. module.escapeRich(v6[p4] or p4))
		end

		local v12 = addPingLines(v11, p3)

		table.insert(v11, "")
		table.insert(v11, dim("CONNECTION"))
		local rakMs = p3.rakMs
		local v14 = if rakMs == nil or rakMs < 0 then module.colorTag(module.COLOR_RED, "—") else module.colorTag(
			module.rttColor(rakMs),
			string.format("%.0f ms", rakMs)
		)
		table.insert(v11, "  RakPing               " .. v14)

		if not v10 then
			addProbeLines(v11, p3, v9)
		end

		if not v12 then
			local dataMs = p3.dataMs
			local rakMs2 = p3.rakMs
			local v15

			if dataMs and rakMs2 then
				v15 = module.colorTag(module.COLOR_DIM, string.format("%+.0f ms", dataMs - rakMs2))
			end

			if v15 then
				table.insert(v11, "  Replication overhead  " .. v15)
			end
		end

		local v15

		if not v10 then
			local rakMs2 = p3.rakMs
			local medianMs = if v9 then v9.medianMs else nil

			if rakMs2 and medianMs then
				v15 = module.colorTag(module.COLOR_DIM, string.format("%+.0f ms", rakMs2 - medianMs))
			end
		end

		if v15 then
			table.insert(v11, "  RakPing vs probe      " .. v15)
		end

		addPeerLines(v11, p3)

		local v16 = alternatives(v7, v8)

		if #v16 > 0 then
			table.insert(v11, "")
			table.insert(v11, dim(v10 and "PoP REGIONS · probe only" or "OTHER REGIONS · probe only"))

			for k, v17 in v16 do
				local format = string.format

				local escapeRich = module.escapeRich(v17.region)
				local medianMs = v17.medianMs
				local v19

				if medianMs == nil or medianMs < 0 then
					v19 = module.colorTag(module.COLOR_RED, "—")
				else
					v19 = module.colorTag(module.rttColor(medianMs), string.format("%.0f ms", medianMs))
				end

				local jitterMs = v17.jitterMs
				table.insert(
					v11,
					format(
						"  %-20s  %s%s",
						escapeRich,
						v19,
						not jitterMs and "" or module.colorTag(
							module.COLOR_DIM,
							string.format(" ±%.0f ms jitter", jitterMs)
						)
					)
				)
			end
		end

		return table.concat(v11, "\n")
	end,
	peerStatsPlausible = function(p2, p3): boolean
		if p2 and (p2 < 0 or p2 > 1) or p3 and (p3 < 0 or p3 > 1000000) then
			return false
		end

		return true
	end,
	statsByRegion = statsByRegion,
	currentRegion = function(p2)
		if p2 == nil or p2.localServer then
			return nil
		end

		if p2.popCode then
			return regionOf(p2.popCode)
		end

		return nil
	end,
	recentProbe = function(items, p2, p3)
		local count = 0
		local total = 0
		local total2 = 0
		local v7 = {}
		local popCodes = {}

		for k, item in items do
			if typeof(item.popCode) ~= "string" then
				continue
			end

			local popCode = item.popCode

			if string.upper((string.sub(popCode, 1, 3))) ~= p2 then
				continue
			end

			count += 1
			local committedHistory = module.committedHistory(item.history or {})
			local v8 = {}

			for i = math.max(1, #committedHistory - p3 + 1), #committedHistory do
				table.insert(v8, committedHistory[i])
			end

			local v9 = {}

			for k2, v10 in v8 do
				if v10 >= 0 then
					table.insert(v9, v10)
				end
			end

			if p3 <= #v8 and #v9 == 0 then
				table.insert(popCodes, item.popCode)
			else
				total += #v8
				total2 += #v8 - #v9

				for k2, v10 in v9 do
					table.insert(v7, v10)
				end
			end
		end

		local v9 = if total > 0 then total2 / total else nil
		return {
			loss = v9,
			medianMs = module.historyMedian(v7),
			silentPops = popCodes,
			allSilent = count > 0 and #popCodes == count
		}
	end
}
