local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local IXPService = game:GetService("IXPService")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local navigateToBadgesSeeAll = require(ServerDrivenUiParent.Badges).navigateToBadgesSeeAll
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local FFlagLuaAppBadgesSeeAllLogExposure = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppBadgesSeeAllLogExposure
local FStringLuaAppBadgesSeeAllIxpLayer = require(ServerDrivenUiParent.SharedFlags).FStringLuaAppBadgesSeeAllIxpLayer

return function(p1, _, p3, _) -- line: 18
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), FFlagLuaAppBadgesSeeAllLogExposure (copy), IXPService (copy), FStringLuaAppBadgesSeeAllIxpLayer (copy), navigateToBadgesSeeAll (copy)
	local v14 = p1 and p1.actionParams or nil

	if v14 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenBadgesSeeAll
		}, p3.appPage)

		return
	end

	local universeId = v14.universeId

	if typeof(universeId) ~= "string" or universeId == "" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "universeId",
			name = SduiActionType.OpenBadgesSeeAll,
			message = `Invalid or missing universeId: { tostring(universeId) }`
		}, p3.appPage)

		return
	end

	if FFlagLuaAppBadgesSeeAllLogExposure then
		IXPService:LogFlagLinkedUserLayerExposure(FStringLuaAppBadgesSeeAllIxpLayer)
	end

	navigateToBadgesSeeAll(p3.dependencies.getNavigation(), universeId)
end
