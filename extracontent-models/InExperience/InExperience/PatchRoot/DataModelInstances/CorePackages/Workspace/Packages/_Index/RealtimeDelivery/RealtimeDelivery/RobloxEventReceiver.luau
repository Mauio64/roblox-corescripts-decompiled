local Parent = script:FindFirstAncestor("RealtimeDelivery").Parent
local Signal = require(Parent.AppCommonLib).Signal
local HttpService = game:GetService("HttpService")
local t1 = {}

t1.__index = t1

function t1.observeEvent(p1, p2, p3) -- line: 14
	-- upvalues: Signal (copy)
	assert(type(p2) == "string", "Expected namespace to be a string")
	assert(type(p3) == "function", "Expected callback to be a function")

	local v8 = p1.namespaceTable[p2]

	if v8 == nil then
		v8 = Signal.new()
		p1.namespaceTable[p2] = v8
	end

	return v8:connect(p3)
end
function t1.new(p4) -- line: 27
	-- upvalues: t1 (copy), HttpService (copy)
	local t2 = {
		namespaceTable = {}
	}

	setmetatable(t2, t1)
	t2.connections = {
		p4.RobloxEventReceived:Connect(function(p5) -- line: 34
			-- upvalues: t2 (copy), HttpService (copy)
			local v12 = t2.namespaceTable[p5.namespace]

			if v12 == nil then
				return
			end

			local v15

			if p5.detail and p5.detail ~= "" then
				local ok, result = pcall(function() -- line: 43
					-- upvalues: HttpService (copy), p5 (copy)
					return HttpService:JSONDecode(p5.detail)
				end)

				v15 = ok and result or p5.detail
			else
				v15 = {}
			end

			v12:fire(v15, p5.detailType)
		end),
		p4.RobloxConnectionChanged:Connect(function(p6, p7, p8, p9) -- line: 60
			-- upvalues: t2 (copy), HttpService (copy)
			local v20 = t2.namespaceTable[p6]

			if v20 == nil then
				return
			end

			local v21 = nil

			if p9 then
				local ok, result = pcall(function() -- line: 69
					-- upvalues: HttpService (copy), p9 (copy)
					return HttpService:JSONDecode(p9)
				end)

				v21 = if not ok then {} else result
			end

			v20:fire(p7, p8, v21)
		end)
	}

	return t2
end

return t1
