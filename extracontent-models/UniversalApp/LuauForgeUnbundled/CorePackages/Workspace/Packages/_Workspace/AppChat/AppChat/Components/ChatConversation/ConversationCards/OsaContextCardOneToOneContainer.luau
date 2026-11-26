local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserProfiles")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ConversationCards/OsaContextCardOneToOne")
local getThumbnailsForUserIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Users/getThumbnailsForUserIds")
local useChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/useChatPagePadding")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxNetworking")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("OsaContextCardOneToOneContainer")

local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local useProfileName = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useProfileName")
local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration").DataStatus
local getCombinedNameFromId = UserProfiles.Selectors.getCombinedNameFromId
local getUsernameFromId = UserProfiles.Selectors.getUsernameFromId
local api = AppChatNetworking.rodux.GetConversationDetails.API

local useGetOneToOneFriendIdFromConversationId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetOneToOneFriendIdFromConversationId")
local useIsGuiInChatVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsGuiInChatVisible")
local useGetConversationFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetConversationFromId")

local useRecordModalSequenceResponseForConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useRecordModalSequenceResponseForConversation")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useIsChatUserMessagesEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatUserMessagesEnabled")

local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnableBlackbirdCheck
local FFlagAppChatUseUserProfileHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseUserProfileHydration")
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber

return React.memo(function(p2)
	local v6 = useDispatch()
	local v7 = useGetOneToOneFriendIdFromConversationId(p2.conversationId) or ""
	local v8 = useChatPagePadding()
	local v9 = React.useMemo(function()
		return { left = UDim.new(0, v8.left), right = UDim.new(0, v8.right) }
	end, { v8.left, v8.right })

	local v10 = useIsChatUserMessagesEnabled()
	local v12 = if fFlagEnableBlackbirdCheck and v7 ~= "" then v7 else nil
	local v13 = useIsRobloxSubscriber(v12)

	local v14 = nil
	local v15 = nil

	if FFlagAppChatUseUserProfileHydration then
		v15 = useProfileName(v7)
	else
		v14 = useUserProfilesFetch({
			userIds = { v7 },
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds,
			overrideRetryCount = 4
		})
	end

	local state, setState = React.useState(false)

	local v16 = useRecordModalSequenceResponseForConversation(p2.conversationId)

	local v17 = React.useCallback(function()
		if p2.openViewProfile then
			p2.openViewProfile(v7)
		end
	end, { v7 })

	local v18 = useGetConversationFromId(p2.conversationId)

	local v19 = v18
		and v18.osaAcknowledgementStatus == AppChatNetworking.Constants.OsaAcknowledgementStatusResponse.Unacknowledged

	local ref = React.useRef(nil)
	local v20 = useIsGuiInChatVisible(ref, { ref.current })

	if not v19 then
		v20 = false
	end

	local v21 = useSelector(function(p3)
		return AppChatNetworking.rodux.RecordModalSequenceResponse.getStatus(p3, p2.conversationId)
	end)

	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(nil)

	React.useEffect(function()
		if v19 and v20 and v21 ~= RoduxNetworking.Enum.NetworkStatus.Fetching and not state and v16 then
			v16("record_has_seen", "conversation_inline_top_modal", nil, "OsaContextCard"):andThen(function()
				setState(true)

				if v18 and v18.source ~= "friends" then
					v6(api(p2.conversationId))
				end
			end):catch(function(p3)
				v5:error("Error in OsaContextCardOneToOneContainer -> recordModalSequenceResponseForConversation -> record_has_seen: " .. tostring(p3))
			end)
		end
	end, { v19, v20, v21, v16, state, v6, p2.conversationId })

	local useEffect = React.useEffect
	local function fn()
		if not FFlagAppChatUseUserProfileHydration and v14.data and v7 then
			local usernameFromId = getUsernameFromId(v14.data, v7)
			local v23 = if usernameFromId then "@" .. usernameFromId else nil
			setState2(v23)
			setState3(getCombinedNameFromId(v14.data, v7))
		end
	end
	local v23 = if not FFlagAppChatUseUserProfileHydration then v14.data else nil
	useEffect(fn, { v7, v23 })

	local v24 = React.useMemo(function()
		return getThumbnailsForUserIds({ v7 })[1]
	end, { v7 })

	local createElement = React.createElement
	local view = Foundation.View

	local createElement2 = React.createElement

	if FFlagAppChatUseUserProfileHydration then
		state3 = v15.combinedName
	end

	if FFlagAppChatUseUserProfileHydration then
		state2 = if v15.username then "@" .. v15.username else nil
	end

	local v29 = if FFlagAppChatUseUserProfileHydration then v15.status == dataStatus.Failed else v14.error and true or false
	local v28 = {
		displayName = state3,
		username = state2,
		avatarThumbnail = v24,
		onAvatarActivated = v17,
		hasError = v29,
		isChatUserMessagesEnabled = v10,
		ref = ref,
		userId = v7,
		isRobloxSubscriber = nil
	}

	if not fFlagEnableBlackbirdCheck then
		v13 = nil
	end

	v28.isRobloxSubscriber = v13
	return createElement(
		view,
		{
			tag = "col size-full-0 auto-y align-x-center padding-top-xxlarge padding-bottom-large",
			padding = v9
		},
		{ OsaContextCardOneToOne = createElement2(module4, v28) }
	)
end)
