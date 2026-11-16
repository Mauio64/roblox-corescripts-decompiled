local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)
local Constants = require(AppChat.Constants)
require(AppChat.Models.ConversationChannels)

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Signals = require(parent.Signals)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local useAppChatIsWideMode = require(AppChat.Hooks.useAppChatIsWideMode)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)

local isUserInConversation = require(script.Parent.Utils.isUserInConversation)
local searchFilterPredicate = require(script.Parent.Utils.searchFilterPredicate)
local sortComparator = require(script.Parent.Utils.sortComparator)

local useFetchPaginatedFriendIds = require(script.Parent.useFetchPaginatedFriendIds)
local SelectChatMembers = require(script.Parent.SelectChatMembers)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagFixPaginatedChatMembersCutoff = require(AppChat.Flags.FFlagFixPaginatedChatMembersCutoff)

local GetSelectedUsersStore = require(AppChat.Stores.GetSelectedUsersStore)

local v = {
	minSelections = 1,
	maxSelections = Constants.MIN_PARTICIPANT_COUNT,
	maxConversationSize = Constants.MAX_PARTICIPANT_COUNT,
	canOnlyCreateOneToOneChat = false,
	filterPredicate = searchFilterPredicate,
	sortComparator = sortComparator,
	conversation = { participants = {} },
	navigateToToast = function(_) end,
	selectedUsersChanged = function(_, _) end,
	isDebugEnabled = false
}

function SelectChatMembersContainer(p)
	local union = Cryo.Dictionary.union(v, p)
	local selectedUsersStore = GetSelectedUsersStore(false)
	local v2

	if FFlagFixPaginatedChatMembersCutoff then
		v2 = useNavigation().getScreenProps("topBarHeight", 0)
	end

	React.useEffect(function()
		selectedUsersStore.setMaxSize(union.maxSelections)
		return function()
			selectedUsersStore.clearStore()
		end
	end, { union.maxSelections })

	React.useEffect(function()
		local effect = Signals.createEffect(function(p2)
			local v3 = selectedUsersStore.getSelectedUserIdsArray()(p2)

			local mapped = Cryo.List.map(v3, function(id)
				return { id = id }
			end)

			union.selectedUsersChanged(mapped, union.minSelections)
		end)
		return function()
			effect()
		end
	end, { union.minSelections })

	local v3 = useLocalization({
		systemButtonText = union.systemButtonText,
		pageHeaderText = union.pageHeaderText,
		searchFriendsText = "Feature.Chat.Label.SearchFriends",
		networkErrorText = "Feature.Chat.Response.NetworkError",
		tooManyFriendsText = {
			GetFFlagIsSquadEnabled() and "Feature.Chat.Message.AddFriendsPartyLimit" or "Feature.Chat.Message.AddFriendsLimit",
			friendNum = Constants.MAX_PARTICIPANT_COUNT,
			connectionsNum = Constants.MAX_PARTICIPANT_COUNT
		},
		tooManyFriendsTextSingular = GetFFlagIsSquadEnabled() and "Feature.Chat.Message.AddFriendsPartyLimitSingular" or "Feature.Chat.Message.GroupFriendLimitSingular"
	})

	local v4 = React.useCallback(function()
		local toastTitle

		if union.canOnlyCreateOneToOneChat then
			toastTitle = v3.tooManyFriendsTextSingular
		else
			toastTitle = v3.tooManyFriendsText
		end

		union.navigateToToast({
			toastProps = {
				toastContent = { toastTitle = toastTitle }
			}
		})
	end, { union.canOnlyCreateOneToOneChat, union.navigateToToast, v3 })
	React.useEffect(function()
		local v5 = selectedUsersStore.onMaxSizeExceeded(v4)
		return function()
			v5()
		end
	end, { v4 })

	local v5, v6, v7 = useFetchPaginatedFriendIds()

	local friendIds = React.useMemo(function()
		return Cryo.List.filter(v5, function(p2): boolean
			return not isUserInConversation(p2, union.conversation)
		end)
	end, { v5, union.conversation })

	local fetchMoreFriends = React.useCallback(function()
		if v6 and not v7 then
			v6()
		end
	end, { v6, v7 })

	local shouldShowSelectChatMembersBar = not union.canOnlyCreateOneToOneChat
	local v8 = not useAppChatIsWideMode((useIsInExperience()))
	return React.createElement(View, {
		Size = UDim2.new(1, 0, 1, v8 and 0 or -(not FFlagFixPaginatedChatMembersCutoff and 56 or v2))
	}, {
		SelectMembers = React.createElement(SelectChatMembers, {
			friendIds = friendIds,
			fetchMoreFriends = fetchMoreFriends,
			searchFriendsText = v3.searchFriendsText,
			shouldShowSelectChatMembersBar = shouldShowSelectChatMembersBar,
			conversation = union.conversation,
			isDebugEnabled = union.isDebugEnabled
		})
	})
end

return React.memo(SelectChatMembersContainer)
