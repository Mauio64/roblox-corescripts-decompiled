local IXPService = game:GetService("IXPService")

local navigateToBadgesSeeAll = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Badges").navigateToBadgesSeeAll

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local fFlagLuaAppBadgesSeeAllLogExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppBadgesSeeAllLogExposure
local fStringLuaAppBadgesSeeAllIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FStringLuaAppBadgesSeeAllIxpLayer

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.OpenBadgesSeeAll, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	local universeId = actionParams.universeId

	if typeof(universeId) ~= "string" or universeId == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenBadgesSeeAll,
				message = `Invalid or missing universeId: {tostring(universeId)}`,
				propName = "universeId"
			},
			p4.appPage
		)
		return
	end

	if fFlagLuaAppBadgesSeeAllLogExposure then
		IXPService:LogFlagLinkedUserLayerExposure(fStringLuaAppBadgesSeeAllIxpLayer)
	end

	navigateToBadgesSeeAll(p4.dependencies.getNavigation(), universeId)
end
