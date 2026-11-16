local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local Constants = require(SquadsCore.Common.Constants)

local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local useCurrentSquadParentChannelId = require(SquadsCore.Hooks.useCurrentSquadParentChannelId)

local React = require(parent.React)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local SharedFlags = require(parent.SharedFlags)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local FFlagSquadAppChatRTNFix = SharedFlags.FFlagSquadAppChatRTNFix

local function SquadAppChatEventReceiver(p): nil
	local v = useDispatch()
	local v2 = React.useContext(SquadExternalContractContext)
	local v3

	if FFlagSquadAppChatRTNFix then
		v3 = useCurrentSquadParentChannelId()
	else
		v3 = p.conversationId
	end

	RealtimeDelivery.useRealtimeNamespace(Constants.COMMUNICATION_CHANNEL_RTN_NAMESPACE, function(data)
		local v4

		if FFlagSquadAppChatRTNFix then
			v4 = false
		else
			v4 = p.conversationId and p.conversationId == data.ChannelId
		end

		if data.ChannelType == Constants.SQUAD_CHANNEL_TYPE then
			if FFlagSquadAppChatRTNFix then
				v4 = v3 and v3 == data.ParentChannelId
			end

			if
				data.Type == Constants.CHANNEL_CREATED_DETAIL_TYPE and not v4
				or data.Type == Constants.CHANNEL_DELETED_DETAIL_TYPE
			then
				v2.fetchParentChannelDetails(v, data.ParentChannelId)
			end

			if
				data.Type == Constants.CHANNEL_UPDATED_DETAIL_TYPE
				and data.PreviousChannelStatus
				and data.PreviousChannelStatus.ParentChannelId
			then
				v2.fetchParentChannelDetails(v, data.PreviousChannelStatus.ParentChannelId)
			end
		end
	end, { v, v3, v2.fetchParentChannelDetails })

	return nil
end

return SquadAppChatEventReceiver
