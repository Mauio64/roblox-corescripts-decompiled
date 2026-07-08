local t1 = {
	version = "0.9.0",
	options = {
		separator = "&"
	},
	services = {
		acap = 674,
		cap = 1026,
		dict = 2628,
		ftp = 21,
		gopher = 70,
		http = 80,
		https = 443,
		iax = 4569,
		icap = 1344,
		imap = 143,
		ipp = 631,
		ldap = 389,
		mtqp = 1038,
		mupdate = 3905,
		news = 2009,
		nfs = 2049,
		nntp = 119,
		rtsp = 554,
		sip = 5060,
		snmp = 161,
		telnet = 23,
		tftp = 69,
		vemmi = 575,
		afs = 1483,
		jms = 5673,
		rsync = 873,
		prospero = 191,
		videotex = 516
	}
}
local t2 = {
	["-"] = true,
	_ = true,
	["."] = true,
	["!"] = true,
	["~"] = true,
	["*"] = true,
	["'"] = true,
	["("] = true,
	[")"] = true,
	[":"] = true,
	["@"] = true,
	["&"] = true,
	["="] = true,
	["+"] = true,
	["$"] = true,
	[","] = true,
	[";"] = true
}

local function decode(p1, p2) -- line: 60
	if not p2 then
		p1 = p1:gsub("+", " ")
	end

	return (p1:gsub("%%(%x%x)", function(p3) -- line: 65
		return (string.char((tonumber(p3, 16))))
	end))
end
local function encode(p4) -- line: 70
	return (p4:gsub("([^A-Za-z0-9%_%.%-%~])", function(p5) -- line: 71
		return string.upper(string.format("%%%02x", string.byte(p5)))
	end))
end
local function encodeValue(p6) -- line: 77
	return p6:gsub("([^A-Za-z0-9%_%.%-%~])", function(p7) -- line: 71
		return string.upper(string.format("%%%02x", string.byte(p7)))
	end):gsub("%%20", "+")
end
local function encodeSegment(p8) -- line: 82
	-- upvalues: t2 (copy)
	return p8:gsub("([^a-zA-Z0-9])", function(p9) -- line: 83
		-- upvalues: t2 (copy)
		if t2[p9] then
			return p9
		end

		return (p9:gsub("([^A-Za-z0-9%_%.%-%~])", function(p10) -- line: 71
			return string.upper(string.format("%%%02x", string.byte(p10)))
		end))
	end)
end
local function concat(p11, p12) -- line: 92
	return p11 .. p12:build()
end

function t1.build(p13) -- line: 98
	-- upvalues: encodeSegment (copy), t1 (copy)
	local s1 = ""

	if p13.path then
		local path = p13.path

		path:gsub("([^/]+)", function(p14) -- line: 102
			-- upvalues: encodeSegment (copy)
			return encodeSegment(p14)
		end)
		s1 ..= tostring(path)
	end

	if p13.query then
		local str = tostring(p13.query)

		if str ~= "" then
			s1 ..= "?" .. str
		end
	end

	if p13.host then
		local host = p13.host

		if p13.port and p13.scheme and t1.services[p13.scheme] ~= p13.port then
			host ..= ":" .. p13.port
		end

		local user = nil

		if p13.user and p13.user ~= "" then
			user = p13.user

			if p13.password then
				user ..= ":" .. p13.password
			end
		end

		if user and user ~= "" then
			host = user .. "@" .. host
		end

		if host then
			s1 = if s1 == "" then "//" .. host else "//" .. host .. "/" .. s1:gsub("^/+", "")
		end
	end

	if p13.scheme then
		s1 = p13.scheme .. ":" .. s1
	end

	if p13.fragment then
		s1 ..= "#" .. p13.fragment
	end

	return s1
end
function t1.buildQuery(p15, p16, p17) -- line: 148
	-- upvalues: t1 (copy)
	local t3 = {}

	if not p16 then
		p16 = t1.options.separator or "&"
	end

	local t4 = {}

	for k in pairs(p15) do
		t4[#t4 + 1] = k
	end

	table.sort(t4)

	for _, v in ipairs(t4) do
		local v30 = v
		local v31 = p15[v30]
		local v32 = tostring(v30):gsub("([^A-Za-z0-9%_%.%-%~])", function(p18) -- line: 71
			return string.upper(string.format("%%%02x", string.byte(p18)))
		end)

		if p17 then
			v32 = string.format("%s[%s]", tostring(p17), (tostring(v32)))
		end

		if type(v31) == "table" then
			t3[#t3 + 1] = t1.buildQuery(v31, p16, v32)
		else
			local v33 = tostring(v31):gsub("([^A-Za-z0-9%_%.%-%~])", function(p19) -- line: 71
				return string.upper(string.format("%%%02x", string.byte(p19)))
			end):gsub("%%20", "+")

			if v33 ~= "" then
				t3[#t3 + 1] = string.format("%s=%s", v32, v33)
			else
				t3[#t3 + 1] = v32
			end
		end
	end

	return table.concat(t3, p16)
end
function t1.parseQuery(p20, p21) -- line: 185
	-- upvalues: t1 (copy)
	if not p21 then
		p21 = t1.options.separator or "&"
	end

	local t5 = {}

	for match, v38 in p20:gmatch(string.format("([^%q=]+)(=*[^%q=]*)", p21, p21)) do
		local t6 = {}
		local v40 = match:gsub("+", " "):gsub("%%(%x%x)", function(p22) -- line: 65
			return (string.char((tonumber(p22, 16))))
		end):gsub("%[([^%]]*)%]", function(p23) -- line: 194
			-- upvalues: t6 (copy)
			local v84 = if not string.find(p23, "^-?%d+$") then p23:gsub("+", " "):gsub("%%(%x%x)", function(p24) -- line: 65
				return (string.char((tonumber(p24, 16))))
			end) else tonumber(p23)

			table.insert(t6, v84)

			return "="
		end):gsub("=+.*$", ""):gsub("%s", "_")
		local v41 = v38:gsub("^=+", "")

		if not t5[v40] then
			t5[v40] = {}
		end

		if #t6 > 0 and type(t5[v40]) ~= "table" then
			t5[v40] = {}
		elseif #t6 == 0 and type(t5[v40]) == "table" then
			t5[v40] = v41:gsub("+", " "):gsub("%%(%x%x)", function(p25) -- line: 65
				return (string.char((tonumber(p25, 16))))
			end)
		end

		local v42 = t5[v40]

		for i, v in ipairs(t6) do
			local v45 = v

			if type(v42) ~= "table" then
				v42 = {}
			end

			if v45 == "" then
				v45 = #v42 + 1
			end

			if not v42[v45] then
				v42[v45] = {}
			end

			if i == #t6 then
				v42[v45] = v41:gsub("+", " "):gsub("%%(%x%x)", function(p26) -- line: 65
					return (string.char((tonumber(p26, 16))))
				end)
			end

			v42 = v42[v45]
		end
	end

	setmetatable(t5, {
		__tostring = t1.buildQuery
	})

	return t5
end
function t1.setQuery(p27, p28) -- line: 241
	-- upvalues: t1 (copy)
	if type(p28) == "table" then
		p28 = t1.buildQuery(p28)
	end

	p27.query = t1.parseQuery(p28)

	return p28
end
function t1.setAuthority(p29, p30) -- line: 254
	p29.authority = p30
	p29.port = nil
	p29.host = nil
	p29.userinfo = nil
	p29.user = nil
	p29.password = nil

	local v50 = p30:gsub("^([^@]*)@", function(p31) -- line: 262
		-- upvalues: p29 (copy)
		p29.userinfo = p31

		return ""
	end):gsub("^%[[^%]]+%]", function(p32) -- line: 266
		-- upvalues: p29 (copy)
		p29.host = p32

		return ""
	end):gsub(":([^:]*)$", function(p33) -- line: 271
		-- upvalues: p29 (copy)
		p29.port = tonumber(p33)

		return ""
	end)

	if v50 ~= "" and not p29.host then
		p29.host = v50:lower()
	end

	if p29.userinfo then
		p29.user = p29.userinfo:gsub(":([^:]*)$", function(p34) -- line: 280
			-- upvalues: p29 (copy)
			p29.password = p34

			return ""
		end)
	end

	return v50
end
function t1.parse(p35) -- line: 295
	-- upvalues: t1 (copy), concat (copy)
	local t7 = {}

	t1.setAuthority(t7, "")
	t1.setQuery(t7, "")
	t7.path = tostring(p35 or ""):gsub("#(.*)$", function(p36) -- line: 301
		-- upvalues: t7 (copy)
		t7.fragment = p36

		return ""
	end):gsub("^([%w][%w%+%-%.]*)%:", function(p37) -- line: 305
		-- upvalues: t7 (copy)
		t7.scheme = p37:lower()

		return ""
	end):gsub("%?(.*)", function(p38) -- line: 309
		-- upvalues: t1 (copy), t7 (copy)
		t1.setQuery(t7, p38)

		return ""
	end):gsub("^//([^/]*)", function(p39) -- line: 313
		-- upvalues: t1 (copy), t7 (copy)
		t1.setAuthority(t7, p39)

		return ""
	end):gsub("%%(%x%x)", function(p40) -- line: 65
		return (string.char((tonumber(p40, 16))))
	end)
	setmetatable(t7, {
		__index = t1,
		__concat = concat,
		__tostring = t1.build
	})

	return t7
end
function t1.removeDotSegments(p41) -- line: 331
	local t8 = {}

	if string.len(p41) == 0 then
		return ""
	end

	local v55 = false
	local v56 = false

	if string.sub(p41, 1, 1) == "/" then
		v55 = true
	end

	if (string.len(p41) > 1 or v55 == false) and string.sub(p41, -1) == "/" then
		v56 = true
	end

	p41:gsub("[^/]+", function(p42) -- line: 345
		-- upvalues: t8 (copy)
		table.insert(t8, p42)
	end)

	local t9 = {}
	local n1 = 0

	for _, v in ipairs(t8) do
		if v == ".." then
			if n1 > 0 then
				n1 -= 1
			end
		elseif v ~= "." then
			n1 += 1
			t9[n1] = v
		end
	end

	local v61 = (not (#t9 > 0) or not (n1 > 0)) and "" or table.concat(t9, "/", 1, n1)

	if v55 then
		v61 = "/" .. v61
	end

	if v56 then
		v61 ..= "/"
	end

	return v61
end

local function absolutePath(p43, p44) -- line: 375
	if string.sub(p44, 1, 1) == "/" then
		return "/" .. string.gsub(p44, "^[%./]+", "")
	end

	if p44 ~= "" then
		p43 = "/" .. p43:gsub("[^/]*$", "")
	end

	local v64 = (p43 .. p44):gsub("([^/]*%./)", function(p45) -- line: 384
		if p45 ~= "./" then
			return p45
		end

		return ""
	end)
	local v65 = string.gsub(v64, "/%.$", "/")
	local v66 = nil

	while v66 ~= v65 do
		v66 = v65
		v65 = string.gsub(v66, "([^/]*/%.%./)", function(p46) -- line: 391
			if p46 ~= "../../" then
				return ""
			end

			return p46
		end)
	end

	local v67 = string.gsub(v65, "([^/]*/%.%.?)$", function(p47) -- line: 395
		if p47 ~= "../.." then
			return ""
		end

		return p47
	end)
	local v68 = nil

	while v68 ~= v67 do
		v68 = v67
		v67 = string.gsub(v68, "^/?%.%./", "")
	end

	return "/" .. v67
end

function t1.resolve(p48, p49) -- line: 409
	-- upvalues: t1 (copy), absolutePath (copy)
	if type(p48) == "string" then
		p48 = t1.parse(p48)
	end

	if type(p49) == "string" then
		p49 = t1.parse(p49)
	end

	if p49.scheme then
		return p49
	end

	p49.scheme = p48.scheme

	if not p49.authority or p49.authority == "" then
		p49:setAuthority(p48.authority)

		if not p49.path or p49.path == "" then
			p49.path = p48.path

			local query = p49.query

			if not query or not next(query) then
				p49.query = p48.query

				return p49
			end
		else
			p49.path = absolutePath(p48.path, p49.path)
		end
	end

	return p49
end
function t1.normalize(p50) -- line: 439
	-- upvalues: t1 (copy), absolutePath (copy)
	if type(p50) == "string" then
		p50 = t1.parse(p50)
	end

	if p50.path then
		local path = p50.path
		local v74 = absolutePath(path, "")

		p50.path = string.gsub(v74, "//+", "/")
	end

	return p50
end

return t1
