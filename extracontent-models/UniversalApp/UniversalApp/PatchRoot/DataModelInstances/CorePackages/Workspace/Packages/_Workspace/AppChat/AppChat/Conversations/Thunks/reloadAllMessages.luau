local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)
local reloadMessagesForConversations = require(script.Parent.reloadMessagesForConversations)

local function reloadAllMessages() -- line: 7
	-- upvalues: reloadMessagesForConversations (copy), Cryo (copy)
	return function(p1) -- line: 8
		-- upvalues: reloadMessagesForConversations (copy), Cryo (copy)
		local Conversations = p1:getState().ChatAppReducer.Conversations

		return p1:dispatch(reloadMessagesForConversations(Cryo.Dictionary.keys(Conversations)))
	end
end

return reloadAllMessages
