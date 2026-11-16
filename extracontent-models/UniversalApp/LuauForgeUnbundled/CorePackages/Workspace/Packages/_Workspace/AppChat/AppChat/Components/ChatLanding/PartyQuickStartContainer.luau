local HttpService = game:GetService("HttpService")

local ChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/EventNames")
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/useAnalytics")
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation

local images = UIBlox.App.ImageSet.Images
local iconName = Foundation.Enums.IconName
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")

local CustomConversationListEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/CustomConversationListEntry")
local CustomConversationListRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/CustomConversationListRow/CustomConversationListRow")

local FFlagAppChatUseFoundationCustomConversationListRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseFoundationCustomConversationListRow")
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")

local placeId = if game.PlaceId > 0 then tostring(game.PlaceId) else nil
local gameId = if game.GameId > 0 then tostring(game.GameId) else nil

function LUAUFORGE_MODULE_GLOBALS_hjG_PartyQuickStartContainer(p2)
	local v5 = useAnalytics()
	local v6 = useChatPlacementContext()
	local v7 = useNavigation()
	local v8 = useLocalization({
		titleText = "Feature.Squads.Label.StartParty",
		subTitleText = "Feature.Squads.Label.JoinExperiencesTogether"
	})

	local v9 = React.useCallback(function()
		local guid = HttpService:GenerateGUID(false)
		v5.fireAnalyticsEvent(EventNames.ChatLandingPartyQuickStartButtonClicked, {
			clickLocation = v6.chatPlacement,
			partyAttemptId = guid,
			placeId = placeId,
			universeId = gameId
		})

		v7.navigate(EnumScreens.QuickStartSquadInviteFriends, { partyAttemptId = guid })
	end, { v5, v7, v6.chatPlacement })

	local v10 = if FFlagDebugAppChatEnableDomLocators then DomLocators.chatLandingConversationListHeader("startParty") else nil

	if FFlagAppChatUseFoundationCustomConversationListRow then
		return React.createElement(CustomConversationListRow, {
			entryHeight = p2.entryHeight,
			entryIcon = iconName.PersonPlay,
			onActivated = v9,
			titleText = v8.titleText,
			subTitleText = v8.subTitleText,
			testId = v10
		})
	end

	return React.createElement(CustomConversationListEntry, {
		entryHeight = p2.entryHeight,
		entryIcon = images["icons/actions/friends/friendsplaying"],
		onActivated = v9,
		titleText = v8.titleText,
		subTitleText = v8.subTitleText,
		testId = v10
	})
end

return LUAUFORGE_MODULE_GLOBALS_hjG_PartyQuickStartContainer
