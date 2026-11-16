local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)

local ConversationHeaderFadeLayout = require(script.Parent.ConversationHeaderFadeLayout)
local getMessageFadeSequence = require(script.Parent.getMessageFadeSequence)

local function useConversationHeaderFadeLayout(p)
	local transparencyValue = p.transparencyValue
	local conversationId = p.conversationId

	local headerHeight, v = React.useBinding(0)
	local v2, v3 = React.useBinding(0)
	local viewportHeight, v4 = React.useBinding(0)

	local onHeaderAbsoluteSizeChanged = React.useCallback(function(p2)
		v(p2.AbsoluteSize.Y)
	end, {})
	local onMessageViewportAbsoluteSizeChanged = React.useCallback(function(p2)
		v4(p2.AbsoluteSize.Y)
	end, {})
	local onMessageCanvasPositionChanged = React.useCallback(function(vector2: Vector2, max: number)
		v3((math.clamp(vector2.Y, 0, max)))
	end, {})

	local headerLayoutPadding = React.useMemo(function()
		return ConversationHeaderFadeLayout.getHeaderOverlapPadding(headerHeight)
	end, { headerHeight })
	local headerVisibleHeight = React.useMemo(function()
		return ConversationHeaderFadeLayout.getHeaderVisibleHeight(headerHeight, transparencyValue)
	end, { headerHeight, transparencyValue })
	local contentTopPadding = React.useMemo(function()
		return ConversationHeaderFadeLayout.getContentTopPadding(headerHeight, headerVisibleHeight, v2)
	end, { headerHeight, headerVisibleHeight, v2 })
	local messageFadeSequence = React.useMemo(function()
		return React.joinBindings({
			headerHeight = headerHeight,
			headerVisibleHeight = headerVisibleHeight,
			viewportHeight = viewportHeight
		}):map(function(data)
			local v5 = not (data.headerHeight > 0) and 0 or data.headerVisibleHeight / data.headerHeight

			return getMessageFadeSequence(data.headerHeight, data.viewportHeight, v5)
		end)
	end, { headerHeight, headerVisibleHeight, viewportHeight })
	local headerInteractable = React.useMemo(function()
		return ConversationHeaderFadeLayout.getHeaderInteractable(transparencyValue)
	end, { transparencyValue })

	React.useEffect(function()
		v3(0)
	end, { conversationId })

	return {
		onHeaderAbsoluteSizeChanged = onHeaderAbsoluteSizeChanged,
		onMessageViewportAbsoluteSizeChanged = onMessageViewportAbsoluteSizeChanged,
		onMessageCanvasPositionChanged = onMessageCanvasPositionChanged,
		headerHeight = headerHeight,
		headerLayoutPadding = headerLayoutPadding,
		headerVisibleHeight = headerVisibleHeight,
		contentTopPadding = contentTopPadding,
		messageFadeSequence = messageFadeSequence,
		headerInteractable = headerInteractable
	}
end

return useConversationHeaderFadeLayout
