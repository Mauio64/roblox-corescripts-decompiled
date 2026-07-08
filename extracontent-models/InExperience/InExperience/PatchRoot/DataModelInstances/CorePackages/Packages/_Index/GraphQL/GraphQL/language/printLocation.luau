local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local String = LuauPolyfill.String
local getLocation = require(scriptParent.location).getLocation
local whitespace = nil
local leftPad = nil
local printSourceLocation = nil
local printPrefixedLines = nil

function printSourceLocation(p1, p2) -- line: 34
	-- upvalues: whitespace (ref), String (copy), printPrefixedLines (ref), Array (copy)
	local v14 = p1.locationOffset.column - 1
	local v15 = whitespace(v14) .. p1.body
	local v16 = p2.line - 1 + 1
	local v17 = p1.locationOffset.line - 1
	local v18 = p2.line + v17
	local v19 = p2.line == 1 and v14 or 0
	local v20 = p2.column + v19
	local v21 = p1.name .. ":" .. v18 .. ":" .. v20 .. "\n"
	local v22 = String.split(v15, {
		"\r\n",
		"\n",
		"\r"
	})
	local v23 = v22[v16]

	if string.len(v23) > 120 then
		local v24 = math.floor(v20 / 80) + 1
		local v25 = v20 % 80
		local t1 = {}

		for i = 1, string.len(v23), 80 do
			table.insert(t1, String.slice(v23, i, i + 80))
		end

		return v21 .. printPrefixedLines(Array.concat({{
			tostring(v18),
			t1[1]
		}}, Array.map(Array.slice(t1, 2, v24 + 1), function(p3) -- line: 61
			return {
				"",
				p3
			}
		end), {{
			" ",
			whitespace(v25 - 1) .. "^"
		}}, {{
			"",
			t1[v24 + 1]
		}}))
	end

	return v21 .. printPrefixedLines({
		{
			v18 - 1,
			v22[v16 - 1]
		},
		{
			v18,
			v23
		},
		{
			"",
			whitespace(v20 - 1) .. "^"
		},
		{
			v18 + 1,
			v22[v16 + 1]
		}
	})
end
function printPrefixedLines(p4) -- line: 83
	-- upvalues: Array (copy), leftPad (ref)
	local v29 = Array.filter(p4, function(p5) -- line: 84
		return p5[2] ~= nil
	end)
	local v30 = math.max(table.unpack(Array.map(v29, function(p6) -- line: 89
		return (string.len(p6[1]))
	end)))

	return Array.join(Array.map(v29, function(p7) -- line: 94
		-- upvalues: leftPad (ref), v30 (copy)
		local v38 = p7[1]
		local v39 = p7[2]

		return leftPad(v30, v38) .. (v39 and (v39 ~= "" and " | " .. v39) or " |")
	end), "\n")
end
function whitespace(n1: number) -- line: 103
	return string.rep(" ", n1)
end
function leftPad(n2: number, s1: string) -- line: 107
	-- upvalues: whitespace (ref)
	return whitespace(n2 - string.len(s1)) .. s1
end

return {
	printSourceLocation = printSourceLocation,
	printLocation = function(p8) -- line: 27
		-- upvalues: printSourceLocation (ref), getLocation (copy)
		return printSourceLocation(p8.source, getLocation(p8.source, p8.start))
	end
}
