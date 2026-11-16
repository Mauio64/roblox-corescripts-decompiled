local navigateToExperienceLeaderboardSeeAll = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/Leaderboards").navigateToExperienceLeaderboardSeeAll

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenExperienceLeaderboardSeeAll,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	local universeId = actionParams.universeId

	if typeof(universeId) ~= "string" or universeId == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenExperienceLeaderboardSeeAll,
				message = `Invalid or missing universeId: {tostring(universeId)}`,
				propName = "universeId"
			},
			p4.appPage
		)
		return
	end

	local initialTab = actionParams.initialTab

	if initialTab ~= nil and initialTab ~= "friends" and initialTab ~= "global" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenExperienceLeaderboardSeeAll,
				message = `Unrecognized initialTab: {tostring(initialTab)}`,
				propName = "initialTab"
			},
			p4.appPage
		)
		initialTab = nil
	end

	navigateToExperienceLeaderboardSeeAll(p4.dependencies.getNavigation(), universeId, initialTab)
end
