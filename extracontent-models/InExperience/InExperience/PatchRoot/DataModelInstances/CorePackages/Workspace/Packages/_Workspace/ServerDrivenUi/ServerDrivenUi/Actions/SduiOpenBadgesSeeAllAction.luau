local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local IXPService = game:GetService("IXPService")
local parent = ServerDrivenUi.Parent

local Badges = require(parent.Badges)
local navigateToBadgesSeeAll = Badges.navigateToBadgesSeeAll

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppBadgesSeeAllLogExposure = SharedFlags.FFlagLuaAppBadgesSeeAllLogExposure
local SharedFlags2 = require(parent.SharedFlags)
local FStringLuaAppBadgesSeeAllIxpLayer = SharedFlags2.FStringLuaAppBadgesSeeAllIxpLayer

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenBadgesSeeAll, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	local universeId = actionParams.universeId

	if typeof(universeId) ~= "string" or universeId == "" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenBadgesSeeAll,
				message = `Invalid or missing universeId: {tostring(universeId)}`,
				propName = "universeId"
			},
			p2.appPage
		)
		return
	end

	if FFlagLuaAppBadgesSeeAllLogExposure then
		IXPService:LogFlagLinkedUserLayerExposure(FStringLuaAppBadgesSeeAllIxpLayer)
	end

	navigateToBadgesSeeAll(p2.dependencies.getNavigation(), universeId)
end
