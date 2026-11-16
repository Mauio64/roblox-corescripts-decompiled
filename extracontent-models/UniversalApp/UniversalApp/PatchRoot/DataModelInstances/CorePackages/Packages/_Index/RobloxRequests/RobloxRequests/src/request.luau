local parent = script.Parent.Parent
local lib = parent.lib
local src = parent.src
local parent2 = parent.Parent

local HttpService = game:GetService("HttpService")

local url = require(lib.url)
local Promise = require(parent2.Promise)

local json = require(src.json)
local response = require(src.response)
local cookies = require(src.cookies)
local ratelimit = require(src.ratelimit)
local util = require(src.util)

local cache = require(src.cache)

local Request = {}
Request.__index = Request
function Request.new(value, input_url, options)
	local self = setmetatable({}, Request)

	options = options or {}

	local parsed = url.parse(input_url)
	local headers = options.headers or {}

	self.method = value:upper()
	self.url = parsed
	self.input_url = input_url
	self.headers = headers
	self.query = {}
	self.data = nil

	self._ratelimits = { ratelimit.get("http", 250, 30) }

	self.ignore_ratelimit = options.ignore_ratelimit or false

	if options.data then
		self:set_data(options.data)
	end

	self:set_query(options.query or {})

	local cookies2 = options.cookies or {}

	if not cookies2.__cookiejar then
		local v = cookies.new()

		if cookies2 then
			for k, v2 in pairs(cookies2) do
				v:insert(k, v2)
			end
		end

		cookies2 = v
	end

	self.cookies = cookies2
	self.headers.Cookie = cookies2:string(input_url)

	self._callback = nil

	self._log = options.log == nil or options.log

	return self
end

function Request.set_headers(p, items)
	for k, item in pairs(items) do
		p.headers[k] = item
	end

	return p
end

Request.update_headers = util.deprecate(Request.set_headers, "0.5", "update_headers")

function Request:set_query(items)
	for k, item in pairs(items) do
		self.query[k] = item
	end

	self.url:setQuery(self.query)

	return self
end

Request.update_query = util.deprecate(Request.set_headers, "0.5", "update_query")

function Request:set_data(object)
	if type(object) == "table" then
		if object.__FormData then
			self.headers["Content-Type"] = object.content_type
			object = object:build()
		else
			object = json.enc(object)
			self.headers["Content-Type"] = "application/json"
		end
	end

	self.data = object

	return self
end

function Request:_ratelimit(): boolean
	for _, ratelimit2 in ipairs(self._ratelimits) do
		if not ratelimit2:request() then
			return false
		end
	end

	return true
end

function Request:_send()
	local v = { ["Url"] = self.url:build(), Method = self.method, Headers = self.headers }

	if self.data ~= nil then
		v.Body = self.data
	end

	local v2 = v.Url:sub(-1, -1) == "/" and v.Url:sub(1, -2) or v.Url

	local formatted = ("Request_%s_%s_%s"):format(self.method, v2, v.Body or "")

	if self.method:upper() == "GET" and cache.is_cached(v.Url, formatted) then
		local lastTime = tick()
		local get_cached, v3 = cache.get_cached(v.Url, formatted)

		if lastTime - get_cached.timestamp <= cache.get_expire(v.Url) then
			local v4 = response.new(self, get_cached, tick() - lastTime)
			v4.from_cache = true

			print("[http]", v3:upper(), "CACHE |", v4.method, v4.url)
			return v4
		end
	end

	local count = 0
	local v3 = false
	local v4 = nil
	local v5 = nil

	while count < 5 do
		if self.ignore_ratelimit or self:_ratelimit() then
			local lastTime = tick()

			v5 = HttpService:RequestAsync(v)
			v4 = response.new(self, v5, tick() - lastTime)
			self.timestamp = lastTime
			v3 = true
			break
		end

		warn("[http] Rate limit exceeded. Retrying in 5 seconds")

		count += 1
		wait(5)
	end

	if not v3 then
		error("[http] Rate limit still exceeded after 5 attempts")
	end

	if self._log then
		local v6 = tostring(math.floor(self._ratelimits[#self._ratelimits]:consumption() * 1000) * 0.1) .. "%"

		print("[http]", v4.code, v4.message, "|", v4.method, v4.url, "(", v6, "ratelimit )")
	end

	if self._callback then
		self._callback(v4)
	end

	if self.method:upper() == "GET" and v4.ok and cache.should_cache(v.Url) then
		cache.update_cache(v.Url, formatted, v5)
	end

	return v4
end

function Request:send(p)
	if p then
		return Promise.new(function(callback, callback2)
			local success, result = pcall(self._send, self)

			if success and result.ok then
				callback(result)
			elseif success then
				callback2({ request_sent = true, response = result })
			else
				callback2({ request_sent = false, error = result })
			end
		end)
	end

	return self:_send()
end

function Request:promise()
	return self:send(true)
end

return Request
