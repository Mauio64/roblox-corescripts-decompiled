local parent = script.Parent
local parent2 = parent.Parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local String = LuauPolyfill.String

local location = require(parent.location)
local getLocation = location.getLocation

local whitespace
local leftPad
local printSourceLocation
local printPrefixedLines

local function printLocation(p)
	return printSourceLocation(p.source, getLocation(p.source, p.start))
end

printSourceLocation = function(source, p)
	local v = source.locationOffset.column - 1
	local v2 = whitespace(v) .. source.body

	local v3 = p.line - 1 + 1
	local v4 = source.locationOffset.line - 1
	local v5 = p.line + v4

	local v6 = p.line == 1 and v or 0
	local v7 = p.column + v6
	local v8 = source.name .. ":" .. v5 .. ":" .. v7 .. "\n"

	local parts = String.split(v2, { "\r\n", "\n", "\r" })
	local part = parts[v3]

	if not (string.len(part) > 120) then
		return v8 .. printPrefixedLines({
			{ v5 - 1, parts[v3 - 1] },
			{ v5, part },
			{ "", whitespace(v7 - 1) .. "^" },
			{ v5 + 1, parts[v3 + 1] }
		})
	end

	local v9 = math.floor(v7 / 80) + 1
	local v10 = v7 % 80
	local v11 = {}

	for i = 1, string.len(part), 80 do
		table.insert(v11, String.slice(part, i, i + 80))
	end

	return v8 .. printPrefixedLines(Array.concat({
		{ tostring(v5), v11[1] }
	}, Array.map(Array.slice(v11, 2, v9 + 1), function(p2)
		return { "", p2 }
	end), {
		{ " ", whitespace(v10 - 1) .. "^" }
	}, {
		{ "", v11[v9 + 1] }
	}))
end

printPrefixedLines = function(p)
	local filtered = Array.filter(p, function(list): boolean
		return list[2] ~= nil
	end)

	local v = math.max(table.unpack(Array.map(filtered, function(list)
		return (string.len(list[1]))
	end)))

	return Array.join(Array.map(filtered, function(list)
		local item = list[1]
		local item2 = list[2]
		return leftPad(v, item) .. (item2 and item2 ~= "" and " | " .. item2 or " |")
	end), "\n")
end

whitespace = function(count: number)
	return string.rep(" ", count)
end

leftPad = function(p: number, value: string)
	return whitespace(p - string.len(value)) .. value
end

return { printSourceLocation = printSourceLocation, printLocation = printLocation }
