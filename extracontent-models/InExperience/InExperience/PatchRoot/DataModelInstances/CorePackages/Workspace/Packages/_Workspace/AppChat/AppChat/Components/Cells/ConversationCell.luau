local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local Images = require(AppChatParent.UIBlox).App.ImageSet.Images
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local FocusNavigationUtils = require(AppChatParent.FocusNavigationUtils)
local useNavigation = require(AppChatParent.Navigation).useNavigation
local EnumScreens = require(AppChat.EnumScreens)
local TestStyle = require(AppChat.SocialLibraries).Components.TestStyle
local useIsUserPending = require(AppChat.Hooks.useIsUserPending)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local getConversationTitle = require(AppChat.Conversations.getConversationTitle)
local usePageTracker = require(AppChatParent.PageLoadTracker).usePageTracker
local FFlagLuaAppEnableChatMilestones = require(AppChatParent.SharedFlags).FFlagLuaAppEnableChatMilestones
local FFlagLuaAppEnablePageLoadTracker = require(AppChatParent.SharedFlags).FFlagLuaAppEnablePageLoadTracker
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagEnableBlackbirdCheck = require(AppChatParent.SharedFlags).FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = require(AppChatParent.UserProfiles).Hooks.useIsRobloxSubscriber
local useGetOneToOneFriendIdFromConversationId = require(AppChat.Hooks.useGetOneToOneFriendIdFromConversationId)
local useConversationAvatarPresenceImage = require(AppChat.Hooks.useConversationAvatarPresenceImage)
local PresenceBubbleCellStyled = require(script.Parent.PresenceBubbleCellStyled)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)
local t1 = {
	messageUnavailableKey = "Feature.Chat.Message.MessageUnavailable",
	boldTitle = true,
	childWidth = 0,
	isLoading = false,
	hideLeftAvatarPadding = false,
	Size = UDim2.new(1, 0, 1, 0),
	style = Cryo.Dictionary.join(TestStyle, {
		Tokens = {
			Color = {
				None = {}
			}
		}
	})
}

local function ConversationCell(t2: {[any]: any}) -- line: 69
	-- upvalues: Cryo (copy), t1 (copy), useIsUserPending (copy), useIsInExperience (copy), useGetOneToOneFriendIdFromConversationId (copy), FFlagEnableBlackbirdCheck (copy), useIsRobloxSubscriber (copy), FFlagAppChatPresenceStoreMigration (copy), useConversationAvatarPresenceImage (copy), FocusNavigationUtils (copy), useNavigation (copy), FFlagLuaAppEnablePageLoadTracker (copy), FFlagLuaAppEnableChatMilestones (copy), usePageTracker (copy), React (copy), EnumScreens (copy), getConversationTitle (copy), useLocalization (copy), PresenceBubbleCellStyled (copy), Images (copy), FFlagDebugAppChatEnableDomLocators (copy)
	local v27 = Cryo.Dictionary.join(t1, t2)
	local conversation = v27.conversation
	local v29 = useIsUserPending(conversation or {})
	local v30 = useIsInExperience()
	local v31 = useGetOneToOneFriendIdFromConversationId(conversation and conversation.id)
	local v32 = if not FFlagEnableBlackbirdCheck then nil else v31
	local v33 = useIsRobloxSubscriber(v32)
	local v34 = if not FFlagAppChatPresenceStoreMigration then nil else useConversationAvatarPresenceImage(v31)
	local v35 = FocusNavigationUtils.useLastInputMode()
	local v36 = useNavigation()
	local u37 = nil

	if FFlagLuaAppEnablePageLoadTracker and FFlagLuaAppEnableChatMilestones then
		u37 = usePageTracker()
	end

	React.useEffect(function() -- line: 91
		-- upvalues: FFlagLuaAppEnablePageLoadTracker (copy), FFlagLuaAppEnableChatMilestones (copy), v30 (copy), u37 (ref)
		if FFlagLuaAppEnablePageLoadTracker and (FFlagLuaAppEnableChatMilestones and not v30) then
			u37:sendMilestone("main_cta_interactable")
		end
	end, {})

	local v38 = React.useCallback(function() -- line: 99
		-- upvalues: v35 (copy), v36 (copy), EnumScreens (copy), v27 (copy)
		if v35 == "Focus" and v36 then
			v36.navigate(EnumScreens.ChatConversation, {
				navigatedWithFocus = true,
				conversationId = v27.conversation.id
			})

			return
		end

		if v27.onActivated then
			v27.onActivated(v27.conversation)
		end
	end, {
		v27.onActivated,
		v27.conversation,
		v35,
		v36
	})
	local v39 = getConversationTitle(conversation)
	local v40 = v27.subTitleText and v27.subTitleText:split("\n")
	local v41 = v40 and v40[1] or ""
	local v42 = useLocalization({
		subTitleText = v27.messageUnavailableKey
	})

	if v29 then
		v41 = v42.subTitleText
	end

	return React.createElement(PresenceBubbleCellStyled, {
		boldTitle = v27.boldTitle,
		style = v27.style,
		childWidth = v27.childWidth,
		onActivated = v38,
		onCircleActivated = v27.onCircleActivated,
		subTitleText = v41,
		subTitleTimestamp = v27.subTitleTimestamp,
		subTitleIcon = v29 and Images["icons/status/private_small"] or nil,
		secondaryTitleText = v27.secondaryTitleText,
		testId = if not FFlagDebugAppChatEnableDomLocators then nil else v27.testId,
		Size = v27.Size,
		isLoading = v27.isLoading,
		avatarCirclePresenceImage = if not FFlagAppChatPresenceStoreMigration then conversation.presenceImage else v34,
		titleText = v39,
		thumbnails = conversation.thumbnails,
		conversationId = conversation.id,
		hideLeftAvatarPadding = v27.hideLeftAvatarPadding,
		paddingLeft = v27.paddingLeft,
		paddingRight = v27.paddingRight,
		isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else v33
	}, v27.children or {})
end

return React.memo(ConversationCell)
