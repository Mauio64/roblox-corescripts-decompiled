local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local ReplyingToMessageDispatchContext = require(script.Parent.ReplyingToMessageDispatchContext)

local function useReplyingToMessageDispatch() -- line: 7
	-- upvalues: React (copy), ReplyingToMessageDispatchContext (copy)
	return React.useContext(ReplyingToMessageDispatchContext)
end

return useReplyingToMessageDispatch
