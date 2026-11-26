local Game = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration").Game

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope

local function SduiDismissGameFeedbackAction(p2, p3, data)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.DismissGameFeedback,
				message = "Missing actionParams"
			},
			data.appPage
		)
		return
	end

	local rootPlaceId = actionParams.rootPlaceId

	if rootPlaceId == nil or typeof(rootPlaceId) ~= "string" then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.DismissGameFeedback,
				message = "Missing or invalid rootPlaceId"
			},
			data.appPage
		)
		return
	end

	Game.getUserVoteFeedbackMetadataStore(false).clearItem(rootPlaceId)

	if data.configKey then
		getSduiClientPageScope(data.configKey).set("showPlayerFeedback", false)
	end
end

return SduiDismissGameFeedbackAction
