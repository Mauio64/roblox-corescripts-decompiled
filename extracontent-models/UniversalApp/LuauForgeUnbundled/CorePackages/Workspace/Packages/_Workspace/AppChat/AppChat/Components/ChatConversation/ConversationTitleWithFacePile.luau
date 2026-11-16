local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local useTokens = Foundation.Hooks.useTokens
local ChatConversationTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatConversationTelemetryEvents")
local ChatConversationTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatConversationTelemetryLayer")
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")

local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/ConversationFacePile")
local useGetConversationFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetConversationFromId")
local useGetUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetUsers")
local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local getOtherParticipants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getOtherParticipants")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local fFlagUserTileUnfilteredChatIndicator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagUserTileUnfilteredChatIndicator
local v5

if fFlagUserTileUnfilteredChatIndicator then
	v5 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()
else
	v5 = nil
end

return function(props)
	local v6 = useTokens()
	local v7 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v8 = React.useCallback(function()
		v7.emit(ChatConversationTelemetryEvents.ConversationInfoBtnClicked, {})
		props.navigateToChatDetails()
	end, { props.navigateToChatDetails, v7 })

	local v9 = nil

	local v10 = props.titleText
	local v11 = useGetConversationFromId(props.conversationId)
	local v12 = useLocalUserId()

	local v13 = v11 and v11.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION

	local v14 = if v13 then getOtherParticipants(v11, v12)[1] else nil

	local v15 = useGetUsers(v14)
	local v16

	if fFlagUserTileUnfilteredChatIndicator then
		local v17 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				if v14 == nil or v14 == "" then
					return nil
				end

				return (v5.getIsTrustedConnection(v14).data(p2))
			end)
		end, { v14 })
		v16 = SignalsReact.useSignalState(v17)
	end

	if v15 then
		v10 = v11.title

		v9 = if fFlagUserTileUnfilteredChatIndicator and v16 then "" else `@{v15.name}`
	end

	return React.createElement(Foundation.View, { Size = UDim2.new(1, 0, 1, 0) }, {
		TitleContainer = React.createElement(
			Foundation.View,
			{
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				cornerRadius = UDim.new(0, v6.Radius.Medium)
			},
			{
				ConversationFacePile = React.createElement(module6, {
					conversationId = props.conversationId,
					titleText = v10,
					titleStyle = v6.Typography.TitleLarge,
					onActivated = v8,
					subtitleText = v9,
					trustedConnectionIndicatorEnabled = v13 and true or false,
					shouldShowUnfilteredChatIndicator = fFlagUserTileUnfilteredChatIndicator and v11 ~= nil and v11.moderationType == ConversationChannels.ModerationType.TrustedComms and true or nil
				})
			}
		)
	})
end
