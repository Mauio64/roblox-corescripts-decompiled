local ParentParent = script.Parent.Parent
local _ = ParentParent.lib
local src = ParentParent.src
local request = require(src.request)
local cookies = require(src.cookies)
local ratelimit = require(src.ratelimit)
local util = require(src.util)

local function randomString(p1) -- line: 15
	local s1 = ""

	for _ = 1, p1 do
		s1 ..= string.char(math.random(97, 122))
	end

	return s1
end

local t1 = {}

t1.__index = t1

function t1.new(p2) -- line: 28
	-- upvalues: t1 (copy), cookies (copy)
	local self = setmetatable({}, t1)

	self.headers = {}
	self.cookies = cookies.new()
	self.base_url = p2 or ""
	self._ratelimit = nil
	self.ignore_ratelimit = false
	self.before_request = nil
	self.after_request = nil
	self.no_stats = false
	self.log = true

	return self
end
function t1.set_ratelimit(p3, p4, p5) -- line: 52
	-- upvalues: ratelimit (copy), randomString (copy)
	if not p4 then
		p3:disable_ratelimit()
	end

	local v20 = p5 or 60

	if p3._ratelimit then
		ratelimit.ratelimit[p3._ratelimit.id] = nil
	end

	local v21 = "http.session-" .. randomString(12)

	p3._ratelimit = ratelimit.get(v21, p4, v20)
end
function t1.disable_ratelimit(p6) -- line: 70
	-- upvalues: ratelimit (copy)
	if p6._ratelimit then
		ratelimit.ratelimit[p6._ratelimit.id] = nil
		p6._ratelimit = nil
	end
end
function t1.set_headers(p7, p8) -- line: 79
	for k, v in pairs(p8) do
		p7.headers[k] = v
	end

	return p7
end
function t1.Request(p9, p10, p11, p12) -- line: 89
	-- upvalues: request (copy)
	local v31 = p12 or {}

	if p11:sub(1, 7) ~= "http://" and p11:sub(1, 8) ~= "https://" then
		p11 = p9.base_url .. p11
	end

	local log = p9.log

	if v31.log ~= nil then
		log = v31.log
	end

	local v33 = request.new(p10, p11, {
		headers = p9.headers,
		query = v31.query,
		data = v31.data,
		log = log,
		cookies = v31.cookies or p9.cookies,
		ignore_ratelimit = v31.ignore_ratelimit or p9.ignore_ratelimit,
		no_stats = p9.no_stats or false
	})

	if p9._ratelimit then
		table.insert(v33._ratelimits, p9._ratelimit)
	end

	v33:set_headers(v31.headers or {})

	function v33._callback(p13) -- line: 122
		-- upvalues: p9 (copy)
		for _, v in ipairs(p13.cookies.cookies) do
			table.insert(p9.cookies.cookies, v)
		end
	end

	return v33
end
function t1.request(p14, p15, p16, p17) -- line: 131
	return p14:Request(p15, p16, p17 or {}):send()
end

t1.send = util.deprecate(t1.request, "0.5", "Session:send")

function t1.promise_request(p18, p19, p20, p21) -- line: 149
	return p18:Request(p19, p20, p21 or {}):send(true)
end

t1.promise_send = util.deprecate(t1.promise_request, "0.5", "Session:promise_send")

for _, v in pairs({
	"GET",
	"POST",
	"HEAD",
	"OPTIONS",
	"PUT",
	"DELETE",
	"PATCH"
}) do
	t1[v:lower()] = function(p22, p23, p24) -- line: 161
		-- upvalues: v (copy)
		return p22:send(v, p23, p24)
	end
	t1["promise_" .. v:lower()] = function(p25, p26, p27) -- line: 165
		-- upvalues: v (copy)
		return p25:promise_send(v, p26, p27)
	end
end

return t1
