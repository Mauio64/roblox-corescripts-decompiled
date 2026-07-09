local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local ReplyingToMessageContext = require(script.Parent.ReplyingToMessageContext)
local ReplyingToMessageDispatchContext = require(script.Parent.ReplyingToMessageDispatchContext)

local function ReplyingToMessageProvider(t1: {[any]: any}) -- line: 13
	-- upvalues: React (copy), ReplyingToMessageContext (copy), ReplyingToMessageDispatchContext (copy)
	local v7, v8 = React.useState(nil)

	return React.createElement(ReplyingToMessageContext.Provider, {
		value = v7
	}, {
		ReplyingToMessageDispatch = React.createElement(ReplyingToMessageDispatchContext.Provider, {
			value = v8
		}, t1.children)
	})
end

return ReplyingToMessageProvider
