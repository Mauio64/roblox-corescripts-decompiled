local t1 = {
	_VERSION = "inspect.lua 3.1.0",
	_URL = "http://github.com/kikito/inspect.lua",
	_DESCRIPTION = "human-readable representations of tables",
	_LICENSE = "\t  MIT LICENSE\n\n\t  Copyright (c) 2013 Enrique García Cota\n\n\t  Permission is hereby granted, free of charge, to any person obtaining a\n\t  copy of this software and associated documentation files (the\n\t  \"Software\"), to deal in the Software without restriction, including\n\t  without limitation the rights to use, copy, modify, merge, publish,\n\t  distribute, sublicense, and/or sell copies of the Software, and to\n\t  permit persons to whom the Software is furnished to do so, subject to\n\t  the following conditions:\n\n\t  The above copyright notice and this permission notice shall be included\n\t  in all copies or substantial portions of the Software.\n\n\t  THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS\n\t  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\n\t  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\n\t  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY\n\t  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,\n\t  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE\n\t  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\t"
}
local _tostring = tostring

t1.KEY = setmetatable({}, {
	__tostring = function() -- line: 34
		return "inspect.KEY"
	end
})
t1.METATABLE = setmetatable({}, {
	__tostring = function() -- line: 39
		return "inspect.METATABLE"
	end
})

local function rawpairs(p1) -- line: 44
	return next, p1, nil
end
local function smartQuote(p2) -- line: 50
	if p2:match("\"") and not p2:match("'") then
		return "'" .. p2 .. "'"
	end

	return "\"" .. p2:gsub("\"", "\\\"") .. "\""
end

local t2 = {
	["\a"] = "\\a",
	["\b"] = "\\b",
	["\f"] = "\\f",
	["\n"] = "\\n",
	["\r"] = "\\r",
	["\t"] = "\\t",
	["\v"] = "\\v"
}
local t3 = {}

for i = 0, 31 do
	local char = string.char(i)

	if not t2[char] then
		t2[char] = "\\" .. i
		t3[char] = string.format("\\%03d", i)
	end
end

local function escape(p3) -- line: 76
	-- upvalues: t3 (copy), t2 (copy)
	return (p3:gsub("\\", "\\\\"):gsub("(%c)%f[0-9]", t3):gsub("%c", t2))
end
local function isIdentifier(p4) -- line: 80
	return type(p4) == "string" and p4:match("^[_%a][_%a%d]*$")
end
local function isSequenceKey(p5, p6) -- line: 84
	return type(p5) == "number" and (p5 >= 1 and (p5 <= p6 and p5 == math.floor(p5)))
end

local t4 = {
	number = 1,
	boolean = 2,
	string = 3,
	table = 4,
	["function"] = 5,
	userdata = 6,
	thread = 7
}

local function sortKeys(p7, p8) -- line: 98
	-- upvalues: t4 (copy)
	local v29 = type(p7)
	local v30 = type(p8)

	if v29 == v30 and (v29 == "string" or v29 == "number") then
		return p7 < p8
	end

	local v31 = t4[v29]
	local v32 = t4[v30]

	if v31 and v32 then
		return t4[v29] < t4[v30]
	end

	if v31 then
		return true
	end

	if v32 then
		return false
	end

	return v29 < v30
end
local function getSequenceLength(p9) -- line: 122
	local n1 = 1
	local v35 = rawget(p9, n1)

	while v35 ~= nil do
		n1 += 1
		v35 = rawget(p9, n1)
	end

	return n1 - 1
end
local function getNonSequentialKeys(p10) -- line: 132
	-- upvalues: sortKeys (copy)
	local t5 = {}
	local n2 = 0
	local n3 = 1
	local v40 = rawget(p10, n3)

	while v40 ~= nil do
		n3 += 1
		v40 = rawget(p10, n3)
	end

	local v41 = n3 - 1

	for k, _ in next, p10 do
		if type(k) ~= "number" or (not (k >= 1) or (not (k <= v41) or k ~= math.floor(k))) then
			n2 += 1
			t5[n2] = k
		end
	end

	table.sort(t5, sortKeys)

	return t5, n2, v41
end
local function countTableAppearances(p11, p12) -- line: 145
	-- upvalues: countTableAppearances (copy)
	local v46 = p12 or {}

	if type(p11) == "table" then
		if not v46[p11] then
			v46[p11] = 1

			for k, v in next, p11 do
				countTableAppearances(k, v46)
				countTableAppearances(v, v46)
			end

			countTableAppearances(getmetatable(p11), v46)

			return v46
		end

		v46[p11] = v46[p11] + 1
	end

	return v46
end
local function makePath(p13, ...) -- line: 172
	local t6 = { ... }
	local t7 = {}
	local v56 = #p13

	for i = 1, v56 do
		t7[i] = p13[i]
	end

	for i = 1, #t6 do
		t7[v56 + i] = t6[i]
	end

	return t7
end
local function processRecursive(p14, p15, p16, p17) -- line: 181
	-- upvalues: processRecursive (copy), makePath (copy), t1 (copy)
	if p15 == nil then
		return nil
	end

	if p17[p15] then
		return p17[p15]
	end

	local v63 = p14(p15, p16)

	if type(v63) == "table" then
		local t8 = {}

		p17[p15] = t8

		for k, v in next, v63 do
			local v67 = processRecursive(p14, k, makePath(p16, k, t1.KEY), p17)

			if v67 ~= nil then
				t8[v67] = processRecursive(p14, v, makePath(p16, v67), p17)
			end
		end

		local v68 = processRecursive(p14, getmetatable(v63), makePath(p16, t1.METATABLE), p17)

		if type(v68) ~= "table" then
			v68 = nil
		end

		setmetatable(t8, v68)
		v63 = t8
	end

	return v63
end

local t9 = {}
local t10 = {
	__index = t9
}

function t9.puts(p18, ...) -- line: 217
	local t11 = { ... }
	local buffer = p18.buffer
	local v72 = #buffer

	for i = 1, #t11 do
		v72 += 1
		buffer[v72] = t11[i]
	end
end
function t9.down(p19, p20) -- line: 227
	p19.level = p19.level + 1
	p20()
	p19.level = p19.level - 1
end
function t9.tabify(p21) -- line: 233
	p21:puts(p21.newline, string.rep(p21.indent, p21.level))
end
function t9.alreadyVisited(p22, p23) -- line: 237
	return p22.ids[p23] ~= nil
end
function t9.getId(p24, p25) -- line: 241
	-- upvalues: _tostring (copy)
	local v81 = p24.ids[p25]

	if not v81 then
		local v82 = type(p25)

		v81 = (p24.maxIds[v82] or 0) + 1
		p24.maxIds[v82] = v81
		p24.ids[p25] = v81
	end

	return (_tostring(v81))
end
function t9.putKey(p26, p27) -- line: 252
	if type(p27) == "string" and p27:match("^[_%a][_%a%d]*$") then
		return p26:puts(p27)
	end

	p26:puts("[")
	p26:putValue(p27)
	p26:puts("]")
end
function t9.putTable(p28, p29) -- line: 261
	-- upvalues: t1 (copy), _tostring (copy), getNonSequentialKeys (copy)
	if p29 == t1.KEY or p29 == t1.METATABLE then
		p28:puts((_tostring(p29)))

		return
	end

	if p28:alreadyVisited(p29) then
		p28:puts("<table ", p28:getId(p29), ">")

		return
	end

	if p28.level >= p28.depth then
		p28:puts("{...}")

		return
	end

	if p28.tableAppearances[p29] > 1 then
		p28:puts("<", p28:getId(p29), ">")
	end

	local v87, v88, v89 = getNonSequentialKeys(p29)
	local mt = getmetatable(p29)

	p28:puts("{")
	p28:down(function() -- line: 277
		-- upvalues: v89 (copy), p28 (copy), p29 (copy), v88 (copy), v87 (copy), mt (copy)
		local n4 = 0

		for i = 1, v89 do
			if n4 > 0 then
				p28:puts(",")
			end

			p28:puts(" ")
			p28:putValue(p29[i])
			n4 += 1
		end

		for i = 1, v88 do
			local v107 = v87[i]

			if n4 > 0 then
				p28:puts(",")
			end

			p28:tabify()
			p28:putKey(v107)
			p28:puts(" = ")
			p28:putValue(p29[v107])
			n4 += 1
		end

		if type(mt) == "table" then
			if n4 > 0 then
				p28:puts(",")
			end

			p28:tabify()
			p28:puts("<metatable> = ")
			p28:putValue(mt)
		end
	end)

	if v88 > 0 or type(mt) == "table" then
		p28:tabify()
	elseif v89 > 0 then
		p28:puts(" ")
	end

	p28:puts("}")
end
function t9.putValue(p30, p31) -- line: 320
	-- upvalues: t3 (copy), t2 (copy), _tostring (copy)
	local v93 = type(p31)

	if v93 == "string" then
		local v94 = p31:gsub("\\", "\\\\"):gsub("(%c)%f[0-9]", t3):gsub("%c", t2)

		p30:puts(if not v94:match("\"") or v94:match("'") then "\"" .. v94:gsub("\"", "\\\"") .. "\"" else "'" .. v94 .. "'")

		return
	end

	if v93 == "number" or v93 == "boolean" or v93 == "nil" or v93 == "cdata" or v93 == "ctype" then
		p30:puts((_tostring(p31)))

		return
	end

	if v93 == "table" then
		p30:putTable(p31)

		return
	end

	p30:puts("<", v93, " ", p30:getId(p31), ">")
end
function t1.inspect(p32, p33) -- line: 336
	-- upvalues: processRecursive (copy), countTableAppearances (copy), t10 (copy)
	local v97 = p33 or {}
	local v98 = v97.depth or 1e999
	local v99 = v97.newline or "\n"
	local v100 = v97.indent or "  "
	local process = v97.process

	if process then
		p32 = processRecursive(process, p32, {}, {})
	end

	local v102 = setmetatable({
		level = 0,
		depth = v98,
		buffer = {},
		ids = {},
		maxIds = {},
		newline = v99,
		indent = v100,
		tableAppearances = countTableAppearances(p32)
	}, t10)

	v102:putValue(p32)

	return table.concat(v102.buffer)
end

setmetatable(t1, {
	__call = function(_, ...) -- line: 365
		-- upvalues: t1 (copy)
		return t1.inspect(...)
	end
})

return t1
