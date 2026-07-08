local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local GameInvite = require(Parent.GameInvite)
local GameInviteModalManager = GameInvite.GameInviteModalManager
local GameInviteAnalyticsManager = GameInvite.GameInviteAnalyticsManager

return function(p1, _, p3) -- line: 16
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), GameInviteAnalyticsManager (copy), GameInviteModalManager (copy)
	local v11 = p1 and p1.actionParams or nil

	if v11 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenGameInvite
		}, p3.appPage)

		return
	end

	assert(v11, "actionParams must exist")

	local universeId = v11.universeId
	local rootPlaceId = v11.rootPlaceId
	local trigger = v11.trigger
	local buttonName = v11.buttonName

	if typeof(rootPlaceId) ~= "string" or rootPlaceId == "" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "rootPlaceId",
			name = SduiActionType.OpenGameInvite,
			message = `Invalid or missing rootPlaceId: { rootPlaceId }`
		}, p3.appPage)

		return
	end

	if typeof(trigger) ~= "string" or trigger == "" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "trigger",
			name = SduiActionType.OpenGameInvite,
			message = `Invalid or missing trigger: { trigger }`
		}, p3.appPage)

		return
	end

	if typeof(buttonName) == "string" and buttonName ~= "" then
		GameInviteAnalyticsManager:withButtonName(buttonName)
		GameInviteAnalyticsManager:inputShareGameEntryPoint(rootPlaceId, universeId)
	end

	GameInviteModalManager:openModal({
		trigger = trigger,
		rootPlaceId = rootPlaceId,
		universeId = universeId
	})
end
