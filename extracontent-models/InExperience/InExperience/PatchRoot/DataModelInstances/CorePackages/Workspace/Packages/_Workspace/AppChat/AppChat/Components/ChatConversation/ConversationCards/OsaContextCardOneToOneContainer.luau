local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Foundation = require(AppChatParent.Foundation)
local React = require(AppChatParent.React)
local UserProfiles = require(AppChatParent.UserProfiles)
local OsaContextCardOneToOne = require(AppChat.Components.ChatConversation.ConversationCards.OsaContextCardOneToOne)
local getThumbnailsForUserIds = require(AppChat.Users.getThumbnailsForUserIds)
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local RoduxNetworking = require(AppChat.Http.RoduxNetworking)
local v12 = require(AppChat.Logger):new(script.Name)
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local getCombinedNameFromId = UserProfiles.Selectors.getCombinedNameFromId
local getUsernameFromId = UserProfiles.Selectors.getUsernameFromId
local API = AppChatNetworking.rodux.GetConversationDetails.API
local useGetOneToOneFriendIdFromConversationId = require(AppChat.Hooks.useGetOneToOneFriendIdFromConversationId)
local useIsGuiInChatVisible = require(AppChat.Hooks.useIsGuiInChatVisible)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local useRecordModalSequenceResponseForConversation = require(AppChat.Hooks.useRecordModalSequenceResponseForConversation)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useIsChatUserMessagesEnabled = require(AppChat.Hooks.useIsChatUserMessagesEnabled)
local FFlagEnableBlackbirdCheck = require(AppChatParent.SharedFlags).FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber

return React.memo(function(t1: {[any]: any}) -- line: 37
	-- upvalues: useDispatch (copy), useGetOneToOneFriendIdFromConversationId (copy), useChatPagePadding (copy), React (copy), useIsChatUserMessagesEnabled (copy), useIsRobloxSubscriber (copy), FFlagEnableBlackbirdCheck (copy), useUserProfilesFetch (copy), UserProfiles (copy), useRecordModalSequenceResponseForConversation (copy), useGetConversationFromId (copy), AppChatNetworking (copy), useIsGuiInChatVisible (copy), useSelector (copy), RoduxNetworking (copy), API (copy), v12 (copy), getUsernameFromId (copy), getCombinedNameFromId (copy), getThumbnailsForUserIds (copy), Foundation (copy), OsaContextCardOneToOne (copy)
	local v26 = useDispatch()
	local v27 = useGetOneToOneFriendIdFromConversationId(t1.conversationId) or ""
	local v28 = useChatPagePadding()
	local v29 = React.useMemo(function() -- line: 41
		-- upvalues: v28 (copy)
		return {
			left = UDim.new(0, v28.left),
			right = UDim.new(0, v28.right)
		}
	end, {
		v28.left,
		v28.right
	})
	local v30 = useIsChatUserMessagesEnabled()
	local v31 = useIsRobloxSubscriber(if not FFlagEnableBlackbirdCheck or v27 == "" then nil else v27)
	local v32 = useUserProfilesFetch({
		overrideRetryCount = 4,
		userIds = { v27 },
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})
	local v33, v34 = React.useState(false)
	local v35 = useRecordModalSequenceResponseForConversation(t1.conversationId)
	local v36 = React.useCallback(function() -- line: 64
		-- upvalues: t1 (copy), v27 (copy)
		if t1.openViewProfile then
			t1.openViewProfile(v27)
		end
	end, { v27 })
	local v37 = useGetConversationFromId(t1.conversationId)
	local v38 = v37 and v37.osaAcknowledgementStatus == AppChatNetworking.Constants.OsaAcknowledgementStatusResponse.Unacknowledged
	local v39 = React.useRef(nil)
	local v40 = useIsGuiInChatVisible(v39, { v39.current })
	local v41 = not not v38 and v40
	local v42 = useSelector(function(p1) -- line: 79
		-- upvalues: AppChatNetworking (copy), t1 (copy)
		return AppChatNetworking.rodux.RecordModalSequenceResponse.getStatus(p1, t1.conversationId)
	end)
	local v43, v44 = React.useState(nil)
	local v45, v46 = React.useState(nil)

	React.useEffect(function() -- line: 87
		-- upvalues: v38 (copy), v41 (copy), v42 (copy), RoduxNetworking (copy), v33 (copy), v35 (copy), v34 (copy), v37 (copy), v26 (copy), API (copy), t1 (copy), v12 (copy)
		if v38 and (v41 and v42 ~= RoduxNetworking.Enum.NetworkStatus.Fetching and not v33 and v35) then
			v35("record_has_seen", "conversation_inline_top_modal", nil, "OsaContextCard"):andThen(function() -- line: 96
				-- upvalues: v34 (copy), v37 (copy), v26 (copy), API (copy), t1 (copy)
				v34(true)

				if v37 and v37.source ~= "friends" then
					v26(API(t1.conversationId))
				end
			end):catch(function(p2) -- line: 104
				-- upvalues: v12 (copy)
				v12:error("Error in OsaContextCardOneToOneContainer -> recordModalSequenceResponseForConversation -> record_has_seen: " .. tostring(p2))
			end)
		end
	end, {
		v38,
		v41,
		v42,
		v35,
		v33,
		v26,
		t1.conversationId
	})
	React.useEffect(function() -- line: 123
		-- upvalues: v32 (copy), v27 (copy), getUsernameFromId (copy), v44 (copy), v46 (copy), getCombinedNameFromId (copy)
		if v32.data and v27 then
			local v49 = getUsernameFromId(v32.data, v27)

			v44(if not v49 then nil else "@" .. v49)
			v46(getCombinedNameFromId(v32.data, v27))
		end
	end, {
		v32.data,
		v27
	})

	local v47 = React.useMemo(function() -- line: 131
		-- upvalues: getThumbnailsForUserIds (copy), v27 (copy)
		return getThumbnailsForUserIds({ v27 })[1]
	end, { v27 })

	return React.createElement(Foundation.View, {
		tag = "col size-full-0 auto-y align-x-center padding-top-xxlarge padding-bottom-large",
		padding = v29
	}, {
		OsaContextCardOneToOne = React.createElement(OsaContextCardOneToOne, {
			displayName = v45,
			username = v43,
			avatarThumbnail = v47,
			onAvatarActivated = v36,
			hasError = not not v32.error,
			isChatUserMessagesEnabled = v30,
			ref = v39,
			userId = v27,
			isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else v31
		})
	})
end)
