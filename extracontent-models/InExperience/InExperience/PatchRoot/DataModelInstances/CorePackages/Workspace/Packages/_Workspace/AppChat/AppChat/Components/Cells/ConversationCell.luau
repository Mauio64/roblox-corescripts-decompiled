local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local EnumScreens = require(AppChat.EnumScreens)
local SocialLibraries = require(AppChat.SocialLibraries)
local TestStyle = SocialLibraries.Components.TestStyle
local useIsUserPending = require(AppChat.Hooks.useIsUserPending)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local getConversationTitle = require(AppChat.Conversations.getConversationTitle)

local PageLoadTracker = require(parent.PageLoadTracker)
local usePageTracker = PageLoadTracker.usePageTracker
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableChatMilestones = SharedFlags.FFlagLuaAppEnableChatMilestones
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppEnablePageLoadTracker = SharedFlags2.FFlagLuaAppEnablePageLoadTracker
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags3.FFlagEnableBlackbirdCheck
local UserProfiles = require(parent.UserProfiles)
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber
local useGetOneToOneFriendIdFromConversationId = require(AppChat.Hooks.useGetOneToOneFriendIdFromConversationId)
local useConversationAvatarPresenceImage = require(AppChat.Hooks.useConversationAvatarPresenceImage)
local PresenceBubbleCellStyled = require(script.Parent.PresenceBubbleCellStyled)

local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)
local FFlagAppChatServerSideConversationSearch = require(AppChat.Flags.FFlagAppChatServerSideConversationSearch)

local v = {
	messageUnavailableKey = "Feature.Chat.Message.MessageUnavailable",
	boldTitle = true,
	childWidth = 0,
	isLoading = false,
	Size = UDim2.new(1, 0, 1, 0),
	hideLeftAvatarPadding = false,
	style = Cryo.Dictionary.join(TestStyle, {
		Tokens = {
			Color = { None = {} }
		}
	})
}

local function ConversationCell(p)
	local joined = Cryo.Dictionary.join(v, p)
	local conversation = joined.conversation

	local v2 = useIsUserPending(conversation or {})
	local v3 = useIsInExperience()

	local v4 = useGetOneToOneFriendIdFromConversationId(conversation and conversation.id)
	local v5

	if FFlagEnableBlackbirdCheck then
		v5 = v4
	end

	local isRobloxSubscriber = useIsRobloxSubscriber(v5)
	local avatarCirclePresenceImage

	if FFlagAppChatPresenceStoreMigration then
		avatarCirclePresenceImage = useConversationAvatarPresenceImage(v4)
	end

	local v6 = FocusNavigationUtils.useLastInputMode()
	local v7 = useNavigation()
	local v8

	if FFlagLuaAppEnablePageLoadTracker and FFlagLuaAppEnableChatMilestones then
		v8 = usePageTracker()
	else
		v8 = nil
	end

	React.useEffect(function()
		if FFlagLuaAppEnablePageLoadTracker and FFlagLuaAppEnableChatMilestones and not v3 then
			v8:sendMilestone("main_cta_interactable")
		end
	end, {})

	local v9 = FFlagAppChatServerSideConversationSearch

	if v9 then
		if joined.conversation.isSearchResult == true then
			v9 = joined.onActivated ~= nil
		else
			v9 = false
		end
	end

	local onActivated = React.useCallback(function()
		if v6 == "Focus" and v7 and not v9 then
			v7.navigate(EnumScreens.ChatConversation, {
				conversationId = joined.conversation.id,
				navigatedWithFocus = true
			})
		elseif joined.onActivated then
			joined.onActivated(joined.conversation)
		end
	end, { joined.onActivated, joined.conversation, v6, v7, v9 })

	local conversationTitle = getConversationTitle(conversation)
	local v10 = joined.subTitleText and joined.subTitleText:split("\n")
	local subTitleText = v10 and v10[1] or ""

	local v11 = useLocalization({ subTitleText = joined.messageUnavailableKey })

	if v2 then
		subTitleText = v11.subTitleText
	end

	local createElement = React.createElement
	local v12 = {
		boldTitle = joined.boldTitle,
		style = joined.style,
		childWidth = joined.childWidth,
		onActivated = onActivated,
		onCircleActivated = joined.onCircleActivated,
		subTitleText = subTitleText,
		subTitleTimestamp = joined.subTitleTimestamp,
		subTitleIcon = v2 and Images["icons/status/private_small"] or nil,
		secondaryTitleText = joined.secondaryTitleText,
		testId = 0,
		Size = 0,
		isLoading = 0,
		avatarCirclePresenceImage = 0,
		titleText = 0,
		thumbnails = 0,
		conversationId = 0,
		participants = 0,
		hideLeftAvatarPadding = 0,
		paddingLeft = 0,
		paddingRight = 0,
		isRobloxSubscriber = 0
	}
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = joined.testId
	end

	v12.testId = testId
	v12.Size = joined.Size
	v12.isLoading = joined.isLoading

	if not FFlagAppChatPresenceStoreMigration then
		avatarCirclePresenceImage = conversation.presenceImage
	end

	v12.avatarCirclePresenceImage = avatarCirclePresenceImage

	v12.titleText = conversationTitle
	v12.thumbnails = conversation.thumbnails
	v12.conversationId = conversation.id
	local participants

	if FFlagAppChatServerSideConversationSearch and conversation.isSearchResult then
		participants = conversation.participants
	end

	v12.participants = participants

	v12.hideLeftAvatarPadding = joined.hideLeftAvatarPadding
	v12.paddingLeft = joined.paddingLeft
	v12.paddingRight = joined.paddingRight

	if not FFlagEnableBlackbirdCheck then
		isRobloxSubscriber = nil
	end

	v12.isRobloxSubscriber = isRobloxSubscriber
	return createElement(PresenceBubbleCellStyled, v12, joined.children or {})
end

return React.memo(ConversationCell)
