local v = {
	" ",
	"▁",
	"▂",
	"▃",
	"▄",
	"▅",
	"▆",
	"▇",
	"█"
}

local color = Color3.fromRGB(14, 14, 18)
local color2 = Color3.fromRGB(70, 180, 200)
local color3 = Color3.fromRGB(255, 255, 255)
local color4 = Color3.fromRGB(140, 140, 150)
local color5 = Color3.fromRGB(200, 200, 220)
local color6 = Color3.fromRGB(220, 90, 90)
local color7 = Color3.fromRGB(80, 220, 100)
local color8 = Color3.fromRGB(220, 200, 80)
local color9 = Color3.fromRGB(220, 80, 80)
local color10 = Color3.fromRGB(110, 110, 120)

local function rttColor(p: number) -- 3 equivalent calls inferred from this helper
	if p < 0 then
		return color10
	end

	if p < 30 then
		return color7
	end

	return if p < 80 then color8 else color9
end

local function rgbTag(color11: Color3) -- 1 equivalent call inferred from this helper
	return string.format(
		"rgb(%d,%d,%d)",
		math.floor(color11.R * 255),
		math.floor(color11.G * 255),
		(math.floor(color11.B * 255))
	)
end

local function colorTag(color11: Color3, p: string) -- 20 equivalent calls inferred from this helper
	return string.format("<font color=\"%s\">%s</font>", rgbTag(color11), p) -- inferred equivalent call
end

local function escapeRich(value: string) -- 11 equivalent calls inferred from this helper
	return (value:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function glyphPad(count: number) -- 4 equivalent calls inferred from this helper
	return "<font transparency=\"1\">" .. string.rep("█", count) .. "</font>"
end

local function cellPad(count: number, flag: boolean?) -- 2 equivalent calls inferred from this helper
	if flag then
		return glyphPad(count) -- inferred equivalent call
	end

	return (colorTag(color10, string.rep(" ", count))) -- inferred equivalent call
end

local function bar(p: number)
	if p < 0 then
		return colorTag(color10, string.rep("░", 18))
	end

	local v2 = math.max(1, (math.min(18, (math.floor(math.min(p / 300, 1) * 18 + 0.5)))))
	local v3 = 18 - v2
	return colorTag(rttColor(p), string.rep("█", v2)) .. colorTag(color10, string.rep("▒", v3)) -- inferred equivalent call
end

local function sparkline(list, flag: boolean?)
	if list and #list ~= 0 then
		local v2 = 1

		for _, item in ipairs(list) do
			if item >= 0 and v2 < item then
				v2 = item
			end
		end

		local v3 = 12 - #list
		local v4 = {}

		if v3 > 0 then
			table.insert(v4, cellPad(v3, flag)) -- inferred equivalent call
		end

		for _, item in ipairs(list) do
			if item < 0 then
				table.insert(v4, colorTag(color10, flag and "░" or "×"))
			else
				local v5 = math.min(#v, (math.max(1, (math.floor(item / v2 * (#v - 1) + 1)))))
				local v6

				if v5 == 1 and flag then
					v6 = glyphPad(1) -- inferred equivalent call
				else
					v6 = colorTag(rttColor(item), v[v5]) -- inferred equivalent call
				end

				table.insert(v4, v6)
			end
		end

		return table.concat(v4)
	end

	return cellPad(12, flag) -- inferred equivalent call
end

local function committedHistory(history)
	local v2 = nil

	for i = 1, #history do
		local item = history[i]

		if item and item >= 0 then
			v2 = i
			break
		end
	end

	if not v2 then
		return {}
	end

	local result = {}

	for i = v2, #history do
		result[#result + 1] = history[i]
	end

	return result
end

local function historyStats(list)
	local count = 0
	local total = 0
	local count2 = 0

	for _, item in ipairs(list) do
		if item < 0 then
			count += 1
		else
			total += item
			count2 += 1
		end
	end

	local v2

	if count2 >= 2 then
		local v3 = total / count2
		local total2 = 0

		for _, item in ipairs(list) do
			if item >= 0 then
				total2 += (item - v3) * (item - v3)
			end
		end

		v2 = math.sqrt(total2 / count2)
	else
		v2 = 0
	end

	return #list, count, v2
end

local function historyMedian(list)
	local v2 = {}

	for _, item in ipairs(list) do
		if item >= 0 then
			v2[#v2 + 1] = item
		end
	end

	if #v2 == 0 then
		return nil
	end

	table.sort(v2)
	local count = #v2

	if count % 2 == 1 then
		return v2[(count + 1) // 2]
	end

	return (v2[count // 2] + v2[count // 2 + 1]) / 2
end

local function historyMean(list) -- 2 equivalent calls inferred from this helper
	local total = 0
	local count = 0

	for _, item in ipairs(list) do
		if not (item >= 0) then
			continue
		end

		total += item
		count += 1
	end

	if count == 0 then
		return nil
	end

	return total / count
end

local function statsCell(p)
	local v2, v3, v4 = historyStats(p)

	if v2 == 0 then
		return colorTag(color10, escapeRich(string.format("%-" .. 11 .. "s", "—"))) -- inferred equivalent call
	end

	local v5 = math.floor(v3 / v2 * 100 + 0.5)
	local v6 = string.format("%d%% ±%dms", v5, (math.floor(v4 + 0.5)))
	return colorTag(
		v3 == 0 and color7 or v5 >= 25 and color9 or color8,
		escapeRich(string.format("%-" .. 11 .. "s", v6)) -- inferred equivalent call
	)
end

local function rttCell(p: number?)
	if not p or p < 0 then
		return colorTag(color10, string.rep(" ", 7) .. "—")
	end

	local v2 = string.format("%" .. 8 .. "s", string.format("%.1fms", p))
	return colorTag(rttColor(p), escapeRich(v2)) -- inferred equivalent call
end

local function timeoutCell() -- 2 equivalent calls inferred from this helper
	return colorTag(color10, escapeRich(string.format("%" .. 8 .. "s", "timeout"))) -- inferred equivalent call
end

local function formatInterval(p: number)
	if not p or p <= 0 then
		return "?"
	end

	local v2 = math.floor(p / 1000 + 0.5)

	if v2 < 60 then
		return string.format("%ds", v2)
	end

	local v3 = v2 / 60

	if v3 == math.floor(v3) then
		return string.format("%dm", v3)
	end

	return string.format("%.1fm", v3)
end

local function formatElapsed(p: number)
	local v2 = math.max(0, (math.floor(p)))
	local v3 = math.floor(v2 / 3600)
	local v4 = math.floor(v2 % 3600 / 60)
	local v5 = v2 % 60
	return string.format("%d:%02d:%02d", v3, v4, v5)
end

local function formatIp(value: string)
	local v2 = {}

	for k in value:gmatch("[^.]+") do
		table.insert(v2, string.format("%3s", k))
	end

	return table.concat(v2, ".")
end

local function separator(count: number?)
	return colorTag(color2, string.rep("─", count or 96))
end

local function vipCell(ipString: string, port: number?, flag: boolean, value: number?)
	local v2 = value or 20
	local v3 = ":" .. tostring(not (port and port > 0 and port) and 3478 or port)
	local v4

	if flag then
		local v5 = v2 - #v3 - 2

		if #ipString <= v5 then
			v4 = "[" .. ipString .. "]" .. v3
		else
			local v6 = v5 - 1
			local v7 = math.ceil(v6 / 2)
			local v8 = ipString:sub(1, v7)
			local v9 = ipString:sub(#ipString - (v6 - v7) + 1)
			local match = v8:match("^(.*:)[^:]*$")

			if match and #match * 2 >= #v8 then
				v8 = match
			end

			local match2 = v9:match("^[^:]*(:.*)$")

			if match2 and #match2 * 2 >= #v9 then
				v9 = match2
			end

			v4 = "[" .. v8 .. "~" .. v9 .. "]" .. v3
		end
	else
		v4 = formatIp(ipString) .. v3
	end

	local v5 = utf8.len(v4) or #v4
	return colorTag(color4, escapeRich(v4 .. string.rep(" ", (math.max(0, v2 - v5))))) -- inferred equivalent call
end

local v2 = "    └ v6" .. string.rep(" ", 6)

local v3 = "    └ v6 dbg" .. string.rep(" ", 2)

local function ipv6DeltaCell(p: number?, p2: number?) -- 1 equivalent call inferred from this helper
	if not (p and p2) then
		return ""
	end

	local v4 = p - p2
	return "   " .. colorTag(v4 <= 0 and color7 or color9, escapeRich(string.format("Δ %+.1fms", v4))) -- inferred equivalent call
end

local function renderIpv6Row(data, __med: number?, value: number)
	local v4 = committedHistory(data.history or {})
	local v5

	if data.rttMs == nil then
		v5 = false
	else
		v5 = data.rttMs >= 0
	end

	local v6

	if v5 then
		v6 = historyMedian(v4) or nil
	end

	local v7

	if v5 then
		v7 = historyMean(v4) or nil -- inferred equivalent call
	end

	local v8 = v5 and rttCell(data.rttMs) or timeoutCell() -- inferred equivalent call
	local v9 = colorTag(color4, data.debug and v3 or v2) -- inferred equivalent call
	return v9 .. rttCell(v6) .. " " .. rttCell(v7) .. " " .. v8 .. "   " .. statsCell(v4) .. "   " .. vipCell(
		tostring(data.ipString or "?"),
		tonumber(data.port),
		true,
		value
	) .. "   " .. bar(v6 or -1) .. "   " .. sparkline(v4, true) .. ipv6DeltaCell(v6, __med) -- inferred equivalent call
end

local function renderPopRows(list, data, p: string, flag: boolean, value: number, flag2: boolean)
	local popCode = tostring(data.popCode or "?")
	local ipString = tostring(data.ipString or "—")

	local v4 = colorTag(flag and color3 or color4, escapeRich(string.format("%-10s", popCode))) -- inferred equivalent call
	local v5

	if flag then
		v5 = data.__med or nil
	end

	local v6 = rttCell(v5)
	local v7

	if flag then
		v7 = data.__avg or nil
	end

	local v8 = rttCell(v7)

	local v9 = flag and rttCell(data.rttMs) or timeoutCell() -- inferred equivalent call

	local v10 = statsCell(data.__hist)

	local port = tonumber(data.port)
	local v11 = ":" .. tostring(not (port and port > 0 and port) and 3478 or port)

	local v12 = formatIp(ipString) .. v11

	local v13 = utf8.len(v12) or #v12
	table.insert(
		list,
		p .. " " .. v4 .. v6 .. " " .. v8 .. " " .. v9 .. "   " .. v10 .. "   " .. colorTag( -- inferred equivalent call
			color4,
			escapeRich(v12 .. string.rep(" ", (math.max(0, (value or 20) - v13)))) -- inferred equivalent call
		) .. "   " .. bar(flag and data.__sort or -1) .. "   " .. sparkline(data.__hist, flag2)
	)

	if data.v6 then
		table.insert(list, renderIpv6Row(data.v6, flag and data.__med or nil, value))
	end
end

local function prepareRows(list)
	local result = {}
	local result2 = {}

	for _, item in ipairs(list) do
		item.__hist = committedHistory(item.history or {})

		if item.rttMs and item.rttMs >= 0 then
			item.__med = historyMedian(item.__hist)
			item.__avg = historyMean(item.__hist) -- inferred equivalent call
			item.__sort = item.__med or item.rttMs
			table.insert(result, item)
		else
			table.insert(result2, item)
		end
	end

	table.sort(result, function(a, b): boolean
		return a.__sort < b.__sort
	end)

	table.sort(result2, function(a, b): boolean
		return tostring(a.popCode) < tostring(b.popCode)
	end)

	return result, result2
end

local function anyIpv6Enabled(list): boolean -- 1 equivalent call inferred from this helper
	for _, item in ipairs(list) do
		if item.ipv6Enabled then
			return true
		end
	end

	return false
end

return {
	POLL_INTERVAL_SECONDS = 1,
	HISTORY_LEN = 12,
	TEXT_SIZE = 14,
	SEP_WIDTH = 96,
	COLOR_BG = color,
	COLOR_BORDER = color2,
	COLOR_HEADER = color5,
	COLOR_DIM = color4,
	COLOR_CLOSE = color6,
	COLOR_RED = color9,
	rttColor = rttColor,
	colorTag = colorTag,
	escapeRich = escapeRich,
	bar = bar,
	sparkline = sparkline,
	rttCell = rttCell,
	formatIp = formatIp,
	vipCell = vipCell,
	separator = separator,
	formatInterval = formatInterval,
	formatElapsed = formatElapsed,
	committedHistory = committedHistory,
	historyStats = historyStats,
	historyMedian = historyMedian,
	historyMean = historyMean,
	renderSnapshot = function(list, p: number, p2: number, p3: number)
		local v4 = {}
		local v5 = {}

		for _, item in ipairs(list) do
			table.insert(item.debug and v4 or v5, item)
		end

		local v6, v7 = prepareRows(v5)
		local v8, v9 = prepareRows(v4)
		local v10 = false

		for _, item in ipairs(list) do
			if item.v6 then
				v10 = true
				break
			end
		end

		local v11 = v10 and 107 or 96
		local v12 = 20

		for _, item in ipairs(list) do
			if v10 or (tonumber(item.port) or 0) >= 10000 then
				v12 = 21
				break
			end
		end

		local v13 = 0
		local v14 = {}

		for _, item in ipairs(list) do
			local lastSampleEpochMs = item.lastSampleEpochMs or 0

			if v13 < lastSampleEpochMs then
				v13 = lastSampleEpochMs
			end
		end

		local v15

		if v13 > 0 and p3 and p3 > 0 then
			local v16 = math.max(0, (math.floor((v13 + p3 - os.time() * 1000) / 1000 + 0.5)))
			v15 = string.format("   next %ds", v16)
		else
			v15 = ""
		end

		local v16 = string.format("probe #%d   every %s%s   up %s", p, formatInterval(p3), v15, formatElapsed(p2))
		local v17 = anyIpv6Enabled(list) -- inferred equivalent call
		local v18 = v17 and "[engine] [v6 enabled]" or "[engine]"
		local v19 = v11 - #("Roblox TURN/STUN UDP Latency Monitor " .. v18 .. "   " .. v16)
		local v20 = v19 < 3 and 3 or v19
		local v21 = colorTag(color3, "Roblox TURN/STUN UDP Latency Monitor") -- inferred equivalent call
		local v22 = colorTag(color4, v18) -- inferred equivalent call
		table.insert(v14, v21 .. " " .. v22 .. string.rep(" ", v20) .. colorTag(color4, v16)) -- inferred equivalent call
		table.insert(v14, separator(v11))

		local v23 = "%" .. 8 .. "s"
		local v24 = "%-3s %-10s" .. v23 .. " " .. v23 .. " " .. v23 .. "   " .. ("%-" .. 11 .. "s") .. "   " .. ("%-" .. v12 .. "s") .. "   "
		local v25 = escapeRich(string.format(v24, "#", "PoP", "Med RTT", "Avg RTT", "Last RTT", "Loss/Jit", "TURN VIP")) -- inferred equivalent call
		local v26

		if v17 then
			v26 = glyphPad(15) -- inferred equivalent call
		else
			v26 = string.rep(" ", 15)
		end

		table.insert(
			v14,
			colorTag(color5, v25 .. "Bar" .. v26 .. "   Trend" .. (not v10 and "" or glyphPad(7) .. "   Δ v6")) -- inferred equivalent call
		)
		table.insert(v14, separator(v11))
		local v27 = 1

		for _, v28 in ipairs(v6) do
			renderPopRows(v14, v28, colorTag(color4, escapeRich(string.format("%2d.", v27))), true, v12, v17) -- inferred equivalent call
			v27 += 1
		end

		for _, v28 in ipairs(v7) do
			renderPopRows(v14, v28, colorTag(color10, " — "), false, v12, v17) -- inferred equivalent call
		end

		if #v4 > 0 then
			table.insert(v14, colorTag(color4, escapeRich("debug — public STUN servers, not Roblox PoPs"))) -- inferred equivalent call

			for _, v28 in ipairs(v8) do
				renderPopRows(v14, v28, colorTag(color4, " · "), true, v12, v17) -- inferred equivalent call
			end

			for _, v28 in ipairs(v9) do
				renderPopRows(v14, v28, colorTag(color10, " — "), false, v12, v17) -- inferred equivalent call
			end
		end

		table.insert(v14, separator(v11))
		local count = 0
		local total = 0
		local v28 = nil
		local v29 = nil
		local popCode = nil
		local popCode2 = nil

		for _, v30 in ipairs(v6) do
			count += 1
			local __sort = v30.__sort
			total += __sort

			if not v28 or __sort < v28 then
				popCode = tostring(v30.popCode)
				v28 = __sort
			end

			if not (not v29 or v29 < __sort) then
				continue
			end

			popCode2 = tostring(v30.popCode)
			v29 = __sort
		end

		local v30 = count > 0 and total / count or 0
		local v31 = #v7
		local v32 = {}

		if popCode then
			table.insert(v32, "best " .. colorTag(color7, string.format("%s %.1fms", popCode, v28))) -- inferred equivalent call
		end

		if popCode2 then
			table.insert(v32, "worst " .. colorTag(color9, string.format("%s %.1fms", popCode2, v29))) -- inferred equivalent call
		end

		if count > 0 then
			table.insert(v32, "avg " .. colorTag(color8, string.format("%.1fms", v30))) -- inferred equivalent call
		end

		local v37 = string.format("%d ok   ", count)
		table.insert(v32, v37 .. colorTag(color10, string.format("%d timeout", v31))) -- inferred equivalent call
		local count2 = 0
		local count3 = 0

		for _, v38 in ipairs(v5) do
			if not v38.v6 or v38.v6.debug then
				continue
			end

			count2 += 1

			if v38.v6.rttMs and v38.v6.rttMs >= 0 then
				count3 += 1
			end
		end

		if count2 > 0 then
			table.insert(
				v32,
				"v6 " .. colorTag(count3 > 0 and color7 or color9, string.format("%d/%d ok", count3, count2)) -- inferred equivalent call
			)
		end

		table.insert(v14, (table.concat(v32, "   │   ")))

		return table.concat(v14, "\n")
	end
}
