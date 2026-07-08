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
local PresenceBubbleCellStyled = require(script.Parent.PresenceBubbleCellStyled)
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

local function ConversationCell(t2: {[any]: any}) -- line: 67
	-- upvalues: Cryo (copy), t1 (copy), useIsUserPending (copy), useIsInExperience (copy), useGetOneToOneFriendIdFromConversationId (copy), FFlagEnableBlackbirdCheck (copy), useIsRobloxSubscriber (copy), FocusNavigationUtils (copy), useNavigation (copy), FFlagLuaAppEnablePageLoadTracker (copy), FFlagLuaAppEnableChatMilestones (copy), usePageTracker (copy), React (copy), EnumScreens (copy), getConversationTitle (copy), useLocalization (copy), PresenceBubbleCellStyled (copy), Images (copy), FFlagDebugAppChatEnableDomLocators (copy)
	local v25 = Cryo.Dictionary.join(t1, t2)
	local conversation = v25.conversation
	local v27 = useIsUserPending(conversation or {})
	local v28 = useIsInExperience()
	local v29 = useGetOneToOneFriendIdFromConversationId(conversation and conversation.id)
	local v30 = if not FFlagEnableBlackbirdCheck then nil else v29
	local v31 = useIsRobloxSubscriber(v30)
	local v32 = FocusNavigationUtils.useLastInputMode()
	local v33 = useNavigation()
	local u34 = nil

	if FFlagLuaAppEnablePageLoadTracker and FFlagLuaAppEnableChatMilestones then
		u34 = usePageTracker()
	end

	React.useEffect(function() -- line: 86
		-- upvalues: FFlagLuaAppEnablePageLoadTracker (copy), FFlagLuaAppEnableChatMilestones (copy), v28 (copy), u34 (ref)
		if FFlagLuaAppEnablePageLoadTracker and (FFlagLuaAppEnableChatMilestones and not v28) then
			u34:sendMilestone("main_cta_interactable")
		end
	end, {})

	local v35 = React.useCallback(function() -- line: 94
		-- upvalues: v32 (copy), v33 (copy), EnumScreens (copy), v25 (copy)
		if v32 == "Focus" and v33 then
			v33.navigate(EnumScreens.ChatConversation, {
				navigatedWithFocus = true,
				conversationId = v25.conversation.id
			})

			return
		end

		if v25.onActivated then
			v25.onActivated(v25.conversation)
		end
	end, {
		v25.onActivated,
		v25.conversation,
		v32,
		v33
	})
	local v36 = getConversationTitle(conversation)
	local v37 = v25.subTitleText and v25.subTitleText:split("\n")
	local v38 = v37 and v37[1] or ""
	local v39 = useLocalization({
		subTitleText = v25.messageUnavailableKey
	})

	if v27 then
		v38 = v39.subTitleText
	end

	return React.createElement(PresenceBubbleCellStyled, {
		boldTitle = v25.boldTitle,
		style = v25.style,
		childWidth = v25.childWidth,
		onActivated = v35,
		onCircleActivated = v25.onCircleActivated,
		subTitleText = v38,
		subTitleTimestamp = v25.subTitleTimestamp,
		subTitleIcon = v27 and Images["icons/status/private_small"] or nil,
		secondaryTitleText = v25.secondaryTitleText,
		testId = if not FFlagDebugAppChatEnableDomLocators then nil else v25.testId,
		Size = v25.Size,
		isLoading = v25.isLoading,
		avatarCirclePresenceImage = conversation.presenceImage,
		titleText = v36,
		thumbnails = conversation.thumbnails,
		conversationId = conversation.id,
		hideLeftAvatarPadding = v25.hideLeftAvatarPadding,
		paddingLeft = v25.paddingLeft,
		paddingRight = v25.paddingRight,
		isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else v31
	}, v25.children or {})
end

return React.memo(ConversationCell)
