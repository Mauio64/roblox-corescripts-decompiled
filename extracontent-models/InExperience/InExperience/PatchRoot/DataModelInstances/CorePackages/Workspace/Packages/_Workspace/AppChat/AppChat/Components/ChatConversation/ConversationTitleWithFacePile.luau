local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Foundation = require(AppChatParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local ChatConversationTelemetryEvents = require(script.Parent.ChatConversationTelemetryEvents)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ConversationFacePile = require(AppChat.Components.Cells.ConversationFacePile)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local useGetUserFromId = require(AppChat.Hooks.useGetUserFromId)
local Conversation = require(AppChat.Models.Conversation)
local getOtherParticipants = require(AppChat.Conversations.getOtherParticipants)
local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId

return function(t1: {[any]: any}) -- line: 24
	-- upvalues: useTokens (copy), useTelemetry (copy), ChatConversationTelemetryLayer (copy), React (copy), ChatConversationTelemetryEvents (copy), useGetConversationFromId (copy), useLocalUserId (copy), Conversation (copy), getOtherParticipants (copy), useGetUserFromId (copy), Foundation (copy), ConversationFacePile (copy)
	local v16 = useTokens()
	local v17 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v18 = React.useCallback(function() -- line: 27
		-- upvalues: v17 (copy), ChatConversationTelemetryEvents (copy), t1 (copy)
		v17.emit(ChatConversationTelemetryEvents.ConversationInfoBtnClicked, {})
		t1.navigateToChatDetails()
	end, {
		t1.navigateToChatDetails,
		v17
	})
	local v19 = nil
	local titleText = t1.titleText
	local v21 = useGetConversationFromId(t1.conversationId)
	local v22 = useLocalUserId()
	local v23 = v21 and v21.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION
	local v24 = if not v23 then nil else getOtherParticipants(v21, v22)[1]
	local v25 = useGetUserFromId(v24)

	if v25 then
		titleText = v21.title
		v19 = `@{ v25.name }`
	end

	return React.createElement(Foundation.View, {
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		TitleContainer = React.createElement(Foundation.View, {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			cornerRadius = UDim.new(0, v16.Radius.Medium)
		}, {
			ConversationFacePile = React.createElement(ConversationFacePile, {
				conversationId = t1.conversationId,
				titleText = titleText,
				titleStyle = v16.Typography.TitleLarge,
				onActivated = v18,
				subtitleText = v19,
				trustedConnectionIndicatorEnabled = not not v23
			})
		})
	})
end
