local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
require(parent.Signals)
local ExpChatShared = require(parent.ExpChatShared)

local useChatWindow = require(script.Parent.Parent.Bridge.useChatWindow)

local v = ExpChatShared.Logger:new(script.Name)

local function FriendsChatMessageList(props)
	local v2 = useChatWindow()

	local resetTargetChannel = React.useCallback(function()
		v:warning("resetTargetChannel called on FriendsChatMessageList; not supported")
	end, {})
	local activateWhisperMode = React.useCallback(function()
		v:warning("activateWhisperMode called on FriendsChatMessageList; not supported")
	end, {})

	local ref = React.useRef(nil)
	local onViewportAbsoluteSizeChanged = props.onViewportAbsoluteSizeChanged
	React.useEffect(function()
		local current = ref.current

		if current and onViewportAbsoluteSizeChanged then
			onViewportAbsoluteSizeChanged(current)
		end
	end, { onViewportAbsoluteSizeChanged })

	return React.createElement("Frame", {
		Name = "FriendsChatWindowSlot",
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
		ZIndex = 1
	}, {
		flex = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }),
		messageMask = React.createElement("CanvasGroup", {
			Name = "FriendsChatMessageMask",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			GroupTransparency = 0,
			Size = UDim2.fromScale(1, 1),
			[React.Change.AbsoluteSize] = props.onViewportAbsoluteSizeChanged,
			ref = ref
		}, {
			fade = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = props.messageFadeSequence
			}),
			window = React.createElement(v2, {
				size = UDim2.fromScale(1, 1),
				isChannelBarVisible = props.isChannelBarVisible,
				scrollResetKey = "FriendsChat:" .. props.conversationId,
				scrollToTopOnReset = props.scrollToTopOnReset,
				onCanvasPositionChanged = props.onCanvasPositionChanged,
				contentTopPadding = props.contentTopPadding,
				messageComponentsSignal = props.scrollViewChildrenSignal,
				chatWindowSettings = props.chatWindowSettings,
				suppressBackground = true,
				transparencyValue = props.transparencyValue,
				textTransparency = props.textTransparency,
				isSpatialUIEnabled = props.isSpatialUIEnabled,
				onHovered = props.onHovered,
				onUnhovered = props.onUnhovered,
				onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
				onAbsolutePositionChanged = props.onAbsolutePositionChanged,
				disableLineReporting = true,
				resetTargetChannel = resetTargetChannel,
				activateWhisperMode = activateWhisperMode
			})
		})
	})
end

return FriendsChatMessageList
