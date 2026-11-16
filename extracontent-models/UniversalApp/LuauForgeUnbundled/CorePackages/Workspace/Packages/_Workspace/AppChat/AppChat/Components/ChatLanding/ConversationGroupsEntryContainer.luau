local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local LuaAppNavigationContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LuaAppNavigationContext")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")

local ChatLandingTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatLandingTelemetryLayer")
local ChatLandingTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingTelemetryEvents")

local getAppChatCommunitiesVisualConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getAppChatCommunitiesVisualConfig")
local images = UIBlox.App.ImageSet.Images
local iconName = Foundation.Enums.IconName
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")

local CustomConversationListEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/CustomConversationListEntry")
local CustomConversationListRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/CustomConversationListRow/CustomConversationListRow")

local FFlagAppChatUseFoundationCustomConversationListRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseFoundationCustomConversationListRow")
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")

function LUAUFORGE_MODULE_GLOBALS_hgs_ConversationGroupsEntryContainer(p2)
	local v5 = getAppChatCommunitiesVisualConfig()
	local v6 = useLocalization({
		groupsText = v5.label,
		createAndExploreGroupsText = "Feature.SocialTab.Label.CreateAndExploreGroups"
	})

	local v7 = React.useContext(LuaAppNavigationContext)
	local v8 = useTelemetry(ChatLandingTelemetryLayer.Context)
	local image = images[v5.icon]

	local v9 = if FFlagDebugAppChatEnableDomLocators then DomLocators.chatLandingConversationListHeader("communities") else nil

	local v10 = React.useCallback(function()
		v8.emit(ChatLandingTelemetryEvents.ChatLandingGroupsBtnClicked, {})

		v7.navigateToGroups()
	end, { v8, v7 })

	if FFlagAppChatUseFoundationCustomConversationListRow then
		return React.createElement(CustomConversationListRow, {
			entryHeight = p2.entryHeight,
			entryIcon = iconName.ThreePeople,
			key = "ConversationGroupsEntry",
			onActivated = v10,
			subTitleText = v6.createAndExploreGroupsText,
			titleText = v6.groupsText,
			testId = v9
		})
	end

	return React.createElement(CustomConversationListEntry, {
		entryHeight = p2.entryHeight,
		entryIcon = image,
		key = "ConversationGroupsEntry",
		onActivated = v10,
		subTitleText = v6.createAndExploreGroupsText,
		titleText = v6.groupsText,
		testId = v9
	})
end

return LUAUFORGE_MODULE_GLOBALS_hgs_ConversationGroupsEntryContainer
