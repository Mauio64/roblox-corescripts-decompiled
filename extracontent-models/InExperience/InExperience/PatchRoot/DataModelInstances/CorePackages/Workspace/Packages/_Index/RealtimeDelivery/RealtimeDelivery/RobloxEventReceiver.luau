local parent = script:FindFirstAncestor("RealtimeDelivery").Parent

local AppCommonLib = require(parent.AppCommonLib)

local Signal = AppCommonLib.Signal

local HttpService = game:GetService("HttpService")

local RobloxEventReceiver = {}
RobloxEventReceiver.__index = RobloxEventReceiver

function RobloxEventReceiver.observeEvent(p, value, callback)
	assert(type(value) == "string", "Expected namespace to be a string")
	assert(type(callback) == "function", "Expected callback to be a function")

	local v = p.namespaceTable[value]

	if v == nil then
		v = Signal.new()
		p.namespaceTable[value] = v
	end

	return v:connect(callback)
end

function RobloxEventReceiver.new(p)
	local v = { namespaceTable = {} }

	setmetatable(v, RobloxEventReceiver)

	v.connections = {
		p.RobloxEventReceived:Connect(function(data)
			local v2 = v.namespaceTable[data.namespace]

			if v2 == nil then
				return
			end

			local v3

			if data.detail and data.detail ~= "" then
				local success, result = pcall(function()
					return HttpService:JSONDecode(data.detail)
				end)

				v3 = success and result or data.detail
			else
				v3 = {}
			end

			v2:fire(v3, data.detailType)
		end),
		p.RobloxConnectionChanged:Connect(function(p2, p3, p4, json)
			local v2 = v.namespaceTable[p2]

			if v2 == nil then
				return
			end

			local v3

			if json then
				local success, result = pcall(function()
					return HttpService:JSONDecode(json)
				end)

				v3 = not success and {} or result
			end

			v2:fire(p3, p4, v3)
		end)
	}

	return v
end

return RobloxEventReceiver
