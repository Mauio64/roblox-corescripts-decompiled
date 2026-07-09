local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local Constants = require(AppChat.Constants)

require(AppChat.Models.ConversationChannels)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local Signals = require(AppChatParent.Signals)
local View = require(AppChatParent.Foundation).View
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useAppChatIsWideMode = require(AppChat.Hooks.useAppChatIsWideMode)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local isUserInConversation = require(script.Parent.Utils.isUserInConversation)
local searchFilterPredicate = require(script.Parent.Utils.searchFilterPredicate)
local sortComparator = require(script.Parent.Utils.sortComparator)
local useFetchPaginatedFriendIds = require(script.Parent.useFetchPaginatedFriendIds)
local SelectChatMembers = require(script.Parent.SelectChatMembers)
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local FFlagConnectionsToFriendsRename = require(AppChatParent.SharedFlags).FFlagConnectionsToFriendsRename
local GetSelectedUsersStore = require(AppChat.Stores.GetSelectedUsersStore)
local t1 = {
	minSelections = 1,
	canOnlyCreateOneToOneChat = false,
	isDebugEnabled = false,
	maxSelections = Constants.MIN_PARTICIPANT_COUNT,
	maxConversationSize = Constants.MAX_PARTICIPANT_COUNT,
	filterPredicate = searchFilterPredicate,
	sortComparator = sortComparator,
	conversation = {
		participants = {}
	},
	navigateToToast = function(_) -- line: 63
	end,
	selectedUsersChanged = function(_, _) -- line: 64
	end
}

function SelectChatMembersContainer(t2: {[any]: any}) -- line: 69
	-- upvalues: Cryo (copy), t1 (copy), GetSelectedUsersStore (copy), React (copy), Signals (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), GetFFlagIsSquadEnabled (copy), Constants (copy), useFetchPaginatedFriendIds (copy), isUserInConversation (copy), useIsInExperience (copy), useAppChatIsWideMode (copy), View (copy), SelectChatMembers (copy)
	local v24 = Cryo.Dictionary.union(t1, t2)
	local v25 = GetSelectedUsersStore(false)

	React.useEffect(function() -- line: 73
		-- upvalues: v25 (copy), v24 (copy)
		v25.setMaxSize(v24.maxSelections)

		return function() -- line: 75
			-- upvalues: v25 (copy)
			v25.clearStore()
		end
	end, { v24.maxSelections })
	React.useEffect(function() -- line: 80
		-- upvalues: Signals (copy), v25 (copy), Cryo (copy), v24 (copy)
		local v36 = Signals.createEffect(function(p4) -- line: 81
			-- upvalues: v25 (copy), Cryo (copy), v24 (copy)
			local v40 = v25.getSelectedUserIdsArray()(p4)
			local v41 = Cryo.List.map(v40, function(p5) -- line: 86
				return {
					id = p5
				}
			end)

			v24.selectedUsersChanged(v41, v24.minSelections)
		end)

		return function() -- line: 92
			-- upvalues: v36 (copy)
			v36()
		end
	end, { v24.minSelections })

	local v26 = useLocalization({
		networkErrorText = "Feature.Chat.Response.NetworkError",
		systemButtonText = v24.systemButtonText,
		pageHeaderText = v24.pageHeaderText,
		searchFriendsText = not FFlagConnectionsToFriendsRename and "Feature.Chat.Label.SearchConnections" or "Feature.Chat.Label.SearchFriends",
		tooManyFriendsText = {
			if not GetFFlagIsSquadEnabled() then not FFlagConnectionsToFriendsRename and "Feature.Chat.Message.AddConnectionsLimit" or "Feature.Chat.Message.AddFriendsLimit" else not FFlagConnectionsToFriendsRename and "Feature.Chat.Message.AddConnectionsPartyLimit" or "Feature.Chat.Message.AddFriendsPartyLimit",
			friendNum = Constants.MAX_PARTICIPANT_COUNT,
			connectionsNum = Constants.MAX_PARTICIPANT_COUNT
		},
		tooManyFriendsTextSingular = if not GetFFlagIsSquadEnabled() then not FFlagConnectionsToFriendsRename and "Feature.Chat.Message.GroupConnectionLimitSingular" or "Feature.Chat.Message.GroupFriendLimitSingular" else not FFlagConnectionsToFriendsRename and "Feature.Chat.Message.AddConnectionsPartyLimitSingular" or "Feature.Chat.Message.AddFriendsPartyLimitSingular"
	})
	local v27 = React.useCallback(function() -- line: 125
		-- upvalues: v24 (copy), v26 (copy)
		local v37 = if not v24.canOnlyCreateOneToOneChat then v26.tooManyFriendsText else v26.tooManyFriendsTextSingular

		v24.navigateToToast({
			toastProps = {
				toastContent = {
					toastTitle = v37
				}
			}
		})
	end, {
		v24.canOnlyCreateOneToOneChat,
		v24.navigateToToast,
		v26
	})

	React.useEffect(function() -- line: 131
		-- upvalues: v25 (copy), v27 (copy)
		local v38 = v25.onMaxSizeExceeded(v27)

		return function() -- line: 133
			-- upvalues: v38 (copy)
			v38()
		end
	end, { v27 })

	local v28, v29, v30 = useFetchPaginatedFriendIds()
	local v31 = React.useMemo(function() -- line: 140
		-- upvalues: Cryo (copy), v28 (copy), isUserInConversation (copy), v24 (copy)
		return Cryo.List.filter(v28, function(p6) -- line: 141
			-- upvalues: isUserInConversation (copy), v24 (copy)
			return not isUserInConversation(p6, v24.conversation)
		end)
	end, {
		v28,
		v24.conversation
	})
	local v32 = React.useCallback(function() -- line: 146
		-- upvalues: v29 (copy), v30 (copy)
		if v29 and not v30 then
			v29()
		end
	end, {
		v29,
		v30
	})
	local canOnlyCreateOneToOneChat = v24.canOnlyCreateOneToOneChat
	local v34 = useIsInExperience()
	local v35 = useAppChatIsWideMode(v34)

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 1, v35 and -56 or 0)
	}, {
		SelectMembers = React.createElement(SelectChatMembers, {
			friendIds = v31,
			fetchMoreFriends = v32,
			searchFriendsText = v26.searchFriendsText,
			shouldShowSelectChatMembersBar = not canOnlyCreateOneToOneChat,
			conversation = v24.conversation,
			isDebugEnabled = v24.isDebugEnabled
		})
	})
end

return React.memo(SelectChatMembersContainer)
