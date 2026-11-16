local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ViewRecycler = require(parent.ViewRecycler)

local ConversationMessageSkeletonList = require(AppChat.Components.ChatConversation.ConversationMessageSkeletonList)
local MessageListContext = require(script.Parent.MessageListContext)

local function renderLoading(showLoadingSkeleton: boolean) -- 1 equivalent call inferred from this helper
	if showLoadingSkeleton then
		return React.createElement(ConversationMessageSkeletonList, { size = UDim2.fromScale(1, 1) })
	end

	return nil
end

local function MessageListV2View(props)
	local createElement = React.createElement
	local provider = MessageListContext.Provider
	local v = { value = props.contextValue }
	local content

	if props.isLoading then
		content = renderLoading(props.showLoadingSkeleton) -- inferred equivalent call
	else
		local createElement2 = React.createElement
		local view = Foundation.View
		local v2 = { Size = UDim2.fromScale(1, 1) }
		local v3 = {
			List = React.createElement(ViewRecycler.VirtualList, props.listProps),
			Loading = 0
		}
		local loading

		if not (props.isListVisible or not props.showLoadingSkeleton) then
			loading = React.createElement(ConversationMessageSkeletonList, {
				size = UDim2.fromScale(1, 1)
			})
		end

		v3.Loading = loading
		content = createElement2(view, v2, v3)
	end

	return createElement(provider, v, { Content = content })
end

return React.memo(MessageListV2View)
