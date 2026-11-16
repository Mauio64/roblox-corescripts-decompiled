local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local UserProfiles = require(parent.UserProfiles)
local OsaContextCardOneToOne = require(AppChat.Components.ChatConversation.ConversationCards.OsaContextCardOneToOne)
local getThumbnailsForUserIds = require(AppChat.Users.getThumbnailsForUserIds)
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local AppChatNetworking = require(parent.AppChatNetworking)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RoduxNetworking = require(AppChat.Http.RoduxNetworking)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local useProfileName = require(AppChat.Hooks.useProfileName)
local DataHydration = require(parent.DataHydration)
local DataStatus = DataHydration.DataStatus
local getCombinedNameFromId = UserProfiles.Selectors.getCombinedNameFromId
local getUsernameFromId = UserProfiles.Selectors.getUsernameFromId
local api = AppChatNetworking.rodux.GetConversationDetails.API

local useGetOneToOneFriendIdFromConversationId = require(AppChat.Hooks.useGetOneToOneFriendIdFromConversationId)
local useIsGuiInChatVisible = require(AppChat.Hooks.useIsGuiInChatVisible)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)

local useRecordModalSequenceResponseForConversation = require(AppChat.Hooks.useRecordModalSequenceResponseForConversation)
local RoactUtils2 = require(parent.RoactUtils)
local useDispatch = RoactUtils2.Hooks.RoactRodux.useDispatch
local useIsChatUserMessagesEnabled = require(AppChat.Hooks.useIsChatUserMessagesEnabled)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagAppChatUseUserProfileHydration = require(AppChat.Flags.FFlagAppChatUseUserProfileHydration)
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber

return React.memo(function(p)
	local v2 = useDispatch()
	local userId = useGetOneToOneFriendIdFromConversationId(p.conversationId) or ""
	local v3 = useChatPagePadding()
	local padding = React.useMemo(function()
		return { left = UDim.new(0, v3.left), right = UDim.new(0, v3.right) }
	end, { v3.left, v3.right })

	local isChatUserMessagesEnabled = useIsChatUserMessagesEnabled()
	local v4

	if FFlagEnableBlackbirdCheck and userId ~= "" then
		v4 = userId
	end

	local isRobloxSubscriber = useIsRobloxSubscriber(v4)

	local v5 = nil
	local v6 = nil

	if FFlagAppChatUseUserProfileHydration then
		v6 = useProfileName(userId)
	else
		v5 = useUserProfilesFetch({
			userIds = { userId },
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds,
			overrideRetryCount = 4
		})
	end

	local state, setState = React.useState(false)

	local v7 = useRecordModalSequenceResponseForConversation(p.conversationId)

	local onAvatarActivated = React.useCallback(function()
		if p.openViewProfile then
			p.openViewProfile(userId)
		end
	end, { userId })

	local v8 = useGetConversationFromId(p.conversationId)

	local v9 = v8
		and v8.osaAcknowledgementStatus == AppChatNetworking.Constants.OsaAcknowledgementStatusResponse.Unacknowledged

	local ref = React.useRef(nil)
	local v10 = useIsGuiInChatVisible(ref, { ref.current })

	if not v9 then
		v10 = false
	end

	local v11 = useSelector(function(p2)
		return AppChatNetworking.rodux.RecordModalSequenceResponse.getStatus(p2, p.conversationId)
	end)

	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(nil)

	React.useEffect(function()
		if v9 and v10 and v11 ~= RoduxNetworking.Enum.NetworkStatus.Fetching and not state and v7 then
			v7("record_has_seen", "conversation_inline_top_modal", nil, "OsaContextCard"):andThen(function()
				setState(true)

				if v8 and v8.source ~= "friends" then
					v2(api(p.conversationId))
				end
			end):catch(function(p2)
				v:error("Error in OsaContextCardOneToOneContainer -> recordModalSequenceResponseForConversation -> record_has_seen: " .. tostring(p2))
			end)
		end
	end, { v9, v10, v11, v7, state, v2, p.conversationId })

	local useEffect = React.useEffect
	local function fn()
		if not FFlagAppChatUseUserProfileHydration and v5.data and userId then
			local usernameFromId = getUsernameFromId(v5.data, userId)
			local v12

			if usernameFromId then
				v12 = "@" .. usernameFromId
			end

			setState2(v12)
			setState3(getCombinedNameFromId(v5.data, userId))
		end
	end

	local v12

	if not FFlagAppChatUseUserProfileHydration then
		v12 = v5.data
	end

	useEffect(fn, { userId, v12 })

	local avatarThumbnail = React.useMemo(function()
		return getThumbnailsForUserIds({ userId })[1]
	end, { userId })

	local createElement = React.createElement
	local view = Foundation.View

	local createElement2 = React.createElement

	if FFlagAppChatUseUserProfileHydration then
		state3 = v6.combinedName
	end

	if FFlagAppChatUseUserProfileHydration then
		if v6.username then
			state2 = "@" .. v6.username
		else
			state2 = nil
		end
	end

	local hasError

	if FFlagAppChatUseUserProfileHydration then
		hasError = v6.status == DataStatus.Failed
	else
		hasError = v5.error and true or false
	end

	local v13 = {
		displayName = state3,
		username = state2,
		avatarThumbnail = avatarThumbnail,
		onAvatarActivated = onAvatarActivated,
		hasError = hasError,
		isChatUserMessagesEnabled = isChatUserMessagesEnabled,
		ref = ref,
		userId = userId,
		isRobloxSubscriber = nil
	}

	if not FFlagEnableBlackbirdCheck then
		isRobloxSubscriber = nil
	end

	v13.isRobloxSubscriber = isRobloxSubscriber
	return createElement(
		view,
		{
			tag = "col size-full-0 auto-y align-x-center padding-top-xxlarge padding-bottom-large",
			padding = padding
		},
		{
			OsaContextCardOneToOne = createElement2(OsaContextCardOneToOne, v13)
		}
	)
end)
