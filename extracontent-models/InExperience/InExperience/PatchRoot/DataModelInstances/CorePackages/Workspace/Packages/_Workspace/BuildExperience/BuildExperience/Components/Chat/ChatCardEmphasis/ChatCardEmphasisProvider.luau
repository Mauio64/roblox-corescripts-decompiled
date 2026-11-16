local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local ChatCardEmphasisContext = require(script.Parent.ChatCardEmphasisContext)
local createChatCardEmphasisStore = require(script.Parent.createChatCardEmphasisStore)

local function ChatCardEmphasisProvider(p)
	local v = React.useMemo(createChatCardEmphasisStore, {})

	return React.createElement(ChatCardEmphasisContext.Provider, { value = v }, p.children)
end

return ChatCardEmphasisProvider
