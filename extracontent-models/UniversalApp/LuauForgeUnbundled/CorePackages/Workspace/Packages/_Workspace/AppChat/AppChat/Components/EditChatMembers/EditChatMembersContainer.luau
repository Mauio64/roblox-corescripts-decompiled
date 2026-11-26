require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local SocialLibraries = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local memo = React.memo
local useCallback = React.useCallback
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useState = React.useState
local useRef = React.useRef

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local createConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/createConversation")
local parseCreateConversationErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/parseCreateConversationErrors")
local expandToGroupConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/expandToGroupConversation")
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/useAnalytics")

local responseIndicator = SocialLibraries.Components.ResponseIndicator
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagIsSquadEnabled
local SelectChatMembersContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/SelectChatMembers/SelectChatMembersContainer")

local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")

local v5 = {
	systemButtonText = getFFlagIsSquadEnabled() and "Feature.Chat.Action.Create" or "Feature.Chat.Action.StartChatWithFriends",
	pageHeaderText = getFFlagIsSquadEnabled() and "Feature.Chat.Heading.PartyWithConnections" or "Feature.Chat.Heading.ChatWithConnections",
	minSelections = 1,
	maxSelections = 5,
	maxConversationSize = 5,
	topBarHeight = nil,
	conversation = nil,
	setSystemButtonActivated = function(p2) end,
	setSystemButtonEnabled = function(p2) end
}

local function EditChatMembersContainer(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useRef({})
	local v7 = useRef(false)
	local state, setState = useState(false)
	local v8 = useAnalytics()

	local v9 = useSelector(useCallback(function(p3)
		return p3.LocalUserId
	end, {}))

	local v10 = useDispatch()

	local v11 = useCallback(function(p3, p4)
		return v10(AppChatNetworking.rodux.AddUserToConversation.API(p4, p3))
	end, { v10 })

	local v12 = useCallback(function(p3)
		return v10(createConversation("group", p3, v8, "userAddedParticipantToOneToOne"))
	end, { v10 })

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

	local v14 = useCallback(function(data)
		if state then
			return Promise.resolve()
		end

		local id = joined.conversation.id
		local conversationType = joined.conversation.conversationType
		local function fn2(p3)
			local v15 = if parseCreateConversationErrors(p3) == "participant_chat_disabled" then data.invalidParticipantText else data.networkErrorText

			v13(v15)
			setState(false)
		end

		setState(true)

		if conversationType == Conversation.Type.MULTI_USER_CONVERSATION then
			return v11(v6.current, id):andThen(function()
				joined.navigateToConversation(id)
			end, fn2)
		end

		if conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION then
			if
				joined.conversation.hasGroupUp
				and joined.conversation.moderationType == ConversationChannels.ModerationType.TrustedComms
			then
				v13(data.cannotExpandToGroupChatActivePartyText)
				setState(false)
				return Promise.reject("Cannot expand to group chat while there is an active party if the chat has expanded chat features")
			else
				local filtered = Cryo.List.filter(
					Cryo.List.join(v6.current, joined.conversation.participants),
					function(p3): boolean
						return p3 ~= v9
					end
				)

				if joined.conversation.source == "channels" or joined.conversation.source == "chat" then
					return v10(expandToGroupConversation(id, filtered, v8)):andThen(function(p3)
						joined.navigateToConversation(p3.id)
					end, fn2)
				end

				return v12(filtered):andThen(function(p3)
					joined.navigateToConversation(p3.id)
				end, fn2)
			end
		else
			local v15 = if parseCreateConversationErrors({
				Body = "conversationType not supported",
				StatusCode = 400
			}) == "participant_chat_disabled" then data.invalidParticipantText else data.networkErrorText
			v13(v15)
			setState(false)

			return Promise.reject(string.format(
				"conversationType not supported: %q",
				(tostring(conversationType))
			))
		end
	end, {
		v10,
		state,
		setState,
		v6,
		joined.navigateToConversation,
		joined.conversation.id,
		joined.conversation.conversationType,
		joined.conversation.participants,
		joined.conversation.source,
		v13,
		v8
	})

	useEffect(function()
		joined.setSystemButtonActivated(v14)
	end, { joined.setSystemButtonActivated, v14 })

	return React.createElement(
		"ImageButton",
		{
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Active = true,
			AutoButtonColor = false
		},
		{
			responseIndicator = state and React.createElement(responseIndicator, {
				soakAreaColor3 = Color3.fromRGB(25, 25, 25),
				soakAreaTransparency = 0.8
			}),
			selectChatMembers = React.createElement(SelectChatMembersContainer, Cryo.Dictionary.join(joined, {
				maxSelections = joined.maxSelections - #joined.conversation.participants + 1,
				selectedUsersChanged = fn,
				localUserId = v9
			}))
		}
	)
end

return memo(EditChatMembersContainer)
