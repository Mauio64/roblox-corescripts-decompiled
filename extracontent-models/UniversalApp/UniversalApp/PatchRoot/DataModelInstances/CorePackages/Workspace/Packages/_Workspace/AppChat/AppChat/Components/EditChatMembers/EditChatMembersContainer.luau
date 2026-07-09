local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local SocialLibraries = require(AppChat.SocialLibraries)
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local Promise = require(AppChatParent.Promise)
local memo = React.memo
local useCallback = React.useCallback
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useState = React.useState
local useRef = React.useRef
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local createConversation = require(AppChat.Conversations.Thunks.createConversation)
local parseCreateConversationErrors = require(AppChat.Conversations.Thunks.parseCreateConversationErrors)
local expandToGroupConversation = require(AppChat.Conversations.Thunks.expandToGroupConversation)
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local ResponseIndicator = SocialLibraries.Components.ResponseIndicator
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local SelectChatMembersContainer = require(AppChat.Components.SelectChatMembers.SelectChatMembersContainer)
local Conversation = require(AppChat.Models.Conversation)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local t1 = {
	minSelections = 1,
	maxSelections = 5,
	maxConversationSize = 5,
	topBarHeight = nil,
	conversation = nil,
	systemButtonText = not GetFFlagIsSquadEnabled() and "Feature.Chat.Action.StartChatWithFriends" or "Feature.Chat.Action.Create",
	pageHeaderText = not GetFFlagIsSquadEnabled() and "Feature.Chat.Heading.ChatWithConnections" or "Feature.Chat.Heading.PartyWithConnections",
	setSystemButtonActivated = function(_) -- line: 70
	end,
	setSystemButtonEnabled = function(_) -- line: 71
	end
}

local function EditChatMembersContainer(t2: {[any]: any}) -- line: 75
	-- upvalues: Cryo (copy), t1 (copy), useRef (copy), useState (copy), useAnalytics (copy), useSelector (copy), useCallback (copy), useDispatch (copy), AppChatNetworking (copy), createConversation (copy), Promise (copy), parseCreateConversationErrors (copy), Conversation (copy), ConversationChannels (copy), expandToGroupConversation (copy), useEffect (copy), React (copy), ResponseIndicator (copy), SelectChatMembersContainer (copy)
	local v29 = Cryo.Dictionary.join(t1, t2)
	local v30 = useRef({})
	local v31 = useRef(false)
	local v32, v33 = useState(false)
	local v34 = useAnalytics()
	local v35 = useSelector(useCallback(function(p3) -- line: 82
		return p3.LocalUserId
	end, {}))
	local v36 = useDispatch()
	local v37 = useCallback(function(p4, p5) -- line: 88
		-- upvalues: v36 (copy), AppChatNetworking (copy)
		return v36(AppChatNetworking.rodux.AddUserToConversation.API(p5, p4))
	end, { v36 })
	local v38 = useCallback(function(p6) -- line: 92
		-- upvalues: v36 (copy), createConversation (copy), v34 (copy)
		return v36(createConversation("group", p6, v34, "userAddedParticipantToOneToOne"))
	end, { v36 })
	local v39 = useCallback(function(p7) -- line: 98
		-- upvalues: v29 (copy)
		v29.navigateToToast({
			toastProps = {
				toastContent = {
					toastTitle = p7
				}
			}
		})
	end, { v29.navigateToToast })
	local v40 = useCallback(function(p8) -- line: 120
		-- upvalues: v32 (copy), Promise (copy), v29 (copy), parseCreateConversationErrors (copy), v39 (copy), v33 (copy), Conversation (copy), v37 (copy), v30 (copy), ConversationChannels (copy), Cryo (copy), v35 (copy), v36 (copy), expandToGroupConversation (copy), v34 (copy), v38 (copy)
		if v32 then
			return Promise.resolve()
		end

		local id = v29.conversation.id
		local conversationType = v29.conversation.conversationType

		local function v52(p9) -- line: 126
			-- upvalues: parseCreateConversationErrors (copy), p8 (copy), v39 (copy), v33 (copy)
			local v58 = if parseCreateConversationErrors(p9) ~= "participant_chat_disabled" then p8.networkErrorText else p8.invalidParticipantText

			v39(v58)
			v33(false)
		end

		v33(true)

		if conversationType == Conversation.Type.MULTI_USER_CONVERSATION then
			return v37(v30.current, id):andThen(function() -- line: 138
				-- upvalues: v29 (copy), id (copy)
				v29.navigateToConversation(id)
			end, v52)
		end

		if conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION then
			if v29.conversation.hasGroupUp and v29.conversation.moderationType == ConversationChannels.ModerationType.TrustedComms then
				v39(p8.cannotExpandToGroupChatActivePartyText)
				v33(false)

				return Promise.reject("Cannot expand to group chat while there is an active party if the chat has expanded chat features")
			end

			local v53 = Cryo.List.filter(Cryo.List.join(v30.current, v29.conversation.participants), function(p10) -- line: 155
				-- upvalues: v35 (copy)
				return p10 ~= v35
			end)

			if v29.conversation.source == "channels" or v29.conversation.source == "chat" then
				return v36(expandToGroupConversation(id, v53, v34)):andThen(function(p11) -- line: 163
					-- upvalues: v29 (copy)
					v29.navigateToConversation(p11.id)
				end, v52)
			end

			return v38(v53):andThen(function(p12) -- line: 167
				-- upvalues: v29 (copy)
				v29.navigateToConversation(p12.id)
			end, v52)
		end

		local t3 = {
			Body = "conversationType not supported",
			StatusCode = 400
		}
		local v55 = if parseCreateConversationErrors(t3) ~= "participant_chat_disabled" then p8.networkErrorText else p8.invalidParticipantText

		v39(v55)
		v33(false)

		return Promise.reject(string.format("conversationType not supported: %q", (tostring(conversationType))))
	end, {
		v36,
		v32,
		v33,
		v30,
		v29.navigateToConversation,
		v29.conversation.id,
		v29.conversation.conversationType,
		v29.conversation.participants,
		v29.conversation.source,
		v39,
		v34
	})

	useEffect(function() -- line: 193
		-- upvalues: v29 (copy), v40 (copy)
		v29.setSystemButtonActivated(v40)
	end, {
		v29.setSystemButtonActivated,
		v40
	})

	return React.createElement("ImageButton", {
		BackgroundTransparency = 1,
		Active = true,
		AutoButtonColor = false,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		responseIndicator = v32 and React.createElement(ResponseIndicator, {
			soakAreaTransparency = 0.8,
			soakAreaColor3 = Color3.fromRGB(25, 25, 25)
		}),
		selectChatMembers = React.createElement(SelectChatMembersContainer, Cryo.Dictionary.join(v29, {
			maxSelections = v29.maxSelections - #v29.conversation.participants + 1,
			selectedUsersChanged = function(p13, p14) -- line: 108
				-- upvalues: v30 (copy), Cryo (copy), v31 (copy), v29 (copy)
				v30.current = Cryo.List.map(p13, function(p15) -- line: 109
					return p15.id
				end)

				local v48 = p14 <= #p13

				if v48 ~= v31.current then
					v31.current = v48
					v29.setSystemButtonEnabled(v48)
				end
			end,
			localUserId = v35
		}))
	})
end

return memo(EditChatMembersContainer)
