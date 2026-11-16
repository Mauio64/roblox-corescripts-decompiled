local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)

local SocialLibraries = require(AppChat.SocialLibraries)

local ResponseIndicator = SocialLibraries.Components.ResponseIndicator

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo
local Promise = require(parent.Promise)
local useCallback = React.useCallback
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useIsGroupChatEnabled = require(AppChat.Hooks.useIsGroupChatEnabled)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local useState = React.useState
local useRef = React.useRef
local AppNavBar = require(parent.AppNavBar)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)

local Conversation = require(AppChat.Models.Conversation)
require(AppChat.Models.ConversationChannels)
local createConversation = require(AppChat.Conversations.Thunks.createConversation)
local parseCreateConversationErrors = require(AppChat.Conversations.Thunks.parseCreateConversationErrors)
local SelectChatMembersContainer = require(AppChat.Components.SelectChatMembers.SelectChatMembersContainer)

local EventNames = require(AppChat.Analytics.EventNames)
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local CreateConversationError = require(AppChat.Analytics.Enums.CreateConversationError)
local SharedFlags = require(parent.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagAppIaScrollAwayFixSocial = SharedFlags.FFlagAppIaScrollAwayFixSocial
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagFixPaginatedChatMembersCutoff = require(AppChat.Flags.FFlagFixPaginatedChatMembersCutoff)

local v = {
	systemButtonText = GetFFlagIsSquadEnabled() and "Feature.Chat.Action.Create" or "Feature.Chat.Action.StartChatWithFriends",
	pageHeaderText = GetFFlagIsSquadEnabled() and (UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Chat.Title.NewChat" or "Feature.Chat.Heading.PartyWithFriends") or "Feature.Chat.Heading.ChatWithConnections",
	topBarHeight = nil,
	minSelections = 1,
	maxSelections = 5,
	maxConversationSize = 5,
	conversation = Conversation.empty(),
	setSystemButtonActivated = function(_) end,
	setSystemButtonEnabled = function(_) end
}

function CreateNewChatContainer(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useRef({})
	local v3 = useRef(false)
	local state, setState = useState(false)
	local v4

	if FFlagAppIaScrollAway and not FFlagAppIaScrollAwayFixSocial then
		v4 = useIsInExperience()
	end

	local maxSelections = joined.maxSelections
	local maxConversationSize = joined.maxConversationSize
	local canOnlyCreateOneToOneChat

	if useIsGroupChatEnabled() then
		canOnlyCreateOneToOneChat = false
	else
		maxSelections = 1
		maxConversationSize = 1
		canOnlyCreateOneToOneChat = true
	end

	local v5 = useDispatch()

	local v6 = useCallback(function(toastTitle)
		joined.navigateToToast({
			toastProps = {
				toastContent = { toastTitle = toastTitle }
			}
		})
	end, { joined.navigateToToast })

	local function fn(list, p2)
		v2.current = Cryo.List.map(list, function(p3)
			return p3.id
		end)

		local current = p2 <= #list

		if v3.current ~= current then
			v3.current = current
			joined.setSystemButtonEnabled(current)
		end
	end

	local v7 = useAnalytics()

	local v8 = useCallback(function(p2)
		if state or not v2.current then
			return Promise.resolve()
		end

		setState(true)

		return v5(createConversation(
			#v2.current == 1 and "one_to_one" or "group",
			v2.current,
			v7,
			"userCreatedNewConversation"
		)):andThen(function(p3)
			joined.navigateToConversation(p3.id)
		end):catch(function(p3)
			local v8

			if parseCreateConversationErrors(p3) == "participant_chat_disabled" then
				v8 = p2.invalidParticipantText
			else
				v8 = p2.networkErrorText
			end

			v6(v8)
			setState(false)

			if v7 then
				v7.fireAnalyticsEvent(EventNames.NewConversationCreated, {
					createConversationResult = CreateConversationError.FetchConversationError
				})
			end
		end)
	end, { v5, state, setState, v2, joined.navigateToConversation, v6, v7 })

	useEffect(function()
		joined.setSystemButtonActivated(v8)
	end, { joined.setSystemButtonActivated, v8 })

	local createElement = React.createElement
	local v9 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Active = true,
		AutoButtonColor = false,
		Selectable = not FFlagFixPaginatedChatMembersCutoff and nil
	}
	local uiPadding

	if
		FFlagAppIaScrollAway
		and not FFlagAppIaScrollAwayFixSocial
		and not v4
		and AppNavBar.getScrollAwayEnabled()
		and joined.topBarHeight ~= nil
	then
		uiPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, joined.topBarHeight)
		})
	end

	return createElement("ImageButton", v9, {
		UIPadding = uiPadding,
		responseIndicator = state and React.createElement(ResponseIndicator, {
			soakAreaColor3 = Color3.fromRGB(25, 25, 25),
			soakAreaTransparency = 0.8
		}),
		selectChatMembers = React.createElement(
			SelectChatMembersContainer,
			Cryo.Dictionary.join(joined, {
				selectedUsersChanged = fn,
				maxSelections = maxSelections,
				maxConversationSize = maxConversationSize,
				canOnlyCreateOneToOneChat = canOnlyCreateOneToOneChat
			})
		)
	})
end

return memo(CreateNewChatContainer)
