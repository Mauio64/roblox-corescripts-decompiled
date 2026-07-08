local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local Constants = require(SquadsCore.Common.Constants)
local Logger = require(SquadsCore.Logger)
local RoduxSquads = require(SquadsCore.RoduxSquads)
local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local fetchActiveSquad = require(SquadsCore.Thunks.fetchActiveSquad)
local serializeTable = require(SquadsCore.Utils.serializeTable)
local React = require(SquadsCoreParent.React)
local RealtimeDelivery = require(SquadsCoreParent.RealtimeDelivery)
local useDispatch = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useDispatch

return function(t1: {[any]: any}) -- line: 22
	-- upvalues: useDispatch (copy), React (copy), SquadExternalContractContext (copy), RealtimeDelivery (copy), Constants (copy), Logger (copy), serializeTable (copy), RoduxSquads (copy), fetchActiveSquad (copy)
	local v13 = useDispatch()
	local v14 = React.useContext(SquadExternalContractContext)

	RealtimeDelivery.useRealtimeNamespace(Constants.COMMUNICATION_CHANNEL_RTN_NAMESPACE, function(p1) -- line: 27
		-- upvalues: Constants (copy), t1 (copy), Logger (copy), serializeTable (copy), v13 (copy), RoduxSquads (copy), fetchActiveSquad (copy)
		if table.find(Constants.PARENT_CHANNEL_TYPES, p1.ChannelType) and (t1.currentParentChannelId and t1.currentParentChannelId == p1.ChannelId) then
			Logger:debug("Parent squad channel RTN received. Detail: {}, CurrentParentChannelId: {}", serializeTable(p1), t1.currentParentChannelId)

			if p1.Type == Constants.CHANNEL_DELETED_DETAIL_TYPE or p1.Type == Constants.CHANNEL_ARCHIVED_DETAIL_TYPE or p1.Type == Constants.CHANNEL_LOCAL_USER_REMOVED_DETAIL_TYPE then
				v13(RoduxSquads.Actions.CurrentSquadUpdated(nil))

				return
			end

			if p1.Type == Constants.CHANNEL_PARTICIPANT_REMOVED_DETAIL_TYPE then
				v13(fetchActiveSquad())
			end
		end
	end, {
		v13,
		t1.currentParentChannelId,
		v14.fetchParentChannelDetails
	})
	React.useEffect(function() -- line: 54
		-- upvalues: t1 (copy), v14 (copy), v13 (copy)
		if t1.currentParentChannelId and t1.currentParentChannelId ~= "" then
			v14.fetchParentChannelDetails(v13, t1.currentParentChannelId)
		end
	end, {
		v13,
		t1.currentParentChannelId,
		v14.fetchParentChannelDetails
	})

	return nil
end
