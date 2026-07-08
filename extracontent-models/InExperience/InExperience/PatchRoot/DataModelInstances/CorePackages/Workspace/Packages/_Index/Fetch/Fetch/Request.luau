local ParentParent = script.Parent.Parent
local instanceof = require(ParentParent.LuauPolyfill).instanceof
local Headers = require(script.Parent.Headers).Headers
local Body = require(script.Parent.Body).Body
local AbortSignal = require(script.Parent.AbortSignal).AbortSignal
local self = setmetatable({}, {
	__index = Body
})

self.__index = self

function self.new(p1, t1: {[any]: any}?) -- line: 92
	-- upvalues: instanceof (copy), self (copy), Body (copy), Headers (copy), AbortSignal (copy)
	local v9 = t1 or {}
	local v10 = nil
	local t2 = nil

	if type(p1) == "string" then
		v10 = p1
		t2 = {}
	elseif instanceof(p1, self) then
		v10 = p1.url
		t2 = p1
	else
		error("The first argument of Request.new() must be a string or Request object")
	end

	local v12 = if v9.body or not instanceof(p1, self) then nil else p1.body
	local v13 = setmetatable(Body.new(v9.body or v12), self)

	v13.method = v9.method or (t2.method or "GET")

	if (v9.body or v12) and (v13.method == "GET" or v13.method == "HEAD") then
		error(string.format("'body' should not be provided as an option for request method %s", v13.method))
	end

	v13.url = v10

	local v14 = t2.headers or Headers.new()

	v13.headers = if not v9.headers then v14 else Headers.new(v9.headers)
	v13.cache = v9.cache or (t2.cache or Enum.HttpCachePolicy.None)
	v13.signal = v9.signal or (t2.signal or AbortSignal.abort("Request Cancelled"))
	v13.destination = "document"
	v13.referrer = "client"
	v13.referrerPolicy = "no-referrer"
	v13.mode = v9.mode or "cors"
	v13.credentials = v9.credentials or (t2.credentials or "omit")
	v13.redirect = v9.redirect or (t2.redirect or "error")
	v13.integrity = v9.integrity or (t2.integrity or "")
	v13.keepalive = v9.keepalive or (t2.keepalive or false)
	v13.isReloadNavigation = false
	v13.isHistoryNavigation = false
	v13.duplex = v9.duplex or (t2.duplex or "half")

	return v13
end
function self.clone(p2) -- line: 137
	-- upvalues: self (copy)
	return self.new(p2)
end

return {
	Request = self
}
