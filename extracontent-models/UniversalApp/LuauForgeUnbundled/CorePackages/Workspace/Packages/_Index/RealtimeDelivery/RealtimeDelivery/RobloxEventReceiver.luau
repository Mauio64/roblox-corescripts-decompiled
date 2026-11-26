local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/RealtimeDelivery/AppCommonLib").Signal

local HttpService = game:GetService("HttpService")

local class = {}
class.__index = class

function class:observeEvent(value, callback)
	assert(type(value) == "string", "Expected namespace to be a string")
	assert(type(callback) == "function", "Expected callback to be a function")

	local v5 = self.namespaceTable[value]

	if v5 == nil then
		v5 = signal.new()
		self.namespaceTable[value] = v5
	end

	return v5:connect(callback)
end

function class.new(p2)
	local v5 = { namespaceTable = {} }

	setmetatable(v5, class)

	v5.connections = {
		p2.RobloxEventReceived:Connect(function(data)
			local v6 = v5.namespaceTable[data.namespace]

			if v6 == nil then
				return
			end

			local v7

			if data.detail and data.detail ~= "" then
				local success, result = pcall(function()
					return HttpService:JSONDecode(data.detail)
				end)

				v7 = success and result or data.detail
			else
				v7 = {}
			end

			v6:fire(v7, data.detailType)
		end),
		p2.RobloxConnectionChanged:Connect(function(p3, p4, p5, json)
			local v6 = v5.namespaceTable[p3]

			if v6 == nil then
				return
			end

			local v7

			if json then
				local success, result = pcall(function()
					return HttpService:JSONDecode(json)
				end)

				v7 = not success and {} or result
			end

			v6:fire(p4, p5, v7)
		end)
	}

	return v5
end

return class
