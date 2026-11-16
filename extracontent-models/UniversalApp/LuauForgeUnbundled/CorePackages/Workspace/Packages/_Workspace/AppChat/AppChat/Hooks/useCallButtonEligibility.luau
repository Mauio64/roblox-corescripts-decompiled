local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local fetchLatestConversationDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/fetchLatestConversationDetails")
local useGetConversationFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetConversationFromId")
local ConversationRoduxSeed = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/ConversationRoduxSeed")

local fFlagFriendsCallingClientGate_DEV = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagFriendsCallingClientGate_DEV
local FFlagAppChatConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConversationStore")

local v5 = if FFlagAppChatConversationStore then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore") else nil

local function useCallButtonEligibility(p2)
	local v6

	if fFlagFriendsCallingClientGate_DEV then
		if FFlagAppChatConversationStore then
			local v7 = React.useMemo(function()
				return Signals.createComputed(function(p3)
					if p2 then
						return (v5(false).getConversation(p2, p3))
					end

					return nil
				end)
			end, { p2 or false })

			v6 = SignalsReact.useSignalState(v7)
		else
			v6 = useGetConversationFromId(p2)
		end
	end

	if v6 == nil or v6.id ~= p2 then
		v6 = nil
	end

	local friendsPlaceholderConversationId = ConversationRoduxSeed.isFriendsPlaceholderConversationId(p2)

	local callButtonEligibility = if v6 and not friendsPlaceholderConversationId then v6.callButtonEligibility else nil

	local v7 = useDispatch()

	React.useEffect(function()
		if
			fFlagFriendsCallingClientGate_DEV
			and p2
			and not friendsPlaceholderConversationId
			and callButtonEligibility == nil
		then
			v7(fetchLatestConversationDetails(p2))
		end
	end, {
		v7,
		p2 or false,
		callButtonEligibility or false,
		friendsPlaceholderConversationId
	})

	return callButtonEligibility
end

return useCallButtonEligibility
