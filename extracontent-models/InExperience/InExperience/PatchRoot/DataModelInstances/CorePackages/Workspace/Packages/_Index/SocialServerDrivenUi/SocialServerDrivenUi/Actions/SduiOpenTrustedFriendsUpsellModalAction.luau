local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Sources = SocialLuaAnalytics.Analytics.Enums.Sources
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local function SduiOpenTrustedFriendsUpsellModalAction(p, _, p2)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenTrustedFriendsUpsellModal,
				message = "Missing actionParams"
			},
			p2.appPage
		)
		return
	end

	local targetUserId = actionParams.targetUserId

	if targetUserId == nil or targetUserId == "" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenTrustedFriendsUpsellModal,
				message = "Missing actionParam: targetUserId",
				propName = "targetUserId"
			},
			p2.appPage
		)
		return
	end

	local source = actionParams.source

	if typeof(source) ~= "string" or source == "" then
		source = Sources.PartyChatConversationUpsell
	end

	local v = {
		name = AppPage.TrustedContactsModal,
		props = { userId = targetUserId, source = source }
	}

	if FFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(v))
	else
		p2.dependencies.dispatch(NavigateDown(v))
	end
end

return SduiOpenTrustedFriendsUpsellModalAction
