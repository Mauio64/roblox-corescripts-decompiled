local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local GameInvite = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameInvite")
local gameInviteModalManager = GameInvite.GameInviteModalManager
local gameInviteAnalyticsManager = GameInvite.GameInviteAnalyticsManager

return function(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.OpenGameInvite, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local universeId = actionParams.universeId
	local rootPlaceId = actionParams.rootPlaceId
	local trigger = actionParams.trigger
	local buttonName = actionParams.buttonName

	if typeof(rootPlaceId) ~= "string" or rootPlaceId == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenGameInvite,
				message = `Invalid or missing rootPlaceId: {rootPlaceId}`,
				propName = "rootPlaceId"
			},
			p4.appPage
		)
		return
	end

	if typeof(trigger) ~= "string" or trigger == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenGameInvite,
				message = `Invalid or missing trigger: {trigger}`,
				propName = "trigger"
			},
			p4.appPage
		)
		return
	end

	if typeof(buttonName) == "string" and buttonName ~= "" then
		gameInviteAnalyticsManager:withButtonName(buttonName)
		gameInviteAnalyticsManager:inputShareGameEntryPoint(rootPlaceId, universeId)
	end

	gameInviteModalManager:openModal({
		trigger = trigger,
		rootPlaceId = rootPlaceId,
		universeId = universeId
	})
end
