local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

require(AppChat.Models.ConversationChannels)
local fetchLatestConversationDetails = require(AppChat.Conversations.Thunks.fetchLatestConversationDetails)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local ConversationRoduxSeed = require(AppChat.Utils.ConversationRoduxSeed)

local SharedFlags = require(parent.SharedFlags)
local FFlagFriendsCallingClientGate_DEV = SharedFlags.FFlagFriendsCallingClientGate_DEV
local FFlagAppChatConversationStore = require(AppChat.Flags.FFlagAppChatConversationStore)
local GetConversationStore

if FFlagAppChatConversationStore then
	GetConversationStore = require(AppChat.Stores.GetConversationStore)
else
	GetConversationStore = nil
end

local function useCallButtonEligibility(p: string?)
	local v

	if FFlagFriendsCallingClientGate_DEV then
		if FFlagAppChatConversationStore then
			local v2 = React.useMemo(function()
				return Signals.createComputed(function(p2)
					if p then
						return (GetConversationStore(false).getConversation(p, p2))
					end

					return nil
				end)
			end, { p or false })

			v = SignalsReact.useSignalState(v2)
		else
			v = useGetConversationFromId(p)
		end
	end

	if v == nil or v.id ~= p then
		v = nil
	end

	local friendsPlaceholderConversationId = ConversationRoduxSeed.isFriendsPlaceholderConversationId(p)
	local callButtonEligibility

	if v and not friendsPlaceholderConversationId then
		callButtonEligibility = v.callButtonEligibility
	else
		callButtonEligibility = nil
	end

	local v2 = useDispatch()

	React.useEffect(function()
		if
			FFlagFriendsCallingClientGate_DEV
			and p
			and not friendsPlaceholderConversationId
			and callButtonEligibility == nil
		then
			v2(fetchLatestConversationDetails(p))
		end
	end, {
		v2,
		p or false,
		callButtonEligibility or false,
		friendsPlaceholderConversationId
	})

	return callButtonEligibility
end

return useCallButtonEligibility
