local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)
local LuaAppNavigationContext = require(AppChat.LuaAppNavigationContext)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useTelemetry = require(AppChat.Telemetry.useTelemetry)

local ChatLanding = script:FindFirstAncestor("ChatLanding")
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ChatLandingTelemetryEvents = require(ChatLanding.ChatLandingTelemetryEvents)

local getAppChatCommunitiesVisualConfig = require(AppChat.Utils.getAppChatCommunitiesVisualConfig)
local Images = UIBlox.App.ImageSet.Images
local IconName = Foundation.Enums.IconName
local DomLocators = require(AppChat.Utils.DomLocators)

local CustomConversationListEntry = require(script.Parent.CustomConversationListEntry)
local CustomConversationListRow = require(script.Parent.CustomConversationListRow.CustomConversationListRow)

local FFlagAppChatUseFoundationCustomConversationListRow = require(AppChat.Flags.FFlagAppChatUseFoundationCustomConversationListRow)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)

function ConversationGroupsEntryContainer(p)
	local appChatCommunitiesVisualConfig = getAppChatCommunitiesVisualConfig()
	local v = useLocalization({
		groupsText = appChatCommunitiesVisualConfig.label,
		createAndExploreGroupsText = "Feature.SocialTab.Label.CreateAndExploreGroups"
	})

	local v2 = React.useContext(LuaAppNavigationContext)
	local v3 = useTelemetry(ChatLandingTelemetryLayer.Context)
	local image = Images[appChatCommunitiesVisualConfig.icon]
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = DomLocators.chatLandingConversationListHeader("communities")
	end

	local onActivated = React.useCallback(function()
		v3.emit(ChatLandingTelemetryEvents.ChatLandingGroupsBtnClicked, {})

		v2.navigateToGroups()
	end, { v3, v2 })

	if FFlagAppChatUseFoundationCustomConversationListRow then
		return React.createElement(CustomConversationListRow, {
			entryHeight = p.entryHeight,
			entryIcon = IconName.ThreePeople,
			key = "ConversationGroupsEntry",
			onActivated = onActivated,
			subTitleText = v.createAndExploreGroupsText,
			titleText = v.groupsText,
			testId = testId
		})
	end

	return React.createElement(CustomConversationListEntry, {
		entryHeight = p.entryHeight,
		entryIcon = image,
		key = "ConversationGroupsEntry",
		onActivated = onActivated,
		subTitleText = v.createAndExploreGroupsText,
		titleText = v.groupsText,
		testId = testId
	})
end

return ConversationGroupsEntryContainer
