local parent = script.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local instanceof = LuauPolyfill.instanceof

local Headers = require(script.Parent.Headers)
local headers = Headers.Headers

local Body = require(script.Parent.Body)
local body = Body.Body

local AbortSignal = require(script.Parent.AbortSignal)
local abortSignal = AbortSignal.AbortSignal

local object = setmetatable({}, { __index = body })
object.__index = object

function object.new(value, options)
	local v = options or {}
	local url = nil
	local v2 = nil

	if type(value) == "string" then
		url = value
		v2 = {}
	elseif instanceof(value, object) then
		url = value.url
		v2 = value
	else
		error("The first argument of Request.new() must be a string or Request object")
	end

	local body2

	if not (v.body or not instanceof(value, object)) then
		body2 = value.body
	end

	local object2 = setmetatable(body.new(v.body or body2), object)

	object2.method = v.method or v2.method or "GET"

	if (v.body or body2) and (object2.method == "GET" or object2.method == "HEAD") then
		error(string.format("'body' should not be provided as an option for request method %s", object2.method))
	end

	object2.url = url
	local headers2 = v2.headers or headers.new()

	if v.headers then
		headers2 = headers.new(v.headers)
	end

	object2.headers = headers2
	object2.cache = v.cache or v2.cache or Enum.HttpCachePolicy.None
	object2.signal = v.signal or v2.signal or abortSignal.abort("Request Cancelled")

	object2.destination = "document"
	object2.referrer = "client"
	object2.referrerPolicy = "no-referrer"
	object2.mode = v.mode or "cors"
	object2.credentials = v.credentials or v2.credentials or "omit"
	object2.redirect = v.redirect or v2.redirect or "error"
	object2.integrity = v.integrity or v2.integrity or ""
	object2.keepalive = v.keepalive or v2.keepalive or false
	object2.isReloadNavigation = false
	object2.isHistoryNavigation = false
	object2.duplex = v.duplex or v2.duplex or "half"

	return object2
end

function object.clone(p)
	return object.new(p)
end

return { Request = object }
