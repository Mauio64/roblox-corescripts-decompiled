local HttpService = game:GetService("HttpService")
local parent = script.Parent.Parent

local Promise = require(parent.Promise)

require(parent.LuauPolyfill)

local class = {}
class.__index = class

function class.new(body: string?)
	local v = {}

	if type(body) == "string" then
		v.body = body
	elseif body == nil then
		v.body = nil
	else
		error(string.format("Expected string or nil as the first argument to Body.new(), but got: %s", (type(body))))
	end

	v.bodyUsed = false
	setmetatable(v, class)
	return v
end

function class.arrayBuffer(_)
	return Promise.new(function(_, callback)
		callback("arrayBuffer not implemented")
	end)
end

function class.blob(_)
	return Promise.new(function(_, callback)
		callback("blob not implemented")
	end)
end

function class.formData(_)
	return Promise.new(function(_, callback)
		callback("formData not implemented")
	end)
end

function class:json()
	return Promise.new(function(callback, callback2)
		if self._json then
			callback(self._json)
			return
		end

		local success, result = pcall(function()
			return HttpService:JSONDecode(self.body)
		end)

		if not success then
			callback2("Failed to decode response body as JSON. JSON decoding is only supported for Content-Type = application/json")
			return
		end

		self._json = result
		callback(result)
	end)
end

function class.text(p)
	return Promise.new(function(callback, _)
		callback(p.body or "")
	end)
end

return { Body = class }
