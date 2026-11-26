local module = require("@luauforge/bundled/ipm")
local messageBus = require("@luauforge/bundled/ipn").MessageBus

local defineFastInt = game:DefineFastInt("AXAvatarUpdateOnGameLeaveDelay", 0)

local function gameLeaveMessageValidator(p2): boolean
	return typeof(p2) == "table"
end

local function useAvatarUpdateOnGameLeave(callback)
	module.useEffect(function()
		local subscriber = messageBus.Subscriber.new()
		local messageId = messageBus.getMessageId("Game", "onGameLeave")
		local thread = nil

		subscriber:subscribe({
			mid = messageId,
			validateParams = gameLeaveMessageValidator
		}, function(p2)
			thread = task.delay(defineFastInt / 1000, function()
				callback()
			end)
		end)

		return function()
			subscriber:unsubscribeWithMsgId(messageId)

			if thread then
				task.cancel(thread)
			end
		end
	end, { callback })
end

return useAvatarUpdateOnGameLeave
