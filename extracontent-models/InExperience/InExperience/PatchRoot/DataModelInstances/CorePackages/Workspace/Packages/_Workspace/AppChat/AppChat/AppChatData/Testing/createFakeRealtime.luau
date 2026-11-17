local HttpService = game:GetService("HttpService")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RealtimeDelivery = require(parent.RealtimeDelivery)
local RobloxEventReceiver = RealtimeDelivery.RobloxEventReceiver

local createRealtimePort = require(AppChat.AppChatData.Ports.createRealtimePort)

local function createEngineSignal()
	local v = {}
	return {
		Connect = function(_, callback)
			table.insert(v, callback)
			return {
				Disconnect = function()
					local index = table.find(v, callback)

					if index ~= nil then
						table.remove(v, index)
					end
				end
			}
		end,
		Fire = function(self, ...)
			for _, v2 in table.clone(v) do
				v2(...)
			end
		end
	}
end

local function createFakeRealtime()
	local v = {
		RobloxEventReceived = createEngineSignal(),
		RobloxConnectionChanged = createEngineSignal()
	}

	local function push(namespace: string, p)
		v.RobloxEventReceived:Fire({ namespace = namespace, detail = HttpService:JSONEncode(p) })
	end

	return {
		port = createRealtimePort(function()
			return RobloxEventReceiver.new(v)
		end),
		push = push
	}
end

return createFakeRealtime
