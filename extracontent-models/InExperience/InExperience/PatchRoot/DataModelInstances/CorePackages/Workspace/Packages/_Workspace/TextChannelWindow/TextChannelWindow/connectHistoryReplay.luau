local TextChatService = game:GetService("TextChatService")

local function connectHistoryReplay(callback, p)
	local service = p and p.service or TextChatService
	local defer = p and p.defer or function(callback2)
		task.defer(callback2)
	end

	local success, result = pcall(function()
		return service.CoreMessageReceived
	end)

	if not (success and result) then
		return
	end

	local v = {}
	local v2 = false

	local function flush()
		v2 = false
		local v3 = v
		v = {}
		callback(v3)
	end

	result:Connect(function(p2)
		if p2.IsHistorical ~= true or p2.TextSource == nil then
			return
		end

		table.insert(v, p2)

		if not v2 then
			v2 = true
			defer(flush)
		end
	end)

	pcall(function()
		service:ChatIsLoaded()
	end)
end

return connectHistoryReplay
