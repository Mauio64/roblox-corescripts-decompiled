local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local ChatCardEmphasisPositionContext = require(script.Parent.ChatCardEmphasisPositionContext)

local function ChatCardEmphasisPositionProvider(props)
	local v = React.useContext(ChatCardEmphasisPositionContext)
	local v2 = React.useMemo(function()
		return {
			messageOrder = props.messageOrder or not v and 0 or v.messageOrder,
			segmentOrder = props.segmentOrder or not v and 0 or v.segmentOrder,
			childOrder = props.childOrder or 0
		}
	end, { v, props.messageOrder, props.segmentOrder, props.childOrder })

	return React.createElement(ChatCardEmphasisPositionContext.Provider, { value = v2 }, props.children)
end

return ChatCardEmphasisPositionProvider
