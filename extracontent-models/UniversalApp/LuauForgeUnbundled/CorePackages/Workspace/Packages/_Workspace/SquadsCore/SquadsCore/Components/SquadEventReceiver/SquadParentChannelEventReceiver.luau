local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Logger")
local RoduxSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/RoduxSquads")

local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
local fetchActiveSquad = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Thunks/fetchActiveSquad")
local serializeTable = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Utils/serializeTable")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RealtimeDelivery")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useDispatch

return function(p2): nil
	local v5 = useDispatch()
	local v6 = React.useContext(SquadExternalContractContext)

	RealtimeDelivery.useRealtimeNamespace(Constants.COMMUNICATION_CHANNEL_RTN_NAMESPACE, function(data)
		if
			table.find(Constants.PARENT_CHANNEL_TYPES, data.ChannelType)
			and p2.currentParentChannelId
			and p2.currentParentChannelId == data.ChannelId
		then
			Logger:debug(
				"Parent squad channel RTN received. Detail: {}, CurrentParentChannelId: {}",
				serializeTable(data),
				p2.currentParentChannelId
			)

			if
				data.Type == Constants.CHANNEL_DELETED_DETAIL_TYPE
				or data.Type == Constants.CHANNEL_ARCHIVED_DETAIL_TYPE
				or data.Type == Constants.CHANNEL_LOCAL_USER_REMOVED_DETAIL_TYPE
			then
				v5(RoduxSquads.Actions.CurrentSquadUpdated(nil))
			elseif data.Type == Constants.CHANNEL_PARTICIPANT_REMOVED_DETAIL_TYPE then
				v5(fetchActiveSquad())
			end
		end
	end, { v5, p2.currentParentChannelId, v6.fetchParentChannelDetails })

	React.useEffect(function()
		if p2.currentParentChannelId and p2.currentParentChannelId ~= "" then
			v6.fetchParentChannelDetails(v5, p2.currentParentChannelId)
		end
	end, { v5, p2.currentParentChannelId, v6.fetchParentChannelDetails })

	return nil
end
