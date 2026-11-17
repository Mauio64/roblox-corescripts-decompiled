local JoinIntentStore = require(script.JoinIntentStore)
local FStringOpenChatOnJoinNotificationTypes = require(script.Flags.FStringOpenChatOnJoinNotificationTypes)

local v = nil
local function getDefaultStore()
	local v2 = v

	if v2 then
		return v2
	end

	local v3 = JoinIntentStore.new({ notificationTypes = FStringOpenChatOnJoinNotificationTypes })
	v = v3
	return v3
end

return {
	["jest.config"] = script["jest.config"],
	FStringOpenChatOnJoinNotificationTypes = FStringOpenChatOnJoinNotificationTypes,
	JoinIntentStore = JoinIntentStore,
	handleDeeplinkTap = function(self)
		local v2 = v

		if not v2 then
			v2 = JoinIntentStore.new({ notificationTypes = FStringOpenChatOnJoinNotificationTypes })
			v = v2
		end

		v2:handleDeeplinkTap(self)
	end,
	read = function(self: number)
		local v2 = v

		if not v2 then
			v2 = JoinIntentStore.new({ notificationTypes = FStringOpenChatOnJoinNotificationTypes })
			v = v2
		end

		return v2:read(self)
	end,
	getIntent = function()
		local v2 = v

		if not v2 then
			v2 = JoinIntentStore.new({ notificationTypes = FStringOpenChatOnJoinNotificationTypes })
			v = v2
		end

		return v2:getIntent()
	end
}
