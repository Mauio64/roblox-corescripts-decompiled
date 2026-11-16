local _ = { cacheSize = 256 }

local object = setmetatable({}, { __mode = "k" })
local v = {}
local v2 = {}
local v3 = {}
local metatable2 = nil

local function to_str_arr(value, p)
	if p then
		value = string.sub(value, utf8.offset(value, p))
	end

	local v4 = utf8.len(value)

	if v4 <= 1999 then
		return {
			n = v4,
			s = value,
			utf8.codepoint(value, 1, #value)
		}
	end

	local v5 = math.ceil(v4 / 1999)
	local v6 = table.create(v4)
	local total = 1

	for i = 1, v5 do
		local v7 = table.pack(utf8.codepoint(
			value,
			utf8.offset(value, i * 1999 - 1998),
			utf8.offset(value, i * 1999 - (i == v5 and 1998 - ((v4 - 1) % 1999 + 1) or -1)) - 1
		))
		table.move(v7, 1, v7.n, total, v6)
		total += v7.n
	end

	v6.s = value
	v6.n = v4
	return v6
end

local function from_str_arr(list)
	local n = list.n or #list

	if n <= 7997 then
		return utf8.char(table.unpack(list))
	end

	local v4 = math.ceil(n / 7997)
	local v5 = table.create(v4)

	for i = 1, v4 do
		v5[i] = utf8.char(table.unpack(list, i * 7997 - 7996, i * 7997 - (i == v4 and 7997 - ((n - 1) % 7997 + 1) or 0)))
	end

	return table.concat(v5)
end

local function utf8_sub(value, p, p2) -- 23 equivalent calls inferred from this helper
	local v4 = utf8.offset(value, p2)
	return (string.sub(value, utf8.offset(value, p), v4 and v4 - 1))
end

local v4 = {
	a = "anchored",
	i = "caseless",
	m = "multiline",
	s = "dotall",
	u = "unicode",
	U = "ungreedy",
	x = "extended"
}

local v5 = {
	alnum = true,
	alpha = true,
	ascii = true,
	blank = true,
	cntrl = true,
	digit = true,
	graph = true,
	lower = true,
	print = true,
	punct = true,
	space = true,
	upper = true,
	word = true,
	xdigit = true
}

local v6 = {
	[68] = { "class", "digit", true },
	[83] = { "class", "space", true },
	[87] = { "class", "word", true },
	[100] = { "class", "digit", false },
	[115] = { "class", "space", false },
	[119] = { "class", "word", false },
	[72] = { "class", "blank", true },
	[86] = { "class", "vertical_tab", true },
	[104] = { "class", "blank", false },
	[118] = { "class", "vertical_tab", false },
	[78] = { 78 },
	[82] = { 82 },
	[66] = 8,
	[110] = 10,
	[114] = 13,
	[116] = 9
}

local v7 = {
	[98] = {
		98,
		{ "class", "word", false }
	},
	[66] = {
		66,
		{ "class", "word", false }
	},
	[75] = { 75 },
	[71] = { 71 },
	[74] = { 74 },
	[90] = { 90 },
	[122] = { 122 }
}

local _ = {
	C = true,
	Cc = true,
	Cf = true,
	Cn = true,
	Co = true,
	Cs = true,
	L = true,
	Ll = true,
	Lm = true,
	Lo = true,
	Lt = true,
	Lu = true,
	M = true,
	Mc = true,
	Me = true,
	Mn = true,
	N = true,
	Nd = true,
	Nl = true,
	No = true,
	P = true,
	Pc = true,
	Pd = true,
	Pe = true,
	Pf = true,
	Pi = true,
	Po = true,
	Ps = true,
	S = true,
	Sc = true,
	Sk = true,
	Sm = true,
	So = true,
	Z = true,
	Zl = true,
	Zp = true,
	Zs = true,
	Xan = true,
	Xps = true,
	Xsp = true,
	Xuc = true,
	Xwd = true
}

local v8 = {
	[33] = true,
	[34] = true,
	[35] = true,
	[36] = true,
	[37] = true,
	[38] = true,
	[39] = true,
	[40] = true,
	[41] = true,
	[42] = true,
	[43] = true,
	[44] = true,
	[45] = true,
	[46] = true,
	[47] = true,
	[58] = true,
	[59] = true,
	[60] = true,
	[61] = true,
	[62] = true,
	[63] = true,
	[64] = true,
	[91] = true,
	[92] = true,
	[93] = true,
	[94] = true,
	[95] = true,
	[96] = true,
	[123] = true,
	[124] = true,
	[125] = true,
	[126] = true
}

local v9 = { 36 }
local v10 = { 46 }
local v11 = { 94 }
local v12 = { 124 }

local function check_re(p, p2, callback)
	if p == "Match" then
		return function(...)
			if select("#", ...) < 1 then
				error("missing argument #1 (Match expected)", 2)
			end

			local v13, v14 = ...

			if object[v13] and object[v13].name == "Match" then
				v13 = object[v13]
			else
				error(string.format("invalid argument #1 to %q (Match expected, got %s)", p2, (typeof(v13))), 2)
			end

			v14 = (p2 == "group" or p2 == "span") and v14 == nil and 0 or v14

			return callback(v13, v14)
		end
	end

	return function(...)
		local v13 = select("#", ...)

		if v13 < 1 then
			error("missing argument #1 (RegEx expected)", 2)
		elseif v13 < 2 then
			error("missing argument #2 (string expected)", 2)
		end

		local v14, v15, v16, v17, v18, v19 = ...

		if object[v14] and object[v14].name == "RegEx" then
			if p2 == "sub" then
				if type(v16) == "number" then
					v16 ..= ""
				elseif type(v16) ~= "string" then
					error(string.format("invalid argument #3 to 'sub' (string expected, got %s)", (typeof(v16))), 2)
				end
			elseif type(v15) == "number" then
				v15 ..= ""
			elseif type(v15) ~= "string" then
				error(string.format("invalid argument #2 to %q (string expected, got %s)", p2, (typeof(v15))), 2)
			end
		else
			if type(v14) ~= "string" and type(v14) ~= "number" then
				error(string.format("invalid argument #1 to %q (RegEx expected, got %s)", p2, (typeof(v14))), 2)
			end

			v14 = v.fromstring(v14)
		end

		if p2 ~= "sub" and p2 ~= "split" then
			local typeName = typeof(v16)

			if typeName ~= "nil" then
				v16 = tonumber(v16)

				if v16 then
					if v16 < 0 then
						v16 = #v15 + math.floor(v16 + 0.5) + 1
					else
						v16 = math.max(math.floor(v16 + 0.5), 1)
					end
				else
					error(string.format("invalid argument #3 to %q (number expected, got %s)", p2, typeName), 2)
				end
			end
		end

		local v20 = object[v14]

		if p2 == "match" or p2 == "matchiter" then
			v17 = ...
		elseif p2 == "sub" then
			v19 = ...
		end

		return callback(v20, v15, v16, v17, v18, v19)
	end
end

local function match_tostr(p)
	local spans = object[p].spans
	local v13 = spans[0][1]
	local v14 = spans[0][2]

	if v14 <= v13 then
		return string.format("Match (%d..%d, empty)", v13, v14 - 1)
	end

	return string.format("Match (%d..%d): %s", v13, v14 - 1, utf8_sub(spans.input, v13, v14)) -- inferred equivalent call
end

local function new_match(spans, group_id, source, input)
	spans.source = source
	spans.input = input
	local v13 = newproxy(true)
	local metatable = getmetatable(v13)
	metatable.__metatable = metatable2
	metatable.__index = setmetatable(spans, v3)
	metatable.__tostring = match_tostr

	object[v13] = { name = "Match", spans = spans, group_id = group_id }
	return v13
end

local function fn(p, value)
	local span = p.spans[type(value) == "number" and value or p.group_id[value]]

	if not span then
		return nil
	end

	return utf8_sub(p.spans.input, span[1], span[2]) -- inferred equivalent call
end

local v13 = "group"
function v3.group(...)
	if select("#", ...) < 1 then
		error("missing argument #1 (Match expected)", 2)
	end

	local v14, v15 = ...

	if object[v14] and object[v14].name == "Match" then
		v14 = object[v14]
	else
		error(string.format("invalid argument #1 to %q (Match expected, got %s)", v13, (typeof(v14))), 2)
	end

	v15 = (v13 == "group" or v13 == "span") and v15 == nil and 0 or v15

	return fn(v14, v15)
end

local function fn2(p, value)
	local span = p.spans[type(value) == "number" and value or p.group_id[value]]

	if span then
		return span[1], span[2] - 1
	end

	return nil
end

local v14 = "span"
function v3.span(...)
	if select("#", ...) < 1 then
		error("missing argument #1 (Match expected)", 2)
	end

	local v15, v16 = ...

	if object[v15] and object[v15].name == "Match" then
		v15 = object[v15]
	else
		error(string.format("invalid argument #1 to %q (Match expected, got %s)", v14, (typeof(v15))), 2)
	end

	v16 = (v14 == "group" or v14 == "span") and v16 == nil and 0 or v16

	return fn2(v15, v16)
end

local function fn3(p)
	local spans = p.spans

	if spans.n > 0 then
		local v15 = table.create(spans.n)

		for i = 0, spans.n do
			local span = spans[i]

			if span then
				v15[i] = utf8_sub(spans.input, span[1], span[2]) -- inferred equivalent call
			end
		end

		return table.unpack(v15, 1, spans.n)
	end

	return utf8_sub(spans.input, spans[0][1], spans[0][2]) -- inferred equivalent call
end

local v15 = "groups"
function v3.groups(...)
	if select("#", ...) < 1 then
		error("missing argument #1 (Match expected)", 2)
	end

	local v16, v17 = ...

	if object[v16] and object[v16].name == "Match" then
		v16 = object[v16]
	else
		error(string.format("invalid argument #1 to %q (Match expected, got %s)", v15, (typeof(v16))), 2)
	end

	v17 = (v15 == "group" or v15 == "span") and v17 == nil and 0 or v17

	return fn3(v16, v17)
end

local function fn4(p)
	local spans = p.spans
	local result = {}

	for k, v16 in pairs(p.group_id) do
		local span = spans[v16]

		if span then
			result[k] = utf8_sub(spans.input, span[1], span[2]) -- inferred equivalent call
		end
	end

	return result
end

local v16 = "groupdict"
function v3.groupdict(...)
	if select("#", ...) < 1 then
		error("missing argument #1 (Match expected)", 2)
	end

	local v17, v18 = ...

	if object[v17] and object[v17].name == "Match" then
		v17 = object[v17]
	else
		error(string.format("invalid argument #1 to %q (Match expected, got %s)", v16, (typeof(v17))), 2)
	end

	v18 = (v16 == "group" or v16 == "span") and v18 == nil and 0 or v18

	return fn4(v17, v18)
end

local function fn5(p)
	local spans = p.spans
	local result = table.create(spans.n)

	for i = 0, spans.n do
		local span = spans[i]

		if span then
			result[i] = utf8_sub(spans.input, span[1], span[2]) -- inferred equivalent call
		end
	end

	result.n = spans.n
	return result
end

local v17 = "groupdict"
function v3.grouparr(...)
	if select("#", ...) < 1 then
		error("missing argument #1 (Match expected)", 2)
	end

	local v18, v19 = ...

	if object[v18] and object[v18].name == "Match" then
		v18 = object[v18]
	else
		error(string.format("invalid argument #1 to %q (Match expected, got %s)", v17, (typeof(v18))), 2)
	end

	v19 = (v17 == "group" or v17 == "span") and v19 == nil and 0 or v19

	return fn5(v18, v19)
end

local v18 = {
	CR = 0,
	LF = 1,
	CRLF = 2,
	ANYRLF = 3,
	ANY = 4,
	NUL = 5
}

local function is_newline(p, p2, p3): boolean
	local newline = p3.newline
	local v19 = p[p2]

	if newline == 0 then
		return v19 == 13
	end

	if newline == 2 then
		return v19 == 10 and p[p2 - 1] == 32
	end

	if newline == 3 then
		return v19 == 10 or v19 == 13
	elseif newline == 4 then
		return v19 == 10 or v19 == 11 or v19 == 12 or v19 == 13 or v19 == 133 or v19 == 8232 or v19 == 8233
	elseif newline == 5 then
		return v19 == 0
	end

	return v19 == 10
end

local function tkn_char_match(value, p, p2, data, p3)
	local v19 = p[p2]

	if not v19 then
		return false
	end

	if data.ignoreCase and v19 >= 97 and v19 <= 122 then
		v19 -= 32
	end

	if (type)(value) == "number" then
		return value == v19
	end

	if value[1] == "charset" then
		for _, v20 in ipairs(value[3]) do
			if tkn_char_match(v20, p, p2, data, p3) then
				return not value[2]
			end
		end

		return value[2]
	elseif value[1] == "range" then
		local v20

		if value[2] <= v19 and v19 <= value[3] then
			return true
		end

		v20 = data.ignoreCase

		if v20 then
			if v19 >= 65 and v19 <= 90 and v19 + 32 >= value[2] then
				return v19 + 32 <= value[3]
			end

			return false
		end

		return v20
	elseif value[1] == "class" then
		local v20 = value[2]
		local v21 = value[3]
		local v22 = false

		if v20 == "xdigit" then
			if v19 >= 48 and v19 <= 57 or v19 >= 65 and v19 <= 70 then
				v22 = true
			elseif v19 >= 97 then
				v22 = v19 <= 102
			else
				v22 = false
			end
		elseif v20 == "ascii" then
			v22 = v19 <= 127
		elseif v20 == "vertical_tab" then
			v22 = v19 >= 10 and v19 <= 13 or (v19 == 8232 or v19 == 8233)
		elseif data.unicode then
			local v23 = (false)[v19] or "Cn"
			local v24 = v23:sub(1, 1)

			if v20 == "alnum" then
				v22 = v24 == "L" or v23 == "Nl" or v23 == "Nd"
			elseif v20 == "alpha" then
				v22 = v24 == "L" or v23 == "Nl"
			elseif v20 == "blank" then
				v22 = v23 == "Zs" or v19 == 9
			elseif v20 == "cntrl" then
				v22 = v23 == "Cc"
			elseif v20 == "digit" then
				v22 = v23 == "Nd"
			elseif v20 == "graph" then
				if v24 == "P" then
					v22 = false
				else
					v22 = v24 ~= "C"
				end
			elseif v20 == "lower" then
				v22 = v23 == "Ll"
			elseif v20 == "print" then
				v22 = v24 ~= "C"
			elseif v20 == "punct" then
				v22 = v24 == "P"
			elseif v20 == "space" then
				if v24 == "Z" then
					v22 = true
				elseif v19 >= 9 then
					v22 = v19 <= 13
				else
					v22 = false
				end
			elseif v20 == "upper" then
				v22 = v23 == "Lu"
			elseif v20 == "word" then
				v22 = v24 == "L" or v23 == "Nl" or v23 == "Nd" or v23 == "Pc"
			end
		elseif v20 == "alnum" then
			if v19 >= 48 and v19 <= 57 or v19 >= 65 and v19 <= 90 then
				v22 = true
			elseif v19 >= 97 then
				v22 = v19 <= 122
			else
				v22 = false
			end
		elseif v20 == "alpha" then
			if v19 >= 65 and v19 <= 90 then
				v22 = true
			elseif v19 >= 97 then
				v22 = v19 <= 122
			else
				v22 = false
			end
		elseif v20 == "blank" then
			v22 = v19 == 9 or v19 == 32
		elseif v20 == "cntrl" then
			v22 = v19 <= 31 or v19 == 127
		elseif v20 == "digit" then
			if v19 >= 48 then
				v22 = v19 <= 57
			else
				v22 = false
			end
		elseif v20 == "graph" then
			if v19 >= 33 then
				v22 = v19 <= 126
			else
				v22 = false
			end
		elseif v20 == "lower" then
			if v19 >= 97 then
				v22 = v19 <= 122
			else
				v22 = false
			end
		elseif v20 == "print" then
			if v19 >= 32 then
				v22 = v19 <= 126
			else
				v22 = false
			end
		elseif v20 == "punct" then
			v22 = v8[v19]
		elseif v20 == "space" then
			v22 = v19 >= 9 and v19 <= 13 or v19 == 32
		elseif v20 == "upper" then
			if v19 >= 65 then
				v22 = v19 <= 90
			else
				v22 = false
			end
		elseif v20 == "word" then
			if v19 >= 48 and v19 <= 57 then
				v22 = true
			elseif v19 >= 65 and v19 <= 90 then
				v22 = true
			elseif v19 >= 97 and v19 <= 122 then
				v22 = true
			else
				v22 = v19 == 95
			end
		end

		if v21 then
			return not v22
		end

		return v22
	elseif value[1] == "category" then
		local v20 = (false)[v19] or "Cn"
		local v21 = value[3]
		local count = #v21

		if count == 3 then
			local v22 = false

			if v21 == "Xan" or v21 == "Xwd" then
				v22 = v20:find("^[LN]")

				if not v22 then
					if v21 == "Xwd" then
						v22 = v19 == 95
					else
						v22 = false
					end
				end
			elseif v21 == "Xps" or v21 == "Xsp" then
				if v20:sub(1, 1) == "Z" then
					v22 = true
				elseif v19 >= 9 then
					v22 = v19 <= 13
				else
					v22 = false
				end
			elseif v21 == "Xuc" then
				v22 = tkn_char_match(false, p, p2, data, p3)
			end

			if value[2] then
				return not v22
			end

			return v22
		elseif v20:sub(1, count) == v21 then
			return not value[2]
		else
			return value[2]
		end
	else
		if value[1] == 46 then
			return data.dotAll or not is_newline(p, p2, p3)
		end

		if value[1] == 78 then
			return not is_newline(p, p2, p3)
		end

		if value[1] ~= 82 then
			return false
		end

		if p3.newline_seq == 0 then
			return v19 == 10 or v19 == 13
		end

		return v19 == 10 or v19 == 11 or v19 == 12 or v19 == 13 or v19 == 133 or v19 == 8232 or v19 == 8233
	end
end

local function find_alternation(p, p2, p3)
	while true do
		local v19 = p[p2]
		local v20 = type(v19) == "table"

		if v19 == v12 then
			return p2, p3
		end

		if v20 and v19[1] == 40 then
			p3 = p3 and p3 + v19.count

			p2 = v19[3]
		elseif v20 and v19[1] == "quantifier" and type(v19[5]) == "table" and v19[5][1] == 40 then
			p3 = p3 and p3 + v19[5].count

			p2 = v19[5][3]
		else
			if not v19 or v20 and v19[1] == 41 then
				return nil, p3
			end

			if p3 then
				if v20 and v19[1] == "quantifier" then
					p3 += v19[3]
				else
					p3 += 1
				end
			end
		end

		p2 += 1
	end
end

local function re_rawfind(_, _, _, _, _, _)
	-- [TOVEK] This code could not be rebuilt at all
	-- Lines 102 to 785, proto: p16
	error("unreversable function")
end

local function fn6(data, p, p2)
	return (re_rawfind(data.token, to_str_arr(p, p2), 1, data.flags, data.verb_flags, true))
end

local v19 = "test"
function v2.test(...)
	local v20 = select("#", ...)

	if v20 < 1 then
		error("missing argument #1 (RegEx expected)", 2)
	elseif v20 < 2 then
		error("missing argument #2 (string expected)", 2)
	end

	local v21, v22, v23, v24, v25, v26 = ...

	if object[v21] and object[v21].name == "RegEx" then
		if v19 == "sub" then
			if type(v23) == "number" then
				v23 ..= ""
			elseif type(v23) ~= "string" then
				error(string.format("invalid argument #3 to 'sub' (string expected, got %s)", (typeof(v23))), 2)
			end
		elseif type(v22) == "number" then
			v22 ..= ""
		elseif type(v22) ~= "string" then
			error(string.format("invalid argument #2 to %q (string expected, got %s)", v19, (typeof(v22))), 2)
		end
	else
		if type(v21) ~= "string" and type(v21) ~= "number" then
			error(string.format("invalid argument #1 to %q (RegEx expected, got %s)", v19, (typeof(v21))), 2)
		end

		v21 = v.fromstring(v21)
	end

	if v19 ~= "sub" and v19 ~= "split" then
		local typeName = typeof(v23)

		if typeName ~= "nil" then
			v23 = tonumber(v23)

			if v23 then
				if v23 < 0 then
					v23 = #v22 + math.floor(v23 + 0.5) + 1
				else
					v23 = math.max(math.floor(v23 + 0.5), 1)
				end
			else
				error(string.format("invalid argument #3 to %q (number expected, got %s)", v19, typeName), 2)
			end
		end
	end

	local v27 = object[v21]

	if v19 == "match" or v19 == "matchiter" then
		v24 = ...
	elseif v19 == "sub" then
		v26 = ...
	end

	return fn6(v27, v22, v23, v24, v25, v26)
end

local function fn7(data, input, p, source)
	local spans = re_rawfind(data.token, to_str_arr(input, p), 1, data.flags, data.verb_flags, false)

	if spans then
		return new_match(spans, data.group_id, source, input)
	end

	return nil
end

local v20 = "match"
function v2.match(...)
	local v21 = select("#", ...)

	if v21 < 1 then
		error("missing argument #1 (RegEx expected)", 2)
	elseif v21 < 2 then
		error("missing argument #2 (string expected)", 2)
	end

	local v22, v23, v24, v25, v26, v27 = ...

	if object[v22] and object[v22].name == "RegEx" then
		if v20 == "sub" then
			if type(v24) == "number" then
				v24 ..= ""
			elseif type(v24) ~= "string" then
				error(string.format("invalid argument #3 to 'sub' (string expected, got %s)", (typeof(v24))), 2)
			end
		elseif type(v23) == "number" then
			v23 ..= ""
		elseif type(v23) ~= "string" then
			error(string.format("invalid argument #2 to %q (string expected, got %s)", v20, (typeof(v23))), 2)
		end
	else
		if type(v22) ~= "string" and type(v22) ~= "number" then
			error(string.format("invalid argument #1 to %q (RegEx expected, got %s)", v20, (typeof(v22))), 2)
		end

		v22 = v.fromstring(v22)
	end

	if v20 ~= "sub" and v20 ~= "split" then
		local typeName = typeof(v24)

		if typeName ~= "nil" then
			v24 = tonumber(v24)

			if v24 then
				if v24 < 0 then
					v24 = #v23 + math.floor(v24 + 0.5) + 1
				else
					v24 = math.max(math.floor(v24 + 0.5), 1)
				end
			else
				error(string.format("invalid argument #3 to %q (number expected, got %s)", v20, typeName), 2)
			end
		end
	end

	local v28 = object[v22]

	if v20 == "match" or v20 == "matchiter" then
		v25 = ...
	elseif v20 == "sub" then
		v27 = ...
	end

	return fn7(v28, v23, v24, v25, v26, v27)
end

local function fn8(data, p, p2, source)
	local v21 = to_str_arr(p, p2)
	local v22 = 1
	return function()
		local v23

		if v22 <= v21.n + 1 then
			v23 = re_rawfind(data.token, v21, v22, data.flags, data.verb_flags, false)
		else
			v23 = false
		end

		if not v23 then
			return nil
		end

		v22 = v23[0][2] + (v23[0][1] >= v23[0][2] and 1 or 0)
		return new_match(v23, data.group_id, source, v21.s)
	end
end

local v21 = "matchall"
function v2.matchall(...)
	local v22 = select("#", ...)

	if v22 < 1 then
		error("missing argument #1 (RegEx expected)", 2)
	elseif v22 < 2 then
		error("missing argument #2 (string expected)", 2)
	end

	local v23, v24, v25, v26, v27, v28 = ...

	if object[v23] and object[v23].name == "RegEx" then
		if v21 == "sub" then
			if type(v25) == "number" then
				v25 ..= ""
			elseif type(v25) ~= "string" then
				error(string.format("invalid argument #3 to 'sub' (string expected, got %s)", (typeof(v25))), 2)
			end
		elseif type(v24) == "number" then
			v24 ..= ""
		elseif type(v24) ~= "string" then
			error(string.format("invalid argument #2 to %q (string expected, got %s)", v21, (typeof(v24))), 2)
		end
	else
		if type(v23) ~= "string" and type(v23) ~= "number" then
			error(string.format("invalid argument #1 to %q (RegEx expected, got %s)", v21, (typeof(v23))), 2)
		end

		v23 = v.fromstring(v23)
	end

	if v21 ~= "sub" and v21 ~= "split" then
		local typeName = typeof(v25)

		if typeName ~= "nil" then
			v25 = tonumber(v25)

			if v25 then
				if v25 < 0 then
					v25 = #v24 + math.floor(v25 + 0.5) + 1
				else
					v25 = math.max(math.floor(v25 + 0.5), 1)
				end
			else
				error(string.format("invalid argument #3 to %q (number expected, got %s)", v21, typeName), 2)
			end
		end
	end

	local v29 = object[v23]

	if v21 == "match" or v21 == "matchiter" then
		v26 = ...
	elseif v21 == "sub" then
		v28 = ...
	end

	return fn8(v29, v24, v25, v26, v27, v28)
end

local function insert_tokenized_sub(list, p, p2, list2)
	for _, item in ipairs(list2) do
		if type(item) == "table" then
			if item[1] == "condition" then
				if p2[item[2]] then
					if item[3] then
						insert_tokenized_sub(list, p, p2, item[3])
					else
						table.move(p, p2[item[2]][1], p2[item[2]][2] - 1, #list + 1, list)
					end
				elseif item[4] then
					insert_tokenized_sub(list, p, p2, item[4])
				end
			else
				table.move(item, 1, #item, #list + 1, list)
			end
		elseif p2[item] then
			table.move(p, p2[item][1], p2[item][2] - 1, #list + 1, list)
		end
	end

	list.n = #list
	return list
end

local function fn9(data, callback, p, p2, value, source)
	if value ~= nil and type(value) ~= "number" and type(value) ~= "string" then
		error(string.format("invalid argument #5 to 'sub' (string expected, got %s)", (typeof(value))), 3)
	end

	local v22 = { l = false, o = false, u = false }

	for k in string.gmatch(value or "", utf8.charpattern) do
		if v22[k] ~= false then
			error("invalid regular expression substitution flag " .. k, 3)
		end

		v22[k] = true
	end

	local v23 = type(callback)

	if v23 == "number" then
		callback ..= ""
	elseif v23 ~= "string" and v23 ~= "function" and (not v22.o or v23 ~= "table") then
		error(
			string.format(
				"invalid argument #2 to 'sub' (string/function%s expected, got %s)",
				v22.o and "/table" or "",
				(typeof(callback))
			),
			3
		)
	end

	if tonumber(p2) then
		local v24 = tonumber(p2)
		p2 = (v24 <= -1 or v24 ~= v24) and 1e999 or v24
	elseif p2 == nil then
		p2 = 1e999
	else
		error(string.format("invalid argument #4 to 'sub' (number expected, got %s)", (typeof(p2))), 3)
	end

	if p2 < 1 then
		return p, 0
	end

	local total = 0

	if v23 == "string" then
		local v24 = to_str_arr(callback)

		if v22.l then
			callback = v24
		else
			local v25 = table.create(3)
			local group_n = data.token.group_n
			local v26 = 0
			local v27 = {}

			while v26 < v24.n do
				local v28 = v26

				repeat
					v28 += 1
				until not v24[v28] or v24[v28] == 36 or v24[v28] == 92 or (v24[v28] == 58 or v24[v28] == 125) and v27[1]

				total += v28 - v26 - 1

				if v28 - v26 > 1 then
					table.insert(v25, table.move(v24, v26 + 1, v28 - 1, 1, table.create(v28 - v26 - 1)))
				end

				if v24[v28] == 58 then
					local v29 = v27[1]

					if v29[2] then
						error("malformed substitution pattern", 3)
					end

					v29[2] = table.move(v25, v29[3], #v25, 1, table.create(#v25 + 1 - v29[3]))

					for i = #v25, v29[3], -1 do
						v25[i] = nil
					end
				elseif v24[v28] == 125 then
					local v29 = table.remove(v27, 1)
					local v30 = table.move(v25, v29[3], #v25, 1, table.create(#v25 + 1 - v29[3]))

					for i = #v25, v29[3], -1 do
						v25[i] = nil
					end

					local v31 = {
						"condition",
						v29[1],
						v29[2] ~= true and (v29[2] or v30),
						v29[2] and v30
					}
					table.insert(v25, v31)
				elseif v24[v28] then
					v28 += 1
					local v29 = v24[v28]

					if v29 then
						if v29 == 92 and v24[v28 - 1] == 36 then
							local v30 = v25[#v25]

							if type(v30) == "table" then
								table.insert(v30, 36)
							else
								table.insert(v25, { 36 })
							end

							v28 -= 1
							total += 1
						elseif v29 == 48 then
							table.insert(v25, 0)
						elseif v29 > 48 and v29 <= 57 then
							local v30 = v29 - 48

							while v24[v28 + 1] and v24[v28 + 1] >= 48 and v24[v28 + 1] <= 57 do
								v30 ..= v24[v28 + 1] - 48
								v28 += 1
							end

							local v31 = tonumber(v30)

							if not v22.u and group_n < v31 then
								error("reference to non-existent subpattern", 3)
							end

							table.insert(v25, v31)
						elseif v29 == 123 and v24[v28 - 1] == 36 then
							v28 += 1
							local v30 = v28

							while
								v24[v28]
								and (v24[v28] >= 48 and v24[v28] <= 57 or v24[v28] >= 65 and v24[v28] <= 90 or v24[v28] >= 97 and v24[v28] <= 122 or v24[v28] == 95)
							do
								v28 += 1
							end

							if
								(v24[v28] == 125 or v24[v28] == 58 and (v24[v28 + 1] == 43 or v24[v28 + 1] == 45))
								and v28 ~= v30
							then
								local v31 = utf8_sub(v24.s, v30, v28) -- inferred equivalent call
								local v32

								if v24[v30] >= 48 and v24[v30] <= 57 then
									v32 = tonumber(v31)

									if not v22.u and group_n < v32 then
										error("reference to non-existent subpattern", 3)
									end
								else
									v32 = data.group_id[v31]

									if not v22.u and (not v32 or group_n < v32) then
										error("reference to non-existent subpattern", 3)
									end
								end

								if v24[v28] == 58 then
									v28 += 1
									table.insert(v27, { v32, v24[v28] == 45, #v25 + 1 })
								else
									table.insert(v25, v32)
								end
							else
								error("malformed substitution pattern", 3)
							end
						else
							local v30 = nil

							if v24[v28 - 1] == 36 then
								if v29 ~= 36 then
									local v31 = v25[#v25]

									if type(v31) == "table" then
										table.insert(v31, 36)
									else
										table.insert(v25, { 36 })
									end
								end
							else
								v30 = v6[v24[v28]]

								if type(v30) ~= "number" then
									v30 = nil
								end
							end

							local v31 = v25[#v25]

							if type(v31) == "table" then
								table.insert(v31, v30 or v24[v28])
							else
								table.insert(v25, { v30 or v24[v28] })
							end

							total += 1
						end
					else
						if v24[v28 - 1] == 92 then
							error("replacement string must not end with a trailing backslash", 3)
						end

						local v30 = v25[#v25]

						if type(v30) == "table" then
							table.insert(v30, v24[v28 - 1])
						else
							table.insert(v25, { v24[v28 - 1] })
						end
					end
				end

				v26 = v28
			end

			if v27[1] then
				error("malformed substitution pattern", 3)
			end

			if v25[2] or type(v25[1]) ~= "table" or v25[1][1] == "condition" then
				callback = v25
				v23 = "subst_string"
			else
				callback = v25[1]
				v24.n = #v25[1]
			end
		end
	end

	local v24 = to_str_arr(p)
	local v25 = 0
	local v26 = 1
	local count = 0

	while v26 <= v24.n + v25 + 1 do
		local spans = re_rawfind(data.token, v24, v26, data.flags, data.verb_flags, false)

		if not spans then
			break
		end

		local v27 = nil

		if v23 == "string" then
			v27 = callback
		elseif v23 == "subst_string" then
			v27 = insert_tokenized_sub(table.create(total), v24, spans, callback)
		else
			local v28, v29

			if v23 == "table" then
				v28 = utf8_sub(v24.s, spans[0][1], spans[0][2]) -- inferred equivalent call
				v29 = callback[v28]
			else
				v28 = new_match(spans, data.group_id, source, v24.s)
				v29 = callback(v28)
			end

			if v29 == v28 or v22.o and not v29 then
				local v30 = spans[0][2] - spans[0][1]
				v27 = table.move(v24, spans[0][1], spans[0][2] - 1, 1, table.create(v30))
				v27.n = v30
			elseif type(v29) == "string" then
				v27 = to_str_arr(v29)
			elseif type(v29) == "number" then
				v27 = to_str_arr(v29 .. "")
			elseif v22.o then
				error(string.format("invalid replacement value (a %s)", (type(v29))), 3)
			else
				v27 = { n = 0 }
			end
		end

		local v28 = spans[0][2] - spans[0][1]
		local v29 = math.min(v27.n, v28)

		for i = 0, v29 - 1 do
			v24[spans[0][1] + i] = v27[i + 1]
		end

		local v30 = spans[0][1] + v29
		v26 = spans[0][2]

		if v27.n < v28 then
			for _ = 1, v28 - v27.n do
				table.remove(v24, v30)
				v25 -= 1
				v26 -= 1
			end
		elseif v28 < v27.n then
			for i = 1, v27.n - v28 do
				table.insert(v24, v30 + i - 1, v27[v29 + i])
				v25 += 1
				v26 += 1
			end
		end

		if v28 <= 0 then
			v26 += 1
		end

		count += 1

		if p2 < count + 1 then
			break
		end
	end

	return from_str_arr(v24), count
end

local v22 = "sub"
function v2.sub(...)
	local v23 = select("#", ...)

	if v23 < 1 then
		error("missing argument #1 (RegEx expected)", 2)
	elseif v23 < 2 then
		error("missing argument #2 (string expected)", 2)
	end

	local v24, v25, v26, v27, v28, v29 = ...

	if object[v24] and object[v24].name == "RegEx" then
		if v22 == "sub" then
			if type(v26) == "number" then
				v26 ..= ""
			elseif type(v26) ~= "string" then
				error(string.format("invalid argument #3 to 'sub' (string expected, got %s)", (typeof(v26))), 2)
			end
		elseif type(v25) == "number" then
			v25 ..= ""
		elseif type(v25) ~= "string" then
			error(string.format("invalid argument #2 to %q (string expected, got %s)", v22, (typeof(v25))), 2)
		end
	else
		if type(v24) ~= "string" and type(v24) ~= "number" then
			error(string.format("invalid argument #1 to %q (RegEx expected, got %s)", v22, (typeof(v24))), 2)
		end

		v24 = v.fromstring(v24)
	end

	if v22 ~= "sub" and v22 ~= "split" then
		local typeName = typeof(v26)

		if typeName ~= "nil" then
			v26 = tonumber(v26)

			if v26 then
				if v26 < 0 then
					v26 = #v25 + math.floor(v26 + 0.5) + 1
				else
					v26 = math.max(math.floor(v26 + 0.5), 1)
				end
			else
				error(string.format("invalid argument #3 to %q (number expected, got %s)", v22, typeName), 2)
			end
		end
	end

	local v30 = object[v24]

	if v22 == "match" or v22 == "matchiter" then
		v27 = ...
	elseif v22 == "sub" then
		v29 = ...
	end

	return fn9(v30, v25, v26, v27, v28, v29)
end

local function fn10(data, p, p2)
	if tonumber(p2) then
		local v23 = tonumber(p2)
		p2 = (v23 <= -1 or v23 ~= v23) and 1e999 or v23
	elseif p2 == nil then
		p2 = 1e999
	else
		error(string.format("invalid argument #3 to 'split' (number expected, got %s)", (typeof(p2))), 3)
	end

	local v23 = to_str_arr(p)
	local v24 = 1
	local count = 0
	local v25 = 0
	local result = {}

	while v24 <= v23.n + 1 do
		count += 1
		local v26

		if count <= p2 then
			v26 = re_rawfind(data.token, v23, v24, data.flags, data.verb_flags, false)
		else
			v26 = false
		end

		if not v26 then
			break
		end

		table.insert(result, utf8_sub(v23.s, v24 - v25, v26[0][1])) -- inferred equivalent call
		v25 = v26[0][1] >= v26[0][2] and 1 or 0
		v24 = v26[0][2] + v25
	end

	table.insert(result, (string.sub(v23.s, utf8.offset(v23.s, v24 - v25))))
	return result
end

local v23 = "split"
function v2.split(...)
	local v24 = select("#", ...)

	if v24 < 1 then
		error("missing argument #1 (RegEx expected)", 2)
	elseif v24 < 2 then
		error("missing argument #2 (string expected)", 2)
	end

	local v25, v26, v27, v28, v29, v30 = ...

	if object[v25] and object[v25].name == "RegEx" then
		if v23 == "sub" then
			if type(v27) == "number" then
				v27 ..= ""
			elseif type(v27) ~= "string" then
				error(string.format("invalid argument #3 to 'sub' (string expected, got %s)", (typeof(v27))), 2)
			end
		elseif type(v26) == "number" then
			v26 ..= ""
		elseif type(v26) ~= "string" then
			error(string.format("invalid argument #2 to %q (string expected, got %s)", v23, (typeof(v26))), 2)
		end
	else
		if type(v25) ~= "string" and type(v25) ~= "number" then
			error(string.format("invalid argument #1 to %q (RegEx expected, got %s)", v23, (typeof(v25))), 2)
		end

		v25 = v.fromstring(v25)
	end

	if v23 ~= "sub" and v23 ~= "split" then
		local typeName = typeof(v27)

		if typeName ~= "nil" then
			v27 = tonumber(v27)

			if v27 then
				if v27 < 0 then
					v27 = #v26 + math.floor(v27 + 0.5) + 1
				else
					v27 = math.max(math.floor(v27 + 0.5), 1)
				end
			else
				error(string.format("invalid argument #3 to %q (number expected, got %s)", v23, typeName), 2)
			end
		end
	end

	local v31 = object[v25]

	if v23 == "match" or v23 == "matchiter" then
		v28 = ...
	elseif v23 == "sub" then
		v30 = ...
	end

	return fn10(v31, v26, v27, v28, v29, v30)
end

local function re_index(p, p2)
	return v2[p2] or object[p].flags[p2]
end

local function re_tostr(p)
	return object[p].pattern_repr .. object[p].flag_repr
end

local v24 = {
	[58] = true,
	[33] = true,
	[61] = true,
	[62] = true,
	[124] = true
}

local function tokenize_ptn(list, data)
	if data.unicode then
		return "USE_UNICODE_DATA has always been false, so you cannot also use the unicode flag"
	end

	local n = list.n
	local v25 = 1
	local result = {}
	local v26 = 0
	local result2 = {}
	local result3 = { newline = 1, newline_seq = 1, not_empty = 0 }

	while v25 <= n do
		local item = list[v25]

		if item == 40 then
			local v27 = nil

			if list[v25 + 1] == 42 then
				v25 += 2
				local v28 = v25

				while
					list[v25]
					and (list[v25] >= 48 and list[v25] <= 57 or list[v25] >= 65 and list[v25] <= 90 or list[v25] >= 97 and list[v25] <= 122 or list[v25] == 95 or list[v25] == 58)
				do
					v25 += 1
				end

				if list[v25] ~= 41 and list[v25 - 1] ~= 58 then
					return "quantifier doesn't follow a repeatable pattern"
				end

				local newline = utf8_sub(list.s, v28, v25) -- inferred equivalent call

				if
					newline == "positive_lookahead:"
					or newline == "negative_lookhead:"
					or newline == "positive_lookbehind:"
					or newline == "negative_lookbehind:"
					or newline:find("^[pn]l[ab]:$")
				then
					v27 = {
						40,
						nil,
						nil,
						newline:find("^n") and 33 or 61,
						newline:find("b", 3, true) and 1
					}
				elseif newline == "atomic:" then
					v27 = { 40, nil, nil, 62, nil }
				elseif
					newline == "ACCEPT"
					or newline == "FAIL"
					or newline == "F"
					or newline == "PRUNE"
					or newline == "SKIP"
				then
					v27 = newline == "F" and "FAIL" or newline
				else
					if v18[newline] then
						result3.newline = newline
					elseif newline == "BSR_ANYCRLF" or newline == "BSR_UNICODE" then
						result3.newline_seq = newline == "BSR_UNICODE" and 1 or 0
					else
						if newline ~= "NOTEMPTY" and newline ~= "NOTEMPTY_ATSTART" then
							return "unknown or malformed verb"
						end

						result3.not_empty = newline == "NOTEMPTY" and 1 or 2
					end

					if result[1] then
						return "this verb must be placed at the beginning of the regex"
					end
				end

				if v27 then
					table.insert(result, v27)
				end

				v25 += 1
			elseif list[v25 + 1] == 63 then
				v25 += 2

				if list[v25] == 35 then
					local index = table.find(list, 41, v25)

					if not index then
						return "unterminated parenthetical"
					end

					v25 = index + 1
				else
					if not list[v25] then
						return "unterminated parenthetical"
					end

					v27 = { 40, nil, nil, list[v25], nil }

					if list[v25] == 48 and list[v25 + 1] == 41 then
						v27[1] = "recurmatch"
						v27[2] = 0
						v27[3] = 0
						v27[5] = nil

						if v27 then
							table.insert(result, v27)
						end

						v25 += 1
					elseif list[v25] > 48 and list[v25] <= 57 then
						local v28 = v25 + 1

						while list[v28] >= 48 and list[v28] <= 48 do
							v28 += 1
						end

						if list[v28] ~= 41 then
							return "invalid group structure"
						end

						local v29 = tonumber(utf8_sub(list.s, v25, v28)) -- inferred equivalent call
						v27[1] = "recurmatch"
						v27[2] = v29
						v27[4] = nil
						v25 = v28

						if v27 then
							table.insert(result, v27)
						end

						v25 += 1
					elseif list[v25] == 60 and list[v25 + 1] == 33 or list[v25 + 1] == 61 then
						v25 += 1
						v27[4] = list[v25]
						v27[5] = 1

						if v27 then
							table.insert(result, v27)
						end

						v25 += 1
					elseif list[v25] == 124 then
						v27[5] = v26

						if v27 then
							table.insert(result, v27)
						end

						v25 += 1
					elseif list[v25] == 80 or list[v25] == 60 or list[v25] == 39 then
						if list[v25] == 80 then
							v25 += 1
						end

						if list[v25] == 61 then
							local v28 = v25 + 1

							while
								list[v25]
								and (list[v25] >= 48 and list[v25] <= 57 or list[v25] >= 65 and list[v25] <= 90 or list[v25] >= 97 and list[v25] <= 122 or list[v25] == 95)
							do
								v25 += 1
							end

							if not list[v25] then
								return "unterminated parenthetical"
							end

							if list[v25] ~= 41 or v25 == v28 then
								return "invalid group structure"
							end

							local s = list.s
							local v29 = utf8.offset(s, v25)
							v27 = { "backref", (string.sub(s, utf8.offset(s, v28), v29 and v29 - 1)) }

							if v27 then
								table.insert(result, v27)
							end

							v25 += 1
						else
							if list[v25] ~= 60 and (list[v25 - 1] == 80 or list[v25] ~= 39) then
								return "invalid group structure"
							end

							local v28 = list[v25] == 39 and 39 or 62
							local v29 = v25 + 1
							local v30 = v25 + 1

							if list[v30] == 41 then
								return "missing character in subpattern"
							end

							if list[v30] >= 48 and list[v30] <= 57 then
								return "subpattern name must not begin with a digit"
							end

							if
								not (list[v30] >= 65 and list[v30] <= 90)
								and not (list[v30] >= 97 and list[v30] <= 122)
								and list[v30] ~= 95
							then
								return "invalid character in subpattern"
							end

							v25 = v30 + 1

							while
								list[v25]
								and (list[v25] >= 48 and list[v25] <= 57 or list[v25] >= 65 and list[v25] <= 90 or list[v25] >= 97 and list[v25] <= 122 or list[v25] == 95)
							do
								v25 += 1
							end

							if not list[v25] then
								return "unterminated parenthetical"
							end

							if list[v25] ~= v28 then
								return "invalid character in subpattern"
							end

							local v31 = utf8_sub(list.s, v29, v25) -- inferred equivalent call
							v26 += 1

							if (result2[v31] or v26) ~= v26 then
								return "subpattern name already exists"
							end

							for k, v32 in pairs(result2) do
								if v31 ~= k and v26 == v32 then
									return "different names for subpatterns of the same number aren't permitted"
								end
							end

							result2[v31] = v26
							v27[2] = v26
							v27[4] = nil

							if v27 then
								table.insert(result, v27)
							end

							v25 += 1
						end
					else
						if not v24[list[v25]] then
							return "invalid group structure"
						end

						if v27 then
							table.insert(result, v27)
						end

						v25 += 1
					end
				end
			else
				v26 += 1
				v27 = { 40, v26, nil, nil }

				if v27 then
					table.insert(result, v27)
				end

				v25 += 1
			end
		elseif item == 41 then
			local v27 = #result + 1
			local v28 = 0
			local count2 = -1
			local maxValue = 0
			local count = 0

			while true do
				v27 -= 1
				local v29 = result[v27]
				local v30 = type(result[v27]) == "table"

				if v30 and v29[1] == 40 then
					count += 1

					if v28 and v29.count then
						v28 += v29.count
					end

					if v29[3] then
						if v27 < 1 then
							break
						end
					else
						if v29[4] == 124 then
							v26 = v29[5] + math.max(maxValue, count)
						end

						if v28 == count2 or count2 == -1 then
							count2 = v28
						else
							count2 = nil
						end

						break
					end
				else
					if v29 == v12 then
						if v28 == count2 or count2 == -1 then
							count2 = v28
							v28 = 0
						else
							count2 = nil
							v28 = nil
						end

						maxValue = math.max(maxValue, count)
						count = 0
					elseif v28 then
						if v30 and v29[1] == "quantifier" then
							if v29[2] == v29[3] then
								v28 += v29[2]
							else
								v28 = nil
							end
						else
							v28 += 1
						end
					end

					if v27 < 1 then
						break
					end
				end
			end

			if v27 < 1 then
				return "unmatched ) in regular expression"
			end

			local v29 = result[v27]
			local v30 = #result + 1
			local v31 = {
				41,
				v29[2],
				v27,
				v29[4],
				v29[5],
				count = count2
			}

			if (v29[4] == 33 or v29[4] == 61) and v29[5] and not count2 then
				return "lookbehind assertion is not fixed width"
			end

			v29[3] = v30
			table.insert(result, v31)

			v25 += 1
		elseif item == 46 then
			table.insert(result, v10)

			v25 += 1
		elseif item == 91 then
			local v27 = false
			local v28 = nil
			local v29 = v25 + 1

			if list[v29] == 94 then
				v25 = v29 + 1
				v27 = true
			else
				if list[v29] == 46 or list[v29] == 58 or list[v29] == 61 then
					v28 = list[v29]
				end

				v25 = v29
			end

			local v30

			if list[v25] == 91 or list[v25] == 92 then
				v30 = {}
			else
				v30 = { list[v25] }
				v25 += 1
			end

			while list[v25] ~= 93 do
				if not list[v25] then
					return "unterminated character class"
				end

				if list[v25] == 45 and v30[1] and type(v30[1]) == "number" then
					if list[v25 + 1] == 93 then
						table.insert(v30, 1, 45)

						v25 += 1
					else
						v25 += 1
						local v31 = list[v25]

						if v31 == 91 then
							if list[v25 + 1] == 46 or list[v25 + 1] == 58 or list[v25 + 1] == 61 then
								local index = v25 + 2

								repeat
									index = table.find(list, 93, index)
								until not index or list[index - 1] ~= 92

								if not index then
									return "unterminated character class"
								end

								if list[index - 1] == list[v25 + 1] and index - 1 ~= v25 + 1 then
									return "invalid range in character class"
								end
							end

							if v30[1] > 91 then
								return "invalid range in character class"
							end

							v30[1] = { "range", v30[1], v31 }

							v25 += 1
						elseif v31 == 92 then
							v25 += 1

							if list[v25] == 120 then
								local v32 = nil
								local v34 = nil
								local v35 = v25 + 1

								if
									list[v35] and list[v35] >= 48 and list[v35] <= 57
									or list[v35] >= 65 and list[v35] <= 70
									or list[v35] >= 97 and list[v35] <= 102
								then
									v32 = list[v35] - (list[v35] >= 65 and list[v35] <= 90 and 55 or list[v35] >= 97 and list[v35] <= 122 and 87 or 48)
									v25 = v35 + 1

									if
										list[v25] and list[v25] >= 48 and list[v25] <= 57
										or list[v25] >= 65 and list[v25] <= 70
										or list[v25] >= 97 and list[v25] <= 102
									then
										v34 = list[v25] - (list[v25] >= 65 and list[v25] <= 90 and 55 or list[v25] >= 97 and list[v25] <= 122 and 87 or 48)
									else
										v25 -= 1
									end
								else
									v25 = v35 - 1
								end

								v31 = v32 and (v34 and 16 * v32 + v34 or v32 or 0) or 0

								v30[1] = { "range", v30[1], v31 }

								v25 += 1
							elseif list[v25] >= 48 and list[v25] <= 55 then
								v31 = list[v25] - 48
								local v32 = nil
								local v34 = nil
								local v35 = v25 + 1

								if list[v35] and list[v35] >= 48 and list[v35] <= 55 then
									v32 = list[v35] - 48
									v25 = v35 + 1

									if list[v25] and list[v25] >= 48 and list[v25] <= 55 then
										v34 = list[v25] - 48
									else
										v25 -= 1
									end
								else
									v25 = v35 - 1
								end

								if v32 then
									v31 = v34 and 64 * v31 + 8 * v32 + v34 or 8 * v31 + v32 or v31
								end

								v30[1] = { "range", v30[1], v31 }

								v25 += 1
							else
								v31 = v6[list[v25]] or list[v25]

								if type(v31) ~= "number" then
									return "invalid range in character class"
								end

								v30[1] = { "range", v30[1], v31 }

								v25 += 1
							end
						else
							if v31 < v30[1] then
								return "invalid range in character class"
							end

							v30[1] = { "range", v30[1], v31 }

							v25 += 1
						end
					end
				elseif list[v25] == 91 then
					if list[v25 + 1] == 46 or list[v25 + 1] == 58 or list[v25 + 1] == 61 then
						local index = v25 + 2

						repeat
							index = table.find(list, 93, index)
						until not index or list[index - 1] ~= 92

						if not index then
							return "unterminated character class"
						end

						if list[index - 1] == list[v25 + 1] and index - 1 ~= v25 + 1 then
							if list[index - 1] == 46 or list[index - 1] == 61 then
								return "POSIX collating elements aren't supported"
							end

							if list[index - 1] == 58 then
								local v31 = list[v25 + 3] == 94
								local v32 = utf8_sub(list.s, v25 + (v31 and 3 or 2), index - 1) -- inferred equivalent call

								if not v5[v32] then
									return "unknown POSIX class name"
								end

								table.insert(v30, 1, { "class", v32, v31 })
								v25 = index
							end

							v25 += 1
							continue
						end
					end

					table.insert(v30, 1, 91)

					v25 += 1
				elseif list[v25] == 92 then
					v25 += 1

					if list[v25] == 120 then
						local v31 = nil
						local v32 = nil
						local v34 = v25 + 1

						if list[v34] == 123 then
							v25 = v34 + 1
							local v35 = v25

							while
								list[v25]
								and (list[v25] >= 48 and list[v25] <= 57 or list[v25] >= 65 and list[v25] <= 70 or list[v25] >= 97 and list[v25] <= 102)
							do
								v25 += 1
							end

							if list[v25] ~= 125 or v25 == v35 then
								return "malformed hexadecimal character"
							end

							if v25 - v35 > 4 then
								return "character offset too large"
							end

							table.insert(v30, 1, (tonumber(utf8_sub(list.s, v35, v25), 16))) -- inferred equivalent call

							v25 += 1
						else
							if
								list[v34] and list[v34] >= 48 and list[v34] <= 57
								or list[v34] >= 65 and list[v34] <= 70
								or list[v34] >= 97 and list[v34] <= 102
							then
								v31 = list[v34] - (list[v34] >= 65 and list[v34] <= 90 and 55 or list[v34] >= 97 and list[v34] <= 122 and 87 or 48)
								v25 = v34 + 1

								if
									list[v25] and list[v25] >= 48 and list[v25] <= 57
									or list[v25] >= 65 and list[v25] <= 70
									or list[v25] >= 97 and list[v25] <= 102
								then
									v32 = list[v25] - (list[v25] >= 65 and list[v25] <= 90 and 55 or list[v25] >= 97 and list[v25] <= 122 and 87 or 48)
								else
									v25 -= 1
								end
							else
								v25 = v34 - 1
							end

							table.insert(v30, 1, v31 and (v32 and 16 * v31 + v32 or v31 or 0) or 0)

							v25 += 1
						end
					elseif list[v25] >= 48 and list[v25] <= 55 then
						local v31 = list[v25] - 48
						local v32 = nil
						local v34 = nil
						local v35 = v25 + 1

						if list[v35] and list[v35] >= 48 and list[v35] <= 55 then
							v32 = list[v35] - 48
							v25 = v35 + 1

							if list[v25] and list[v25] >= 48 and list[v25] <= 55 then
								v34 = list[v25] - 48
							else
								v25 -= 1
							end
						else
							v25 = v35 - 1
						end

						if v32 then
							v31 = v34 and 64 * v31 + 8 * v32 + v34 or 8 * v31 + v32 or v31
						end

						table.insert(v30, 1, v31)

						v25 += 1
					elseif list[v25] == 69 then
						v25 += 1
					elseif list[v25] == 81 then
						local v31 = v25 + 1

						repeat
							v25 = table.find(list, 92, v25 + 1)
						until not v25 or list[v25 + 1] == 69

						table.move(list, v31, v25 and v25 - 1 or #list, #result + 1, result)

						if not v25 then
							break
						end

						v25 += 1

						v25 += 1
					elseif list[v25] == 78 then
						if list[v25 + 1] ~= 123 or list[v25 + 2] ~= 85 or list[v25 + 3] ~= 43 or not data.unicode then
							return "invalid escape sequence"
						end

						v25 += 4
						local v31 = v25

						while
							list[v25]
							and (list[v25] >= 48 and list[v25] <= 57 or list[v25] >= 65 and list[v25] <= 70 or list[v25] >= 97 and list[v25] <= 102)
						do
							v25 += 1
						end

						if list[v25] ~= 125 or v25 == v31 then
							return "malformed Unicode code point"
						end

						table.insert(v30, 1, (tonumber(utf8_sub(list.s, v31, v25)))) -- inferred equivalent call

						v25 += 1
					else
						if list[v25] == 80 or list[v25] == 112 then
							return "USE_UNICODE_DATA in regexp has always been disabled. Do not use the flag \\p"
						end

						if list[v25] == 111 then
							local v31 = v25 + 1

							if list[v31] ~= 123 then
								return "malformed octal code"
							end

							v25 = v31 + 1
							local v32 = v25

							while list[v25] and list[v25] >= 48 and list[v25] <= 55 do
								v25 += 1
							end

							if list[v25] ~= 125 or v25 == v32 then
								return "malformed octal code"
							end

							local v34 = tonumber(utf8_sub(list.s, v32, v25), 8) -- inferred equivalent call

							if v34 > 65535 then
								return "character offset too large"
							end

							table.insert(v30, 1, v34)

							v25 += 1
						else
							local v31 = v6[list[v25]]
							table.insert(v30, 1, type(v31) == "string" and { "class", v31, false } or v31 or list[v25])

							v25 += 1
						end
					end
				else
					if data.ignoreCase and list[v25] >= 97 and list[v25] <= 122 then
						table.insert(v30, 1, list[v25] - 32)
					else
						table.insert(v30, 1, list[v25])
					end

					v25 += 1
				end
			end

			if list[v25 - 1] == v28 and v25 - 1 ~= v29 then
				if v28 == 58 then
					return "POSIX named classes are only support within a character set"
				end

				return "POSIX collating elements aren't supported"
			end

			if v30[2] or v27 then
				table.insert(result, { "charset", v27, v30 })
			else
				table.insert(result, v30[1])
			end

			v25 += 1
		elseif item == 92 then
			v25 += 1
			local item2 = list[v25]

			if not item2 then
				return "pattern may not end with a trailing backslash"
			end

			if item2 >= 48 and item2 <= 57 then
				local v27 = v25

				while list[v25 + 1] and list[v25 + 1] >= 48 and list[v25 + 1] <= 57 do
					v25 += 1
				end

				local v28 = tonumber(utf8_sub(list.s, v27, v25 + 1)) -- inferred equivalent call

				if v26 < v28 and v25 ~= v27 then
					local v29 = nil
					local v30 = nil
					local v31

					if list[v27] <= 55 then
						v31 = list[v27] - 48
						local v32 = v27 + 1

						if list[v32] and list[v32] >= 48 and list[v32] <= 55 then
							v29 = list[v32] - 48
							v25 = v32 + 1

							if list[v25] and list[v25] >= 48 and list[v25] <= 55 then
								v30 = list[v25] - 48
							else
								v25 -= 1
							end
						else
							v25 = v32 - 1
						end
					else
						v25 = v27
					end

					local v32

					if v31 then
						v32 = v29 and (v30 and 64 * v31 + 8 * v29 + v30 or 8 * v31 + v29)

						if not v32 then
							if v31 then
								v32 = v31
							else
								v32 = list[v27]
							end
						end
					else
						v32 = list[v27]
					end

					table.insert(result, v32)
				else
					table.insert(result, { "backref", v28 })
				end

				v25 += 1
			elseif item2 == 69 then
				v25 += 1
			elseif item2 == 81 then
				local v27 = v25 + 1

				repeat
					v25 = table.find(list, 92, v25 + 1)
				until not v25 or list[v25 + 1] == 69

				table.move(list, v27, v25 and v25 - 1 or #list, #result + 1, result)

				if not v25 then
					break
				end

				v25 += 1

				v25 += 1
			elseif item2 == 78 then
				if list[v25 + 1] == 123 and list[v25 + 2] == 85 and list[v25 + 3] == 43 and data.unicode then
					v25 += 4
					local v27 = v25

					while
						list[v25]
						and (list[v25] >= 48 and list[v25] <= 57 or list[v25] >= 65 and list[v25] <= 70 or list[v25] >= 97 and list[v25] <= 102)
					do
						v25 += 1
					end

					if list[v25] ~= 125 or v25 == v27 then
						return "malformed Unicode code point"
					end

					table.insert(result, (tonumber(utf8_sub(list.s, v27, v25)))) -- inferred equivalent call

					v25 += 1
				else
					table.insert(result, v6[78])

					v25 += 1
				end
			else
				if item2 == 80 or item2 == 112 then
					return "USE_UNICODE_DATA in regexp has always been disabled. Do not use the flag \\p"
				end

				if item2 == 103 and (list[v25 + 1] == 123 or list[v25 + 1] >= 48 and list[v25 + 1] <= 57) then
					local v27 = false
					v25 += 1
					local v28, s, v29, v30

					if list[v25] == 123 then
						v25 += 1
						v27 = true
					elseif list[v25] < 48 or list[v25] > 57 then
						return "malformed reference code"
					end

					v28 = v25

					while
						list[v25]
						and (list[v25] >= 48 and list[v25] <= 57 or list[v25] >= 65 and list[v25] <= 70 or list[v25] >= 97 and list[v25] <= 102)
					do
						v25 += 1
					end

					if v27 and list[v25] ~= 125 then
						return "malformed reference code"
					end

					s = list.s
					v29 = v25 + (v27 and 0 or 1)
					v30 = utf8.offset(s, v29)
					table.insert(result, {
						"backref",
						(tonumber((string.sub(s, utf8.offset(s, v28), v30 and v30 - 1))))
					})

					if not v27 then
						v25 -= 1
					end

					v25 += 1
				elseif item2 == 111 then
					local v27 = v25 + 1

					if list[v27 + 1] ~= 123 then
						return "malformed octal code"
					end

					v25 = v27 + 1
					local v28 = v25

					while list[v25] and list[v25] >= 48 and list[v25] <= 55 do
						v25 += 1
					end

					if list[v25] ~= 125 or v25 == v28 then
						return "malformed octal code"
					end

					local v29 = tonumber(utf8_sub(list.s, v28, v25), 8) -- inferred equivalent call

					if v29 > 65535 then
						return "character offset too large"
					end

					table.insert(result, v29)

					v25 += 1
				elseif item2 == 120 then
					local v27 = nil
					local v28 = nil
					local v29 = v25 + 1

					if list[v29] == 123 then
						v25 = v29 + 1
						local v30 = v25

						while
							list[v25]
							and (list[v25] >= 48 and list[v25] <= 57 or list[v25] >= 65 and list[v25] <= 70 or list[v25] >= 97 and list[v25] <= 102)
						do
							v25 += 1
						end

						if list[v25] ~= 125 or v25 == v30 then
							return "malformed hexadecimal code"
						end

						if v25 - v30 > 4 then
							return "character offset too large"
						end

						table.insert(result, (tonumber(utf8_sub(list.s, v30, v25), 16))) -- inferred equivalent call

						v25 += 1
					else
						if
							list[v29]
							and (list[v29] >= 48 and list[v29] <= 57 or list[v29] >= 65 and list[v29] <= 70 or list[v29] >= 97 and list[v29] <= 102)
						then
							v27 = list[v29] - (list[v29] >= 65 and list[v29] <= 90 and 55 or list[v29] >= 97 and list[v29] <= 122 and 87 or 48)
							v25 = v29 + 1

							if
								list[v25]
								and (list[v25] >= 48 and list[v25] <= 57 or list[v25] >= 65 and list[v25] <= 70 or list[v25] >= 97 and list[v25] <= 102)
							then
								v28 = list[v25] - (list[v25] >= 65 and list[v25] <= 90 and 55 or list[v25] >= 97 and list[v25] <= 122 and 87 or 48)
							else
								v25 -= 1
							end
						else
							v25 = v29 - 1
						end

						table.insert(result, v27 and (v28 and 16 * v27 + v28 or v27 or 0) or 0)

						v25 += 1
					end
				else
					table.insert(result, v7[item2] or v6[item2] or item2)

					v25 += 1
				end
			end
		elseif item == 42 or item == 43 or item == 63 or item == 123 then
			local v27 = nil
			local v28 = nil
			local v29, v30, v31

			if item == 123 then
				local v32 = v25 + 1
				local v34 = nil

				while
					list[v25 + 1]
					and (list[v25 + 1] >= 48 and list[v25 + 1] <= 57 or list[v25 + 1] == 44 and not v34 and v25 + 1 ~= v32)
				do
					v25 += 1

					if list[v25] == 44 then
						v34 = v25
					end
				end

				if list[v25 + 1] == 125 then
					v25 += 1

					if v34 then
						v27 = tonumber(utf8_sub(list.s, v32, v34)) -- inferred equivalent call

						if v34 + 1 == v25 then
							v28 = 1e999
						else
							v28 = tonumber(utf8_sub(list.s, v34 + 1, v25)) -- inferred equivalent call
						end

						if v28 < v27 then
							return "numbers out of order in {} quantifier"
						end
					else
						v27 = tonumber(utf8_sub(list.s, v32, v25)) -- inferred equivalent call
						v28 = v27
					end
				else
					table.move(list, v32 - 1, v25, #result + 1, result)
				end

				if v27 then
					v29 = data.ungreedy and "lazy" or "greedy"

					if list[v25 + 1] == 43 or list[v25 + 1] == 63 then
						v25 += 1
						v29 = list[v25] == 43 and "possessive" or data.ungreedy and "greedy" or "lazy"
					end

					v30 = #result
					v31 = result[v30]

					if
						not v31
						or type(v31) == "table" and (v31[1] == "quantifier" or v31[1] == 40 or v7[v31[1]])
						or v31 == v12
						or type(v31) == "string"
					then
						return "quantifier doesn't follow a repeatable pattern"
					end

					if v28 == 0 then
						table.remove(result)
					elseif v27 ~= 1 or v28 ~= 1 then
						if type(v31) == "table" and v31[1] == 41 then
							v30 = v31[3]
						end

						result[v30] = { "quantifier", v27, v28, v29, result[v30] }
					end
				end

				v25 += 1
			else
				v27 = item == 43 and 1 or 0
				v28 = item == 63 and 1 or 1e999

				if v27 then
					v29 = data.ungreedy and "lazy" or "greedy"

					if list[v25 + 1] == 43 or list[v25 + 1] == 63 then
						v25 += 1
						v29 = list[v25] == 43 and "possessive" or data.ungreedy and "greedy" or "lazy"
					end

					v30 = #result
					v31 = result[v30]

					if
						not v31
						or type(v31) == "table" and (v31[1] == "quantifier" or v31[1] == 40 or v7[v31[1]])
						or v31 == v12
						or type(v31) == "string"
					then
						return "quantifier doesn't follow a repeatable pattern"
					end

					if v28 == 0 then
						table.remove(result)
					elseif v27 ~= 1 or v28 ~= 1 then
						if type(v31) == "table" and v31[1] == 41 then
							v30 = v31[3]
						end

						result[v30] = { "quantifier", v27, v28, v29, result[v30] }
					end
				end

				v25 += 1
			end
		else
			if item == 124 then
				table.insert(result, v12)
				local v27 = #result

				while true do
					v27 -= 1
					local v28 = result[v27]
					local v29 = type(result[v27]) == "table"

					if v29 and v28[1] == 41 then
						v27 = result[v27][3]

						if not v28 then
							break
						end
					elseif v29 and v28[1] == 40 then
						if v28[4] ~= 124 then
							break
						end

						v26 = v28[5]
						break
					elseif not v28 then
						break
					end
				end
			elseif item == 36 or item == 94 then
				table.insert(result, item == 94 and v11 or v9)
			elseif data.ignoreCase and item >= 97 and item <= 122 then
				table.insert(result, item - 32)
			elseif data.extended and (item >= 9 and item <= 13 or item == 32 or item == 35) then
				if item == 35 then
					repeat
						v25 += 1
					until not list[v25] or list[v25] == 10 or list[v25] == 13
				end
			else
				table.insert(result, item)
			end

			v25 += 1
		end
	end

	local maxValue = 0

	for _, v27 in ipairs(result) do
		if
			type(v27) == "table"
			and (v27[1] == 40 or v27[1] == "quantifier" and type(v27[5]) == "table" and v27[5][1] == 40)
		then
			if v27[1] == "quantifier" then
				v27 = v27[5]
			end

			if not v27[3] then
				return "unterminated parenthetical"
			end

			if v27[2] then
				maxValue = math.max(maxValue, v27[2])
			end
		elseif type(v27) == "table" and (v27[1] == "backref" or v27[1] == "recurmatch") then
			if not result2[v27[2]] and (type(v27[2]) ~= "number" or v26 < v27[2]) then
				return "reference to a non-existent or invalid subpattern"
			end

			if v27[1] == "recurmatch" and v27[2] ~= 0 then
				for i, v28 in ipairs(result) do
					if type(v28) == "table" and v28[1] == 40 and v28[2] == v27[2] then
						v27[3] = i
						break
					end
				end
			elseif type(v27[2]) == "string" then
				v27[2] = result2[v27[2]]
			end
		end
	end

	result.group_n = maxValue
	return result, result2, result3
end

if not tonumber(256) then
	error(string.format("expected number for options.cacheSize, got %s", "number"), 2)
end

local v25 = tonumber(256)
local v26 = nil
local v27 = nil

if v25 then
	if v25 < 0 or v25 ~= v25 then
		error("cache size cannot be a negative number or a NaN", 2)
	elseif v25 == 1e999 then
		v27 = { nil }
		v26 = { nil }
	elseif v25 >= 4294967296 then
		error("cache size too large", 2)
	else
		v26 = table.create(256)
		v27 = table.create(256)
	end
end

if v25 then
	function v.pruge()
		table.clear(v27)
		table.clear(v26)
	end
end

local function new_re(p, flags, joined, pattern_repr)
	local v28 = v25 and string.format("%s|%s", p.s, joined)
	local v29 = v25 and v26[table.find(v27, v28)]
	local token, group_id, verb_flags

	if v29 then
		token, group_id, verb_flags = table.unpack(v29, 1, 3)
	else
		token, group_id, verb_flags = tokenize_ptn(p, flags)

		if type(token) == "string" then
			error(token, 2)
		end

		if v25 and token[1] then
			table.insert(v27, 1, v28)
			table.insert(v26, 1, { token, group_id, verb_flags })

			if v25 ~= 1e999 then
				table.remove(v27, v25 + 1)
				table.remove(v26, v25 + 1)
			end
		end
	end

	local v30 = newproxy(true)
	object[v30] = {
		name = "RegEx",
		flags = flags,
		flag_repr = joined,
		pattern_repr = pattern_repr,
		token = token,
		group_id = group_id,
		verb_flags = verb_flags
	}
	local metatable = getmetatable(v30)
	metatable.__index = setmetatable(flags, v2)
	metatable.__tostring = re_tostr
	metatable.__metatable = metatable2

	return v30
end

local function escape_fslash(list)
	return (#list % 2 == 0 and "\\" or "") .. list .. "."
end

local function sort_flag_chr(value, value2): boolean
	return value:lower() < value2:lower()
end

function v.new(...)
	if select("#", ...) == 0 then
		error("missing argument #1 (string expected)", 2)
	end

	local v28, v29 = ...

	if type(v28) == "number" then
		v28 ..= ""
	elseif type(v28) ~= "string" then
		error(string.format("invalid argument #1 (string expected, got %s)", (typeof(v28))), 2)
	end

	if type(v29) ~= "string" and type(v29) ~= "number" and v29 ~= nil then
		error(string.format("invalid argument #2 (string expected, got %s)", (typeof(v29))), 2)
	end

	local flags = {
		anchored = false,
		caseless = false,
		multiline = false,
		dotall = false,
		unicode = false,
		ungreedy = false,
		extended = false
	}

	local v30 = {}

	for k in string.gmatch(v29 or "", utf8.charpattern) do
		if flags[v4[k]] ~= false then
			error("invalid regular expression flag " .. k, 3)
		end

		flags[v4[k]] = true
		table.insert(v30, k)
	end

	table.sort(v30, sort_flag_chr)
	local joined = table.concat(v30)
	return new_re(to_str_arr(v28), flags, joined, string.format("/%s/", v28:gsub("(\\*)/", escape_fslash)))
end

function v.fromstring(...)
	if select("#", ...) == 0 then
		error("missing argument #1 (string expected)", 2)
	end

	local v28 = ...

	if type(v28) == "number" then
		v28 ..= ""
	elseif type(v28) ~= "string" then
		error(string.format("invalid argument #1 (string expected, got %s)", typeof(v28), 2))
	end

	local v29 = to_str_arr(v28)
	local v30 = v29[1]

	if v30 then
		if v30 == 92 or v30 >= 48 and v30 <= 57 or v30 >= 65 and v30 <= 90 or v30 >= 97 and v30 <= 122 then
			error("delimiter must not be alphanumeric or a backslash", 2)
		end
	else
		error("empty regex", 2)
	end

	local v31 = 1

	repeat
		v31 = table.find(v29, v30, v31 + 1)

		if not v31 then
			error(string.format("no ending delimiter ('%s') found", utf8.char(v30)), 2)
		end

		local v32 = 1

		while v29[v31 - v32] == 92 do
			v32 += 1
		end
	until v32 % 2 == 1

	local flags = {
		anchored = false,
		caseless = false,
		multiline = false,
		dotall = false,
		unicode = false,
		ungreedy = false,
		extended = false
	}

	local v32 = {}

	while v31 < v29.n do
		local v35 = utf8.char(table.remove(v29))
		v29.n -= 1

		if flags[v4[v35]] ~= false then
			error("invalid regular expression flag " .. v35, 3)
		end

		flags[v4[v35]] = true
		table.insert(v32, v35)
	end

	table.sort(v32, sort_flag_chr)
	local joined = table.concat(v32)
	table.remove(v29, 1)
	table.remove(v29)
	v29.n -= 2
	v29.s = string.sub(v29.s, 2, 1 + v29.n)
	return new_re(v29, flags, joined, string.sub(v28, 1, 2 + v29.n))
end

local v28 = {
	["\0"] = "\\x00",
	["\n"] = "\\n",
	["\t"] = "\\t",
	["\r"] = "\\r",
	["\f"] = "\\f"
}

function v.escape(...)
	if select("#", ...) == 0 then
		error("missing argument #1 (string expected)", 2)
	end

	local v29, v30, v31 = ...

	if type(v29) == "number" then
		v29 ..= ""
	elseif type(v29) ~= "string" then
		error(string.format("invalid argument #1 to 'escape' (string expected, got %s)", (typeof(v29))), 2)
	end

	if v31 == nil then
		v31 = ""
	elseif type(v31) == "number" then
		v31 ..= ""
	elseif type(v31) ~= "string" then
		error(string.format("invalid argument #3 to 'escape' (string expected, got %s)", (typeof(v31))), 2)
	end

	if utf8.len(v31) > 1 or v31:match("^[%a\\]$") then
		error("delimiter have not be alphanumeric", 2)
	end

	return (string.gsub(v29, "[\0\f\n\r\t]", v28):gsub(
		string.format("[\\%s#()%%%%*+.?[%%]^{|%s]", v30 and "%s" or "", (v31:find("^[%%%]]$") and "%" or "") .. v31),
		"\\%1"
	))
end

function v.type(...)
	if select("#", ...) == 0 then
		error("missing argument #1", 2)
	end

	return object[...] and object[...].name
end

for k, v29 in pairs(v2) do
	v[k] = v29
end

v2 = { __index = v2 }

metatable2 = v.fromstring("/The\\s*metatable\\s*is\\s*(?:locked|inaccessible)(?#Nice try :])/i")
getmetatable(metatable2).__metatable = metatable2

local function readonly_table()
	error("Attempt to modify a readonly table", 2)
end

v3 = { __index = v3, __metatable = metatable2, __newindex = readonly_table }

v.Match = setmetatable({}, v3)

return (setmetatable({}, { __index = v, __metatable = metatable2, __newindex = readonly_table }))
