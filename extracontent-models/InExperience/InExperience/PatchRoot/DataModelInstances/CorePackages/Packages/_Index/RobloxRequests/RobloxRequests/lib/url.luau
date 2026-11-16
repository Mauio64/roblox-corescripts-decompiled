local Url = {}
Url.version = "0.9.0"
Url.options = { separator = "&" }

Url.services = {
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

local v = {
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

local function decode(value, p)
	if not p then
		value = value:gsub("+", " ")
	end

	return (value:gsub("%%(%x%x)", function(p2)
		return (string.char((tonumber(p2, 16))))
	end))
end

local function encode(value)
	return (value:gsub("([^A-Za-z0-9%_%.%-%~])", function(value2)
		return string.upper(string.format("%%%02x", string.byte(value2)))
	end))
end

local function encodeValue(value)
	return value:gsub("([^A-Za-z0-9%_%.%-%~])", function(value2)
		return string.upper(string.format("%%%02x", string.byte(value2)))
	end):gsub("%%20", "+")
end

local function encodeSegment(value)
	return value:gsub("([^a-zA-Z0-9])", function(value2)
		if v[value2] then
			return value2
		end

		return (value2:gsub("([^A-Za-z0-9%_%.%-%~])", function(value3)
			return string.upper(string.format("%%%02x", string.byte(value3)))
		end))
	end)
end

local function concat(p, object)
	return p .. object:build()
end

function Url:build()
	local v2 = ""

	if self.path then
		local path = self.path
		path:gsub("([^/]+)", function(p)
			return encodeSegment(p)
		end)
		v2 ..= tostring(path)
	end

	if self.query then
		local query = tostring(self.query)

		if query ~= "" then
			v2 ..= "?" .. query
		end
	end

	if self.host then
		local v3 = self.host

		if self.port and self.scheme and Url.services[self.scheme] ~= self.port then
			v3 ..= ":" .. self.port
		end

		local v4

		if self.user and self.user ~= "" then
			v4 = self.user

			if self.password then
				v4 ..= ":" .. self.password
			end
		end

		if v4 and v4 ~= "" then
			v3 = v4 .. "@" .. v3
		end

		if v3 then
			if v2 == "" then
				v2 = "//" .. v3
			else
				v2 = "//" .. v3 .. "/" .. v2:gsub("^/+", "")
			end
		end
	end

	if self.scheme then
		v2 = self.scheme .. ":" .. v2
	end

	if self.fragment then
		return v2 .. "#" .. self.fragment
	end

	return v2
end

function Url.buildQuery(items, p, p2)
	local v2 = p or Url.options.separator or "&"

	local v3 = {}
	local v4 = {}

	for k in pairs(items) do
		v3[#v3 + 1] = k
	end

	table.sort(v3)

	for _, v5 in ipairs(v3) do
		local item = items[v5]

		local function fn(value)
			return string.upper(string.format("%%%02x", string.byte(value)))
		end

		local v6 = tostring(v5):gsub("([^A-Za-z0-9%_%.%-%~])", fn)

		if p2 then
			v6 = string.format("%s[%s]", tostring(p2), (tostring(v6)))
		end

		if type(item) == "table" then
			v4[#v4 + 1] = Url.buildQuery(item, v2, v6)
		else
			local v7 = tostring(item):gsub("([^A-Za-z0-9%_%.%-%~])", fn):gsub("%%20", "+")

			if v7 == "" then
				v4[#v4 + 1] = v6
			else
				v4[#v4 + 1] = string.format("%s=%s", v6, v7)
			end
		end
	end

	return table.concat(v4, v2)
end

function Url.parseQuery(value, p)
	local v2 = p or Url.options.separator or "&"

	local query = {}

	for k, v3 in value:gmatch(string.format("([^%q=]+)(=*[^%q=]*)", v2, v2)) do
		local v4 = {}

		local function fn(p2)
			return (string.char((tonumber(p2, 16))))
		end

		local v5 = k:gsub("+", " "):gsub("%%(%x%x)", fn):gsub("%[([^%]]*)%]", function(value2): string
			local v5

			if string.find(value2, "^-?%d+$") then
				v5 = tonumber(value2)
			else
				v5 = value2:gsub("+", " "):gsub("%%(%x%x)", function(p2)
					return (string.char((tonumber(p2, 16))))
				end)
			end

			table.insert(v4, v5)
			return "="
		end):gsub("=+.*$", ""):gsub("%s", "_")
		local v6 = v3:gsub("^=+", "")

		if not query[v5] then
			query[v5] = {}
		end

		if #v4 > 0 and type(query[v5]) ~= "table" then
			query[v5] = {}
		elseif #v4 == 0 and type(query[v5]) == "table" then
			query[v5] = v6:gsub("+", " "):gsub("%%(%x%x)", fn)
		end

		local v7 = query[v5]

		for i, v8 in ipairs(v4) do
			local v9 = type(v7) ~= "table" and {} or v7

			if v8 == "" then
				v8 = #v9 + 1
			end

			if not v9[v8] then
				v9[v8] = {}
			end

			if i == #v4 then
				v9[v8] = v6:gsub("+", " "):gsub("%%(%x%x)", fn)
			end

			v7 = v9[v8]
		end
	end

	setmetatable(query, { __tostring = Url.buildQuery })
	return query
end

function Url:setQuery(p)
	if type(p) == "table" then
		p = Url.buildQuery(p)
	end

	self.query = Url.parseQuery(p)
	return p
end

function Url:setAuthority(authority)
	self.authority = authority
	self.port = nil
	self.host = nil
	self.userinfo = nil
	self.user = nil
	self.password = nil

	local v2 = authority:gsub("^([^@]*)@", function(userinfo): string
		self.userinfo = userinfo
		return ""
	end):gsub("^%[[^%]]+%]", function(host): string
		self.host = host
		return ""
	end):gsub(":([^:]*)$", function(p): string
		self.port = tonumber(p)
		return ""
	end)

	if v2 ~= "" and not self.host then
		self.host = v2:lower()
	end

	if self.userinfo then
		self.user = self.userinfo:gsub(":([^:]*)$", function(password): string
			self.password = password
			return ""
		end)
	end

	return v2
end

function Url.parse(value)
	local v2 = {}
	Url.setAuthority(v2, "")
	Url.setQuery(v2, "")
	v2.path = tostring(value or ""):gsub("#(.*)$", function(fragment): string
		v2.fragment = fragment
		return ""
	end):gsub("^([%w][%w%+%-%.]*)%:", function(value2): string
		v2.scheme = value2:lower()
		return ""
	end):gsub("%?(.*)", function(p): string
		Url.setQuery(v2, p)
		return ""
	end):gsub("^//([^/]*)", function(p): string
		Url.setAuthority(v2, p)
		return ""
	end):gsub("%%(%x%x)", function(p)
		return (string.char((tonumber(p, 16))))
	end)

	setmetatable(v2, { __index = Url, __concat = concat, __tostring = Url.build })

	return v2
end

function Url.removeDotSegments(value)
	local v2 = {}

	if string.len(value) == 0 then
		return ""
	end

	local v3 = false
	local v4 = string.sub(value, 1, 1) == "/"

	v3 = (string.len(value) > 1 or v4 == false) and string.sub(value, -1) == "/" or false

	value:gsub("[^/]+", function(p)
		table.insert(v2, p)
	end)
	local v5 = 0
	local v6 = {}

	for _, v7 in ipairs(v2) do
		if v7 == ".." then
			if v5 > 0 then
				v5 -= 1
			end
		elseif v7 ~= "." then
			v5 += 1
			v6[v5] = v7
		end
	end

	local v7 = not (#v6 > 0 and v5 > 0) and "" or table.concat(v6, "/", 1, v5)

	if v4 then
		v7 = "/" .. v7
	end

	if v3 then
		return v7 .. "/"
	end

	return v7
end

local function absolutePath(path, value)
	if (string.sub)(value, 1, 1) == "/" then
		return "/" .. string.gsub(value, "^[%./]+", "")
	end

	if value ~= "" then
		path = "/" .. path:gsub("[^/]*$", "")
	end

	local v2 = (path .. value):gsub("([^/]*%./)", function(p)
		return if p == "./" then "" else p
	end)

	local v3 = string.gsub(v2, "/%.$", "/")
	local v4 = nil

	while v4 ~= v3 do
		v4 = v3
		v3 = string.gsub(v3, "([^/]*/%.%./)", function(p): string
			return if p == "../../" then "../../" else ""
		end)
	end

	local v5 = string.gsub(v3, "([^/]*/%.%.?)$", function(p): string
		return if p == "../.." then "../.." else ""
	end)
	local v6 = nil

	while v6 ~= v5 do
		v6 = v5
		v5 = string.gsub(v5, "^/?%.%./", "")
	end

	return "/" .. v5
end

function Url.resolve(value, value2)
	if type(value) == "string" then
		value = Url.parse(value)
	end

	if type(value2) == "string" then
		value2 = Url.parse(value2)
	end

	if value2.scheme then
		return value2
	end

	value2.scheme = value.scheme

	if value2.authority and value2.authority ~= "" then
		return value2
	end

	value2:setAuthority(value.authority)

	if value2.path and value2.path ~= "" then
		value2.path = absolutePath(value.path, value2.path)
	else
		value2.path = value.path
		local query = value2.query

		if not (query and next(query)) then
			value2.query = value.query
			return value2
		end
	end

	return value2
end

function Url.normalize(value)
	if type(value) == "string" then
		value = Url.parse(value)
	end

	if value.path then
		local v2 = absolutePath(value.path, "")

		value.path = string.gsub(v2, "//+", "/")
	end

	return value
end

return Url
