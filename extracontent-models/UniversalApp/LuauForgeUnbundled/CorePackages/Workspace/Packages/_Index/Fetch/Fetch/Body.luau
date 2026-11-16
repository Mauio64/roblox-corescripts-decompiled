local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Fetch/Promise")

require("@game/CorePackages/Workspace/Packages/_Workspace/Fetch/LuauPolyfill")

local class = {}
class.__index = class

function class.new(body)
	local v5 = {}

	if type(body) == "string" then
		v5.body = body
	elseif body == nil then
		v5.body = nil
	else
		error(string.format(
			"Expected string or nil as the first argument to Body.new(), but got: %s",
			(type(body))
		))
	end

	v5.bodyUsed = false
	setmetatable(v5, class)
	return v5
end

function class.arrayBuffer(p2)
	return Promise.new(function(p3, callback)
		callback("arrayBuffer not implemented")
	end)
end

function class.blob(p2)
	return Promise.new(function(p3, callback)
		callback("blob not implemented")
	end)
end

function class.formData(p2)
	return Promise.new(function(p3, callback)
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

function class.text(p2)
	return Promise.new(function(callback, p3)
		callback(p2.body or "")
	end)
end

return { Body = class }
