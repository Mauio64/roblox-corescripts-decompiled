local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants")

local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
local useCurrentSquadParentChannelId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useCurrentSquadParentChannelId")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RealtimeDelivery")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SharedFlags")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useDispatch

local fFlagSquadAppChatRTNFix = SharedFlags.FFlagSquadAppChatRTNFix

local function SquadAppChatEventReceiver(p2): nil
	local v5 = useDispatch()
	local v6 = React.useContext(SquadExternalContractContext)

	local v7 = if fFlagSquadAppChatRTNFix then useCurrentSquadParentChannelId() else p2.conversationId

	RealtimeDelivery.useRealtimeNamespace(Constants.COMMUNICATION_CHANNEL_RTN_NAMESPACE, function(data)
		local v8

		if fFlagSquadAppChatRTNFix then
			v8 = false
		else
			v8 = p2.conversationId and p2.conversationId == data.ChannelId
		end

		if data.ChannelType == Constants.SQUAD_CHANNEL_TYPE then
			if fFlagSquadAppChatRTNFix then
				v8 = v7 and v7 == data.ParentChannelId
			end

			if
				data.Type == Constants.CHANNEL_CREATED_DETAIL_TYPE and not v8
				or data.Type == Constants.CHANNEL_DELETED_DETAIL_TYPE
			then
				v6.fetchParentChannelDetails(v5, data.ParentChannelId)
			end

			if
				data.Type == Constants.CHANNEL_UPDATED_DETAIL_TYPE
				and data.PreviousChannelStatus
				and data.PreviousChannelStatus.ParentChannelId
			then
				v6.fetchParentChannelDetails(v5, data.PreviousChannelStatus.ParentChannelId)
			end
		end
	end, { v5, v7, v6.fetchParentChannelDetails })

	return nil
end

return SquadAppChatEventReceiver
