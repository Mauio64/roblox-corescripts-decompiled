local HttpService = game:GetService("HttpService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local EventNames = require(AppChat.Analytics.EventNames)
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext
local React = require(AppChatParent.React)
local Foundation = require(AppChatParent.Foundation)
local UIBlox = require(AppChatParent.UIBlox)
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useNavigation = require(AppChatParent.Navigation).useNavigation
local Images = UIBlox.App.ImageSet.Images
local IconName = Foundation.Enums.IconName
local DomLocators = require(AppChat.Utils.DomLocators)
local CustomConversationListEntry = require(script.Parent.CustomConversationListEntry)
local CustomConversationListRow = require(script.Parent.CustomConversationListRow)
local FFlagAppChatCustomConversationListRow = require(AppChat.Flags.FFlagAppChatCustomConversationListRow)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local EnumScreens = require(AppChat.EnumScreens)
local v21 = if not (game.PlaceId > 0) then nil else tostring(game.PlaceId)
local v22 = if not (game.GameId > 0) then nil else tostring(game.GameId)

function PartyQuickStartContainer(t1: {[any]: any}) -- line: 34
	-- upvalues: useAnalytics (copy), useChatPlacementContext (copy), useNavigation (copy), useLocalization (copy), React (copy), HttpService (copy), EventNames (copy), v21 (copy), v22 (copy), EnumScreens (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), FFlagAppChatCustomConversationListRow (copy), CustomConversationListRow (copy), IconName (copy), CustomConversationListEntry (copy), Images (copy)
	local v24 = useAnalytics()
	local v25 = useChatPlacementContext()
	local v26 = useNavigation()
	local v27 = useLocalization({
		titleText = "Feature.Squads.Label.StartParty",
		subTitleText = "Feature.Squads.Label.JoinExperiencesTogether"
	})
	local v28 = React.useCallback(function() -- line: 43
		-- upvalues: HttpService (copy), v24 (copy), EventNames (copy), v25 (copy), v21 (copy), v22 (copy), v26 (copy), EnumScreens (copy)
		local guid = HttpService:GenerateGUID(false)

		v24.fireAnalyticsEvent(EventNames.ChatLandingPartyQuickStartButtonClicked, {
			clickLocation = v25.chatPlacement,
			partyAttemptId = guid,
			placeId = v21,
			universeId = v22
		})
		v26.navigate(EnumScreens.QuickStartSquadInviteFriends, {
			partyAttemptId = guid
		})
	end, {
		v24,
		v26,
		v25.chatPlacement
	})
	local v29 = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingConversationListHeader("startParty")

	if FFlagAppChatCustomConversationListRow then
		return React.createElement(CustomConversationListRow, {
			entryHeight = t1.entryHeight,
			entryIcon = IconName.PersonPlay,
			onActivated = v28,
			titleText = v27.titleText,
			subTitleText = v27.subTitleText,
			testId = v29
		})
	end

	return React.createElement(CustomConversationListEntry, {
		entryHeight = t1.entryHeight,
		entryIcon = Images["icons/actions/friends/friendsplaying"],
		onActivated = v28,
		titleText = v27.titleText,
		subTitleText = v27.subTitleText,
		testId = v29
	})
end

return PartyQuickStartContainer
