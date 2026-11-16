local parent = script:FindFirstAncestor("AppChat").Parent
local React = require(parent.React)

local ReplyingToMessageContext = require(script.Parent.ReplyingToMessageContext)
local ReplyingToMessageDispatchContext = require(script.Parent.ReplyingToMessageDispatchContext)

local function ReplyingToMessageProvider(p)
	local state, setState = React.useState(nil)

	return React.createElement(ReplyingToMessageContext.Provider, { value = state }, {
		ReplyingToMessageDispatch = React.createElement(
			ReplyingToMessageDispatchContext.Provider,
			{ value = setState },
			p.children
		)
	})
end

return ReplyingToMessageProvider
