local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local GetExternalChatMessageSenderStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetExternalChatMessageSenderStore")
local useExternalChatMessageSender = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useExternalChatMessageSender")

local function ExternalChatMessageSenderRegistration(p2): nil
	local v5 = useExternalChatMessageSender(p2.isInExperience == true)
	local v6 = GetExternalChatMessageSenderStore()

	React.useEffect(function()
		v6.setSender(v5)
	end, { v5, v6 })

	React.useEffect(function()
		return v6.clearSender
	end, { v6 })

	return nil
end

return ExternalChatMessageSenderRegistration
