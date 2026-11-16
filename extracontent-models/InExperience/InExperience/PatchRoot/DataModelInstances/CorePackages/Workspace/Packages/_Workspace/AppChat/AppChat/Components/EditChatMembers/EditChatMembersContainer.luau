local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)
local SocialLibraries = require(AppChat.SocialLibraries)

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Promise = require(parent.Promise)
local memo = React.memo
local useCallback = React.useCallback
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local useState = React.useState
local useRef = React.useRef

local AppChatNetworking = require(parent.AppChatNetworking)
local createConversation = require(AppChat.Conversations.Thunks.createConversation)
local parseCreateConversationErrors = require(AppChat.Conversations.Thunks.parseCreateConversationErrors)
local expandToGroupConversation = require(AppChat.Conversations.Thunks.expandToGroupConversation)
local useAnalytics = require(AppChat.Analytics.useAnalytics)

local ResponseIndicator = SocialLibraries.Components.ResponseIndicator
local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local SelectChatMembersContainer = require(AppChat.Components.SelectChatMembers.SelectChatMembersContainer)

local Conversation = require(AppChat.Models.Conversation)
local ConversationChannels = require(AppChat.Models.ConversationChannels)

local v = {
	systemButtonText = GetFFlagIsSquadEnabled() and "Feature.Chat.Action.Create" or "Feature.Chat.Action.StartChatWithFriends",
	pageHeaderText = GetFFlagIsSquadEnabled() and "Feature.Chat.Heading.PartyWithConnections" or "Feature.Chat.Heading.ChatWithConnections",
	minSelections = 1,
	maxSelections = 5,
	maxConversationSize = 5,
	topBarHeight = nil,
	conversation = nil,
	setSystemButtonActivated = function(_) end,
	setSystemButtonEnabled = function(_) end
}

local function EditChatMembersContainer(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useRef({})
	local v3 = useRef(false)
	local state, setState = useState(false)
	local v4 = useAnalytics()

	local localUserId = useSelector(useCallback(function(p2)
		return p2.LocalUserId
	end, {}))

	local v5 = useDispatch()

	local v6 = useCallback(function(p2, p3)
		return v5(AppChatNetworking.rodux.AddUserToConversation.API(p3, p2))
	end, { v5 })

	local v7 = useCallback(function(p2)
		return v5(createConversation("group", p2, v4, "userAddedParticipantToOneToOne"))
	end, { v5 })

	local v8 = useCallback(function(toastTitle)
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

	local v9 = useCallback(function(data)
		if state then
			return Promise.resolve()
		end

		local id = joined.conversation.id
		local conversationType = joined.conversation.conversationType
		local function fn2(p2) -- 1 equivalent call inferred from this helper
			local v9

			if parseCreateConversationErrors(p2) == "participant_chat_disabled" then
				v9 = data.invalidParticipantText
			else
				v9 = data.networkErrorText
			end

			v8(v9)
			setState(false)
		end

		setState(true)

		if conversationType == Conversation.Type.MULTI_USER_CONVERSATION then
			return v6(v2.current, id):andThen(function()
				joined.navigateToConversation(id)
			end, fn2)
		end

		if conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION then
			if
				joined.conversation.hasGroupUp
				and joined.conversation.moderationType == ConversationChannels.ModerationType.TrustedComms
			then
				v8(data.cannotExpandToGroupChatActivePartyText)
				setState(false)
				return Promise.reject("Cannot expand to group chat while there is an active party if the chat has expanded chat features")
			else
				local filtered = Cryo.List.filter(
					Cryo.List.join(v2.current, joined.conversation.participants),
					function(p2): boolean
						return p2 ~= localUserId
					end
				)

				if joined.conversation.source == "channels" or joined.conversation.source == "chat" then
					return v5(expandToGroupConversation(id, filtered, v4)):andThen(function(p2)
						joined.navigateToConversation(p2.id)
					end, fn2)
				end

				return v7(filtered):andThen(function(p2)
					joined.navigateToConversation(p2.id)
				end, fn2)
			end
		else
			fn2({ Body = "conversationType not supported", StatusCode = 400 }) -- inferred equivalent call
			return Promise.reject(string.format("conversationType not supported: %q", (tostring(conversationType))))
		end
	end, {
		v5,
		state,
		setState,
		v2,
		joined.navigateToConversation,
		joined.conversation.id,
		joined.conversation.conversationType,
		joined.conversation.participants,
		joined.conversation.source,
		v8,
		v4
	})

	useEffect(function()
		joined.setSystemButtonActivated(v9)
	end, { joined.setSystemButtonActivated, v9 })

	return React.createElement(
		"ImageButton",
		{
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Active = true,
			AutoButtonColor = false
		},
		{
			responseIndicator = state and React.createElement(ResponseIndicator, {
				soakAreaColor3 = Color3.fromRGB(25, 25, 25),
				soakAreaTransparency = 0.8
			}),
			selectChatMembers = React.createElement(SelectChatMembersContainer, Cryo.Dictionary.join(joined, {
				maxSelections = joined.maxSelections - #joined.conversation.participants + 1,
				selectedUsersChanged = fn,
				localUserId = localUserId
			}))
		}
	)
end

return memo(EditChatMembersContainer)
