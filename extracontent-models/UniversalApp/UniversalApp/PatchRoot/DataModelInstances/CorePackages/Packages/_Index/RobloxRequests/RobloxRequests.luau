local lib = script.lib
local src = script.src

local html = require(lib.html)

local request = require(src.request)
local session = require(src.session)
local form = require(src.form)
local ratelimit = require(src.ratelimit)
local util = require(src.util)
local fetch = require(src.fetch)

local RobloxRequests = {}
RobloxRequests.VERSION = "0.5.4"
RobloxRequests.Request = request.new
RobloxRequests.Session = session.new

RobloxRequests.FormData = form.FormData.new
RobloxRequests.File = form.File.new

RobloxRequests.cache = require(src.cache)

function RobloxRequests.request(p, p2, options)
	return request.new(p, p2, options or {}):send()
end

RobloxRequests.send = util.deprecate(RobloxRequests.request, "0.5", "http.send")

function RobloxRequests.promise_request(p, p2, options)
	return request.new(p, p2, options or {}):send(true)
end

RobloxRequests.promise_send = util.deprecate(RobloxRequests.promise_request, "0.5", "http.promise_send")

RobloxRequests.fetch = fetch(RobloxRequests.promise_request)

for _, v in pairs({ "GET", "POST", "HEAD", "OPTIONS", "PUT", "DELETE", "PATCH" }) do
	RobloxRequests[v:lower()] = function(p, p2)
		return RobloxRequests.request(v, p, p2)
	end

	RobloxRequests["promise_" .. v:lower()] = function(p, p2)
		return RobloxRequests.promise_request(v, p, p2)
	end
end

function RobloxRequests.set_ratelimit(p, p2)
	local http = ratelimit.get("http", p, p2)

	print("[http] RateLimiter settings changed: ", http.rate, "reqs /", http.window_size, "secs")
end

function RobloxRequests.parse_html(p, p2)
	return html.parse(p, 100000, p2)
end

RobloxRequests.parse_xml = RobloxRequests.parse_html

return RobloxRequests
