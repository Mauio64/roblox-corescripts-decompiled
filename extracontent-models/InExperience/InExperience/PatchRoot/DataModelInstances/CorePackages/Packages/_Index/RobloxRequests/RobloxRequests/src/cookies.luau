local ParentParent = script.Parent.Parent
local lib = ParentParent.lib
local src = ParentParent.src
local json = require(src.json)
local url = require(lib.url)

local function maybe_number(p1) -- line: 12
	return tonumber(p1) or p1
end
local function trim(p2) -- line: 20
	local v12 = p2 or ""

	while v12:sub(1, 1) == " " do
		v12 = v12:sub(2)
	end

	while v12:sub(-1, -1) == " " do
		v12 = v12:sub(1, -2)
	end

	return v12
end

local t1 = {}

t1.__index = t1

function t1.new(p3, p4, p5) -- line: 38
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)
	local v17 = p5 or {}

	self.name = p3
	self.value = p4
	self.domain = v17.domain or ""
	self.path = v17.path or ""

	return self
end
function t1.fromSet(p6) -- line: 52
	-- upvalues: trim (copy), t1 (copy)
	local t2 = {}
	local parts = p6:split(";")
	local parts2 = parts[1]:split("=")
	local v22 = trim(parts2[1])
	local v23 = trim(parts2[2])

	for i = 2, #parts do
		local parts3 = parts[i]:split("=")

		t2[trim(parts3[1]):lower()] = trim(parts3[2])
	end

	return t1.new(v22, v23, t2)
end
function t1.matches(p7, p8) -- line: 72
	-- upvalues: url (copy)
	if not p7.domain then
		return true
	end

	local v28 = url.parse(p8)

	if p7.domain:sub(1, 1) == "." then
		if v28.host:sub(-#p7.domain, -1) ~= p7.domain and v28.host ~= p7.domain:sub(2) then
			return false
		end
	elseif v28.host ~= p7.domain then
		return false
	end

	if p7.path then
		local v29 = v28.path:sub(1, #p7.path)

		if p7.path == not v29 then
			return false
		end
	end

	return true
end

local t3 = {}

t3.__index = t3

function t3.new() -- line: 104
	-- upvalues: t3 (copy)
	local self = setmetatable({}, t3)

	self.__cookiejar = true
	self.cookies = {}

	return self
end
function t3.insert(p9, p10, p11, p12) -- line: 114
	-- upvalues: t1 (copy)
	p9.cookies[p10] = t1.new(p10, p11, p12)

	return p9
end
function t3.SetCookie(p13, p14) -- line: 122
	-- upvalues: t1 (copy)
	local v37 = t1.fromSet(p14)

	p13.cookies[v37.name] = v37
end
function t3.delete(p15, p16) -- line: 130
	p15.cookies[p16] = nil
end
function t3.string(p17, _) -- line: 134
	local s1 = ""

	for _, v in pairs(p17.cookies) do
		if s1 then
			s1 ..= "; "
		end

		s1 ..= ("%s=%s"):format(v.name, v.value)
	end

	return s1
end
function t3.__tostring(p19) -- line: 149
	-- upvalues: json (copy)
	return json.enc(p19.domains)
end

return t3
