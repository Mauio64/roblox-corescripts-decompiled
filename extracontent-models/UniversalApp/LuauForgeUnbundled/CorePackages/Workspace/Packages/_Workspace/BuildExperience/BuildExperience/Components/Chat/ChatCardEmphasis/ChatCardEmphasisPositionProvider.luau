local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local ChatCardEmphasisPositionContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/ChatCardEmphasisPositionContext")

local function ChatCardEmphasisPositionProvider(props)
	local v5 = React.useContext(ChatCardEmphasisPositionContext)
	local v6 = React.useMemo(function()
		return {
			messageOrder = props.messageOrder or not v5 and 0 or v5.messageOrder,
			segmentOrder = props.segmentOrder or not v5 and 0 or v5.segmentOrder,
			childOrder = props.childOrder or 0
		}
	end, { v5, props.messageOrder, props.segmentOrder, props.childOrder })

	return React.createElement(ChatCardEmphasisPositionContext.Provider, { value = v6 }, props.children)
end

return ChatCardEmphasisPositionProvider
