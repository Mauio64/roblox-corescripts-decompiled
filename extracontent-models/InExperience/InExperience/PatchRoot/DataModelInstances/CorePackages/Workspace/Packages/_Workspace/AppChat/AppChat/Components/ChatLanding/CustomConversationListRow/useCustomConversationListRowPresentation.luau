local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)

local function useCustomConversationListRowPresentation(t1: {[any]: any}) -- line: 22
	-- upvalues: useChatPagePadding (copy), React (copy)
	local v7 = useChatPagePadding()
	local onActivated = t1.onActivated
	local v9 = React.useCallback(function() -- line: 28
		-- upvalues: onActivated (copy)
		if onActivated ~= nil then
			onActivated()
		end
	end, { onActivated })

	return {
		entryHeight = t1.entryHeight or 64,
		pagePaddingLeft = v7.left,
		pagePaddingRight = v7.right,
		onActivated = v9
	}
end

return useCustomConversationListRowPresentation
