local parent = script:FindFirstAncestor("ExpChat").Parent

local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal
local ExpChatShared = require(parent.ExpChatShared)
local v = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

local function createDictationRateLimit(p)
	local stopRequested = Signal.new()

	return {
		stopRequested = stopRequested,
		onIncomingMessage = function(p2, p3: number?): boolean
			if not p.getIsListening() or p3 == nil or p2.Status ~= Enum.TextChatMessageStatus.Floodchecked then
				return false
			end

			local textSource = p2.TextSource

			if textSource ~= nil and textSource.UserId ~= p3 then
				return false
			end

			local success, result = pcall(function()
				stopRequested:fire()
			end)

			if not success then
				v:error("Failed to stop dictation after a rate limit: {}", (tostring(result)))
			end

			return true
		end,
		getStoppedMessage = function(object)
			local success, result = pcall(function()
				return object:FormatByKey("CoreScripts.TextChat.MessageStatus.Warning.DictationRateLimited")
			end)
			return if success then result else ""
		end
	}
end

return createDictationRateLimit
