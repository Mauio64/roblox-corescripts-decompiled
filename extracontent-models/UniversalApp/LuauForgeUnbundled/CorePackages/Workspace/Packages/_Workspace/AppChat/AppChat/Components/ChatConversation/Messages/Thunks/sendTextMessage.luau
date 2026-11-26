local SendTextMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/SendTextMessage")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("sendTextMessage")

return function(...)
	v5:info("Sending text message")
	return SendTextMessage(...)
end
