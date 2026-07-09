local ParentParent = script.Parent.Parent

require(ParentParent.LuauPolyfill)

local Headers = require(script.Parent.Headers).Headers
local Body = require(script.Parent.Body).Body
local self = setmetatable({}, {
	__index = Body
})

self.__index = self

function self.new(p1, t1: {[any]: any}?) -- line: 44
	-- upvalues: Body (copy), self (copy), Headers (copy)
	local v7 = t1 or {}
	local v8 = setmetatable(Body.new(p1), self)

	v8.status = v7.status or 200
	v8.statusText = v7.statusText or ""
	v8.headers = Headers.new(v7.headers or {})
	v8.headers.guard = "response"
	v8.type = "text"
	v8.url = ""
	v8.redirected = false
	v8.ok = v8.status >= 200 and v8.status < 300

	return v8
end
function self.error() -- line: 59
	-- upvalues: self (copy)
	local v9 = self.new(nil, {
		status = 0
	})

	v9.type = "error"

	return v9
end
function self.redirect(_: string, _: number?) -- line: 67
	error("Response.redirect not implemented")
end
function self.STATIC_json(_, _: {[any]: any}) -- line: 75
	error("Response.json static method not implemented")
end
function self.clone(p3) -- line: 79
	-- upvalues: self (copy)
	return self.new(p3.body, {
		status = p3.status,
		statusText = p3.statusText,
		headers = p3.headers.headerList
	})
end

return {
	Response = self
}
