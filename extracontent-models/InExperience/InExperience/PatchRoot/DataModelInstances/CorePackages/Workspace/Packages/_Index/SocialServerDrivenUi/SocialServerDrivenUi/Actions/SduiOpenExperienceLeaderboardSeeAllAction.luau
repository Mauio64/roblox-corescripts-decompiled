local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

local Leaderboards = require(parent.Leaderboards)
local navigateToExperienceLeaderboardSeeAll = Leaderboards.navigateToExperienceLeaderboardSeeAll

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenExperienceLeaderboardSeeAll,
				message = "Missing actionParams"
			},
			p2.appPage
		)
		return
	end

	local universeId = actionParams.universeId

	if typeof(universeId) ~= "string" or universeId == "" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenExperienceLeaderboardSeeAll,
				message = `Invalid or missing universeId: {tostring(universeId)}`,
				propName = "universeId"
			},
			p2.appPage
		)
		return
	end

	local initialTab = actionParams.initialTab

	if initialTab ~= nil and initialTab ~= "friends" and initialTab ~= "global" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenExperienceLeaderboardSeeAll,
				message = `Unrecognized initialTab: {tostring(initialTab)}`,
				propName = "initialTab"
			},
			p2.appPage
		)
		initialTab = nil
	end

	navigateToExperienceLeaderboardSeeAll(p2.dependencies.getNavigation(), universeId, initialTab)
end
