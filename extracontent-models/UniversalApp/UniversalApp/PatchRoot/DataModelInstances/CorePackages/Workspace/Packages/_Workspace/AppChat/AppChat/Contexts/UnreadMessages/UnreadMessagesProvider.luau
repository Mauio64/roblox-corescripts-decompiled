local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local UnreadMessagesDispatchContext = require(script.Parent.UnreadMessagesDispatchContext)

local function UnreadMessagesProvider(t1: {[any]: any}) -- line: 11
	-- upvalues: React (copy), UnreadMessagesDispatchContext (copy)
	return React.createElement(UnreadMessagesDispatchContext.Provider, {
		value = t1.dispatch
	}, t1.children)
end

return UnreadMessagesProvider
