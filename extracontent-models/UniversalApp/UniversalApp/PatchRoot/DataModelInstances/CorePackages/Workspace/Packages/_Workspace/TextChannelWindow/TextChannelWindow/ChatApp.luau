local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local ReactUtils = require(ParentParent.ReactUtils)
local Foundation = require(ParentParent.Foundation)

require(ParentParent.Signals)
require(ParentParent.ChatUIPrimitives)

local TextChatWindowInputBarHost = require(script.Parent.TextChatWindowInputBarHost)
local ChatWindowTopBanner = require(script.Parent.ChatWindowTopBanner)
local MessageListArea = require(script.Parent.MessageListArea)
local themeFromBackgroundColor = require(script.Parent.themeFromBackgroundColor)
local v9 = game:DefineFastFlag("ExpChatTextChannelWindowThemeByBackground", false)
local createNextOrder = ReactUtils.createNextOrder
local _ = {
	Pending = "pending",
	Failed = "failed"
}

local function ChatAppInner(t1: {[any]: any}) -- line: 53
	-- upvalues: Foundation (copy), createNextOrder (copy), React (copy), v9 (copy), MessageListArea (copy), TextChatWindowInputBarHost (copy), ChatWindowTopBanner (copy)
	local v15 = Foundation.Hooks.useTokens()
	local v16 = createNextOrder()

	return React.createElement(Foundation.View, {
		Size = t1.Size or UDim2.fromScale(1, 1)
	}, {
		chatView = React.createElement(Foundation.View, {
			tag = "col fill clip",
			cornerRadius = if v9 then nil else UDim.new(0, v15.Radius.Medium),
			Size = UDim2.fromScale(1, 1),
			backgroundStyle = if v9 then nil else {
				Transparency = 0.3,
				Color3 = v15.DarkMode.Surface.Surface_100.Color3
			}
		}, {
			messageList = React.createElement(Foundation.View, {
				tag = "fill",
				LayoutOrder = v16(),
				Size = UDim2.fromScale(1, 0)
			}, {
				content = React.createElement(MessageListArea, {
					channelState = t1.channelState,
					messagesSignal = t1.messagesSignal
				})
			}),
			inputBar = React.createElement(Foundation.View, {
				tag = "auto-y padding-small",
				LayoutOrder = v16(),
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				host = React.createElement(TextChatWindowInputBarHost, {
					targetChannel = t1.targetChannel,
					canLocalUserChat = t1.canLocalUserChat,
					localUserId = t1.localUserId
				})
			})
		}),
		topBanner = React.createElement(ChatWindowTopBanner, {
			ZIndex = 2,
			messagesSignal = t1.messagesSignal,
			targetChannel = t1.targetChannel
		})
	})
end
local function ChatApp(t2: {[any]: any}) -- line: 108
	-- upvalues: v9 (copy), themeFromBackgroundColor (copy), Foundation (copy), React (copy), ChatAppInner (copy)
	local v18 = if not v9 or not t2.backgroundColor then Foundation.Enums.Theme.Dark else themeFromBackgroundColor(t2.backgroundColor)

	return React.createElement(Foundation.FoundationProvider, {
		theme = v18
	}, {
		inner = React.createElement(ChatAppInner, t2)
	})
end

return ChatApp
