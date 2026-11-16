local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local GameInvite = require(parent.GameInvite)
local GameInviteModalManager = GameInvite.GameInviteModalManager
local GameInviteAnalyticsManager = GameInvite.GameInviteAnalyticsManager

return function(p, _, p2)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenGameInvite, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local universeId = actionParams.universeId
	local rootPlaceId = actionParams.rootPlaceId
	local trigger = actionParams.trigger
	local buttonName = actionParams.buttonName

	if typeof(rootPlaceId) ~= "string" or rootPlaceId == "" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenGameInvite,
				message = `Invalid or missing rootPlaceId: {rootPlaceId}`,
				propName = "rootPlaceId"
			},
			p2.appPage
		)
		return
	end

	if typeof(trigger) ~= "string" or trigger == "" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenGameInvite,
				message = `Invalid or missing trigger: {trigger}`,
				propName = "trigger"
			},
			p2.appPage
		)
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
