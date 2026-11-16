local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local UnreadMessagesDispatchContext = require(script.Parent.UnreadMessagesDispatchContext)

local function UnreadMessagesProvider(p)
	return React.createElement(UnreadMessagesDispatchContext.Provider, { value = p.dispatch }, p.children)
end

return UnreadMessagesProvider
