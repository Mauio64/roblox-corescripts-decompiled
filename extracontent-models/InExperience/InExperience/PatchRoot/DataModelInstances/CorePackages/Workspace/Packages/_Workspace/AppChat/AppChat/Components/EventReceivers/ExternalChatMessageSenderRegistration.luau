local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local GetExternalChatMessageSenderStore = require(AppChat.Stores.GetExternalChatMessageSenderStore)
local useExternalChatMessageSender = require(AppChat.Hooks.useExternalChatMessageSender)

local function ExternalChatMessageSenderRegistration(t1: {[any]: any}) -- line: 13
	-- upvalues: useExternalChatMessageSender (copy), GetExternalChatMessageSenderStore (copy), React (copy)
	local v8 = useExternalChatMessageSender(t1.isInExperience == true)
	local v9 = GetExternalChatMessageSenderStore()

	React.useEffect(function() -- line: 17
		-- upvalues: v9 (copy), v8 (copy)
		v9.setSender(v8)
	end, {
		v8,
		v9
	})
	React.useEffect(function() -- line: 21
		-- upvalues: v9 (copy)
		return v9.clearSender
	end, { v9 })

	return nil
end

return ExternalChatMessageSenderRegistration
