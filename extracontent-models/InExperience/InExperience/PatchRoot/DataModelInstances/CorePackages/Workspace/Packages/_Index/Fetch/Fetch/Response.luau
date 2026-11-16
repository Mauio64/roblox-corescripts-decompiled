local parent = script.Parent.Parent

require(parent.LuauPolyfill)

local Headers = require(script.Parent.Headers)
local headers = Headers.Headers

local Body = require(script.Parent.Body)
local body = Body.Body

local object = setmetatable({}, { __index = body })
object.__index = object

function object.new(p, options)
	local v = options or {}
	local self = setmetatable(body.new(p), object)

	self.status = v.status or 200
	self.statusText = v.statusText or ""
	self.headers = headers.new(v.headers or {})
	self.headers.guard = "response"
	self.type = "text"
	self.url = ""
	self.redirected = false
	self.ok = self.status >= 200 and self.status < 300
	return self
end

function object.error()
	local v = object.new(nil, { status = 0 })

	v.type = "error"
	return v
end

function object.redirect(_: string, _: number?)
	error("Response.redirect not implemented")
end

function object.STATIC_json(_, _)
	error("Response.json static method not implemented")
end

function object.clone(data)
	return object.new(data.body, {
		status = data.status,
		statusText = data.statusText,
		headers = data.headers.headerList
	})
end

return { Response = object }
