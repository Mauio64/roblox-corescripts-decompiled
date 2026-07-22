local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local ResponseIndicator = require(AppChat.SocialLibraries).Components.ResponseIndicator
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local Promise = require(AppChatParent.Promise)
local useCallback = React.useCallback
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useIsGroupChatEnabled = require(AppChat.Hooks.useIsGroupChatEnabled)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local useState = React.useState
local useRef = React.useRef
local AppNavBar = require(AppChatParent.AppNavBar)
local UniversalAppPolicy = require(AppChatParent.UniversalAppPolicy)
local Conversation = require(AppChat.Models.Conversation)

require(AppChat.Models.ConversationChannels)

local createConversation = require(AppChat.Conversations.Thunks.createConversation)
local parseCreateConversationErrors = require(AppChat.Conversations.Thunks.parseCreateConversationErrors)
local SelectChatMembersContainer = require(AppChat.Components.SelectChatMembers.SelectChatMembersContainer)
local EventNames = require(AppChat.Analytics.EventNames)
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local CreateConversationError = require(AppChat.Analytics.Enums.CreateConversationError)
local SharedFlags = require(AppChatParent.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagAppIaScrollAwayFixSocial = SharedFlags.FFlagAppIaScrollAwayFixSocial
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagAppChatNewChatFixEnabled = SharedFlags.FFlagAppChatNewChatFixEnabled
local ArgoPartyExperimentation = require(AppChatParent.SocialExperiments).ArgoPartyExperimentation
local t1 = {
	topBarHeight = nil,
	minSelections = 1,
	maxSelections = 5,
	maxConversationSize = 5,
	systemButtonText = not GetFFlagIsSquadEnabled() and "Feature.Chat.Action.StartChatWithFriends" or "Feature.Chat.Action.Create",
	pageHeaderText = not GetFFlagIsSquadEnabled() and "Feature.Chat.Heading.ChatWithConnections" or if not ArgoPartyExperimentation.getIsRenameEnabled() then not FFlagConnectionsToFriendsRename and "Feature.Chat.Heading.PartyWithConnections" or "Feature.Chat.Heading.PartyWithFriends" else not UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Chat.Heading.PartyWithFriends" or (not FFlagAppChatNewChatFixEnabled and "Feature.Chat.Heading.ChatWithFriends" or "Feature.Chat.Title.NewChat"),
	conversation = Conversation.empty(),
	setSystemButtonActivated = function(_) -- line: 87
	end,
	setSystemButtonEnabled = function(_) -- line: 88
	end
}

function CreateNewChatContainer(t2: {[any]: any}) -- line: 92
	-- upvalues: Cryo (copy), t1 (copy), useRef (copy), useState (copy), FFlagAppIaScrollAway (copy), FFlagAppIaScrollAwayFixSocial (copy), useIsInExperience (copy), useIsGroupChatEnabled (copy), useDispatch (copy), useCallback (copy), useAnalytics (copy), Promise (copy), createConversation (copy), parseCreateConversationErrors (copy), EventNames (copy), CreateConversationError (copy), useEffect (copy), React (copy), AppNavBar (copy), ResponseIndicator (copy), SelectChatMembersContainer (copy)
	local v35 = Cryo.Dictionary.join(t1, t2)
	local v36 = useRef({})
	local v37 = useRef(false)
	local v38, v39 = useState(false)
	local v40 = if not FFlagAppIaScrollAway or FFlagAppIaScrollAwayFixSocial then nil else useIsInExperience()
	local maxSelections = v35.maxSelections
	local maxConversationSize = v35.maxConversationSize
	local v43 = false

	if not useIsGroupChatEnabled() then
		maxSelections = 1
		maxConversationSize = 1
		v43 = true
	end

	local v44 = useDispatch()
	local v45 = useCallback(function(p3) -- line: 113
		-- upvalues: v35 (copy)
		v35.navigateToToast({
			toastProps = {
				toastContent = {
					toastTitle = p3
				}
			}
		})
	end, { v35.navigateToToast })
	local v46 = useAnalytics()
	local v47 = useCallback(function(p4) -- line: 137
		-- upvalues: v38 (copy), v36 (copy), Promise (copy), v39 (copy), v44 (copy), createConversation (copy), v46 (copy), v35 (copy), parseCreateConversationErrors (copy), v45 (copy), EventNames (copy), CreateConversationError (copy)
		if v38 or not v36.current then
			return Promise.resolve()
		end

		v39(true)

		local v53 = #v36.current ~= 1 and "group" or "one_to_one"

		return v44(createConversation(v53, v36.current, v46, "userCreatedNewConversation")):andThen(function(p5) -- line: 158
			-- upvalues: v35 (copy)
			v35.navigateToConversation(p5.id)
		end):catch(function(p6) -- line: 162
			-- upvalues: parseCreateConversationErrors (copy), p4 (copy), v45 (copy), v39 (copy), v46 (copy), EventNames (copy), CreateConversationError (copy)
			local v57 = if parseCreateConversationErrors(p6) ~= "participant_chat_disabled" then p4.networkErrorText else p4.invalidParticipantText

			v45(v57)
			v39(false)

			if v46 then
				v46.fireAnalyticsEvent(EventNames.NewConversationCreated, {
					createConversationResult = CreateConversationError.FetchConversationError
				})
			end
		end)
	end, {
		v44,
		v38,
		v39,
		v36,
		v35.navigateToConversation,
		v45,
		v46
	})

	useEffect(function() -- line: 192
		-- upvalues: v35 (copy), v47 (copy)
		v35.setSystemButtonActivated(v47)
	end, {
		v35.setSystemButtonActivated,
		v47
	})

	return React.createElement("ImageButton", {
		BackgroundTransparency = 1,
		Active = true,
		AutoButtonColor = false,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		UIPadding = if not FFlagAppIaScrollAway or (FFlagAppIaScrollAwayFixSocial or (v40 or (not AppNavBar.getScrollAwayEnabled() or v35.topBarHeight == nil))) then nil else React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v35.topBarHeight)
		}),
		responseIndicator = v38 and React.createElement(ResponseIndicator, {
			soakAreaTransparency = 0.8,
			soakAreaColor3 = Color3.fromRGB(25, 25, 25)
		}),
		selectChatMembers = React.createElement(SelectChatMembersContainer, Cryo.Dictionary.join(v35, {
			selectedUsersChanged = function(p7, p8) -- line: 123
				-- upvalues: v36 (copy), Cryo (copy), v37 (copy), v35 (copy)
				v36.current = Cryo.List.map(p7, function(p9) -- line: 124
					return p9.id
				end)

				local v51 = p8 <= #p7

				if v51 ~= v37.current then
					v37.current = v51
					v35.setSystemButtonEnabled(v51)
				end
			end,
			maxSelections = maxSelections,
			maxConversationSize = maxConversationSize,
			canOnlyCreateOneToOneChat = v43
		}))
	})
end

return memo(CreateNewChatContainer)
