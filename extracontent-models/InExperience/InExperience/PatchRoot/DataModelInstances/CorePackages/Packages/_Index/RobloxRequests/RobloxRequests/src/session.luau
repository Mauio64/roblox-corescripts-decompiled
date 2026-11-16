local parent = script.Parent.Parent
local lib = parent.lib
local src = parent.src

local request = require(src.request)
local cookies = require(src.cookies)
local ratelimit = require(src.ratelimit)
local util = require(src.util)

local function randomString(p)
	local v = ""

	for _ = 1, p do
		v ..= string.char(math.random(97, 122))
	end

	return v
end

local Session = {}
Session.__index = Session
function Session.new(value)
	local self = setmetatable({}, Session)

	self.headers = {}
	self.cookies = cookies.new()

	self.base_url = value or ""

	self._ratelimit = nil
	self.ignore_ratelimit = false

	self.before_request = nil
	self.after_request = nil

	self.no_stats = false

	self.log = true

	return self
end

function Session:set_ratelimit(p, value)
	if not p then
		self:disable_ratelimit()
	end

	if self._ratelimit then
		ratelimit.ratelimit[self._ratelimit.id] = nil
	end

	local v = "http.session-" .. randomString(12)

	self._ratelimit = ratelimit.get(v, p, value or 60)
end

function Session:disable_ratelimit()
	if self._ratelimit then
		ratelimit.ratelimit[self._ratelimit.id] = nil
		self._ratelimit = nil
	end
end

function Session:set_headers(items)
	for k, item in pairs(items) do
		self.headers[k] = item
	end

	return self
end

function Session:Request(p, value, options)
	local v = options or {}

	if value:sub(1, 7) ~= "http://" and value:sub(1, 8) ~= "https://" then
		value = self.base_url .. value
	end

	local log = self.log

	if v.log ~= nil then
		log = v.log
	end

	local v2 = request.new(p, value, {
		headers = self.headers,
		query = v.query,
		data = v.data,
		log = log,
		cookies = v.cookies or self.cookies,
		ignore_ratelimit = v.ignore_ratelimit or self.ignore_ratelimit,
		no_stats = self.no_stats or false
	})

	if self._ratelimit then
		table.insert(v2._ratelimits, self._ratelimit)
	end

	v2:set_headers(v.headers or {})

	function v2._callback(p2)
		for _, v3 in ipairs(p2.cookies.cookies) do
			table.insert(self.cookies.cookies, v3)
		end
	end

	return v2
end

function Session:request(p, p2, options)
	return self:Request(p, p2, options or {}):send()
end

Session.send = util.deprecate(Session.request, "0.5", "Session:send")

function Session:promise_request(p, p2, options)
	return self:Request(p, p2, options or {}):send(true)
end

Session.promise_send = util.deprecate(Session.promise_request, "0.5", "Session:promise_send")

for _, v in pairs({ "GET", "POST", "HEAD", "OPTIONS", "PUT", "DELETE", "PATCH" }) do
	Session[v:lower()] = function(object, p, p2)
		return object:send(v, p, p2)
	end

	Session["promise_" .. v:lower()] = function(object, p, p2)
		return object:promise_send(v, p, p2)
	end
end

return Session
