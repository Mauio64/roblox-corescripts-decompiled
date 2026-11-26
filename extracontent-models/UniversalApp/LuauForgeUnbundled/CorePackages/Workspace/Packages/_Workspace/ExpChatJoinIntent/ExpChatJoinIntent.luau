local module = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatJoinIntent/ExpChatJoinIntent/JoinIntentStore")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatJoinIntent/ExpChatJoinIntent/Flags/FStringOpenChatOnJoinNotificationTypes")

local v5 = nil
local function getDefaultStore()
	local v6 = v5

	if v6 then
		return v6
	end

	local v7 = module.new({ notificationTypes = module2 })
	v5 = v7
	return v7
end

return {
	FStringOpenChatOnJoinNotificationTypes = module2,
	JoinIntentStore = module,
	handleDeeplinkTap = function(self)
		local v6 = v5

		if not v6 then
			v6 = module.new({ notificationTypes = module2 })
			v5 = v6
		end

		v6:handleDeeplinkTap(self)
	end,
	read = function(p2)
		local v6 = v5

		if not v6 then
			v6 = module.new({ notificationTypes = module2 })
			v5 = v6
		end

		return v6:read(p2)
	end,
	getIntent = function()
		local v6 = v5

		if not v6 then
			v6 = module.new({ notificationTypes = module2 })
			v5 = v6
		end

		return v6:getIntent()
	end
}
