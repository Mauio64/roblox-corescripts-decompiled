require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation").View
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation

local useAppChatIsWideMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppChatIsWideMode")
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")

local isUserInConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/SelectChatMembers/Utils/isUserInConversation")
local searchFilterPredicate = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/SelectChatMembers/Utils/searchFilterPredicate")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/SelectChatMembers/Utils/sortComparator")

local useFetchPaginatedFriendIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/SelectChatMembers/useFetchPaginatedFriendIds")
local SelectChatMembers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/SelectChatMembers/SelectChatMembers")

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagIsSquadEnabled
local FFlagFixPaginatedChatMembersCutoff = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagFixPaginatedChatMembersCutoff")

local GetSelectedUsersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetSelectedUsersStore")

local v5 = {
	minSelections = 1,
	maxSelections = Constants.MIN_PARTICIPANT_COUNT,
	maxConversationSize = Constants.MAX_PARTICIPANT_COUNT,
	canOnlyCreateOneToOneChat = false,
	filterPredicate = searchFilterPredicate,
	sortComparator = module9,
	conversation = { participants = {} },
	navigateToToast = function(p2) end,
	selectedUsersChanged = function(p2, p3) end,
	isDebugEnabled = false
}

function LUAUFORGE_MODULE_GLOBALS_hEf_SelectChatMembersContainer(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v6 = GetSelectedUsersStore(false)

	local v7 = if FFlagFixPaginatedChatMembersCutoff then useNavigation().getScreenProps("topBarHeight", 0) else nil

	React.useEffect(function()
		v6.setMaxSize(union.maxSelections)
		return function()
			v6.clearStore()
		end
	end, { union.maxSelections })

	React.useEffect(function()
		local effect = Signals.createEffect(function(p3)
			local v8 = v6.getSelectedUserIdsArray()(p3)

			local mapped = Cryo.List.map(v8, function(p4)
				return { id = p4 }
			end)

			union.selectedUsersChanged(mapped, union.minSelections)
		end)
		return function()
			effect()
		end
	end, { union.minSelections })

	local v8 = useLocalization({
		systemButtonText = union.systemButtonText,
		pageHeaderText = union.pageHeaderText,
		searchFriendsText = "Feature.Chat.Label.SearchFriends",
		networkErrorText = "Feature.Chat.Response.NetworkError",
		tooManyFriendsText = {
			getFFlagIsSquadEnabled() and "Feature.Chat.Message.AddFriendsPartyLimit" or "Feature.Chat.Message.AddFriendsLimit",
			friendNum = Constants.MAX_PARTICIPANT_COUNT,
			connectionsNum = Constants.MAX_PARTICIPANT_COUNT
		},
		tooManyFriendsTextSingular = getFFlagIsSquadEnabled() and "Feature.Chat.Message.AddFriendsPartyLimitSingular" or "Feature.Chat.Message.GroupFriendLimitSingular"
	})

	local v9 = React.useCallback(function()
		local v10 = if union.canOnlyCreateOneToOneChat then v8.tooManyFriendsTextSingular else v8.tooManyFriendsText
		union.navigateToToast({
			toastProps = {
				toastContent = { toastTitle = v10 }
			}
		})
	end, { union.canOnlyCreateOneToOneChat, union.navigateToToast, v8 })
	React.useEffect(function()
		local v10 = v6.onMaxSizeExceeded(v9)
		return function()
			v10()
		end
	end, { v9 })

	local v10, v11, v12 = useFetchPaginatedFriendIds()

	local v13 = React.useMemo(function()
		return Cryo.List.filter(v10, function(p3): boolean
			return not isUserInConversation(p3, union.conversation)
		end)
	end, { v10, union.conversation })

	local v14 = React.useCallback(function()
		if v11 and not v12 then
			v11()
		end
	end, { v11, v12 })

	local v15 = not union.canOnlyCreateOneToOneChat
	local v17 = not useAppChatIsWideMode((useIsInExperience()))
	return React.createElement(view, {
		Size = UDim2.new(1, 0, 1, v17 and 0 or -(not FFlagFixPaginatedChatMembersCutoff and 56 or v7))
	}, {
		SelectMembers = React.createElement(SelectChatMembers, {
			friendIds = v13,
			fetchMoreFriends = v14,
			searchFriendsText = v8.searchFriendsText,
			shouldShowSelectChatMembersBar = v15,
			conversation = union.conversation,
			isDebugEnabled = union.isDebugEnabled
		})
	})
end

return React.memo(LUAUFORGE_MODULE_GLOBALS_hEf_SelectChatMembersContainer)
