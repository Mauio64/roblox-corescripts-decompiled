local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Foundation = require(AppChatParent.Foundation)
local UIBlox = require(AppChatParent.UIBlox)
local LuaAppNavigationContext = require(AppChat.LuaAppNavigationContext)
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatLanding = script:FindFirstAncestor("ChatLanding")
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ChatLandingTelemetryEvents = require(ChatLanding.ChatLandingTelemetryEvents)
local getAppChatCommunitiesVisualConfig = require(AppChat.Utils.getAppChatCommunitiesVisualConfig)
local getFFlagCommunitiesUseVisualConfigUtil = require(AppChatParent.SharedFlags).getFFlagCommunitiesUseVisualConfigUtil
local GetFFlagUseCommunitiesTranslation = require(AppChatParent.SharedFlags).GetFFlagUseCommunitiesTranslation
local Images = UIBlox.App.ImageSet.Images
local IconName = Foundation.Enums.IconName
local DomLocators = require(AppChat.Utils.DomLocators)
local CustomConversationListEntry = require(script.Parent.CustomConversationListEntry)
local CustomConversationListRow = require(script.Parent.CustomConversationListRow)
local FFlagAppChatCustomConversationListRow = require(AppChat.Flags.FFlagAppChatCustomConversationListRow)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local v22 = Images["icons/menu/groups"]

function ConversationGroupsEntryContainer(t1: {[any]: any}) -- line: 33
	-- upvalues: getFFlagCommunitiesUseVisualConfigUtil (copy), getAppChatCommunitiesVisualConfig (copy), useLocalization (copy), GetFFlagUseCommunitiesTranslation (copy), React (copy), LuaAppNavigationContext (copy), useTelemetry (copy), ChatLandingTelemetryLayer (copy), Images (copy), v22 (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ChatLandingTelemetryEvents (copy), FFlagAppChatCustomConversationListRow (copy), CustomConversationListRow (copy), IconName (copy), CustomConversationListEntry (copy)
	local v24 = if not getFFlagCommunitiesUseVisualConfigUtil() then nil else getAppChatCommunitiesVisualConfig()
	local v25 = useLocalization({
		createAndExploreGroupsText = "Feature.SocialTab.Label.CreateAndExploreGroups",
		groupsText = if not getFFlagCommunitiesUseVisualConfigUtil() then not GetFFlagUseCommunitiesTranslation() and "CommonUI.Features.Label.sGroups" or "Feature.SocialTab.Label.Groups" else v24.label
	})
	local v26 = React.useContext(LuaAppNavigationContext)
	local v27 = useTelemetry(ChatLandingTelemetryLayer.Context)
	local v28 = if not getFFlagCommunitiesUseVisualConfigUtil() then v22 else Images[v24.icon]
	local v29 = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatLandingConversationListHeader("communities")
	local v30 = React.useCallback(function() -- line: 52
		-- upvalues: v27 (copy), ChatLandingTelemetryEvents (copy), v26 (copy)
		v27.emit(ChatLandingTelemetryEvents.ChatLandingGroupsBtnClicked, {})
		v26.navigateToGroups()
	end, {
		v27,
		v26
	})

	if FFlagAppChatCustomConversationListRow then
		return React.createElement(CustomConversationListRow, {
			key = "ConversationGroupsEntry",
			entryHeight = t1.entryHeight,
			entryIcon = IconName.ThreePeople,
			onActivated = v30,
			subTitleText = v25.createAndExploreGroupsText,
			titleText = v25.groupsText,
			testId = v29
		})
	end

	return React.createElement(CustomConversationListEntry, {
		key = "ConversationGroupsEntry",
		entryHeight = t1.entryHeight,
		entryIcon = v28,
		onActivated = v30,
		subTitleText = v25.createAndExploreGroupsText,
		titleText = v25.groupsText,
		testId = v29
	})
end

return ConversationGroupsEntryContainer
