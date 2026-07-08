local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local UnreadMessagesDispatchContext = require(script.Parent.UnreadMessagesDispatchContext)

local function useUnreadMessagesDispatch() -- line: 7
	-- upvalues: React (copy), UnreadMessagesDispatchContext (copy)
	return React.useContext(UnreadMessagesDispatchContext)
end

return useUnreadMessagesDispatch
