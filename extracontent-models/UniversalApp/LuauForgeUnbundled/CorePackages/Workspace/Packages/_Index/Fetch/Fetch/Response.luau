require("@game/CorePackages/Workspace/Packages/_Workspace/Fetch/LuauPolyfill")

local headers = require("@game/CorePackages/Workspace/Packages/_Index/Fetch/Fetch/Headers").Headers

local body = require("@game/CorePackages/Workspace/Packages/_Index/Fetch/Fetch/Body").Body

local object = setmetatable({}, { __index = body })
object.__index = object

function object.new(p2, options)
	local v5 = options or {}
	local object2 = setmetatable(body.new(p2), object)

	object2.status = v5.status or 200
	object2.statusText = v5.statusText or ""
	object2.headers = headers.new(v5.headers or {})
	object2.headers.guard = "response"
	object2.type = "text"
	object2.url = ""
	object2.redirected = false
	object2.ok = object2.status >= 200 and object2.status < 300
	return object2
end

function object.error()
	local v5 = object.new(nil, { status = 0 })

	v5.type = "error"
	return v5
end

function object.redirect(p2, p3)
	error("Response.redirect not implemented")
end

function object.STATIC_json(p2, p3)
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
