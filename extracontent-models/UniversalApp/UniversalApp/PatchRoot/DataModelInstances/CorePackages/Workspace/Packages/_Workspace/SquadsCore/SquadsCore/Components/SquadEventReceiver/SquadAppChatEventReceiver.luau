local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local Constants = require(SquadsCore.Common.Constants)
local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local useCurrentSquadParentChannelId = require(SquadsCore.Hooks.useCurrentSquadParentChannelId)
local React = require(SquadsCoreParent.React)
local RealtimeDelivery = require(SquadsCoreParent.RealtimeDelivery)
local SharedFlags = require(SquadsCoreParent.SharedFlags)
local useDispatch = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useDispatch
local FFlagSquadAppChatRTNFix = SharedFlags.FFlagSquadAppChatRTNFix

local function SquadAppChatEventReceiver(t1: {[any]: any}) -- line: 20
	-- upvalues: useDispatch (copy), React (copy), SquadExternalContractContext (copy), FFlagSquadAppChatRTNFix (copy), useCurrentSquadParentChannelId (copy), RealtimeDelivery (copy), Constants (copy)
	local v13 = useDispatch()
	local v14 = React.useContext(SquadExternalContractContext)
	local v15 = if not FFlagSquadAppChatRTNFix then t1.conversationId else useCurrentSquadParentChannelId()

	RealtimeDelivery.useRealtimeNamespace(Constants.COMMUNICATION_CHANNEL_RTN_NAMESPACE, function(p1) -- line: 28
		-- upvalues: FFlagSquadAppChatRTNFix (copy), t1 (copy), Constants (copy), v15 (copy), v14 (copy), v13 (copy)
		local v17 = not FFlagSquadAppChatRTNFix and (t1.conversationId and t1.conversationId == p1.ChannelId)

		if p1.ChannelType == Constants.SQUAD_CHANNEL_TYPE then
			if FFlagSquadAppChatRTNFix then
				v17 = v15 and v15 == p1.ParentChannelId
			end

			if p1.Type == Constants.CHANNEL_CREATED_DETAIL_TYPE and not v17 or p1.Type == Constants.CHANNEL_DELETED_DETAIL_TYPE then
				v14.fetchParentChannelDetails(v13, p1.ParentChannelId)
			end

			if p1.Type == Constants.CHANNEL_UPDATED_DETAIL_TYPE and p1.PreviousChannelStatus and p1.PreviousChannelStatus.ParentChannelId then
				v14.fetchParentChannelDetails(v13, p1.PreviousChannelStatus.ParentChannelId)
			end
		end
	end, {
		v13,
		v15,
		v14.fetchParentChannelDetails
	})

	return nil
end

return SquadAppChatEventReceiver
