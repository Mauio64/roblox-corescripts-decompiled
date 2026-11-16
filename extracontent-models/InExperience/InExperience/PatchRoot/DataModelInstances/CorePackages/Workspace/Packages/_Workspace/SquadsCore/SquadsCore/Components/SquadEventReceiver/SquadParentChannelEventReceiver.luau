local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local Constants = require(SquadsCore.Common.Constants)
local Logger = require(SquadsCore.Logger)
local RoduxSquads = require(SquadsCore.RoduxSquads)

local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local fetchActiveSquad = require(SquadsCore.Thunks.fetchActiveSquad)
local serializeTable = require(SquadsCore.Utils.serializeTable)

local React = require(parent.React)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local RoactUtils = require(parent.RoactUtils)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

return function(p): nil
	local v = useDispatch()
	local v2 = React.useContext(SquadExternalContractContext)

	RealtimeDelivery.useRealtimeNamespace(Constants.COMMUNICATION_CHANNEL_RTN_NAMESPACE, function(data)
		if
			table.find(Constants.PARENT_CHANNEL_TYPES, data.ChannelType)
			and p.currentParentChannelId
			and p.currentParentChannelId == data.ChannelId
		then
			Logger:debug(
				"Parent squad channel RTN received. Detail: {}, CurrentParentChannelId: {}",
				serializeTable(data),
				p.currentParentChannelId
			)

			if
				data.Type == Constants.CHANNEL_DELETED_DETAIL_TYPE
				or data.Type == Constants.CHANNEL_ARCHIVED_DETAIL_TYPE
				or data.Type == Constants.CHANNEL_LOCAL_USER_REMOVED_DETAIL_TYPE
			then
				v(RoduxSquads.Actions.CurrentSquadUpdated(nil))
			elseif data.Type == Constants.CHANNEL_PARTICIPANT_REMOVED_DETAIL_TYPE then
				v(fetchActiveSquad())
			end
		end
	end, { v, p.currentParentChannelId, v2.fetchParentChannelDetails })

	React.useEffect(function()
		if p.currentParentChannelId and p.currentParentChannelId ~= "" then
			v2.fetchParentChannelDetails(v, p.currentParentChannelId)
		end
	end, { v, p.currentParentChannelId, v2.fetchParentChannelDetails })

	return nil
end
