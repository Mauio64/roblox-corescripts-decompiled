local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local ViewRecyclerReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ViewRecyclerReact")

local ConversationMessageSkeletonList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ConversationMessageSkeletonList")
local MessageListContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/MessageListV2/MessageListContext")

local function renderLoading(p2)
	if p2 then
		return React.createElement(ConversationMessageSkeletonList, { size = UDim2.fromScale(1, 1) })
	end

	return nil
end

local function MessageListV2View(props)
	local createElement = React.createElement
	local provider = MessageListContext.Provider
	local v5 = { value = props.contextValue }
	local v7

	if props.isLoading then
		if props.showLoadingSkeleton then
			v7 = React.createElement(ConversationMessageSkeletonList, { size = UDim2.fromScale(1, 1) })
		end
	else
		local createElement2 = React.createElement
		local view = Foundation.View
		local v8 = { Size = UDim2.fromScale(1, 1) }
		local v9 = {
			List = React.createElement(ViewRecyclerReact.VirtualList, props.listProps),
			Loading = 0
		}
		local v10 = if not (props.isListVisible or not props.showLoadingSkeleton) then React.createElement(ConversationMessageSkeletonList, {
			size = UDim2.fromScale(1, 1)
		}) else nil
		v9.Loading = v10
		v7 = createElement2(view, v8, v9)
	end

	return createElement(provider, v5, { Content = v7 })
end

return React.memo(MessageListV2View)
