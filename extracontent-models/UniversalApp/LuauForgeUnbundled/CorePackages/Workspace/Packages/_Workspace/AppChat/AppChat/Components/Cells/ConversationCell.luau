local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local images = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").App.ImageSet.Images
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local testStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries").Components.TestStyle
local useIsUserPending = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsUserPending")
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")
local getConversationTitle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getConversationTitle")

local usePageTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/PageLoadTracker").usePageTracker
local fFlagLuaAppEnableChatMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagLuaAppEnableChatMilestones
local fFlagLuaAppEnablePageLoadTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagLuaAppEnablePageLoadTracker
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserProfiles").Hooks.useIsRobloxSubscriber
local useGetOneToOneFriendIdFromConversationId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetOneToOneFriendIdFromConversationId")
local useConversationAvatarPresenceImage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useConversationAvatarPresenceImage")
local PresenceBubbleCellStyled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/PresenceBubbleCellStyled")

local FFlagAppChatPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration")
local FFlagAppChatServerSideConversationSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatServerSideConversationSearch")

local v5 = {
	messageUnavailableKey = "Feature.Chat.Message.MessageUnavailable",
	boldTitle = true,
	childWidth = 0,
	isLoading = false,
	Size = UDim2.new(1, 0, 1, 0),
	hideLeftAvatarPadding = false,
	style = Cryo.Dictionary.join(testStyle, {
		Tokens = {
			Color = { None = {} }
		}
	})
}

local function ConversationCell(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local conversation = joined.conversation

	local v6 = useIsUserPending(conversation or {})
	local v7 = useIsInExperience()

	local v8 = useGetOneToOneFriendIdFromConversationId(conversation and conversation.id)
	local v9 = if fFlagEnableBlackbirdCheck then v8 else nil
	local v10 = useIsRobloxSubscriber(v9)

	local v11 = if FFlagAppChatPresenceStoreMigration then useConversationAvatarPresenceImage(v8) else nil

	local v12 = FocusNavigationUtils.useLastInputMode()
	local v13 = useNavigation()
	local v14

	if fFlagLuaAppEnablePageLoadTracker and fFlagLuaAppEnableChatMilestones then
		v14 = usePageTracker()
	else
		v14 = nil
	end

	React.useEffect(function()
		if fFlagLuaAppEnablePageLoadTracker and fFlagLuaAppEnableChatMilestones and not v7 then
			v14:sendMilestone("main_cta_interactable")
		end
	end, {})

	local v15 = FFlagAppChatServerSideConversationSearch

	if v15 then
		v15 = joined.conversation.isSearchResult == true and joined.onActivated ~= nil
	end

	local v16 = React.useCallback(function()
		if v12 == "Focus" and v13 and not v15 then
			v13.navigate(EnumScreens.ChatConversation, {
				conversationId = joined.conversation.id,
				navigatedWithFocus = true
			})
		elseif joined.onActivated then
			joined.onActivated(joined.conversation)
		end
	end, { joined.onActivated, joined.conversation, v12, v13, v15 })

	local v17 = getConversationTitle(conversation)
	local v18 = joined.subTitleText and joined.subTitleText:split("\n")
	local v19 = v18 and v18[1] or ""

	local v20 = useLocalization({ subTitleText = joined.messageUnavailableKey })

	if v6 then
		v19 = v20.subTitleText
	end

	local createElement = React.createElement
	local v22 = {
		boldTitle = joined.boldTitle,
		style = joined.style,
		childWidth = joined.childWidth,
		onActivated = v16,
		onCircleActivated = joined.onCircleActivated,
		subTitleText = v19,
		subTitleTimestamp = joined.subTitleTimestamp,
		subTitleIcon = v6 and images["icons/status/private_small"] or nil,
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
	local v23 = if FFlagDebugAppChatEnableDomLocators then joined.testId else nil
	v22.testId = v23
	v22.Size = joined.Size
	v22.isLoading = joined.isLoading

	if not FFlagAppChatPresenceStoreMigration then
		v11 = conversation.presenceImage
	end

	v22.avatarCirclePresenceImage = v11

	v22.titleText = v17
	v22.thumbnails = conversation.thumbnails
	v22.conversationId = conversation.id

	local v24 = if FFlagAppChatServerSideConversationSearch and conversation.isSearchResult then conversation.participants else nil
	v22.participants = v24

	v22.hideLeftAvatarPadding = joined.hideLeftAvatarPadding
	v22.paddingLeft = joined.paddingLeft
	v22.paddingRight = joined.paddingRight

	if not fFlagEnableBlackbirdCheck then
		v10 = nil
	end

	v22.isRobloxSubscriber = v10
	return createElement(PresenceBubbleCellStyled, v22, joined.children or {})
end

return React.memo(ConversationCell)
