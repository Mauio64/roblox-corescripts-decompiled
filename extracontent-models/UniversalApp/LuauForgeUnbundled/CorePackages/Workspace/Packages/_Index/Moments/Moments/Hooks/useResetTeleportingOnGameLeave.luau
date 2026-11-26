local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local messageBus = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MessageBus").MessageBus

local GetMomentsPreferencesStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore")

local function gameLeaveMessageValidator(p2): boolean
	return typeof(p2) == "table"
end

local function useResetTeleportingOnGameLeave()
	React.useEffect(function()
		local subscriber = messageBus.Subscriber.new()
		local messageId = messageBus.getMessageId("Game", "onGameLeave")
		subscriber:subscribe({
			mid = messageId,
			validateParams = gameLeaveMessageValidator
		}, function(p2)
			GetMomentsPreferencesStore(false).setTeleporting(false)
		end)

		return function()
			subscriber:unsubscribeWithMsgId(messageId)
		end
	end, {})
end

return useResetTeleportingOnGameLeave
