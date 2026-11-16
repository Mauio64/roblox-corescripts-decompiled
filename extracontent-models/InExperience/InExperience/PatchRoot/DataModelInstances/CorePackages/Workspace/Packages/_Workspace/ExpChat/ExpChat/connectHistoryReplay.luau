local TextChatService = game:GetService("TextChatService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local isHistoricalMessage = require(ExpChat.isHistoricalMessage)

local function connectCoreMessageReceived(service, fn): boolean -- 1 equivalent call inferred from this helper
	local success, result = pcall(function()
		return service.CoreMessageReceived
	end)

	if success and result then
		result:Connect(fn)
		return true
	end

	return false
end

local function connectHistoryReplay(callback, p)
	local service = p and p.service or TextChatService
	local defer = p and p.defer or function(callback2)
		task.defer(callback2)
	end

	local v = {}
	local v2 = false

	local function flush()
		v2 = false
		local v3 = v
		v = {}
		callback(v3)
	end

	local function fn(p2)
		if not isHistoricalMessage(p2) or p2.TextSource == nil then
			return
		end

		table.insert(v, p2)

		if not v2 then
			v2 = true
			defer(flush)
		end
	end

	if connectCoreMessageReceived(service, fn) then -- inferred equivalent call
		pcall(function()
			service:ChatIsLoaded()
		end)
	end
end

return connectHistoryReplay
