local HttpService = game:GetService("HttpService")
local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local EventNames = require(AppChat.Analytics.EventNames)
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local Images = UIBlox.App.ImageSet.Images
local IconName = Foundation.Enums.IconName
local DomLocators = require(AppChat.Utils.DomLocators)

local CustomConversationListEntry = require(script.Parent.CustomConversationListEntry)
local CustomConversationListRow = require(script.Parent.CustomConversationListRow.CustomConversationListRow)

local FFlagAppChatUseFoundationCustomConversationListRow = require(AppChat.Flags.FFlagAppChatUseFoundationCustomConversationListRow)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)

local EnumScreens = require(AppChat.EnumScreens)
local placeId

if game.PlaceId > 0 then
	placeId = tostring(game.PlaceId)
else
	placeId = nil
end

local gameId

if game.GameId > 0 then
	gameId = tostring(game.GameId)
else
	gameId = nil
end

function PartyQuickStartContainer(p)
	local v = useAnalytics()
	local v2 = useChatPlacementContext()
	local v3 = useNavigation()
	local v4 = useLocalization({
		titleText = "Feature.Squads.Label.StartParty",
		subTitleText = "Feature.Squads.Label.JoinExperiencesTogether"
	})

	local onActivated = React.useCallback(function()
		local guid = HttpService:GenerateGUID(false)
		v.fireAnalyticsEvent(EventNames.ChatLandingPartyQuickStartButtonClicked, {
			clickLocation = v2.chatPlacement,
			partyAttemptId = guid,
			placeId = placeId,
			universeId = gameId
		})

		v3.navigate(EnumScreens.QuickStartSquadInviteFriends, { partyAttemptId = guid })
	end, { v, v3, v2.chatPlacement })
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = DomLocators.chatLandingConversationListHeader("startParty")
	end

	if FFlagAppChatUseFoundationCustomConversationListRow then
		return React.createElement(CustomConversationListRow, {
			entryHeight = p.entryHeight,
			entryIcon = IconName.PersonPlay,
			onActivated = onActivated,
			titleText = v4.titleText,
			subTitleText = v4.subTitleText,
			testId = testId
		})
	end

	return React.createElement(CustomConversationListEntry, {
		entryHeight = p.entryHeight,
		entryIcon = Images["icons/actions/friends/friendsplaying"],
		onActivated = onActivated,
		titleText = v4.titleText,
		subTitleText = v4.subTitleText,
		testId = testId
	})
end

return PartyQuickStartContainer
