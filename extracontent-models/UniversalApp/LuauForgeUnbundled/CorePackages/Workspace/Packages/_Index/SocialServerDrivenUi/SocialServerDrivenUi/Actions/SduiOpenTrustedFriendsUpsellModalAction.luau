local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/RobloxAppEnums").AppPage
local sources = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SocialLuaAnalytics").Analytics.Enums.Sources
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/RobloxAppNavigation").NavigationCommands else nil

local function SduiOpenTrustedFriendsUpsellModalAction(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenTrustedFriendsUpsellModal,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	local targetUserId = actionParams.targetUserId

	if targetUserId == nil or targetUserId == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenTrustedFriendsUpsellModal,
				message = "Missing actionParam: targetUserId",
				propName = "targetUserId"
			},
			p4.appPage
		)
		return
	end

	local v5 = actionParams.source

	if typeof(v5) ~= "string" or v5 == "" then
		v5 = sources.PartyChatConversationUpsell
	end

	local v6 = {
		name = appPage.TrustedContactsModal,
		props = { userId = targetUserId, source = v5 }
	}

	if fFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(v6))
	else
		p4.dependencies.dispatch(navigateDown(v6))
	end
end

return SduiOpenTrustedFriendsUpsellModalAction
