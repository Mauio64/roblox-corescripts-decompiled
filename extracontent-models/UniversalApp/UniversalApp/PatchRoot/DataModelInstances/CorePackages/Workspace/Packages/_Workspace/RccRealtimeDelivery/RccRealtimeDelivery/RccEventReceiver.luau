local Parent = script:FindFirstAncestor("RccRealtimeDelivery").Parent
local AppCommonLib = require(Parent.AppCommonLib)

require(script.Parent.RccRealtimeTypes)

local Signal = AppCommonLib.Signal
local HttpService = game:GetService("HttpService")
local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}) -- line: 62
	-- upvalues: Signal (copy), t1 (copy), HttpService (copy)
	assert(t2, "Expected notificationService to be provided")
	assert(t2.RccEventReceived, "Expected notificationService to have RccEventReceived signal")
	assert(t2.RccConnectionChanged, "Expected notificationService to have RccConnectionChanged signal")
	assert(t2.SubscribeToRccEventNamespace, "Expected notificationService to have SubscribeToRccEventNamespace")

	local t3 = {
		namespaceTable = {},
		notificationService = t2,
		connectionStateSignal = Signal.new(),
		connections = {}
	}

	setmetatable(t3, t1)
	t3.connections = {
		t2.RccEventReceived:Connect(function(t4: {[any]: any}, n1: number) -- line: 84
			-- upvalues: t3 (copy), HttpService (copy)
			local v14 = t3.namespaceTable[t4.namespace]

			if v14 == nil then
				return
			end

			local v17

			if t4.detail and t4.detail ~= "" then
				local ok, result = pcall(function() -- line: 92
					-- upvalues: HttpService (copy), t4 (copy)
					return HttpService:JSONDecode(t4.detail)
				end)

				v17 = if not ok then t4.detail else result
			else
				v17 = {}
			end

			v14:fire(v17, t4.detailType, n1)
		end),
		t2.RccConnectionChanged:Connect(function(s1: string, p1, s2: string, p2) -- line: 111
			-- upvalues: t3 (copy)
			local v22 = t3.namespaceTable[s1]

			if v22 == nil then
				return
			end

			v22:fire(p1, s2, p2)
		end)
	}

	return t3
end
function t1.observeEvent(p3, s3: string, p4: ((...any) -> ...any)) -- line: 130
	-- upvalues: Signal (copy)
	assert(type(s3) == "string", "Expected namespace to be a string")
	assert(type(p4) == "function", "Expected callback to be a function")

	local v11 = p3.namespaceTable[s3]

	if v11 == nil then
		v11 = Signal.new()
		p3.namespaceTable[s3] = v11
		p3.notificationService:SubscribeToRccEventNamespace(s3)
	end

	return v11:connect(p4)
end

return t1
