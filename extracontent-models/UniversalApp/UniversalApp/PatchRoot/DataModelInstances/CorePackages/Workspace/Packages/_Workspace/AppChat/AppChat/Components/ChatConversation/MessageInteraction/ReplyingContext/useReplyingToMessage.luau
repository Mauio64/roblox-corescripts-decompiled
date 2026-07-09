local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local ReplyingToMessageContext = require(script.Parent.ReplyingToMessageContext)

local function useReplyingToMessage() -- line: 7
	-- upvalues: React (copy), ReplyingToMessageContext (copy)
	return React.useContext(ReplyingToMessageContext)
end

return useReplyingToMessage
