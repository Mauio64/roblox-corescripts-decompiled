local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local ReplyingToMessageContext = require(script.Parent.ReplyingToMessageContext)

local function useReplyingToMessage()
	return React.useContext(ReplyingToMessageContext)
end

return useReplyingToMessage
