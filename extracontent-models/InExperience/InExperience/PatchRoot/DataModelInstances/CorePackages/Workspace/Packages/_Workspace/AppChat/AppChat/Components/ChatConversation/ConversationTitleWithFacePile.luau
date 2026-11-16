local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local ChatConversationTelemetryEvents = require(script.Parent.ChatConversationTelemetryEvents)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)

local ConversationFacePile = require(AppChat.Components.Cells.ConversationFacePile)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local useGetUserFromId = require(AppChat.Hooks.useGetUserFromId)
local Conversation = require(AppChat.Models.Conversation)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local getOtherParticipants = require(AppChat.Conversations.getOtherParticipants)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local DataHydration = require(parent.DataHydration)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local SharedFlags = require(parent.SharedFlags)
local FFlagUserTileUnfilteredChatIndicator = SharedFlags.FFlagUserTileUnfilteredChatIndicator
local v

if FFlagUserTileUnfilteredChatIndicator then
	v = DataHydration.TrustedConnections.TrustedConnectionsStore.get()
else
	v = nil
end

return function(props)
	local v2 = useTokens()
	local v3 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local onActivated = React.useCallback(function()
		v3.emit(ChatConversationTelemetryEvents.ConversationInfoBtnClicked, {})
		props.navigateToChatDetails()
	end, { props.navigateToChatDetails, v3 })

	local subtitleText = nil

	local titleText = props.titleText
	local v4 = useGetConversationFromId(props.conversationId)
	local v5 = useLocalUserId()

	local v6 = v4 and v4.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION
	local v7

	if v6 then
		v7 = getOtherParticipants(v4, v5)[1]
	else
		v7 = nil
	end

	local v8 = useGetUserFromId(v7)
	local v9

	if FFlagUserTileUnfilteredChatIndicator then
		local v10 = React.useMemo(function()
			return Signals.createComputed(function(p)
				if v7 == nil or v7 == "" then
					return nil
				end

				return (v.getIsTrustedConnection(v7).data(p))
			end)
		end, { v7 })
		v9 = SignalsReact.useSignalState(v10)
	end

	if v8 then
		titleText = v4.title

		if FFlagUserTileUnfilteredChatIndicator and v9 then
			subtitleText = ""
		else
			subtitleText = `@{v8.name}`
		end
	end

	return React.createElement(Foundation.View, { Size = UDim2.new(1, 0, 1, 0) }, {
		TitleContainer = React.createElement(
			Foundation.View,
			{
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				cornerRadius = UDim.new(0, v2.Radius.Medium)
			},
			{
				ConversationFacePile = React.createElement(ConversationFacePile, {
					conversationId = props.conversationId,
					titleText = titleText,
					titleStyle = v2.Typography.TitleLarge,
					onActivated = onActivated,
					subtitleText = subtitleText,
					trustedConnectionIndicatorEnabled = v6 and true or false,
					shouldShowUnfilteredChatIndicator = FFlagUserTileUnfilteredChatIndicator and v4 ~= nil and v4.moderationType == ConversationChannels.ModerationType.TrustedComms and true or nil
				})
			}
		)
	})
end
