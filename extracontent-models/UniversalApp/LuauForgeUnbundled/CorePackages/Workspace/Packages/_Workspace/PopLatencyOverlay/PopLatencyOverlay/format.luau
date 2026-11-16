local v5 = {
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

local function rgbTag(data)
	return string.format(
		"rgb(%d,%d,%d)",
		math.floor(data.R * 255),
		math.floor(data.G * 255),
		(math.floor(data.B * 255))
	)
end

local function colorTag(data, p2)
	return string.format(
		"<font color=\"%s\">%s</font>",
		string.format(
			"rgb(%d,%d,%d)",
			math.floor(data.R * 255),
			math.floor(data.G * 255),
			(math.floor(data.B * 255))
		),
		p2
	)
end

local function glyphPad(count)
	return "<font transparency=\"1\">" .. string.rep("█", count) .. "</font>"
end

local function cellPad(count, p2)
	if p2 then
		return "<font transparency=\"1\">" .. string.rep("█", count) .. "</font>"
	end

	local v6 = color10
	local v7 = string.rep(" ", count)
	return (string.format(
		"<font color=\"%s\">%s</font>",
		string.format(
			"rgb(%d,%d,%d)",
			math.floor(v6.R * 255),
			math.floor(v6.G * 255),
			(math.floor(v6.B * 255))
		),
		v7
	))
end

local function bar(p2)
	if p2 < 0 then
		return colorTag(color10, string.rep("░", 18))
	end

	local v6 = math.max(1, (math.min(18, (math.floor(math.min(p2 / 300, 1) * 18 + 0.5)))))
	local v7 = 18 - v6
	local v8 = if p2 < 0 then color10 elseif p2 < 30 then color7 elseif p2 < 80 then color8 else color9

	local v9 = string.rep("█", v6)
	local v10 = string.format(
		"<font color=\"%s\">%s</font>",
		string.format(
			"rgb(%d,%d,%d)",
			math.floor(v8.R * 255),
			math.floor(v8.G * 255),
			(math.floor(v8.B * 255))
		),
		v9
	)

	local v11 = color10
	local v12 = string.rep("▒", v7)
	return v10 .. string.format(
		"<font color=\"%s\">%s</font>",
		string.format(
			"rgb(%d,%d,%d)",
			math.floor(v11.R * 255),
			math.floor(v11.G * 255),
			(math.floor(v11.B * 255))
		),
		v12
	)
end

local function sparkline(list, p2)
	if list and #list ~= 0 then
		local v6 = 1

		for i, item in ipairs(list) do
			if item >= 0 and v6 < item then
				v6 = item
			end
		end

		local v7 = 12 - #list
		local v8 = {}

		if v7 > 0 then
			local v9

			if p2 then
				v9 = "<font transparency=\"1\">" .. string.rep("█", v7) .. "</font>"
			else
				local v10 = color10
				local v11 = string.rep(" ", v7)
				v9 = string.format(
					"<font color=\"%s\">%s</font>",
					string.format(
						"rgb(%d,%d,%d)",
						math.floor(v10.R * 255),
						math.floor(v10.G * 255),
						(math.floor(v10.B * 255))
					),
					v11
				)
			end

			table.insert(v8, v9)
		end

		for i, item in ipairs(list) do
			if item < 0 then
				table.insert(v8, colorTag(color10, p2 and "░" or "×"))
			else
				local v9 = math.min(#v5, (math.max(1, (math.floor(item / v6 * (#v5 - 1) + 1)))))
				local v10

				if v9 == 1 and p2 then
					v10 = "<font transparency=\"1\">" .. string.rep("█", 1) .. "</font>"
				else
					local v11

					if item < 0 then
						v11 = color10
					else
						v11 = if item < 30 then color7 elseif item < 80 then color8 else color9
					end

					local v12 = v5[v9]
					v10 = string.format(
						"<font color=\"%s\">%s</font>",
						string.format(
							"rgb(%d,%d,%d)",
							math.floor(v11.R * 255),
							math.floor(v11.G * 255),
							(math.floor(v11.B * 255))
						),
						v12
					)
				end

				table.insert(v8, v10)
			end
		end

		return table.concat(v8)
	else
		if p2 then
			return "<font transparency=\"1\">" .. string.rep("█", 12) .. "</font>"
		end

		local v6 = color10
		local v7 = string.rep(" ", 12)
		return (string.format(
			"<font color=\"%s\">%s</font>",
			string.format(
				"rgb(%d,%d,%d)",
				math.floor(v6.R * 255),
				math.floor(v6.G * 255),
				(math.floor(v6.B * 255))
			),
			v7
		))
	end
end

local function committedHistory(history)
	local v6 = nil

	for i = 1, #history do
		local item = history[i]

		if item and item >= 0 then
			v6 = i
			break
		end
	end

	if not v6 then
		return {}
	end

	local result = {}

	for i = v6, #history do
		result[#result + 1] = history[i]
	end

	return result
end

local function historyStats(list)
	local count = 0
	local total = 0
	local count2 = 0

	for i, item in ipairs(list) do
		if item < 0 then
			count += 1
		else
			total += item
			count2 += 1
		end
	end

	local v6

	if count2 >= 2 then
		local v7 = total / count2
		local total2 = 0

		for i, item in ipairs(list) do
			if item >= 0 then
				total2 += (item - v7) * (item - v7)
			end
		end

		v6 = (math.sqrt)(total2 / count2)
	else
		v6 = 0
	end

	return #list, count, v6
end

local function historyMedian(list)
	local v6 = {}

	for i, item in ipairs(list) do
		if item >= 0 then
			v6[#v6 + 1] = item
		end
	end

	if #v6 == 0 then
		return nil
	end

	table.sort(v6)
	local count = #v6

	if count % 2 == 1 then
		return v6[(count + 1) // 2]
	end

	return (v6[count // 2] + v6[count // 2 + 1]) / 2
end

local function statsCell(p2)
	local v6, v7, v8 = historyStats(p2)

	if v6 == 0 then
		return colorTag(
			color10,
			string.format("%-" .. 11 .. "s", "—"):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
		)
	end

	local v9 = math.floor(v7 / v6 * 100 + 0.5)
	local v10 = string.format("%d%% ±%dms", v9, (math.floor(v8 + 0.5)))
	return colorTag(
		v7 == 0 and color7 or v9 >= 25 and color9 or color8,
		string.format("%-" .. 11 .. "s", v10):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
	)
end

local function rttCell(p2)
	if not p2 or p2 < 0 then
		return colorTag(color10, string.rep(" ", 7) .. "—")
	end

	local v6 = string.format("%" .. 8 .. "s", string.format("%.1fms", p2))
	local v8 = if p2 < 0 then color10 elseif p2 < 30 then color7 elseif p2 < 80 then color8 else color9

	return colorTag(v8, v6:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function timeoutCell()
	return colorTag(
		color10,
		string.format("%" .. 8 .. "s", "timeout"):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
	)
end

local function formatInterval(p2)
	if not p2 or p2 <= 0 then
		return "?"
	end

	local v6 = math.floor(p2 / 1000 + 0.5)

	if v6 < 60 then
		return string.format("%ds", v6)
	end

	local v7 = v6 / 60

	if v7 == math.floor(v7) then
		return string.format("%dm", v7)
	end

	return string.format("%.1fm", v7)
end

local function formatElapsed(p2)
	local v6 = math.max(0, (math.floor(p2)))
	local v7 = math.floor(v6 / 3600)
	local v8 = math.floor(v6 % 3600 / 60)
	local v9 = v6 % 60
	return string.format("%d:%02d:%02d", v7, v8, v9)
end

local function formatIp(value)
	local v6 = {}

	for k in value:gmatch("[^.]+") do
		table.insert(v6, string.format("%3s", k))
	end

	return table.concat(v6, ".")
end

local function separator(count)
	return colorTag(color2, string.rep("─", count or 96))
end

local function vipCell(ipString, port, p2, value)
	local v6 = value or 20
	local v7 = ":" .. tostring(not (port and port > 0 and port) and 3478 or port)
	local v8

	if p2 then
		local v9 = v6 - #v7 - 2

		if #ipString <= v9 then
			v8 = "[" .. ipString .. "]" .. v7
		else
			local v10 = v9 - 1
			local v11 = math.ceil(v10 / 2)
			local v12 = ipString:sub(1, v11)
			local v13 = ipString:sub(#ipString - (v10 - v11) + 1)
			local match = v12:match("^(.*:)[^:]*$")

			if match and #match * 2 >= #v12 then
				v12 = match
			end

			local match2 = v13:match("^[^:]*(:.*)$")

			if match2 and #match2 * 2 >= #v13 then
				v13 = match2
			end

			v8 = "[" .. v12 .. "~" .. v13 .. "]" .. v7
		end
	else
		v8 = formatIp(ipString) .. v7
	end

	local v9 = utf8.len(v8) or #v8
	return colorTag(
		color4,
		(v8 .. string.rep(" ", (math.max(0, v6 - v9)))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(
			">",
			"&gt;"
		)
	)
end

local v6 = "    └ v6" .. string.rep(" ", 6)

local v7 = "    └ v6 dbg" .. string.rep(" ", 2)

local function ipv6DeltaCell(p2, p3)
	if not (p2 and p3) then
		return ""
	end

	local v8 = p2 - p3
	local v9 = v8 <= 0 and color7 or color9
	local v10 = string.format("Δ %+.1fms", v8):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
	return "   " .. string.format(
		"<font color=\"%s\">%s</font>",
		string.format(
			"rgb(%d,%d,%d)",
			math.floor(v9.R * 255),
			math.floor(v9.G * 255),
			(math.floor(v9.B * 255))
		),
		v10
	)
end

local function renderIpv6Row(data, __med, value)
	local v8 = committedHistory(data.history or {})

	local v9 = not (data.rttMs == nil) and data.rttMs >= 0
	local v10 = if v9 then historyMedian(v8) or nil else nil
	local v11

	if v9 then
		local total = 0
		local count = 0

		for i, v12 in ipairs(v8) do
			if not (v12 >= 0) then
				continue
			end

			total += v12
			count += 1
		end

		if count ~= 0 then
			v11 = total / count
		end

		if not v11 then
			v11 = nil
		end
	end

	local v12 = v9 and rttCell(data.rttMs)

	if not v12 then
		local v13 = color10
		local v14 = string.format("%" .. 8 .. "s", "timeout"):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(
			">",
			"&gt;"
		)
		v12 = string.format(
			"<font color=\"%s\">%s</font>",
			string.format(
				"rgb(%d,%d,%d)",
				math.floor(v13.R * 255),
				math.floor(v13.G * 255),
				(math.floor(v13.B * 255))
			),
			v14
		)
	end

	local v13 = color4
	local v14 = data.debug and v7 or v6
	local v15 = string.format(
		"<font color=\"%s\">%s</font>",
		string.format(
			"rgb(%d,%d,%d)",
			math.floor(v13.R * 255),
			math.floor(v13.G * 255),
			(math.floor(v13.B * 255))
		),
		v14
	)

	local v16 = rttCell(v10)

	local v18 = rttCell(v11)

	local v21 = statsCell(v8)

	local v23 = vipCell(tostring(data.ipString or "?"), tonumber(data.port), true, value)

	local v25 = bar(v10 or -1)

	local v27 = sparkline(v8, true)
	local v28

	if v10 and __med then
		local v29 = v10 - __med
		local v30 = v29 <= 0 and color7 or color9
		local v31 = string.format("Δ %+.1fms", v29):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
		v28 = "   " .. string.format(
			"<font color=\"%s\">%s</font>",
			string.format(
				"rgb(%d,%d,%d)",
				math.floor(v30.R * 255),
				math.floor(v30.G * 255),
				(math.floor(v30.B * 255))
			),
			v31
		)
	else
		v28 = ""
	end

	return v15 .. v16 .. " " .. v18 .. " " .. v12 .. "   " .. v21 .. "   " .. v23 .. "   " .. v25 .. "   " .. v27 .. v28
end

local function renderPopRows(list, data, p2, p3, value, flag)
	local popCode = tostring(data.popCode or "?")
	local ipString = tostring(data.ipString or "—")
	local v9 = p3 and color3 or color4
	local v10 = string.format("%-10s", popCode):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
	local v11 = string.format(
		"<font color=\"%s\">%s</font>",
		string.format(
			"rgb(%d,%d,%d)",
			math.floor(v9.R * 255),
			math.floor(v9.G * 255),
			(math.floor(v9.B * 255))
		),
		v10
	)

	local v13 = if p3 then data.__med or nil else nil
	local v14 = rttCell(v13)

	local v17 = if p3 then data.__avg or nil else nil
	local v18 = rttCell(v17)

	local v20 = p3 and rttCell(data.rttMs)

	if not v20 then
		local v21 = color10
		local v22 = string.format("%" .. 8 .. "s", "timeout"):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(
			">",
			"&gt;"
		)
		v20 = string.format(
			"<font color=\"%s\">%s</font>",
			string.format(
				"rgb(%d,%d,%d)",
				math.floor(v21.R * 255),
				math.floor(v21.G * 255),
				(math.floor(v21.B * 255))
			),
			v22
		)
	end

	local v21 = statsCell(data.__hist)

	local port = tonumber(data.port)
	local v22 = ":" .. tostring(not (port and port > 0 and port) and 3478 or port)

	local v23 = formatIp(ipString) .. v22

	local v24 = utf8.len(v23) or #v23
	local v25 = color4
	local v26 = (v23 .. string.rep(" ", (math.max(0, (value or 20) - v24)))):gsub("&", "&amp;"):gsub(
		"<",
		"&lt;"
	):gsub(
		">",
		"&gt;"
	)
	table.insert(
		list,
		p2 .. " " .. v11 .. v14 .. " " .. v18 .. " " .. v20 .. "   " .. v21 .. "   " .. string.format(
			"<font color=\"%s\">%s</font>",
			string.format(
				"rgb(%d,%d,%d)",
				math.floor(v25.R * 255),
				math.floor(v25.G * 255),
				(math.floor(v25.B * 255))
			),
			v26
		) .. "   " .. bar(p3 and data.__sort or -1) .. "   " .. sparkline(data.__hist, flag)
	)

	if data.v6 then
		table.insert(list, renderIpv6Row(data.v6, p3 and data.__med or nil, value))
	end
end

local function prepareRows(list)
	local result = {}
	local result2 = {}

	for i, item in ipairs(list) do
		item.__hist = committedHistory(item.history or {})

		if item.rttMs and item.rttMs >= 0 then
			item.__med = historyMedian(item.__hist)
			local __hist = item.__hist
			local total = 0
			local count = 0

			for j, v8 in ipairs(__hist) do
				if not (v8 >= 0) then
					continue
				end

				total += v8
				count += 1
			end

			local v8 = if count ~= 0 then total / count else nil

			item.__avg = v8
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

local function anyIpv6Enabled(list): boolean
	for i, item in ipairs(list) do
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
	rttColor = function(p2)
		if p2 < 0 then
			return color10
		end

		if p2 < 30 then
			return color7
		end

		if p2 < 80 then
			return color8
		end

		return color9
	end,
	colorTag = colorTag,
	escapeRich = function(value)
		return (value:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
	end,
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
	historyMean = function(list)
		local total = 0
		local count = 0

		for i, item in ipairs(list) do
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
	end,
	renderSnapshot = function(list, p2, p3, p4)
		local v8 = {}
		local v9 = {}

		for i, item in ipairs(list) do
			table.insert(item.debug and v8 or v9, item)
		end

		local v10, v11 = prepareRows(v9)
		local v12, v13 = prepareRows(v8)
		local v14 = false

		for i, item in ipairs(list) do
			if item.v6 then
				v14 = true
				break
			end
		end

		local v16 = v14 and 107 or 96
		local v17 = 20

		for i, item in ipairs(list) do
			if v14 or (tonumber(item.port) or 0) >= 10000 then
				v17 = 21
				break
			end
		end

		local v19 = 0
		local v20 = {}

		for i, item in ipairs(list) do
			local lastSampleEpochMs = item.lastSampleEpochMs or 0

			if v19 < lastSampleEpochMs then
				v19 = lastSampleEpochMs
			end
		end

		local v21

		if v19 > 0 and p4 and p4 > 0 then
			local v22 = math.max(0, (math.floor((v19 + p4 - os.time() * 1000) / 1000 + 0.5)))
			v21 = string.format("   next %ds", v22)
		else
			v21 = ""
		end

		local v22 = string.format(
			"probe #%d   every %s%s   up %s",
			p2,
			formatInterval(p4),
			v21,
			formatElapsed(p3)
		)
		local flag = true
		local flag2

		for i, item in ipairs(list) do
			if item.ipv6Enabled then
				flag2 = true
				flag = false
				break
			end
		end

		if flag then
			flag2 = false
		end

		local v23 = flag2 and "[engine] [v6 enabled]" or "[engine]"
		local v24 = v16 - #("Roblox TURN/STUN UDP Latency Monitor " .. v23 .. "   " .. v22)
		local v25 = v24 < 3 and 3 or v24

		local v26 = color3
		local v27 = string.format(
			"<font color=\"%s\">%s</font>",
			string.format(
				"rgb(%d,%d,%d)",
				math.floor(v26.R * 255),
				math.floor(v26.G * 255),
				(math.floor(v26.B * 255))
			),
			"Roblox TURN/STUN UDP Latency Monitor"
		)

		local v28 = color4
		local v29 = string.format(
			"<font color=\"%s\">%s</font>",
			string.format(
				"rgb(%d,%d,%d)",
				math.floor(v28.R * 255),
				math.floor(v28.G * 255),
				(math.floor(v28.B * 255))
			),
			v23
		)

		local v30 = string.rep(" ", v25)
		local v31 = color4
		table.insert(
			v20,
			v27 .. " " .. v29 .. v30 .. string.format(
				"<font color=\"%s\">%s</font>",
				string.format(
					"rgb(%d,%d,%d)",
					math.floor(v31.R * 255),
					math.floor(v31.G * 255),
					(math.floor(v31.B * 255))
				),
				v22
			)
		)
		table.insert(v20, separator(v16))

		local v32 = "%" .. 8 .. "s"
		local v33 = "%-3s %-10s" .. v32 .. " " .. v32 .. " " .. v32 .. "   " .. ("%-" .. 11 .. "s") .. "   " .. ("%-" .. v17 .. "s") .. "   "
		local v34 = string.format(v33, "#", "PoP", "Med RTT", "Avg RTT", "Last RTT", "Loss/Jit", "TURN VIP"):gsub(
			"&",
			"&amp;"
		):gsub(
			"<",
			"&lt;"
		):gsub(
			">",
			"&gt;"
		)
		local v36 = if flag2 then "<font transparency=\"1\">" .. string.rep("█", 15) .. "</font>" else string.rep(" ", 15)
		local v37 = v34 .. "Bar" .. v36 .. "   Trend" .. (not v14 and "" or ("<font transparency=\"1\">" .. string.rep("█", 7) .. "</font>") .. "   Δ v6")
		table.insert(v20, colorTag(color5, v37))
		table.insert(v20, separator(v16))
		local v38 = 1

		for i, v39 in ipairs(v10) do
			local v41 = color4
			local v42 = string.format("%2d.", v38):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
			renderPopRows(
				v20,
				v39,
				string.format(
					"<font color=\"%s\">%s</font>",
					string.format(
						"rgb(%d,%d,%d)",
						math.floor(v41.R * 255),
						math.floor(v41.G * 255),
						(math.floor(v41.B * 255))
					),
					v42
				),
				true,
				v17,
				flag2
			)
			v38 += 1
		end

		for i, v39 in ipairs(v11) do
			local v40 = color10
			renderPopRows(
				v20,
				v39,
				string.format(
					"<font color=\"%s\">%s</font>",
					string.format(
						"rgb(%d,%d,%d)",
						math.floor(v40.R * 255),
						math.floor(v40.G * 255),
						(math.floor(v40.B * 255))
					),
					" — "
				),
				false,
				v17,
				flag2
			)
		end

		if #v8 > 0 then
			table.insert(
				v20,
				colorTag(
					color4,
					("debug — public STUN servers, not Roblox PoPs"):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(
						">",
						"&gt;"
					)
				)
			)

			for i, v39 in ipairs(v12) do
				local v40 = color4
				renderPopRows(
					v20,
					v39,
					string.format(
						"<font color=\"%s\">%s</font>",
						string.format(
							"rgb(%d,%d,%d)",
							math.floor(v40.R * 255),
							math.floor(v40.G * 255),
							(math.floor(v40.B * 255))
						),
						" · "
					),
					true,
					v17,
					flag2
				)
			end

			for i, v39 in ipairs(v13) do
				local v40 = color10
				renderPopRows(
					v20,
					v39,
					string.format(
						"<font color=\"%s\">%s</font>",
						string.format(
							"rgb(%d,%d,%d)",
							math.floor(v40.R * 255),
							math.floor(v40.G * 255),
							(math.floor(v40.B * 255))
						),
						" — "
					),
					false,
					v17,
					flag2
				)
			end
		end

		table.insert(v20, separator(v16))
		local count = 0
		local total = 0
		local v39 = nil
		local v40 = nil
		local popCode = nil
		local popCode2 = nil

		for i, v41 in ipairs(v10) do
			count += 1
			local __sort = v41.__sort
			total += __sort

			if not v39 or __sort < v39 then
				popCode = tostring(v41.popCode)
				v39 = __sort
			end

			if not (not v40 or v40 < __sort) then
				continue
			end

			popCode2 = tostring(v41.popCode)
			v40 = __sort
		end

		local v41 = count > 0 and total / count or 0
		local v42 = #v11
		local v43 = {}

		if popCode then
			local v44 = color7
			local v45 = string.format("%s %.1fms", popCode, v39)
			table.insert(
				v43,
				"best " .. string.format(
					"<font color=\"%s\">%s</font>",
					string.format(
						"rgb(%d,%d,%d)",
						math.floor(v44.R * 255),
						math.floor(v44.G * 255),
						(math.floor(v44.B * 255))
					),
					v45
				)
			)
		end

		if popCode2 then
			local v44 = color9
			local v45 = string.format("%s %.1fms", popCode2, v40)
			table.insert(
				v43,
				"worst " .. string.format(
					"<font color=\"%s\">%s</font>",
					string.format(
						"rgb(%d,%d,%d)",
						math.floor(v44.R * 255),
						math.floor(v44.G * 255),
						(math.floor(v44.B * 255))
					),
					v45
				)
			)
		end

		if count > 0 then
			local v44 = color8
			local v45 = string.format("%.1fms", v41)
			table.insert(
				v43,
				"avg " .. string.format(
					"<font color=\"%s\">%s</font>",
					string.format(
						"rgb(%d,%d,%d)",
						math.floor(v44.R * 255),
						math.floor(v44.G * 255),
						(math.floor(v44.B * 255))
					),
					v45
				)
			)
		end

		local v44 = string.format("%d ok   ", count)
		local v45 = color10
		local v46 = string.format("%d timeout", v42)
		table.insert(
			v43,
			v44 .. string.format(
				"<font color=\"%s\">%s</font>",
				string.format(
					"rgb(%d,%d,%d)",
					math.floor(v45.R * 255),
					math.floor(v45.G * 255),
					(math.floor(v45.B * 255))
				),
				v46
			)
		)
		local count2 = 0
		local count3 = 0

		for i, v47 in ipairs(v9) do
			if not v47.v6 or v47.v6.debug then
				continue
			end

			count2 += 1

			if v47.v6.rttMs and v47.v6.rttMs >= 0 then
				count3 += 1
			end
		end

		if count2 > 0 then
			local v47 = count3 > 0 and color7 or color9
			local v48 = string.format("%d/%d ok", count3, count2)
			table.insert(
				v43,
				"v6 " .. string.format(
					"<font color=\"%s\">%s</font>",
					string.format(
						"rgb(%d,%d,%d)",
						math.floor(v47.R * 255),
						math.floor(v47.G * 255),
						(math.floor(v47.B * 255))
					),
					v48
				)
			)
		end

		table.insert(v20, (table.concat(v43, "   │   ")))

		return table.concat(v20, "\n")
	end
}
