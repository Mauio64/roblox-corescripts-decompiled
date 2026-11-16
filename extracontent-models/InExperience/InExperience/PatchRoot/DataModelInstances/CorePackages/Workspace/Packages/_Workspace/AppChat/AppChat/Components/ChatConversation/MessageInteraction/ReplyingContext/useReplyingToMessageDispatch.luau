local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local ReplyingToMessageDispatchContext = require(script.Parent.ReplyingToMessageDispatchContext)

local function useReplyingToMessageDispatch()
	return React.useContext(ReplyingToMessageDispatchContext)
end

return useReplyingToMessageDispatch
