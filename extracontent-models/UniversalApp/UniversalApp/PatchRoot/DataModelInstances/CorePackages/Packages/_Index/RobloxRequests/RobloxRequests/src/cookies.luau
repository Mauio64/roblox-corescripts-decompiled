local parent = script.Parent.Parent
local lib = parent.lib
local src = parent.src

local json = require(src.json)
local url = require(lib.url)

local function maybe_number(p)
	return tonumber(p) or p
end

local function trim(value)
	local v = value or ""

	while v:sub(1, 1) == " " do
		v = v:sub(2)
	end

	while v:sub(-1, -1) == " " do
		v = v:sub(1, -2)
	end

	return v
end

local class = {}
class.__index = class
function class.new(name, p, options)
	local self = setmetatable({}, class)

	local v = options or {}

	self.name = name
	self.value = p

	self.domain = v.domain or ""
	self.path = v.path or ""

	return self
end

function class.fromSet(value)
	local parts = value:split(";")

	local parts2 = parts[1]:split("=")
	local v = trim(parts2[1])
	local v2 = trim(parts2[2])
	local v3 = {}

	for i = 2, #parts do
		local parts3 = parts[i]:split("=")
		v3[trim(parts3[1]):lower()] = trim(parts3[2])
	end

	return class.new(v, v2, v3)
end

function class.matches(p, p2): boolean
	if not p.domain then
		return true
	end

	local parsed = url.parse(p2)

	if p.domain:sub(1, 1) == "." then
		if parsed.host:sub(-#p.domain, -1) ~= p.domain and parsed.host ~= p.domain:sub(2) then
			return false
		end
	elseif parsed.host ~= p.domain then
		return false
	end

	return not p.path or not parsed.path:sub(1, #p.path) ~= p.path
end

local Cookies = {}
Cookies.__index = Cookies
function Cookies.new()
	local self = setmetatable({}, Cookies)

	self.__cookiejar = true

	self.cookies = {}

	return self
end

function Cookies.insert(p, p2, p3, p4)
	p.cookies[p2] = class.new(p2, p3, p4)

	return p
end

function Cookies.SetCookie(p, p2)
	local v = class.fromSet(p2)

	p.cookies[v.name] = v
end

function Cookies.delete(p, p2)
	p.cookies[p2] = nil
end

function Cookies.string(p, _)
	local v = ""

	for _, v2 in pairs(p.cookies) do
		v = (v and v .. "; ") .. ("%s=%s"):format(v2.name, v2.value)
	end

	return v
end

function Cookies.__tostring(p)
	return json.enc(p.domains)
end

return Cookies
