local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local MessageBus = require(parent.MessageBus)
local messageBus = MessageBus.MessageBus

local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)

local function gameLeaveMessageValidator(p): boolean
	return typeof(p) == "table"
end

local function useResetTeleportingOnGameLeave()
	React.useEffect(function()
		local subscriber = messageBus.Subscriber.new()
		local messageId = messageBus.getMessageId("Game", "onGameLeave")
		subscriber:subscribe({ mid = messageId, validateParams = gameLeaveMessageValidator }, function(_)
			GetMomentsPreferencesStore(false).setTeleporting(false)
		end)

		return function()
			subscriber:unsubscribeWithMsgId(messageId)
		end
	end, {})
end

return useResetTeleportingOnGameLeave
