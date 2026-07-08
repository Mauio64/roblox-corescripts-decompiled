local ParentParent = script.Parent.Parent
local lib = ParentParent.lib
local src = ParentParent.src
local ParentParentParent = ParentParent.Parent
local HttpService = game:GetService("HttpService")
local url = require(lib.url)
local Promise = require(ParentParentParent.Promise)
local json = require(src.json)
local response = require(src.response)
local cookies = require(src.cookies)
local ratelimit = require(src.ratelimit)
local util = require(src.util)
local cache = require(src.cache)
local t1 = {}

t1.__index = t1

function t1.new(p1, p2, p3) -- line: 26
	-- upvalues: t1 (copy), url (copy), ratelimit (copy), cookies (copy)
	local self = setmetatable({}, t1)
	local v19 = p3 or {}
	local v20 = url.parse(p2)
	local v21 = v19.headers or {}

	self.method = p1:upper()
	self.url = v20
	self.input_url = p2
	self.headers = v21
	self.query = {}
	self.data = nil
	self._ratelimits = { ratelimit.get("http", 250, 30) }
	self.ignore_ratelimit = v19.ignore_ratelimit or false

	if v19.data then
		self:set_data(v19.data)
	end

	self:set_query(v19.query or {})

	local v22 = v19.cookies or {}

	if not v22.__cookiejar then
		local v23 = cookies.new()

		if v22 then
			for k, v in pairs(v22) do
				v23:insert(k, v)
			end
		end

		v22 = v23
	end

	self.cookies = v22
	self.headers.Cookie = v22:string(p2)
	self._callback = nil
	self._log = v19.log == nil or v19.log

	return self
end
function t1.set_headers(p4, p5) -- line: 87
	for k, v in pairs(p5) do
		p4.headers[k] = v
	end

	return p4
end

t1.update_headers = util.deprecate(t1.set_headers, "0.5", "update_headers")

function t1.set_query(p6, p7) -- line: 98
	for k, v in pairs(p7) do
		p6.query[k] = v
	end

	p6.url:setQuery(p6.query)

	return p6
end

t1.update_query = util.deprecate(t1.set_headers, "0.5", "update_query")

function t1.set_data(p8, p9) -- line: 111
	-- upvalues: json (copy)
	if type(p9) == "table" then
		if p9.__FormData then
			p8.headers["Content-Type"] = p9.content_type
			p9 = p9:build()
		else
			p9 = json.enc(p9)
			p8.headers["Content-Type"] = "application/json"
		end
	end

	p8.data = p9

	return p8
end
function t1._ratelimit(p10) -- line: 129
	for _, v in ipairs(p10._ratelimits) do
		if not v:request() then
			return false
		end
	end

	return true
end
function t1._send(p11) -- line: 141
	-- upvalues: cache (copy), response (copy), HttpService (copy)
	local t2 = {
		Url = p11.url:build(),
		Method = p11.method,
		Headers = p11.headers
	}

	if p11.data ~= nil then
		t2.Body = p11.data
	end

	local v41 = t2.Url:sub(-1, -1) == "/" and t2.Url:sub(1, -2) or t2.Url
	local v42 = ("Request_%s_%s_%s"):format(p11.method, v41, t2.Body or "")

	if p11.method:upper() == "GET" and cache.is_cached(t2.Url, v42) then
		local timestamp = tick()
		local v44, v45 = cache.get_cached(t2.Url, v42)

		if timestamp - v44.timestamp <= cache.get_expire(t2.Url) then
			local v46 = response.new(p11, v44, tick() - timestamp)

			v46.from_cache = true
			print("[http]", v45:upper(), "CACHE |", v46.method, v46.url)

			return v46
		end
	end

	local n1 = 0
	local v48 = false
	local v49 = nil
	local v50 = nil

	while n1 < 5 do
		if p11.ignore_ratelimit or p11:_ratelimit() then
			local timestamp = tick()

			v50 = HttpService:RequestAsync(t2)
			v49 = response.new(p11, v50, tick() - timestamp)
			p11.timestamp = timestamp
			v48 = true

			break
		end

		warn("[http] Rate limit exceeded. Retrying in 5 seconds")
		n1 += 1
		wait(5)
	end

	if not v48 then
		error("[http] Rate limit still exceeded after 5 attempts")
	end

	if p11._log then
		local v52 = tostring(math.floor(p11._ratelimits[#p11._ratelimits]:consumption() * 1000) * 0.1) .. "%"

		print("[http]", v49.code, v49.message, "|", v49.method, v49.url, "(", v52, "ratelimit )")
	end

	if p11._callback then
		p11._callback(v49)
	end

	if p11.method:upper() == "GET" and v49.ok and cache.should_cache(t2.Url) then
		cache.update_cache(t2.Url, v42, v50)
	end

	return v49
end
function t1.send(p12, p13) -- line: 212
	-- upvalues: Promise (copy)
	if p13 then
		return Promise.new(function(resolve, reject) -- line: 218
			-- upvalues: p12 (copy)
			local ok, result = pcall(p12._send, p12)

			if ok and result.ok then
				resolve(result)

				return
			end

			if ok then
				reject({
					request_sent = true,
					response = result
				})

				return
			end

			reject({
				request_sent = false,
				error = result
			})
		end)
	end

	return p12:_send()
end
function t1.promise(p14) -- line: 238
	return p14:send(true)
end

return t1
