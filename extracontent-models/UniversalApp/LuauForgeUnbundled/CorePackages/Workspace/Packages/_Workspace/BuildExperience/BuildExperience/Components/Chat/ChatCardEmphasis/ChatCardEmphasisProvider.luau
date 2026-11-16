local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local ChatCardEmphasisContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/ChatCardEmphasisContext")
local createChatCardEmphasisStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/createChatCardEmphasisStore")

local function ChatCardEmphasisProvider(p2)
	local v5 = React.useMemo(createChatCardEmphasisStore, {})

	return React.createElement(ChatCardEmphasisContext.Provider, { value = v5 }, p2.children)
end

return ChatCardEmphasisProvider
