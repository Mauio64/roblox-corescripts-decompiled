local lib = script.lib
local src = script.src
local html = require(lib.html)
local request = require(src.request)
local session = require(src.session)
local form = require(src.form)
local ratelimit = require(src.ratelimit)
local util = require(src.util)
local fetch = require(src.fetch)
local t1 = {
	VERSION = "0.5.4",
	Request = request.new,
	Session = session.new,
	FormData = form.FormData.new,
	File = form.File.new,
	cache = require(src.cache),
	request = function(p1, p2, p3) -- line: 32
		-- upvalues: request (copy)
		local v16 = p3 or {}

		return request.new(p1, p2, v16):send()
	end
}

t1.send = util.deprecate(t1.request, "0.5", "http.send")

function t1.promise_request(p4, p5, p6) -- line: 50
	-- upvalues: request (copy)
	local v20 = p6 or {}

	return request.new(p4, p5, v20):send(true)
end

t1.promise_send = util.deprecate(t1.promise_request, "0.5", "http.promise_send")
t1.fetch = fetch(t1.promise_request)

for _, v in pairs({
	"GET",
	"POST",
	"HEAD",
	"OPTIONS",
	"PUT",
	"DELETE",
	"PATCH"
}) do
	t1[v:lower()] = function(p7, p8) -- line: 65
		-- upvalues: t1 (copy), v (copy)
		return t1.request(v, p7, p8)
	end
	t1["promise_" .. v:lower()] = function(p9, p10) -- line: 69
		-- upvalues: t1 (copy), v (copy)
		return t1.promise_request(v, p9, p10)
	end
end

function t1.set_ratelimit(p11, p12) -- line: 74
	-- upvalues: ratelimit (copy)
	local v27 = ratelimit.get("http", p11, p12)

	print("[http] RateLimiter settings changed: ", v27.rate, "reqs /", v27.window_size, "secs")
end
function t1.parse_html(p13, p14) -- line: 81
	-- upvalues: html (copy)
	return html.parse(p13, 100000, p14)
end

t1.parse_xml = t1.parse_html

return t1
