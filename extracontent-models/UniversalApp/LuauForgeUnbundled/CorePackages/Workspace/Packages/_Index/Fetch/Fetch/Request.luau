local instanceof = require("@game/CorePackages/Workspace/Packages/_Workspace/Fetch/LuauPolyfill").instanceof

local headers = require("@game/CorePackages/Workspace/Packages/_Index/Fetch/Fetch/Headers").Headers

local body = require("@game/CorePackages/Workspace/Packages/_Index/Fetch/Fetch/Body").Body

local abortSignal = require("@game/CorePackages/Workspace/Packages/_Index/Fetch/Fetch/AbortSignal").AbortSignal

local object = setmetatable({}, { __index = body })
object.__index = object

function object.new(value, options)
	local v5 = options or {}
	local v6 = nil
	local v7 = nil

	if type(value) == "string" then
		v6 = value
		v7 = {}
	elseif instanceof(value, object) then
		v6 = value.url
		v7 = value
	else
		error("The first argument of Request.new() must be a string or Request object")
	end

	local body2 = if not (v5.body or not instanceof(value, object)) then value.body else nil
	local object2 = setmetatable(body.new(v5.body or body2), object)

	object2.method = v5.method or v7.method or "GET"

	if (v5.body or body2) and (object2.method == "GET" or object2.method == "HEAD") then
		error(string.format(
			"'body' should not be provided as an option for request method %s",
			object2.method
		))
	end

	object2.url = v6
	local v8 = v7.headers or headers.new()

	if v5.headers then
		v8 = headers.new(v5.headers)
	end

	object2.headers = v8
	object2.cache = v5.cache or v7.cache or Enum.HttpCachePolicy.None
	object2.signal = v5.signal or v7.signal or abortSignal.abort("Request Cancelled")

	object2.destination = "document"
	object2.referrer = "client"
	object2.referrerPolicy = "no-referrer"
	object2.mode = v5.mode or "cors"
	object2.credentials = v5.credentials or v7.credentials or "omit"
	object2.redirect = v5.redirect or v7.redirect or "error"
	object2.integrity = v5.integrity or v7.integrity or ""
	object2.keepalive = v5.keepalive or v7.keepalive or false
	object2.isReloadNavigation = false
	object2.isHistoryNavigation = false
	object2.duplex = v5.duplex or v7.duplex or "half"

	return object2
end

function object.clone(p2)
	return object.new(p2)
end

return { Request = object }
