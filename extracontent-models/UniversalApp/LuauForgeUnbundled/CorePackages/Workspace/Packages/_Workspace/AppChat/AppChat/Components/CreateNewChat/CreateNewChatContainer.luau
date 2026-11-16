require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

local responseIndicator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries").Components.ResponseIndicator

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local useCallback = React.useCallback
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useIsGroupChatEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsGroupChatEnabled")
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")
local useState = React.useState
local useRef = React.useRef
local AppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppNavBar")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy")

local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local createConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/createConversation")
local parseCreateConversationErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/parseCreateConversationErrors")
local SelectChatMembersContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/SelectChatMembers/SelectChatMembersContainer")

local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/EventNames")
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/useAnalytics")
local CreateConversationError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/Enums/CreateConversationError")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagAppIaScrollAwayFixSocial = SharedFlags.FFlagAppIaScrollAwayFixSocial
local getFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagFixPaginatedChatMembersCutoff = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagFixPaginatedChatMembersCutoff")

local v5 = {
	systemButtonText = getFFlagIsSquadEnabled() and "Feature.Chat.Action.Create" or "Feature.Chat.Action.StartChatWithFriends",
	pageHeaderText = getFFlagIsSquadEnabled() and (UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Chat.Title.NewChat" or "Feature.Chat.Heading.PartyWithFriends") or "Feature.Chat.Heading.ChatWithConnections",
	topBarHeight = nil,
	minSelections = 1,
	maxSelections = 5,
	maxConversationSize = 5,
	conversation = Conversation.empty(),
	setSystemButtonActivated = function(p2) end,
	setSystemButtonEnabled = function(p2) end
}

function LUAUFORGE_MODULE_GLOBALS_hsY_CreateNewChatContainer(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useRef({})
	local v7 = useRef(false)
	local state, setState = useState(false)

	local v8 = if fFlagAppIaScrollAway and not fFlagAppIaScrollAwayFixSocial then useIsInExperience() else nil

	local v9 = joined.maxSelections
	local v10 = joined.maxConversationSize
	local v11

	if useIsGroupChatEnabled() then
		v11 = false
	else
		v9 = 1
		v10 = 1
		v11 = true
	end

	local v12 = useDispatch()

	local v13 = useCallback(function(p3)
		joined.navigateToToast({
			toastProps = {
				toastContent = { toastTitle = p3 }
			}
		})
	end, { joined.navigateToToast })

	local function fn(list, p3)
		v6.current = Cryo.List.map(list, function(p4)
			return p4.id
		end)

		local v14 = p3 <= #list

		if v7.current ~= v14 then
			v7.current = v14
			joined.setSystemButtonEnabled(v14)
		end
	end

	local v14 = useAnalytics()

	local v15 = useCallback(function(p3)
		if state or not v6.current then
			return Promise.resolve()
		end

		setState(true)

		return v12(createConversation(
			#v6.current == 1 and "one_to_one" or "group",
			v6.current,
			v14,
			"userCreatedNewConversation"
		)):andThen(function(p4)
			joined.navigateToConversation(p4.id)
		end):catch(function(p4)
			local v17 = if parseCreateConversationErrors(p4) == "participant_chat_disabled" then p3.invalidParticipantText else p3.networkErrorText

			v13(v17)
			setState(false)

			if v14 then
				v14.fireAnalyticsEvent(EventNames.NewConversationCreated, {
					createConversationResult = CreateConversationError.FetchConversationError
				})
			end
		end)
	end, { v12, state, setState, v6, joined.navigateToConversation, v13, v14 })

	useEffect(function()
		joined.setSystemButtonActivated(v15)
	end, { joined.setSystemButtonActivated, v15 })

	local createElement = React.createElement
	local v17 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Active = true,
		AutoButtonColor = false,
		Selectable = if FFlagFixPaginatedChatMembersCutoff then false else nil
	}

	local v20 = if fFlagAppIaScrollAway and not fFlagAppIaScrollAwayFixSocial and not v8 and AppNavBar.getScrollAwayEnabled() and joined.topBarHeight ~= nil then React.createElement("UIPadding", {
		PaddingTop = UDim.new(0, joined.topBarHeight)
	}) else nil
	return createElement("ImageButton", v17, {
		UIPadding = v20,
		responseIndicator = state and React.createElement(responseIndicator, {
			soakAreaColor3 = Color3.fromRGB(25, 25, 25),
			soakAreaTransparency = 0.8
		}),
		selectChatMembers = React.createElement(
			SelectChatMembersContainer,
			Cryo.Dictionary.join(joined, {
				selectedUsersChanged = fn,
				maxSelections = v9,
				maxConversationSize = v10,
				canOnlyCreateOneToOneChat = v11
			})
		)
	})
end

return memo(LUAUFORGE_MODULE_GLOBALS_hsY_CreateNewChatContainer)
