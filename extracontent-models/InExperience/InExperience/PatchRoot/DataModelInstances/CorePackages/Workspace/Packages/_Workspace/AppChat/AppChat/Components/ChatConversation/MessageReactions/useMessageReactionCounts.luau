local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local GetMessageReactionsViewModelStore = require(AppChat.Stores.GetMessageReactionsViewModelStore)

local function useMessageReactionCounts(p: string)
	local v = React.useMemo(function()
		return GetMessageReactionsViewModelStore(false).getReactionCounts(p)
	end, { p })
	SignalsReact.useSignalState(v)

	return v(false)
end

return useMessageReactionCounts
