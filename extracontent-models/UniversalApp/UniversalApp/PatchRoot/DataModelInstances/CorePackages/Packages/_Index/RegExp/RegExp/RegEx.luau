local t1 = {
	cacheSize = 256,
	unicodeData = false
}
local v2 = t1.unicodeData and require(script:WaitForChild("_unicodechar_category"))
local v3 = t1.unicodeData and require(script:WaitForChild("_scripts"))
local v4 = t1.unicodeData and require(script:WaitForChild("_xuc"))
local self = setmetatable({}, {
	__mode = "k"
})
local t2 = {}
local t3 = {}
local t4 = {}
local u9 = nil

local function to_str_arr(p1, p2) -- line: 54
	if p2 then
		p1 = string.sub(p1, utf8.offset(p1, p2))
	end

	local v68 = utf8.len(p1)

	if v68 <= 1999 then
		return {
			n = v68,
			s = p1,
			utf8.codepoint(p1, 1, #p1)
		}
	end

	local v69 = math.ceil(v68 / 1999)
	local t5 = table.create(v68)
	local n1 = 1

	for i = 1, v69 do
		local v73 = table.pack(utf8.codepoint(p1, utf8.offset(p1, i * 1999 - 1998), utf8.offset(p1, i * 1999 - (i == v69 and 1998 - ((v68 - 1) % 1999 + 1) or -1)) - 1))

		table.move(v73, 1, v73.n, n1, t5)
		n1 += v73.n
	end

	t5.s = p1
	t5.n = v68

	return t5
end
local function from_str_arr(p3) -- line: 74
	local v75 = p3.n or #p3

	if v75 <= 7997 then
		return utf8.char(table.unpack(p3))
	end

	local v76 = math.ceil(v75 / 7997)
	local t6 = table.create(v76)

	for i = 1, v76 do
		t6[i] = utf8.char(table.unpack(p3, i * 7997 - 7996, i * 7997 - (i == v76 and 7997 - ((v75 - 1) % 7997 + 1) or 0)))
	end

	return table.concat(t6)
end
local function utf8_sub(p4, p5, p6) -- line: 87
	local v82 = utf8.offset(p4, p6)

	return (string.sub(p4, utf8.offset(p4, p5), v82 and v82 - 1))
end

local t7 = {
	a = "anchored",
	i = "caseless",
	m = "multiline",
	s = "dotall",
	u = "unicode",
	U = "ungreedy",
	x = "extended"
}
local t8 = {
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
local t9 = {
	[68] = {
		"class",
		"digit",
		true
	},
	[83] = {
		"class",
		"space",
		true
	},
	[87] = {
		"class",
		"word",
		true
	},
	[100] = {
		"class",
		"digit",
		false
	},
	[115] = {
		"class",
		"space",
		false
	},
	[119] = {
		"class",
		"word",
		false
	},
	[72] = {
		"class",
		"blank",
		true
	},
	[86] = {
		"class",
		"vertical_tab",
		true
	},
	[104] = {
		"class",
		"blank",
		false
	},
	[118] = {
		"class",
		"vertical_tab",
		false
	},
	[78] = { 78 },
	[82] = { 82 },
	[66] = 8,
	[110] = 10,
	[114] = 13,
	[116] = 9
}
local t10 = {
	[98] = {
		98,
		{
			"class",
			"word",
			false
		}
	},
	[66] = {
		66,
		{
			"class",
			"word",
			false
		}
	},
	[75] = { 75 },
	[71] = { 71 },
	[74] = { 74 },
	[90] = { 90 },
	[122] = { 122 }
}
local t11 = {
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
local t12 = {
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
local t13 = { 36 }
local t14 = { 46 }
local t15 = { 94 }
local t16 = { 124 }

local function check_re(p7, p8, p9) -- line: 150
	-- upvalues: self (copy), t2 (copy)
	if p7 == "Match" then
		return function(...) -- line: 152
			-- upvalues: self (copy), p8 (copy), p9 (copy)
			if select("#", ...) < 1 then
				error("missing argument #1 (Match expected)", 2)
			end

			local v572, v573 = ...

			if not self[v572] or self[v572].name ~= "Match" then
				error(string.format("invalid argument #1 to %q (Match expected, got %s)", p8, (typeof(v572))), 2)
			else
				v572 = self[v572]
			end

			if (p8 == "group" or p8 == "span") and v573 == nil then
				v573 = 0
			end

			return p9(v572, v573)
		end
	end

	return function(...) -- line: 171
		-- upvalues: self (copy), p8 (copy), t2 (copy), p9 (copy)
		local v574 = select("#", ...)

		if v574 < 1 then
			error("missing argument #1 (RegEx expected)", 2)
		elseif v574 < 2 then
			error("missing argument #2 (string expected)", 2)
		end

		local v575, v576, v577, v578, v579, v580 = ...

		if not self[v575] or self[v575].name ~= "RegEx" then
			if type(v575) ~= "string" and type(v575) ~= "number" then
				error(string.format("invalid argument #1 to %q (RegEx expected, got %s)", p8, (typeof(v575))), 2)
			end

			v575 = t2.fromstring(v575)
		elseif p8 == "sub" then
			if type(v577) == "number" then
				v577 ..= ""
			elseif type(v577) ~= "string" then
				error(string.format("invalid argument #3 to 'sub' (string expected, got %s)", (typeof(v577))), 2)
			end
		elseif type(v576) == "number" then
			v576 ..= ""
		elseif type(v576) ~= "string" then
			error(string.format("invalid argument #2 to %q (string expected, got %s)", p8, (typeof(v576))), 2)
		end

		if p8 ~= "sub" and p8 ~= "split" then
			local v581 = typeof(v577)

			if v581 ~= "nil" then
				v577 = tonumber(v577)

				if not v577 then
					error(string.format("invalid argument #3 to %q (number expected, got %s)", p8, v581), 2)
				else
					v577 = if not (v577 < 0) then math.max(math.floor(v577 + 0.5), 1) else #v576 + math.floor(v577 + 0.5) + 1
				end
			end
		end

		local v582 = self[v575]

		if p8 == "match" or p8 == "matchiter" then
			v578 = ...
		elseif p8 == "sub" then
			v580 = ...
		end

		return p9(v582, v576, v577, v578, v579, v580)
	end
end
local function match_tostr(p10) -- line: 219
	-- upvalues: self (copy)
	local spans = self[p10].spans
	local v88 = spans[0][1]
	local v89 = spans[0][2]

	if v89 <= v88 then
		return string.format("Match (%d..%d, empty)", v88, v89 - 1)
	end

	local format = string.format
	local v91 = v89 - 1
	local input = spans.input
	local v93 = utf8.offset(input, v89)

	return format("Match (%d..%d): %s", v88, v91, (string.sub(input, utf8.offset(input, v88), v93 and v93 - 1)))
end
local function new_match(p11, p12, p13, p14) -- line: 228
	-- upvalues: u9 (ref), t4 (ref), match_tostr (copy), self (copy)
	p11.source = p13
	p11.input = p14

	local v98 = newproxy(true)
	local mt = getmetatable(v98)

	mt.__metatable = u9
	mt.__index = setmetatable(p11, t4)
	mt.__tostring = match_tostr
	self[v98] = {
		name = "Match",
		spans = p11,
		group_id = p12
	}

	return v98
end
local function v26(p15, p16) -- line: 240
	local v102 = p15.spans[type(p16) == "number" and p16 or p15.group_id[p16]]

	if not v102 then
		return nil
	end

	local input = p15.spans.input
	local v104 = v102[1]
	local v105 = v102[2]
	local v106 = utf8.offset(input, v105)

	return (string.sub(input, utf8.offset(input, v104), v106 and v106 - 1))
end

local s1 = "group"

function t4.group(...) -- line: 152
	-- upvalues: self (copy), s1 (copy), v26 (copy)
	if select("#", ...) < 1 then
		error("missing argument #1 (Match expected)", 2)
	end

	local v107, v108 = ...

	if not self[v107] or self[v107].name ~= "Match" then
		error(string.format("invalid argument #1 to %q (Match expected, got %s)", s1, (typeof(v107))), 2)
	else
		v107 = self[v107]
	end

	if (s1 == "group" or s1 == "span") and v108 == nil then
		v108 = 0
	end

	return v26(v107, v108)
end

local function v28(p17, p18) -- line: 248
	local v111 = p17.spans[type(p18) == "number" and p18 or p17.group_id[p18]]

	if not v111 then
		return nil
	end

	return v111[1], v111[2] - 1
end

local s2 = "span"

function t4.span(...) -- line: 152
	-- upvalues: self (copy), s2 (copy), v28 (copy)
	if select("#", ...) < 1 then
		error("missing argument #1 (Match expected)", 2)
	end

	local v112, v113 = ...

	if not self[v112] or self[v112].name ~= "Match" then
		error(string.format("invalid argument #1 to %q (Match expected, got %s)", s2, (typeof(v112))), 2)
	else
		v112 = self[v112]
	end

	if (s2 == "group" or s2 == "span") and v113 == nil then
		v113 = 0
	end

	return v28(v112, v113)
end

local function v30(p19) -- line: 256
	local spans = p19.spans

	if spans.n > 0 then
		local t17 = table.create(spans.n)

		for i = 0, spans.n do
			local v118 = spans[i]

			if v118 then
				local input = spans.input
				local v120 = v118[1]
				local v121 = v118[2]
				local v122 = utf8.offset(input, v121)

				t17[i] = string.sub(input, utf8.offset(input, v120), v122 and v122 - 1)
			end
		end

		return table.unpack(t17, 1, spans.n)
	end

	local input = spans.input
	local v124 = spans[0][1]
	local v125 = spans[0][2]
	local v126 = utf8.offset(input, v125)

	return (string.sub(input, utf8.offset(input, v124), v126 and v126 - 1))
end

local s3 = "groups"

function t4.groups(...) -- line: 152
	-- upvalues: self (copy), s3 (copy), v30 (copy)
	if select("#", ...) < 1 then
		error("missing argument #1 (Match expected)", 2)
	end

	local v127, v128 = ...

	if not self[v127] or self[v127].name ~= "Match" then
		error(string.format("invalid argument #1 to %q (Match expected, got %s)", s3, (typeof(v127))), 2)
	else
		v127 = self[v127]
	end

	if (s3 == "group" or s3 == "span") and v128 == nil then
		v128 = 0
	end

	return v30(v127, v128)
end

local function v32(p20) -- line: 271
	local spans = p20.spans
	local t18 = {}

	for k, v in pairs(p20.group_id) do
		local v134 = spans[v]

		if v134 then
			local input = spans.input
			local v136 = v134[1]
			local v137 = v134[2]
			local v138 = utf8.offset(input, v137)

			t18[k] = string.sub(input, utf8.offset(input, v136), v138 and v138 - 1)
		end
	end

	return t18
end

local s4 = "groupdict"

function t4.groupdict(...) -- line: 152
	-- upvalues: self (copy), s4 (copy), v32 (copy)
	if select("#", ...) < 1 then
		error("missing argument #1 (Match expected)", 2)
	end

	local v139, v140 = ...

	if not self[v139] or self[v139].name ~= "Match" then
		error(string.format("invalid argument #1 to %q (Match expected, got %s)", s4, (typeof(v139))), 2)
	else
		v139 = self[v139]
	end

	if (s4 == "group" or s4 == "span") and v140 == nil then
		v140 = 0
	end

	return v32(v139, v140)
end

local function v34(p21) -- line: 283
	local spans = p21.spans
	local t19 = table.create(spans.n)

	for i = 0, spans.n do
		local v145 = spans[i]

		if v145 then
			local input = spans.input
			local v147 = v145[1]
			local v148 = v145[2]
			local v149 = utf8.offset(input, v148)

			t19[i] = string.sub(input, utf8.offset(input, v147), v149 and v149 - 1)
		end
	end

	t19.n = spans.n

	return t19
end

local s5 = "groupdict"

function t4.grouparr(...) -- line: 152
	-- upvalues: self (copy), s5 (copy), v34 (copy)
	if select("#", ...) < 1 then
		error("missing argument #1 (Match expected)", 2)
	end

	local v150, v151 = ...

	if not self[v150] or self[v150].name ~= "Match" then
		error(string.format("invalid argument #1 to %q (Match expected, got %s)", s5, (typeof(v150))), 2)
	else
		v150 = self[v150]
	end

	if (s5 == "group" or s5 == "span") and v151 == nil then
		v151 = 0
	end

	return v34(v150, v151)
end

local t20 = {
	CR = 0,
	LF = 1,
	CRLF = 2,
	ANYRLF = 3,
	ANY = 4,
	NUL = 5
}

local function is_newline(p22, p23, p24) -- line: 300
	local newline = p24.newline
	local v156 = p22[p23]

	if newline == 0 then
		return v156 == 13
	end

	if newline == 2 then
		return v156 == 10 and p22[p23 - 1] == 32
	end

	if newline == 3 then
		return v156 == 10 or v156 == 13
	end

	if newline == 4 then
		return v156 == 10 or (v156 == 11 or (v156 == 12 or (v156 == 13 or (v156 == 133 or (v156 == 8232 or v156 == 8233)))))
	end

	if newline == 5 then
		return v156 == 0
	end

	return v156 == 10
end
local function tkn_char_match(p25, p26, p27, p28, p29) -- line: 324
	-- upvalues: tkn_char_match (copy), v2 (copy), t12 (copy), v4 (copy), is_newline (copy)
	local v162 = p26[p27]

	if not v162 then
		return false
	end

	if p28.ignoreCase and v162 >= 97 and v162 <= 122 then
		v162 -= 32
	end

	if type(p25) == "number" then
		return p25 == v162
	end

	if p25[1] == "charset" then
		for _, v in ipairs(p25[3]) do
			if tkn_char_match(v, p26, p27, p28, p29) then
				return not p25[2]
			end
		end

		return p25[2]
	end

	if p25[1] == "range" then
		return v162 >= p25[2] and v162 <= p25[3] or p28.ignoreCase and (v162 >= 65 and (v162 <= 90 and (v162 + 32 >= p25[2] and v162 + 32 <= p25[3])))
	end

	if p25[1] == "class" then
		local v165 = p25[2]
		local v166 = p25[3]
		local v167 = false

		if v165 == "xdigit" then
			v167 = v162 >= 48 and v162 <= 57 or (v162 >= 65 and v162 <= 70 or v162 >= 97 and v162 <= 102)
		elseif v165 == "ascii" then
			v167 = v162 <= 127
		elseif v165 == "vertical_tab" then
			v167 = v162 >= 10 and v162 <= 13 or (v162 == 8232 or v162 == 8233)
		elseif p28.unicode then
			local v168 = v2[v162] or "Cn"
			local v169 = v168:sub(1, 1)

			if v165 == "alnum" then
				v167 = v169 == "L" or (v168 == "Nl" or v168 == "Nd")
			elseif v165 == "alpha" then
				v167 = v169 == "L" or v168 == "Nl"
			elseif v165 == "blank" then
				v167 = v168 == "Zs" or v162 == 9
			elseif v165 == "cntrl" then
				v167 = v168 == "Cc"
			elseif v165 == "digit" then
				v167 = v168 == "Nd"
			elseif v165 == "graph" then
				v167 = v169 ~= "P" and v169 ~= "C"
			elseif v165 == "lower" then
				v167 = v168 == "Ll"
			elseif v165 == "print" then
				v167 = v169 ~= "C"
			elseif v165 == "punct" then
				v167 = v169 == "P"
			elseif v165 == "space" then
				v167 = v169 == "Z" or v162 >= 9 and v162 <= 13
			elseif v165 == "upper" then
				v167 = v168 == "Lu"
			elseif v165 == "word" then
				v167 = v169 == "L" or (v168 == "Nl" or (v168 == "Nd" or v168 == "Pc"))
			end
		elseif v165 == "alnum" then
			v167 = v162 >= 48 and v162 <= 57 or (v162 >= 65 and v162 <= 90 or v162 >= 97 and v162 <= 122)
		elseif v165 == "alpha" then
			v167 = v162 >= 65 and v162 <= 90 or v162 >= 97 and v162 <= 122
		elseif v165 == "blank" then
			v167 = v162 == 9 or v162 == 32
		elseif v165 == "cntrl" then
			v167 = v162 <= 31 or v162 == 127
		elseif v165 == "digit" then
			v167 = v162 >= 48 and v162 <= 57
		elseif v165 == "graph" then
			v167 = v162 >= 33 and v162 <= 126
		elseif v165 == "lower" then
			v167 = v162 >= 97 and v162 <= 122
		elseif v165 == "print" then
			v167 = v162 >= 32 and v162 <= 126
		elseif v165 == "punct" then
			v167 = t12[v162]
		elseif v165 == "space" then
			v167 = v162 >= 9 and v162 <= 13 or v162 == 32
		elseif v165 == "upper" then
			v167 = v162 >= 65 and v162 <= 90
		elseif v165 == "word" then
			v167 = v162 >= 48 and v162 <= 57 or (v162 >= 65 and v162 <= 90 or (v162 >= 97 and v162 <= 122 or v162 == 95))
		end

		if v166 then
			return not v167
		end

		return v167
	end

	if p25[1] == "category" then
		local v170 = v2[v162] or "Cn"
		local v171 = p25[3]
		local v172 = #v171

		if v172 == 3 then
			local v173 = false

			if v171 == "Xan" or v171 == "Xwd" then
				v173 = v170:find("^[LN]") or v171 == "Xwd" and v162 == 95
			elseif v171 == "Xps" or v171 == "Xsp" then
				v173 = v170:sub(1, 1) == "Z" or v162 >= 9 and v162 <= 13
			elseif v171 == "Xuc" then
				v173 = tkn_char_match(v4, p26, p27, p28, p29)
			end

			if p25[2] then
				return not v173
			end

			return v173
		end

		if v171 == v170:sub(1, v172) then
			return not p25[2]
		end

		return p25[2]
	end

	if p25[1] == 46 then
		return p28.dotAll or not is_newline(p26, p27, p29)
	end

	if p25[1] == 78 then
		return not is_newline(p26, p27, p29)
	end

	if p25[1] == 82 then
		if p29.newline_seq == 0 then
			return v162 == 10 or v162 == 13
		end

		return v162 == 10 or (v162 == 11 or (v162 == 12 or (v162 == 13 or (v162 == 133 or (v162 == 8232 or v162 == 8233)))))
	end

	return false
end
local function find_alternation(p30, p31, p32) -- line: 449
	-- upvalues: t16 (copy)
	while true do
		local v177 = p30[p31]
		local v178 = type(v177) == "table"

		if v177 == t16 then
			break
		end

		if v178 and v177[1] == 40 then
			if p32 then
				p32 += v177.count
			end

			p31 = v177[3]
		elseif v178 and v177[1] == "quantifier" and type(v177[5]) == "table" and v177[5][1] == 40 then
			if p32 then
				p32 += v177[5].count
			end

			p31 = v177[5][3]
		else
			if not v177 or v178 and v177[1] == 41 then
				return nil, p32
			end

			if p32 then
				p32 = if not v178 or v177[1] ~= "quantifier" then p32 + 1 else p32 + v177[3]
			end
		end

		p31 += 1
	end

	return p31, p32
end
local function re_rawfind(p33, p34, p35, p36, p37, p38) -- line: 478
	-- upvalues: find_alternation (copy), tkn_char_match (copy), is_newline (copy)
	local n2 = 0
	local v186 = p35
	local v187 = p35
	local t21 = {}
	local v200 = nil
	local v199 = nil
	local g250 = nil
	local v246 = nil
	local v247 = nil

	repeat
		local g189 = false

		while n2 do
			if n2 == 0 then
				n2 += 1

				local v190 = find_alternation(p33, n2)

				if v190 then
					table.insert(t21, 1, {
						"alternation",
						v190,
						v186
					})
				end

				continue
			end

			local v191 = p33[n2]
			local v192 = type(v191) == "table" and v191[1]

			if not v191 then
				break
			end

			if v191 == "ACCEPT" then
				local v193 = true
				local v194 = n2

				repeat
					v194 += 1

					local v195 = type(p33[v194]) == "table"
					local v196 = p33[v194]

					if v195 and (v196[1] == 40 or v196[1] == "quantifier" and type(v196[5]) == "table" and v196[5][1] == 40) then
						v194 = v196[1] == "quantifier" and v196[5][3] or v196[3]

						continue
					end

					if v195 and v196[1] == 41 and (v196[4] == 33 or v196[4] == 61) then
						v193 = false
						n2 = v194

						break
					end
				until not v196

				if not v193 then
					continue
				end

				break
			end

			if v191 == "PRUNE" or v191 == "SKIP" then
				table.insert(t21, 1, {
					v191,
					v186
				})
				n2 += 1

				continue
			end

			if v192 == 40 then
				table.insert(t21, 1, {
					"group",
					n2,
					v186,
					nil,
					v191[2],
					v191[3],
					v191[4]
				})
				n2 += 1

				local v197, v198 = find_alternation(p33, n2, (v191[4] == 33 or v191[4] == 61) and (v191[5] and 0))

				if v197 then
					table.insert(t21, 1, {
						"alternation",
						v197,
						v186
					})
				end

				if v198 then
					v186 -= v198
				end

				continue
			end

			if v192 == 41 and v191[4] ~= 33 then
				if v191[4] == 33 or v191[4] == 61 then
					while true do
						v199 = nil
						v200 = table.remove(t21, 1)

						if v200[1] == "group" and v200[2] == v191[3] then
							break
						end

						if v200[1] == "matchStart" and not v199 and v191[4] == 61 then
						end
					end

					if (v191[4] == 33 or v191[4] == 61) and not v191[5] then
						v186 = v200[3]
					end

					if v199 then
						table.insert(t21, 1, v199)
					end
				elseif v191[4] == 62 then
					repeat
						local v201 = table.remove(t21, 1)
					until not v201 or v201[1] == "group" and v201[2] == v191[3]
				else
					for _, v in ipairs(t21) do
						if v[1] == "group" and v[2] == v191[3] then
							if v.jmp then
								n2 = v.jmp
							end

							v[4] = v186

							if v[7] ~= "quantifier" or not (v[10] + 1 < v[9]) then
								break
							end

							if p33[v191[3]][4] ~= "lazy" or v[10] + 1 < v[8] then
								n2 = v191[3]
							end

							local v204 = p33[v191[3]]

							table.insert(t21, 1, {
								"group",
								v[2],
								v186,
								nil,
								v204[5][2],
								v204[5][3],
								"quantifier",
								v204[2],
								v204[3],
								v[10] + 1,
								v[11],
								v204[4]
							})

							if not v[11] then
								break
							end

							table.insert(t21, 1, {
								"alternation",
								v[11],
								v186
							})

							break
						end
					end
				end

				n2 += 1

				continue
			end

			if v192 == 75 then
				table.insert(t21, 1, {
					"matchStart",
					v186
				})
				n2 += 1

				continue
			end

			if v192 == 124 then
				local v205 = n2

				repeat
					v205 += 1

					local v206 = type(p33[v205]) == "table"
					local v207 = p33[v205]

					if v206 and (v207[1] == 40 or v207[1] == "quantifier" and type(v207[5]) == "table" and v207[5][1] == 40) then
						v205 = v207[1] == "quantifier" and v207[5][3] or v207[3]
					end
				until v206 and v207[1] == 41 or not v207

				if p33[v205] then
					for _, v in ipairs(t21) do
						if v[1] == "group" and v205 == v[6] then
							n2 = v[6]
							g189 = true
						end

						if g189 then
							break
						end
					end
				else
					n2 = v205
				end

				if not g189 then
					continue
				end
			end

			if g189 then
				break
			end

			if v192 == "recurmatch" then
				table.insert(t21, 1, {
					"group",
					v191[3],
					v186,
					nil,
					nil,
					p33[v191[3]][3],
					nil,
					jmp = n2
				})
				n2 = v191[3] + 1

				local v210, _ = find_alternation(p33, n2)

				if v210 then
					table.insert(t21, 1, {
						"alternation",
						v210,
						v186
					})
				end

				continue
			end

			local v212 = nil

			if v191 == "FAIL" then
				v212 = false
			elseif v192 == 41 then
				repeat
					local v213 = table.remove(t21, 1)
				until v213[1] == "group" and v213[2] == v191[3]
			elseif v192 == "quantifier" then
				if type(v191[5]) == "table" and v191[5][1] == 40 then
					local v214 = find_alternation(p33, n2 + 1)

					if v214 then
						table.insert(t21, 1, {
							"alternation",
							v214,
							v186
						})
					end

					table.insert(t21, not v214 and 1 or 2, {
						"group",
						n2,
						v186,
						nil,
						v191[5][2],
						v191[5][3],
						"quantifier",
						v191[2],
						v191[3],
						0,
						v214,
						v191[4]
					})

					if v191[4] == "lazy" and v191[2] == 0 then
						n2 = v191[5][3]
					end

					v212 = true
				else
					local v215 = nil
					local v216 = nil
					local n3 = 1
					local v218 = type(v191[5]) == "table" and v191[5][1] == "backref"

					if v218 then
						n3 = 0

						local v219 = v191[5][2]

						for _, v in ipairs(t21) do
							if v[1] == "group" and v219 == v[5] then
								v215 = v[3]
								v216 = v[4]
								n3 = v216 - v215

								break
							end
						end
					end

					local v222 = v186 + v191[2] * n3
					local n4 = 0

					while n4 < v191[3] do
						if v218 then
							if not v215 or not v216 then
								break
							end

							local s = p34.s
							local v225 = utf8.offset(s, v216)
							local v226 = string.sub(s, utf8.offset(s, v215), v225 and v225 - 1)
							local s6 = p34.s
							local v228 = v186 + n3
							local v229 = utf8.offset(s6, v228)

							if v226 ~= string.sub(s6, utf8.offset(s6, v186), v229 and v229 - 1) then
								break
							end
						elseif not tkn_char_match(v191[5], p34, v186, p36, p37) then
							break
						end

						v186 += n3
						n4 += 1
					end

					v212 = n4 >= v191[2]

					if v212 and v191[4] ~= "possessive" then
						if v191[4] == "lazy" then
							local v230 = v222

							v222 = v186
							v186 = v230
						end

						table.insert(t21, 1, {
							"quantifier",
							n2,
							v186,
							math.min(v222, p34.n + 1),
							(v191[4] ~= "lazy" and -1 or 1) * n3
						})
					end
				end
			elseif v192 == "backref" then
				local v231 = nil
				local v232 = nil
				local v233 = v191[2]

				for _, v in ipairs(t21) do
					if v[1] == "group" and v233 == v[5] then
						v231 = v[3]
						v232 = v[4]

						break
					end
				end

				if v231 and v232 then
					local v236 = v186 + (v232 - v231)
					local s = p34.s
					local v238 = utf8.offset(s, v232)
					local v239 = string.sub(s, utf8.offset(s, v231), v238 and v238 - 1)
					local s7 = p34.s
					local v241 = utf8.offset(s7, v236)

					v212 = v239 == string.sub(s7, utf8.offset(s7, v186), v241 and v241 - 1)
					v186 = v236
				end
			else
				local v242 = p34[v186]

				if v192 == 36 or v192 == 90 or v192 == 122 then
					v212 = v186 == p34.n + 1 or (v192 == 36 and (not not p36.multiline and is_newline(p34, v186 + 1, p37)) or v192 == 90 and (v186 == p34.n and is_newline(p34, v186, p37)))
				elseif v192 == 94 or v192 == 65 or v192 == 71 then
					v212 = v186 == 1 or (v192 == 94 and (not not p36.multiline and is_newline(p34, v186 - 1, p37)) or v192 == 71 and v186 == p35)
				elseif v192 == 66 or v192 == 98 then
					local v243 = v186 == 1 or p36.multiline and is_newline(p34, v186 - 1, p37)
					local v244 = v186 == p34.n + 1 or p36.multiline and is_newline(p34, v186, p37)
					local v245 = if not tkn_char_match(v191[2], p34[v186 - 1], p36) then tkn_char_match(v191[2], v242, p36) and 1 else 0

					if v245 == 0 then
						v212 = v244 or not tkn_char_match(v191[2], v242, p36)
					elseif v245 then
						v212 = v243 or not tkn_char_match(v191[2], p34[v186 - 1], p36)
					end

					if v192 == 66 then
						v212 = not v212
					end
				else
					v212 = tkn_char_match(v191, p34, v186, p36, p37)
					v186 += 1
				end
			end

			if not v212 then
				while true do
					v246 = t21[1] and t21[1][1]
					v247 = t21[1]

					if not v246 or v246 == "PRUNE" or v246 == "SKIP" then
						break
					end

					if v246 == "alternation" then
						n2 = v247[2]
						v186 = v247[3]

						local v248, v249 = find_alternation(p33, n2 + 1)

						if v248 then
							v247[2] = v248
						else
							table.remove(t21, 1)
						end

						if v249 then
							v186 -= v249
						end

						g250 = true
					end

					if g250 then
						break
					end

					if v246 == "group" then
						if v247[7] == "quantifier" then
							if v247[12] == "greedy" and v247[10] >= v247[8] or v247[12] == "lazy" and v247[10] < v247[9] and not v247[13] then
								n2 = v247[12] == "greedy" and v247[6] or v247[2]
								v186 = v247[3]

								if v247[12] == "greedy" then
									table.remove(t21, 1)
									g250 = true
								end

								if not g250 then
									if v247[10] >= v247[8] then
										v247[13] = true
										g250 = true
									end
								end
							end
						elseif v247[7] == 33 then
							table.remove(t21, 1)
							n2 = v247[6]
							v186 = v247[3]
							g250 = true
						end
					elseif v246 == "quantifier" and math.sign(v247[4] - v247[3]) == math.sign(v247[5]) then
						v247[3] = v247[3] + v247[5]
						n2 = v247[2]
						v186 = v247[3]
						g250 = true
					end

					if g250 then
						break
					end

					if g250 then
						break
					end

					if g250 then
						break
					end

					if g250 then
						break
					end

					table.remove(t21, 1)
				end

				if not g250 then
					if not g250 then
						if not g250 then
							if not g250 then
								if not g250 then
									if v246 then
										table.clear(t21)
									end

									if v187 > p34.n then
										if p38 then
											return false
										end

										return nil
									end

									v187 = v246 == "SKIP" and v247[2] or v187 + 1
									n2 = 0
									v186 = v187
								end
							end
						end
					end
				end
			end

			g250 = false
			n2 += 1
		end
	until not g189

	if p38 then
		return true
	end

	local v251 = false
	local t22 = table.create(p33.group_n)
	local group_n = p33.group_n

	t22[0] = {
		v187,
		v186
	}
	t22.n = group_n

	for _, v in ipairs(t21) do
		if v[1] == "matchStart" and not v251 then
			v251 = true
			t22[0][1] = v[2]
		elseif v[1] == "group" and v[5] and not t22[v[5]] then
			t22[v[5]] = {
				v[3],
				v[4]
			}
		end
	end

	return t22
end
local function v41(p39, p40, p41) -- line: 775
	-- upvalues: re_rawfind (copy), to_str_arr (copy)
	return (re_rawfind(p39.token, to_str_arr(p40, p41), 1, p39.flags, p39.verb_flags, true))
end

local s6 = "test"

function t3.test(...) -- line: 171
	-- upvalues: self (copy), s6 (copy), t2 (copy), v41 (copy)
	local v259 = select("#", ...)

	if v259 < 1 then
		error("missing argument #1 (RegEx expected)", 2)
	elseif v259 < 2 then
		error("missing argument #2 (string expected)", 2)
	end

	local v260, v261, v262, v263, v264, v265 = ...

	if not self[v260] or self[v260].name ~= "RegEx" then
		if type(v260) ~= "string" and type(v260) ~= "number" then
			error(string.format("invalid argument #1 to %q (RegEx expected, got %s)", s6, (typeof(v260))), 2)
		end

		v260 = t2.fromstring(v260)
	elseif s6 == "sub" then
		if type(v262) == "number" then
			v262 ..= ""
		elseif type(v262) ~= "string" then
			error(string.format("invalid argument #3 to 'sub' (string expected, got %s)", (typeof(v262))), 2)
		end
	elseif type(v261) == "number" then
		v261 ..= ""
	elseif type(v261) ~= "string" then
		error(string.format("invalid argument #2 to %q (string expected, got %s)", s6, (typeof(v261))), 2)
	end

	if s6 ~= "sub" and s6 ~= "split" then
		local v266 = typeof(v262)

		if v266 ~= "nil" then
			v262 = tonumber(v262)

			if not v262 then
				error(string.format("invalid argument #3 to %q (number expected, got %s)", s6, v266), 2)
			else
				v262 = if not (v262 < 0) then math.max(math.floor(v262 + 0.5), 1) else #v261 + math.floor(v262 + 0.5) + 1
			end
		end
	end

	local v267 = self[v260]

	if s6 == "match" or s6 == "matchiter" then
		v263 = ...
	elseif s6 == "sub" then
		v265 = ...
	end

	return v41(v267, v261, v262, v263, v264, v265)
end

local function v43(p42, p43, p44, p45) -- line: 779
	-- upvalues: re_rawfind (copy), to_str_arr (copy), new_match (copy)
	local v272 = re_rawfind(p42.token, to_str_arr(p43, p44), 1, p42.flags, p42.verb_flags, false)

	if not v272 then
		return nil
	end

	return (new_match(v272, p42.group_id, p45, p43))
end

local s7 = "match"

function t3.match(...) -- line: 171
	-- upvalues: self (copy), s7 (copy), t2 (copy), v43 (copy)
	local v273 = select("#", ...)

	if v273 < 1 then
		error("missing argument #1 (RegEx expected)", 2)
	elseif v273 < 2 then
		error("missing argument #2 (string expected)", 2)
	end

	local v274, v275, v276, v277, v278, v279 = ...

	if not self[v274] or self[v274].name ~= "RegEx" then
		if type(v274) ~= "string" and type(v274) ~= "number" then
			error(string.format("invalid argument #1 to %q (RegEx expected, got %s)", s7, (typeof(v274))), 2)
		end

		v274 = t2.fromstring(v274)
	elseif s7 == "sub" then
		if type(v276) == "number" then
			v276 ..= ""
		elseif type(v276) ~= "string" then
			error(string.format("invalid argument #3 to 'sub' (string expected, got %s)", (typeof(v276))), 2)
		end
	elseif type(v275) == "number" then
		v275 ..= ""
	elseif type(v275) ~= "string" then
		error(string.format("invalid argument #2 to %q (string expected, got %s)", s7, (typeof(v275))), 2)
	end

	if s7 ~= "sub" and s7 ~= "split" then
		local v280 = typeof(v276)

		if v280 ~= "nil" then
			v276 = tonumber(v276)

			if not v276 then
				error(string.format("invalid argument #3 to %q (number expected, got %s)", s7, v280), 2)
			else
				v276 = if not (v276 < 0) then math.max(math.floor(v276 + 0.5), 1) else #v275 + math.floor(v276 + 0.5) + 1
			end
		end
	end

	local v281 = self[v274]

	if s7 == "match" or s7 == "matchiter" then
		v277 = ...
	elseif s7 == "sub" then
		v279 = ...
	end

	return v43(v281, v275, v276, v277, v278, v279)
end

local function v45(p46, p47, p48, p49) -- line: 787
	-- upvalues: to_str_arr (copy), re_rawfind (copy), new_match (copy)
	local u286 = to_str_arr(p47, p48)
	local n5 = 1

	return function() -- line: 790
		-- upvalues: n5 (ref), u286 (ref), re_rawfind (copy), p46 (copy), new_match (copy), p49 (copy)
		local v583 = n5 <= u286.n + 1 and re_rawfind(p46.token, u286, n5, p46.flags, p46.verb_flags, false)

		if not v583 then
			return nil
		end

		n5 = v583[0][2] + (not (v583[0][1] >= v583[0][2]) and 0 or 1)

		return (new_match(v583, p46.group_id, p49, u286.s))
	end
end

local s8 = "matchall"

function t3.matchall(...) -- line: 171
	-- upvalues: self (copy), s8 (copy), t2 (copy), v45 (copy)
	local v288 = select("#", ...)

	if v288 < 1 then
		error("missing argument #1 (RegEx expected)", 2)
	elseif v288 < 2 then
		error("missing argument #2 (string expected)", 2)
	end

	local v289, v290, v291, v292, v293, v294 = ...

	if not self[v289] or self[v289].name ~= "RegEx" then
		if type(v289) ~= "string" and type(v289) ~= "number" then
			error(string.format("invalid argument #1 to %q (RegEx expected, got %s)", s8, (typeof(v289))), 2)
		end

		v289 = t2.fromstring(v289)
	elseif s8 == "sub" then
		if type(v291) == "number" then
			v291 ..= ""
		elseif type(v291) ~= "string" then
			error(string.format("invalid argument #3 to 'sub' (string expected, got %s)", (typeof(v291))), 2)
		end
	elseif type(v290) == "number" then
		v290 ..= ""
	elseif type(v290) ~= "string" then
		error(string.format("invalid argument #2 to %q (string expected, got %s)", s8, (typeof(v290))), 2)
	end

	if s8 ~= "sub" and s8 ~= "split" then
		local v295 = typeof(v291)

		if v295 ~= "nil" then
			v291 = tonumber(v291)

			if not v291 then
				error(string.format("invalid argument #3 to %q (number expected, got %s)", s8, v295), 2)
			else
				v291 = if not (v291 < 0) then math.max(math.floor(v291 + 0.5), 1) else #v290 + math.floor(v291 + 0.5) + 1
			end
		end
	end

	local v296 = self[v289]

	if s8 == "match" or s8 == "matchiter" then
		v292 = ...
	elseif s8 == "sub" then
		v294 = ...
	end

	return v45(v296, v290, v291, v292, v293, v294)
end

local function insert_tokenized_sub(p50, p51, p52, p53) -- line: 800
	-- upvalues: insert_tokenized_sub (copy)
	for _, v in ipairs(p53) do
		if type(v) == "table" then
			if v[1] == "condition" then
				if p52[v[2]] then
					if v[3] then
						insert_tokenized_sub(p50, p51, p52, v[3])
					else
						table.move(p51, p52[v[2]][1], p52[v[2]][2] - 1, #p50 + 1, p50)
					end
				elseif v[4] then
					insert_tokenized_sub(p50, p51, p52, v[4])
				end
			else
				table.move(v, 1, #v, #p50 + 1, p50)
			end
		elseif p52[v] then
			table.move(p51, p52[v][1], p52[v][2] - 1, #p50 + 1, p50)
		end
	end

	p50.n = #p50

	return p50
end
local function v48(p54, p55, p56, p57, p58, p59) -- line: 824
	-- upvalues: to_str_arr (copy), t9 (copy), re_rawfind (copy), insert_tokenized_sub (copy), new_match (copy), from_str_arr (copy)
	if p58 ~= nil and (type(p58) ~= "number" and type(p58) ~= "string") then
		error(string.format("invalid argument #5 to 'sub' (string expected, got %s)", (typeof(p58))), 3)
	end

	local t23 = {
		l = false,
		o = false,
		u = false
	}

	for match in string.gmatch(p58 or "", utf8.charpattern) do
		if t23[match] ~= false then
			error("invalid regular expression substitution flag " .. match, 3)
		end

		t23[match] = true
	end

	local v311 = type(p55)

	if v311 == "number" then
		p55 ..= ""
	elseif v311 ~= "string" and v311 ~= "function" and (not t23.o or v311 ~= "table") then
		error(string.format("invalid argument #2 to 'sub' (string/function%s expected, got %s)", not t23.o and "" or "/table", (typeof(p55))), 3)
	end

	if tonumber(p57) then
		p57 = tonumber(p57)

		if p57 <= -1 or p57 ~= p57 then
			p57 = 1e999
		end
	elseif p57 ~= nil then
		error(string.format("invalid argument #4 to 'sub' (number expected, got %s)", (typeof(p57))), 3)
	else
		p57 = 1e999
	end

	if p57 < 1 then
		return p56, 0
	end

	local n6 = 0

	if v311 == "string" then
		p55 = to_str_arr(p55)

		if not t23.l then
			local n7 = 0
			local t24 = table.create(3)
			local group_n = p54.token.group_n
			local t25 = {}

			while n7 < p55.n do
				local v317 = n7

				repeat
					v317 += 1
				until not p55[v317] or p55[v317] == 36 or p55[v317] == 92 or (p55[v317] == 58 or p55[v317] == 125) and t25[1]

				n6 += v317 - n7 - 1

				if v317 - n7 > 1 then
					table.insert(t24, table.move(p55, n7 + 1, v317 - 1, 1, table.create(v317 - n7 - 1)))
				end

				if p55[v317] == 58 then
					local v318 = t25[1]

					if v318[2] then
						error("malformed substitution pattern", 3)
					end

					v318[2] = table.move(t24, v318[3], #t24, 1, table.create(#t24 + 1 - v318[3]))

					for i = #t24, v318[3], -1 do
						t24[i] = nil
					end
				elseif p55[v317] == 125 then
					local v320 = table.remove(t25, 1)
					local v321 = table.move(t24, v320[3], #t24, 1, table.create(#t24 + 1 - v320[3]))

					for i = #t24, v320[3], -1 do
						t24[i] = nil
					end

					table.insert(t24, {
						"condition",
						v320[1],
						v320[2] ~= true and (v320[2] or v321),
						v320[2] and v321
					})
				elseif p55[v317] then
					v317 += 1

					local v323 = p55[v317]

					if not v323 then
						if p55[v317 - 1] == 92 then
							error("replacement string must not end with a trailing backslash", 3)
						end

						local v324 = t24[#t24]

						if type(v324) == "table" then
							table.insert(v324, p55[v317 - 1])
						else
							table.insert(t24, { p55[v317 - 1] })
						end
					elseif v323 == 92 and p55[v317 - 1] == 36 then
						local v325 = t24[#t24]

						if type(v325) == "table" then
							table.insert(v325, 36)
						else
							table.insert(t24, { 36 })
						end

						v317 -= 1
						n6 += 1
					elseif v323 == 48 then
						table.insert(t24, 0)
					elseif v323 > 48 and v323 <= 57 then
						local v326 = v323 - 48

						while p55[v317 + 1] and p55[v317 + 1] >= 48 and p55[v317 + 1] <= 57 do
							v326 ..= p55[v317 + 1] - 48
							v317 += 1
						end

						local num = tonumber(v326)

						if not t23.u and group_n < num then
							error("reference to non-existent subpattern", 3)
						end

						table.insert(t24, num)
					elseif v323 == 123 and p55[v317 - 1] == 36 then
						v317 += 1

						local v328 = v317

						while p55[v317] and (p55[v317] >= 48 and p55[v317] <= 57 or p55[v317] >= 65 and p55[v317] <= 90 or (p55[v317] >= 97 and p55[v317] <= 122 or p55[v317] == 95)) do
							v317 += 1
						end

						if (p55[v317] == 125 or p55[v317] == 58 and (p55[v317 + 1] == 43 or p55[v317 + 1] == 45)) and v317 ~= v328 then
							local s = p55.s
							local v330 = utf8.offset(s, v317)
							local v331 = string.sub(s, utf8.offset(s, v328), v330 and v330 - 1)
							local num

							if p55[v328] >= 48 and p55[v328] <= 57 then
								num = tonumber(v331)

								if not t23.u and group_n < num then
									error("reference to non-existent subpattern", 3)
								end
							else
								num = p54.group_id[v331]

								if not t23.u and (not num or group_n < num) then
									error("reference to non-existent subpattern", 3)
								end
							end

							if p55[v317] == 58 then
								v317 += 1
								table.insert(t25, {
									num,
									p55[v317] == 45,
									#t24 + 1
								})
							else
								table.insert(t24, num)
							end
						else
							error("malformed substitution pattern", 3)
						end
					else
						local v333 = nil

						if p55[v317 - 1] == 36 then
							if v323 ~= 36 then
								local v334 = t24[#t24]

								if type(v334) == "table" then
									table.insert(v334, 36)
								else
									table.insert(t24, { 36 })
								end
							end
						else
							v333 = t9[p55[v317]]

							if type(v333) ~= "number" then
								v333 = nil
							end
						end

						local v335 = t24[#t24]

						if type(v335) == "table" then
							table.insert(v335, v333 or p55[v317])
						else
							table.insert(t24, { v333 or p55[v317] })
						end

						n6 += 1
					end
				end

				n7 = v317
			end

			if t25[1] then
				error("malformed substitution pattern", 3)
			end

			if not t24[2] and type(t24[1]) == "table" and t24[1][1] ~= "condition" then
				local v336 = t24[1]

				p55.n = #t24[1]
				p55 = v336
			else
				p55 = t24
				v311 = "subst_string"
			end
		end
	end

	local v337 = to_str_arr(p56)
	local n8 = 0
	local n9 = 1
	local n10 = 0

	while n9 <= v337.n + n8 + 1 do
		local v341 = re_rawfind(p54.token, v337, n9, p54.flags, p54.verb_flags, false)

		if not v341 then
			return from_str_arr(v337), n10
		end

		local v342 = nil

		if v311 == "string" then
			v342 = p55
		elseif v311 == "subst_string" then
			v342 = insert_tokenized_sub(table.create(n6), v337, v341, p55)
		else
			local v347, v348

			if v311 == "table" then
				local s = v337.s
				local v344 = v341[0][1]
				local v345 = v341[0][2]
				local v346 = utf8.offset(s, v345)

				v347 = string.sub(s, utf8.offset(s, v344), v346 and v346 - 1)
				v348 = p55[v347]
			else
				v347 = new_match(v341, p54.group_id, p59, v337.s)
				v348 = p55(v347)
			end

			if v348 == v347 or t23.o and not v348 then
				local v349 = v341[0][2] - v341[0][1]

				v342 = table.move(v337, v341[0][1], v341[0][2] - 1, 1, table.create(v349))
				v342.n = v349
			elseif type(v348) == "string" then
				v342 = to_str_arr(v348)
			elseif type(v348) == "number" then
				v342 = to_str_arr(v348 .. "")
			elseif t23.o then
				error(string.format("invalid replacement value (a %s)", (type(v348))), 3)
			else
				v342 = {
					n = 0
				}
			end
		end

		local v350 = v341[0][2] - v341[0][1]
		local v351 = math.min(v342.n, v350)

		for i = 0, v351 - 1 do
			v337[v341[0][1] + i] = v342[i + 1]
		end

		local v353 = v341[0][1] + v351

		n9 = v341[0][2]

		if v350 > v342.n then
			for _ = 1, v350 - v342.n do
				table.remove(v337, v353)
				n8 -= 1
				n9 -= 1
			end
		elseif v350 < v342.n then
			for i = 1, v342.n - v350 do
				table.insert(v337, v353 + i - 1, v342[v351 + i])
				n8 += 1
				n9 += 1
			end
		end

		if v350 <= 0 then
			n9 += 1
		end

		n10 += 1

		if p57 < n10 + 1 then
			return from_str_arr(v337), n10
		end
	end

	return from_str_arr(v337), n10
end

local s9 = "sub"

function t3.sub(...) -- line: 171
	-- upvalues: self (copy), s9 (copy), t2 (copy), v48 (copy)
	local v356 = select("#", ...)

	if v356 < 1 then
		error("missing argument #1 (RegEx expected)", 2)
	elseif v356 < 2 then
		error("missing argument #2 (string expected)", 2)
	end

	local v357, v358, v359, v360, v361, v362 = ...

	if not self[v357] or self[v357].name ~= "RegEx" then
		if type(v357) ~= "string" and type(v357) ~= "number" then
			error(string.format("invalid argument #1 to %q (RegEx expected, got %s)", s9, (typeof(v357))), 2)
		end

		v357 = t2.fromstring(v357)
	elseif s9 == "sub" then
		if type(v359) == "number" then
			v359 ..= ""
		elseif type(v359) ~= "string" then
			error(string.format("invalid argument #3 to 'sub' (string expected, got %s)", (typeof(v359))), 2)
		end
	elseif type(v358) == "number" then
		v358 ..= ""
	elseif type(v358) ~= "string" then
		error(string.format("invalid argument #2 to %q (string expected, got %s)", s9, (typeof(v358))), 2)
	end

	if s9 ~= "sub" and s9 ~= "split" then
		local v363 = typeof(v359)

		if v363 ~= "nil" then
			v359 = tonumber(v359)

			if not v359 then
				error(string.format("invalid argument #3 to %q (number expected, got %s)", s9, v363), 2)
			else
				v359 = if not (v359 < 0) then math.max(math.floor(v359 + 0.5), 1) else #v358 + math.floor(v359 + 0.5) + 1
			end
		end
	end

	local v364 = self[v357]

	if s9 == "match" or s9 == "matchiter" then
		v360 = ...
	elseif s9 == "sub" then
		v362 = ...
	end

	return v48(v364, v358, v359, v360, v361, v362)
end

local function v50(p60, p61, p62) -- line: 1062
	-- upvalues: to_str_arr (copy), re_rawfind (copy)
	if tonumber(p62) then
		p62 = tonumber(p62)

		if p62 <= -1 or p62 ~= p62 then
			p62 = 1e999
		end
	elseif p62 ~= nil then
		error(string.format("invalid argument #3 to 'split' (number expected, got %s)", (typeof(p62))), 3)
	else
		p62 = 1e999
	end

	local v368 = to_str_arr(p61)
	local n11 = 1
	local n12 = 0
	local t26 = {}
	local n13 = 0

	while n11 <= v368.n + 1 do
		n12 += 1

		local v373 = n12 <= p62 and re_rawfind(p60.token, v368, n11, p60.flags, p60.verb_flags, false)

		if not v373 then
			break
		end

		local s = v368.s
		local v375 = n11 - n13
		local v376 = v373[0][1]
		local v377 = utf8.offset(s, v376)

		table.insert(t26, (string.sub(s, utf8.offset(s, v375), v377 and v377 - 1)))
		n13 = not (v373[0][1] >= v373[0][2]) and 0 or 1
		n11 = v373[0][2] + n13
	end

	table.insert(t26, (string.sub(v368.s, utf8.offset(v368.s, n11 - n13))))

	return t26
end

local s10 = "split"

function t3.split(...) -- line: 171
	-- upvalues: self (copy), s10 (copy), t2 (copy), v50 (copy)
	local v378 = select("#", ...)

	if v378 < 1 then
		error("missing argument #1 (RegEx expected)", 2)
	elseif v378 < 2 then
		error("missing argument #2 (string expected)", 2)
	end

	local v379, v380, v381, v382, v383, v384 = ...

	if not self[v379] or self[v379].name ~= "RegEx" then
		if type(v379) ~= "string" and type(v379) ~= "number" then
			error(string.format("invalid argument #1 to %q (RegEx expected, got %s)", s10, (typeof(v379))), 2)
		end

		v379 = t2.fromstring(v379)
	elseif s10 == "sub" then
		if type(v381) == "number" then
			v381 ..= ""
		elseif type(v381) ~= "string" then
			error(string.format("invalid argument #3 to 'sub' (string expected, got %s)", (typeof(v381))), 2)
		end
	elseif type(v380) == "number" then
		v380 ..= ""
	elseif type(v380) ~= "string" then
		error(string.format("invalid argument #2 to %q (string expected, got %s)", s10, (typeof(v380))), 2)
	end

	if s10 ~= "sub" and s10 ~= "split" then
		local v385 = typeof(v381)

		if v385 ~= "nil" then
			v381 = tonumber(v381)

			if not v381 then
				error(string.format("invalid argument #3 to %q (number expected, got %s)", s10, v385), 2)
			else
				v381 = if not (v381 < 0) then math.max(math.floor(v381 + 0.5), 1) else #v380 + math.floor(v381 + 0.5) + 1
			end
		end
	end

	local v386 = self[v379]

	if s10 == "match" or s10 == "matchiter" then
		v382 = ...
	elseif s10 == "sub" then
		v384 = ...
	end

	return v50(v386, v380, v381, v382, v383, v384)
end

local function re_index(p63, p64) -- line: 1092
	-- upvalues: t3 (ref), self (copy)
	return t3[p64] or self[p63].flags[p64]
end
local function re_tostr(p65) -- line: 1096
	-- upvalues: self (copy)
	return self[p65].pattern_repr .. self[p65].flag_repr
end

local t27 = {
	[58] = true,
	[33] = true,
	[61] = true,
	[62] = true,
	[124] = true
}

local function tokenize_ptn(p66, p67) -- line: 1112
	-- upvalues: t1 (copy), t20 (copy), t27 (copy), t16 (copy), t14 (copy), t9 (copy), t8 (copy), t11 (copy), v3 (copy), t10 (copy), t15 (copy), t13 (copy)
	if p67.unicode and not t1.unicodeData then
		return "options.unicodeData cannot be turned off while having unicode flag"
	end

	local n14 = 1
	local n = p66.n
	local n15 = 0
	local t28 = {}
	local t29 = {}
	local t30 = {
		newline = 1,
		newline_seq = 1,
		not_empty = 0
	}
	local g539 = nil

	while n14 <= n do
		local v398 = p66[n14]

		if v398 == 40 then
			local t31 = nil

			if p66[n14 + 1] == 42 then
				local v400 = n14 + 2

				n14 = v400

				while p66[n14] and (p66[n14] >= 48 and p66[n14] <= 57 or p66[n14] >= 65 and p66[n14] <= 90 or (p66[n14] >= 97 and p66[n14] <= 122 or p66[n14] == 95 or p66[n14] == 58)) do
					n14 += 1
				end

				if p66[n14] ~= 41 and p66[n14 - 1] ~= 58 then
					return "quantifier doesn't follow a repeatable pattern"
				end

				local s = p66.s
				local v402 = utf8.offset(s, n14)
				local v403 = string.sub(s, utf8.offset(s, v400), v402 and v402 - 1)

				if v403 == "positive_lookahead:" or v403 == "negative_lookhead:" or v403 == "positive_lookbehind:" or v403 == "negative_lookbehind:" or v403:find("^[pn]l[ab]:$") then
					t31 = {
						40,
						nil,
						nil,
						not v403:find("^n") and 61 or 33,
						v403:find("b", 3, true) and 1
					}
				elseif v403 == "atomic:" then
					t31 = {
						40,
						nil,
						nil,
						62,
						nil
					}
				elseif v403 == "ACCEPT" or v403 == "FAIL" or v403 == "F" or v403 == "PRUNE" or v403 == "SKIP" then
					t31 = if v403 ~= "F" then v403 else "FAIL"
				else
					if t20[v403] then
						t30.newline = v403
					elseif v403 == "BSR_ANYCRLF" or v403 == "BSR_UNICODE" then
						t30.newline_seq = v403 ~= "BSR_UNICODE" and 0 or 1
					else
						if v403 ~= "NOTEMPTY" and v403 ~= "NOTEMPTY_ATSTART" then
							return "unknown or malformed verb"
						end

						t30.not_empty = v403 ~= "NOTEMPTY" and 2 or 1
					end

					if t28[1] then
						return "this verb must be placed at the beginning of the regex"
					end
				end
			elseif p66[n14 + 1] == 63 then
				n14 += 2

				if p66[n14] == 35 then
					local v404 = table.find(p66, 41, n14)

					if not v404 then
						return "unterminated parenthetical"
					end

					n14 = v404 + 1

					continue
				end

				if not p66[n14] then
					return "unterminated parenthetical"
				end

				t31 = {
					40,
					nil,
					nil,
					p66[n14],
					nil
				}

				if p66[n14] == 48 and p66[n14 + 1] == 41 then
					t31[1] = "recurmatch"
					t31[2] = 0
					t31[3] = 0
					t31[5] = nil
				elseif p66[n14] > 48 and p66[n14] <= 57 then
					local v405 = n14 + 1

					while p66[v405] >= 48 and p66[v405] <= 48 do
						v405 += 1
					end

					if p66[v405] ~= 41 then
						return "invalid group structure"
					end

					local s = p66.s
					local v407 = utf8.offset(s, v405)
					local num = tonumber((string.sub(s, utf8.offset(s, n14), v407 and v407 - 1)))

					t31[1] = "recurmatch"
					t31[2] = num
					t31[4] = nil
					n14 = v405
				elseif p66[n14] == 60 and p66[n14 + 1] == 33 or p66[n14 + 1] == 61 then
					n14 += 1
					t31[4] = p66[n14]
					t31[5] = 1
				elseif p66[n14] == 124 then
					t31[5] = n15
				elseif p66[n14] == 80 or p66[n14] == 60 or p66[n14] == 39 then
					if p66[n14] == 80 then
						n14 += 1
					end

					if p66[n14] == 61 then
						local v409 = n14 + 1

						while p66[n14] and (p66[n14] >= 48 and p66[n14] <= 57 or p66[n14] >= 65 and p66[n14] <= 90 or (p66[n14] >= 97 and p66[n14] <= 122 or p66[n14] == 95)) do
							n14 += 1
						end

						if not p66[n14] then
							return "unterminated parenthetical"
						end

						if p66[n14] ~= 41 or n14 == v409 then
							return "invalid group structure"
						end

						t31 = {}

						local s11 = "backref"
						local s = p66.s
						local v412 = utf8.offset(s, n14)
						local v413 = string.sub(s, utf8.offset(s, v409), v412 and v412 - 1)

						t31[1] = s11
						t31[2] = v413
					else
						if p66[n14] ~= 60 and (p66[n14 - 1] == 80 or p66[n14] ~= 39) then
							return "invalid group structure"
						end

						local v414 = p66[n14] ~= 39 and 62 or 39
						local v415 = n14 + 1
						local v416 = n14 + 1

						if p66[v416] == 41 then
							return "missing character in subpattern"
						end

						if p66[v416] >= 48 and p66[v416] <= 57 then
							return "subpattern name must not begin with a digit"
						end

						if (not (p66[v416] >= 65) or not (p66[v416] <= 90)) and ((not (p66[v416] >= 97) or not (p66[v416] <= 122)) and p66[v416] ~= 95) then
							return "invalid character in subpattern"
						end

						n14 = v416 + 1

						while p66[n14] and (p66[n14] >= 48 and p66[n14] <= 57 or p66[n14] >= 65 and p66[n14] <= 90 or (p66[n14] >= 97 and p66[n14] <= 122 or p66[n14] == 95)) do
							n14 += 1
						end

						if not p66[n14] then
							return "unterminated parenthetical"
						end

						if v414 ~= p66[n14] then
							return "invalid character in subpattern"
						end

						local s = p66.s
						local v418 = utf8.offset(s, n14)
						local v419 = string.sub(s, utf8.offset(s, v415), v418 and v418 - 1)

						n15 += 1

						if n15 ~= (t29[v419] or n15) then
							return "subpattern name already exists"
						end

						for k, v in pairs(t29) do
							if v419 ~= k and n15 == v then
								return "different names for subpatterns of the same number aren't permitted"
							end
						end

						t29[v419] = n15
						t31[2] = n15
						t31[4] = nil
					end
				elseif not t27[p66[n14]] then
					return "invalid group structure"
				end
			else
				n15 += 1
				t31 = {
					40,
					n15,
					nil,
					nil
				}
			end

			if t31 then
				table.insert(t28, t31)
			end
		elseif v398 == 41 then
			local v422 = #t28 + 1
			local n16 = -1
			local n17 = 0
			local n18 = 0
			local n19 = 0

			repeat
				v422 -= 1

				local v427 = t28[v422]
				local v428 = type(t28[v422]) == "table"

				if v428 and v427[1] == 40 then
					n19 += 1

					if n17 and v427.count then
						n17 += v427.count
					end

					if v427[3] then
						continue
					end

					if v427[4] == 124 then
						n15 = v427[5] + math.max(n18, n19)
					end

					n16 = if n17 == n16 or n16 == -1 then n17 else nil

					break
				end

				if v427 == t16 then
					if n17 ~= n16 and n16 ~= -1 then
						n16 = nil
						n17 = nil
					else
						n16 = n17
						n17 = 0
					end

					n18 = math.max(n18, n19)
					n19 = 0
				elseif n17 then
					n17 = if not v428 or v427[1] ~= "quantifier" then n17 + 1 else if v427[2] ~= v427[3] then nil else n17 + v427[2]
				end
			until v422 < 1

			if v422 < 1 then
				return "unmatched ) in regular expression"
			end

			local v429 = t28[v422]
			local v430 = #t28 + 1
			local t32 = {
				41,
				v429[2],
				v422,
				v429[4],
				v429[5],
				count = n16
			}

			if (v429[4] == 33 or v429[4] == 61) and v429[5] and not n16 then
				return "lookbehind assertion is not fixed width"
			end

			v429[3] = v430
			table.insert(t28, t32)
		elseif v398 == 46 then
			table.insert(t28, t14)
		elseif v398 == 91 then
			local v432 = false
			local v433 = nil
			local v434 = n14 + 1

			if p66[v434] == 94 then
				v432 = true
				n14 = v434 + 1
			else
				n14 = v434

				if p66[v434] == 46 or p66[v434] == 58 or p66[v434] == 61 then
					v433 = p66[v434]
					n14 = v434
				end
			end

			local t33

			if p66[n14] == 91 or p66[n14] == 92 then
				t33 = {}
			else
				t33 = { p66[n14] }
				n14 += 1
			end

			while p66[n14] ~= 93 do
				if not p66[n14] then
					return "unterminated character class"
				end

				if p66[n14] == 45 and t33[1] and type(t33[1]) == "number" then
					if p66[n14 + 1] == 93 then
						table.insert(t33, 1, 45)
					else
						n14 += 1

						local v436 = p66[n14]

						if v436 == 91 then
							if p66[n14 + 1] == 46 or p66[n14 + 1] == 58 or p66[n14 + 1] == 61 then
								local v437 = n14 + 2

								repeat
									v437 = table.find(p66, 93, v437)
								until not v437 or p66[v437 - 1] ~= 92

								if not v437 then
									return "unterminated character class"
								end

								if p66[v437 - 1] == p66[n14 + 1] and v437 - 1 ~= n14 + 1 then
									return "invalid range in character class"
								end
							end

							if t33[1] > 91 then
								return "invalid range in character class"
							end
						elseif v436 == 92 then
							n14 += 1

							if p66[n14] == 120 then
								local v438 = nil
								local v439 = nil
								local v440 = n14 + 1

								if p66[v440] and p66[v440] >= 48 and p66[v440] <= 57 or p66[v440] >= 65 and p66[v440] <= 70 or p66[v440] >= 97 and p66[v440] <= 102 then
									v438 = p66[v440] - if not (p66[v440] >= 65) or not (p66[v440] <= 90) then (not (p66[v440] >= 97) or not (p66[v440] <= 122)) and 48 or 87 else 55
									n14 = v440 + 1

									if p66[n14] and p66[n14] >= 48 and p66[n14] <= 57 or p66[n14] >= 65 and p66[n14] <= 70 or p66[n14] >= 97 and p66[n14] <= 102 then
										v439 = p66[n14] - if not (p66[n14] >= 65) or not (p66[n14] <= 90) then (not (p66[n14] >= 97) or not (p66[n14] <= 122)) and 48 or 87 else 55
									else
										n14 -= 1
									end
								else
									n14 = v440 - 1
								end

								v436 = v438 and (v439 and 16 * v438 + v439 or v438) or 0
							elseif p66[n14] >= 48 and p66[n14] <= 55 then
								local v441 = p66[n14] - 48
								local v442 = nil
								local v443 = nil
								local v444 = n14 + 1

								if p66[v444] and p66[v444] >= 48 and p66[v444] <= 55 then
									v442 = p66[v444] - 48
									n14 = v444 + 1

									if p66[n14] and p66[n14] >= 48 and p66[n14] <= 55 then
										v443 = p66[n14] - 48
									else
										n14 -= 1
									end
								else
									n14 = v444 - 1
								end

								v436 = v442 and (v443 and 64 * v441 + 8 * v442 + v443 or 8 * v441 + v442) or v441
							else
								v436 = t9[p66[n14]] or p66[n14]

								if type(v436) ~= "number" then
									return "invalid range in character class"
								end
							end
						elseif v436 < t33[1] then
							return "invalid range in character class"
						end

						t33[1] = {
							"range",
							t33[1],
							v436
						}
					end
				elseif p66[n14] == 91 then
					if p66[n14 + 1] == 46 or p66[n14 + 1] == 58 or p66[n14 + 1] == 61 then
						local v445 = n14 + 2

						repeat
							v445 = table.find(p66, 93, v445)
						until not v445 or p66[v445 - 1] ~= 92

						if not v445 then
							return "unterminated character class"
						end

						if p66[v445 - 1] ~= p66[n14 + 1] or v445 - 1 == n14 + 1 then
							table.insert(t33, 1, 91)
						else
							if p66[v445 - 1] == 46 or p66[v445 - 1] == 61 then
								return "POSIX collating elements aren't supported"
							end

							if p66[v445 - 1] == 58 then
								local v446 = p66[n14 + 3] == 94
								local s = p66.s
								local v448 = n14 + (not v446 and 2 or 3)
								local v449 = v445 - 1
								local v450 = utf8.offset(s, v449)
								local v451 = string.sub(s, utf8.offset(s, v448), v450 and v450 - 1)

								if not t8[v451] then
									return "unknown POSIX class name"
								end

								table.insert(t33, 1, {
									"class",
									v451,
									v446
								})
								n14 = v445
							end
						end
					else
						table.insert(t33, 1, 91)
					end
				elseif p66[n14] == 92 then
					n14 += 1

					if p66[n14] == 120 then
						local v452 = nil
						local v453 = nil
						local v454 = n14 + 1

						if p66[v454] == 123 then
							n14 = v454 + 1

							local v455 = n14

							while p66[n14] and (p66[n14] >= 48 and p66[n14] <= 57 or p66[n14] >= 65 and p66[n14] <= 70 or p66[n14] >= 97 and p66[n14] <= 102) do
								n14 += 1
							end

							if p66[n14] ~= 125 or n14 == v455 then
								return "malformed hexadecimal character"
							end

							if n14 - v455 > 4 then
								return "character offset too large"
							end

							local s = p66.s
							local v457 = utf8.offset(s, n14)

							table.insert(t33, 1, (tonumber(string.sub(s, utf8.offset(s, v455), v457 and v457 - 1), 16)))
						else
							if p66[v454] and p66[v454] >= 48 and p66[v454] <= 57 or p66[v454] >= 65 and p66[v454] <= 70 or p66[v454] >= 97 and p66[v454] <= 102 then
								v452 = p66[v454] - if not (p66[v454] >= 65) or not (p66[v454] <= 90) then (not (p66[v454] >= 97) or not (p66[v454] <= 122)) and 48 or 87 else 55
								n14 = v454 + 1

								if p66[n14] and p66[n14] >= 48 and p66[n14] <= 57 or p66[n14] >= 65 and p66[n14] <= 70 or p66[n14] >= 97 and p66[n14] <= 102 then
									v453 = p66[n14] - if not (p66[n14] >= 65) or not (p66[n14] <= 90) then (not (p66[n14] >= 97) or not (p66[n14] <= 122)) and 48 or 87 else 55
								else
									n14 -= 1
								end
							else
								n14 = v454 - 1
							end

							table.insert(t33, 1, v452 and (v453 and 16 * v452 + v453 or v452) or 0)
						end
					elseif p66[n14] >= 48 and p66[n14] <= 55 then
						local v458 = p66[n14] - 48
						local v459 = nil
						local v460 = nil
						local v461 = n14 + 1

						if p66[v461] and p66[v461] >= 48 and p66[v461] <= 55 then
							v459 = p66[v461] - 48
							n14 = v461 + 1

							if p66[n14] and p66[n14] >= 48 and p66[n14] <= 55 then
								v460 = p66[n14] - 48
							else
								n14 -= 1
							end
						else
							n14 = v461 - 1
						end

						table.insert(t33, 1, v459 and (v460 and 64 * v458 + 8 * v459 + v460 or 8 * v458 + v459) or v458)
					elseif p66[n14] ~= 69 then
						if p66[n14] == 81 then
							local v462 = n14 + 1

							repeat
								n14 = table.find(p66, 92, n14 + 1)
							until not n14 or p66[n14 + 1] == 69

							table.move(p66, v462, n14 and n14 - 1 or #p66, #t28 + 1, t28)

							if not n14 then
								break
							end

							n14 += 1
						elseif p66[n14] == 78 then
							if p66[n14 + 1] ~= 123 or p66[n14 + 2] ~= 85 or p66[n14 + 3] ~= 43 or not p67.unicode then
								return "invalid escape sequence"
							end

							n14 += 4

							local v463 = n14

							while p66[n14] and (p66[n14] >= 48 and p66[n14] <= 57 or p66[n14] >= 65 and p66[n14] <= 70 or p66[n14] >= 97 and p66[n14] <= 102) do
								n14 += 1
							end

							if p66[n14] ~= 125 or n14 == v463 then
								return "malformed Unicode code point"
							end

							local s = p66.s
							local v465 = utf8.offset(s, n14)

							table.insert(t33, 1, (tonumber((string.sub(s, utf8.offset(s, v463), v465 and v465 - 1)))))
						elseif p66[n14] == 80 or p66[n14] == 112 then
							if not t1.unicodeData then
								return "options.unicodeData cannot be turned off when using \\p"
							end

							n14 += 1

							if p66[n14] ~= 123 then
								local v466 = utf8.char(p66[n14] or 0)

								if not t11[v466] then
									return "unknown or malformed script name"
								end

								table.insert(t33, 1, {
									"category",
									false,
									v466
								})
							else
								local v467 = p66[n14] == 80
								local v468 = n14 + 1

								if p66[v468] == 94 then
									v468 += 1
									v467 = not v467
								end

								n14 = v468

								while p66[n14] and (p66[n14] >= 48 and p66[n14] <= 57 or p66[n14] >= 65 and p66[n14] <= 90 or (p66[n14] >= 97 and p66[n14] <= 122 or p66[n14] == 95)) do
									n14 += 1
								end

								if p66[n14] ~= 125 then
									return "unknown or malformed script name"
								end

								local s = p66.s
								local v470 = utf8.offset(s, n14)
								local v471 = string.sub(s, utf8.offset(s, v468), v470 and v470 - 1)
								local v472 = v3[v471]

								if v472 then
									table.insert(t33, 1, {
										"charset",
										v467,
										v472
									})
								else
									if not t11[v471] then
										return "unknown or malformed script name"
									end

									table.insert(t33, 1, {
										"category",
										v467,
										v471
									})
								end
							end
						elseif p66[n14] == 111 then
							local v473 = n14 + 1

							if p66[v473] ~= 123 then
								return "malformed octal code"
							end

							n14 = v473 + 1

							local v474 = n14

							while p66[n14] and p66[n14] >= 48 and p66[n14] <= 55 do
								n14 += 1
							end

							if p66[n14] ~= 125 or n14 == v474 then
								return "malformed octal code"
							end

							local s = p66.s
							local v476 = utf8.offset(s, n14)
							local num = tonumber(string.sub(s, utf8.offset(s, v474), v476 and v476 - 1), 8)

							if num > 65535 then
								return "character offset too large"
							end

							table.insert(t33, 1, num)
						else
							local v478 = t9[p66[n14]]

							table.insert(t33, 1, type(v478) == "string" and {
								"class",
								v478,
								false
							} or (v478 or p66[n14]))
						end
					end
				elseif p67.ignoreCase and p66[n14] >= 97 and p66[n14] <= 122 then
					table.insert(t33, 1, p66[n14] - 32)
				else
					table.insert(t33, 1, p66[n14])
				end

				n14 += 1
			end

			if v433 == p66[n14 - 1] and v434 ~= n14 - 1 then
				if v433 == 58 then
					return "POSIX named classes are only support within a character set"
				end

				return "POSIX collating elements aren't supported"
			end

			if not t33[2] and not v432 then
				table.insert(t28, t33[1])
			else
				table.insert(t28, {
					"charset",
					v432,
					t33
				})
			end
		elseif v398 == 92 then
			n14 += 1

			local v479 = p66[n14]

			if not v479 then
				return "pattern may not end with a trailing backslash"
			end

			if v479 >= 48 and v479 <= 57 then
				local v480 = n14

				while p66[n14 + 1] and p66[n14 + 1] >= 48 and p66[n14 + 1] <= 57 do
					n14 += 1
				end

				local s = p66.s
				local v482 = n14 + 1
				local v483 = utf8.offset(s, v482)
				local num = tonumber((string.sub(s, utf8.offset(s, v480), v483 and v483 - 1)))

				if n15 < num and n14 ~= v480 then
					n14 = v480

					local v485 = nil
					local v486 = nil
					local v487 = nil

					if p66[n14] <= 55 then
						v485 = p66[n14] - 48

						local v488 = n14 + 1

						if p66[v488] and p66[v488] >= 48 and p66[v488] <= 55 then
							v486 = p66[v488] - 48
							n14 = v488 + 1

							if p66[n14] and p66[n14] >= 48 and p66[n14] <= 55 then
								v487 = p66[n14] - 48
							else
								n14 -= 1
							end
						else
							n14 = v488 - 1
						end
					end

					table.insert(t28, v485 and (v486 and (v487 and 64 * v485 + 8 * v486 + v487 or 8 * v485 + v486) or v485) or p66[v480])
				else
					table.insert(t28, {
						"backref",
						num
					})
				end
			elseif v479 ~= 69 then
				if v479 == 81 then
					local v489 = n14 + 1

					repeat
						n14 = table.find(p66, 92, n14 + 1)
					until not n14 or p66[n14 + 1] == 69

					table.move(p66, v489, n14 and n14 - 1 or #p66, #t28 + 1, t28)

					if not n14 then
						break
					end

					n14 += 1
				elseif v479 == 78 then
					if p66[n14 + 1] == 123 and p66[n14 + 2] == 85 and p66[n14 + 3] == 43 and p67.unicode then
						n14 += 4

						local v490 = n14

						while p66[n14] and (p66[n14] >= 48 and p66[n14] <= 57 or p66[n14] >= 65 and p66[n14] <= 70 or p66[n14] >= 97 and p66[n14] <= 102) do
							n14 += 1
						end

						if p66[n14] ~= 125 or n14 == v490 then
							return "malformed Unicode code point"
						end

						local s = p66.s
						local v492 = utf8.offset(s, n14)

						table.insert(t28, (tonumber((string.sub(s, utf8.offset(s, v490), v492 and v492 - 1)))))
					else
						table.insert(t28, t9[78])
					end
				elseif v479 == 80 or v479 == 112 then
					if not t1.unicodeData then
						return "options.unicodeData cannot be turned off when using \\p"
					end

					n14 += 1

					if p66[n14] ~= 123 then
						local v493 = utf8.char(p66[n14] or 0)

						if not t11[v493] then
							return "unknown or malformed script name"
						end

						table.insert(t28, {
							"category",
							false,
							v493
						})
					else
						local v494 = v479 == 80
						local v495 = n14 + 1

						if p66[v495] == 94 then
							v495 += 1
							v494 = not v494
						end

						n14 = v495

						while p66[n14] and (p66[n14] >= 48 and p66[n14] <= 57 or p66[n14] >= 65 and p66[n14] <= 90 or (p66[n14] >= 97 and p66[n14] <= 122 or p66[n14] == 95)) do
							n14 += 1
						end

						if p66[n14] ~= 125 then
							return "unknown or malformed script name"
						end

						local s = p66.s
						local v497 = utf8.offset(s, n14)
						local v498 = string.sub(s, utf8.offset(s, v495), v497 and v497 - 1)
						local v499 = v3[v498]

						if v499 then
							table.insert(t28, {
								"charset",
								v494,
								v499
							})
						else
							if not t11[v498] then
								return "unknown or malformed script name"
							end

							table.insert(t28, {
								"category",
								v494,
								v498
							})
						end
					end
				elseif v479 == 103 and (p66[n14 + 1] == 123 or p66[n14 + 1] >= 48 and p66[n14 + 1] <= 57) then
					local v500 = false
					local v501 = n14 + 1

					if p66[v501] == 123 then
						v501 += 1
						v500 = true
					elseif p66[v501] < 48 or p66[v501] > 57 then
						return "malformed reference code"
					end

					n14 = v501

					while p66[n14] and (p66[n14] >= 48 and p66[n14] <= 57 or p66[n14] >= 65 and p66[n14] <= 70 or p66[n14] >= 97 and p66[n14] <= 102) do
						n14 += 1
					end

					if v500 and p66[n14] ~= 125 then
						return "malformed reference code"
					end

					local s = p66.s
					local v503 = n14 + (not v500 and 1 or 0)
					local v504 = utf8.offset(s, v503)

					table.insert(t28, {
						"backref",
						(tonumber((string.sub(s, utf8.offset(s, v501), v504 and v504 - 1))))
					})

					if not v500 then
						n14 -= 1
					end
				elseif v479 == 111 then
					local v505 = n14 + 1

					if p66[v505 + 1] ~= 123 then
						return "malformed octal code"
					end

					n14 = v505 + 1

					local v506 = n14

					while p66[n14] and p66[n14] >= 48 and p66[n14] <= 55 do
						n14 += 1
					end

					if p66[n14] ~= 125 or n14 == v506 then
						return "malformed octal code"
					end

					local s = p66.s
					local v508 = utf8.offset(s, n14)
					local num = tonumber(string.sub(s, utf8.offset(s, v506), v508 and v508 - 1), 8)

					if num > 65535 then
						return "character offset too large"
					end

					table.insert(t28, num)
				elseif v479 == 120 then
					local v510 = nil
					local v511 = nil
					local v512 = n14 + 1

					if p66[v512] == 123 then
						n14 = v512 + 1

						local v513 = n14

						while p66[n14] and (p66[n14] >= 48 and p66[n14] <= 57 or p66[n14] >= 65 and p66[n14] <= 70 or p66[n14] >= 97 and p66[n14] <= 102) do
							n14 += 1
						end

						if p66[n14] ~= 125 or n14 == v513 then
							return "malformed hexadecimal code"
						end

						if n14 - v513 > 4 then
							return "character offset too large"
						end

						local s = p66.s
						local v515 = utf8.offset(s, n14)

						table.insert(t28, (tonumber(string.sub(s, utf8.offset(s, v513), v515 and v515 - 1), 16)))
					else
						if p66[v512] and (p66[v512] >= 48 and p66[v512] <= 57 or p66[v512] >= 65 and p66[v512] <= 70 or p66[v512] >= 97 and p66[v512] <= 102) then
							v510 = p66[v512] - if not (p66[v512] >= 65) or not (p66[v512] <= 90) then (not (p66[v512] >= 97) or not (p66[v512] <= 122)) and 48 or 87 else 55
							n14 = v512 + 1

							if p66[n14] and (p66[n14] >= 48 and p66[n14] <= 57 or p66[n14] >= 65 and p66[n14] <= 70 or p66[n14] >= 97 and p66[n14] <= 102) then
								v511 = p66[n14] - if not (p66[n14] >= 65) or not (p66[n14] <= 90) then (not (p66[n14] >= 97) or not (p66[n14] <= 122)) and 48 or 87 else 55
							else
								n14 -= 1
							end
						else
							n14 = v512 - 1
						end

						table.insert(t28, v510 and (v511 and 16 * v510 + v511 or v510) or 0)
					end
				else
					table.insert(t28, t10[v479] or t9[v479] or v479)
				end
			end
		elseif v398 == 42 or v398 == 43 or v398 == 63 or v398 == 123 then
			local num = nil
			local v517 = nil

			if v398 == 123 then
				local v518 = n14 + 1
				local v519 = nil

				while p66[n14 + 1] and (p66[n14 + 1] >= 48 and p66[n14 + 1] <= 57 or p66[n14 + 1] == 44 and not v519 and v518 ~= n14 + 1) do
					n14 += 1

					if p66[n14] == 44 then
						v519 = n14
					end
				end

				if p66[n14 + 1] == 125 then
					n14 += 1

					if not v519 then
						local s = p66.s
						local v521 = utf8.offset(s, n14)

						num = tonumber((string.sub(s, utf8.offset(s, v518), v521 and v521 - 1)))
						v517 = num
					else
						local s = p66.s
						local v523 = utf8.offset(s, v519)

						num = tonumber((string.sub(s, utf8.offset(s, v518), v523 and v523 - 1)))

						if n14 == v519 + 1 then
							v517 = 1e999
						else
							local s11 = p66.s
							local v525 = v519 + 1
							local v526 = utf8.offset(s11, n14)

							v517 = tonumber((string.sub(s11, utf8.offset(s11, v525), v526 and v526 - 1)))
						end

						if v517 < num then
							return "numbers out of order in {} quantifier"
						end
					end
				else
					table.move(p66, v518 - 1, n14, #t28 + 1, t28)
				end
			else
				num = v398 ~= 43 and 0 or 1
				v517 = v398 ~= 63 and 1e999 or 1
			end

			if num then
				local v527 = not p67.ungreedy and "greedy" or "lazy"

				if p66[n14 + 1] == 43 or p66[n14 + 1] == 63 then
					n14 += 1
					v527 = if p66[n14] ~= 43 then not p67.ungreedy and "lazy" or "greedy" else "possessive"
				end

				local v528 = #t28
				local v529 = t28[v528]

				if not v529 or (type(v529) == "table" and (v529[1] == "quantifier" or v529[1] == 40 or t10[v529[1]]) or (v529 == t16 or type(v529) == "string")) then
					return "quantifier doesn't follow a repeatable pattern"
				end

				if v517 == 0 then
					table.remove(t28)
				elseif num ~= 1 or v517 ~= 1 then
					if type(v529) == "table" and v529[1] == 41 then
						v528 = v529[3]
					end

					t28[v528] = {
						"quantifier",
						num,
						v517,
						v527,
						t28[v528]
					}
				end
			end
		elseif v398 == 124 then
			table.insert(t28, t16)

			local v530 = #t28

			repeat
				v530 -= 1

				local v531 = t28[v530]
				local v532 = type(t28[v530]) == "table"

				if v532 and v531[1] == 41 then
					v530 = t28[v530][3]

					continue
				end

				if v532 and v531[1] == 40 then
					if v531[4] == 124 then
						n15 = v531[5]
					end

					break
				end
			until not v531
		elseif v398 == 36 or v398 == 94 then
			table.insert(t28, v398 == 94 and t15 or t13)
		elseif p67.ignoreCase and v398 >= 97 and v398 <= 122 then
			table.insert(t28, v398 - 32)
		elseif p67.extended and (v398 >= 9 and v398 <= 13 or v398 == 32 or v398 == 35) then
			if v398 == 35 then
				repeat
					n14 += 1
				until not p66[n14] or p66[n14] == 10 or p66[n14] == 13
			end
		else
			table.insert(t28, v398)
		end

		n14 += 1
	end

	local n20 = 0

	for _, v in ipairs(t28) do
		local v536 = v

		if type(v536) ~= "table" or v536[1] ~= 40 and (v536[1] ~= "quantifier" or type(v536[5]) ~= "table" or v536[5][1] ~= 40) then
			if type(v536) ~= "table" or v536[1] ~= "backref" and v536[1] ~= "recurmatch" then
				continue
			end

			if not t29[v536[2]] and (type(v536[2]) ~= "number" or n15 < v536[2]) then
				return "reference to a non-existent or invalid subpattern"
			end

			if v536[1] == "recurmatch" and v536[2] ~= 0 then
				for i, v5 in ipairs(t28) do
					if type(v5) == "table" and v5[1] == 40 and v5[2] == v536[2] then
						v536[3] = i
						g539 = true
					end

					if g539 then
						break
					end
				end
			elseif type(v536[2]) == "string" then
				v536[2] = t29[v536[2]]
			end

			if not g539 then
				continue
			end
		end

		if not g539 then
			if v536[1] == "quantifier" then
				v536 = v536[5]
			end

			if not v536[3] then
				return "unterminated parenthetical"
			end

			if v536[2] then
				n20 = math.max(n20, v536[2])
			end
		end

		g539 = false
	end

	t28.group_n = n20

	return t28, t29, t30
end

if not tonumber(t1.cacheSize) then
	error(string.format("expected number for options.cacheSize, got %s", (typeof(t1.cacheSize))), 2)
end

local v56 = math.floor(t1.cacheSize or 0) ~= 0 and tonumber(t1.cacheSize)
local t34 = nil
local t35 = nil

if v56 then
	if v56 < 0 or v56 ~= v56 then
		error("cache size cannot be a negative number or a NaN", 2)
	elseif v56 == 1e999 then
		t34 = { nil }
		t35 = { nil }
	elseif v56 >= 4294967296 then
		error("cache size too large", 2)
	else
		t34 = table.create(t1.cacheSize)
		t35 = table.create(t1.cacheSize)
	end
end

if v56 then
	function t2.pruge() -- line: 1902
		-- upvalues: t35 (ref), t34 (ref)
		table.clear(t35)
		table.clear(t34)
	end
end

local function new_re(p68, p69, p70, p71) -- line: 1908
	-- upvalues: v56 (copy), t34 (ref), t35 (ref), tokenize_ptn (copy), self (copy), t3 (ref), re_tostr (copy), u9 (ref)
	local v544 = v56 and string.format("%s|%s", p68.s, p70)
	local v545 = v56 and t34[table.find(t35, v544)]
	local v546, v547, v548

	if v545 then
		v546, v547, v548 = table.unpack(v545, 1, 3)
	else
		v546, v547, v548 = tokenize_ptn(p68, p69)

		if type(v546) == "string" then
			error(v546, 2)
		end

		if v56 and v546[1] then
			table.insert(t35, 1, v544)
			table.insert(t34, 1, {
				v546,
				v547,
				v548
			})

			if v56 ~= 1e999 then
				table.remove(t35, v56 + 1)
				table.remove(t34, v56 + 1)
			end
		end
	end

	local v549 = newproxy(true)

	self[v549] = {
		name = "RegEx",
		flags = p69,
		flag_repr = p70,
		pattern_repr = p71,
		token = v546,
		group_id = v547,
		verb_flags = v548
	}

	local mt = getmetatable(v549)

	mt.__index = setmetatable(p69, t3)
	mt.__tostring = re_tostr
	mt.__metatable = u9

	return v549
end
local function escape_fslash(p72) -- line: 1939
	return (#p72 % 2 ~= 0 and "" or "\\") .. p72 .. "."
end
local function sort_flag_chr(p73, p74) -- line: 1943
	return p73:lower() < p74:lower()
end

function t2.new(...) -- line: 1947
	-- upvalues: t7 (copy), sort_flag_chr (copy), new_re (copy), to_str_arr (copy), escape_fslash (copy)
	if select("#", ...) == 0 then
		error("missing argument #1 (string expected)", 2)
	end

	local v554, v555 = ...

	if type(v554) == "number" then
		v554 ..= ""
	elseif type(v554) ~= "string" then
		error(string.format("invalid argument #1 (string expected, got %s)", (typeof(v554))), 2)
	end

	if type(v555) ~= "string" and type(v555) ~= "number" and v555 ~= nil then
		error(string.format("invalid argument #2 (string expected, got %s)", (typeof(v555))), 2)
	end

	local t36 = {
		anchored = false,
		caseless = false,
		multiline = false,
		dotall = false,
		unicode = false,
		ungreedy = false,
		extended = false
	}
	local t37 = {}

	for match in string.gmatch(v555 or "", utf8.charpattern) do
		if t36[t7[match]] ~= false then
			error("invalid regular expression flag " .. match, 3)
		end

		t36[t7[match]] = true
		table.insert(t37, match)
	end

	table.sort(t37, sort_flag_chr)

	local v559 = table.concat(t37)

	return (new_re(to_str_arr(v554), t36, v559, string.format("/%s/", v554:gsub("(\\*)/", escape_fslash))))
end
function t2.fromstring(...) -- line: 1977
	-- upvalues: to_str_arr (copy), t7 (copy), sort_flag_chr (copy), new_re (copy)
	if select("#", ...) == 0 then
		error("missing argument #1 (string expected)", 2)
	end

	local v560 = ...

	if type(v560) == "number" then
		v560 ..= ""
	elseif type(v560) ~= "string" then
		error(string.format("invalid argument #1 (string expected, got %s)", typeof(v560), 2))
	end

	local v561 = to_str_arr(v560)
	local v562 = v561[1]

	if not v562 then
		error("empty regex", 2)
	elseif v562 == 92 or v562 >= 48 and v562 <= 57 or v562 >= 65 and v562 <= 90 or v562 >= 97 and v562 <= 122 then
		error("delimiter must not be alphanumeric or a backslash", 2)
	end

	local n21 = 1

	repeat
		n21 = table.find(v561, v562, n21 + 1)

		if not n21 then
			error(string.format("no ending delimiter ('%s') found", utf8.char(v562)), 2)
		end

		local n22 = 1

		while v561[n21 - n22] == 92 do
			n22 += 1
		end
	until n22 % 2 == 1

	local t38 = {
		anchored = false,
		caseless = false,
		multiline = false,
		dotall = false,
		unicode = false,
		ungreedy = false,
		extended = false
	}
	local t39 = {}

	while n21 < v561.n do
		local v567 = utf8.char(table.remove(v561))

		v561.n = v561.n - 1

		if t38[t7[v567]] ~= false then
			error("invalid regular expression flag " .. v567, 3)
		end

		t38[t7[v567]] = true
		table.insert(t39, v567)
	end

	table.sort(t39, sort_flag_chr)

	local v568 = table.concat(t39)

	table.remove(v561, 1)
	table.remove(v561)
	v561.n = v561.n - 2
	v561.s = string.sub(v561.s, 2, 1 + v561.n)

	return (new_re(v561, t38, v568, (string.sub(v560, 1, 2 + v561.n))))
end

local t40 = {
	["\000"] = "\\x00",
	["\n"] = "\\n",
	["\t"] = "\\t",
	["\r"] = "\\r",
	["\f"] = "\\f"
}

function t2.escape(...) -- line: 2033
	-- upvalues: t40 (copy)
	if select("#", ...) == 0 then
		error("missing argument #1 (string expected)", 2)
	end

	local v569, v570, v571 = ...

	if type(v569) == "number" then
		v569 ..= ""
	elseif type(v569) ~= "string" then
		error(string.format("invalid argument #1 to 'escape' (string expected, got %s)", (typeof(v569))), 2)
	end

	if v571 == nil then
		v571 = ""
	elseif type(v571) == "number" then
		v571 ..= ""
	elseif type(v571) ~= "string" then
		error(string.format("invalid argument #3 to 'escape' (string expected, got %s)", (typeof(v571))), 2)
	end

	if utf8.len(v571) > 1 or v571:match("^[%a\\]$") then
		error("delimiter have not be alphanumeric", 2)
	end

	return (string.gsub(v569, "[\000\f\n\r\t]", t40):gsub(string.format("[\\%s#()%%%%*+.?[%%]^{|%s]", not v570 and "" or "%s", (not v571:find("^[%%%]]$") and "" or "%") .. v571), "\\%1"))
end
function t2.type(...) -- line: 2056
	-- upvalues: self (copy)
	if select("#", ...) == 0 then
		error("missing argument #1", 2)
	end

	return self[...] and self[...].name
end

for k, v in pairs(t3) do
	t2[k] = v
end

t3 = {
	__index = t3
}
u9 = t2.fromstring("/The\\s*metatable\\s*is\\s*(?:locked|inaccessible)(?#Nice try :])/i")
getmetatable(u9).__metatable = u9

local function readonly_table() -- line: 2072
	error("Attempt to modify a readonly table", 2)
end

t4 = {
	__index = t4,
	__metatable = u9,
	__newindex = readonly_table
}
t2.Match = setmetatable({}, t4)

return (setmetatable({}, {
	__index = t2,
	__metatable = u9,
	__newindex = readonly_table
}))
