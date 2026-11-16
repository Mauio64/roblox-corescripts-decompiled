local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local DataHydration = require(parent.DataHydration)
local Game = DataHydration.Game

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope

local function SduiDismissGameFeedbackAction(p, _, data)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.DismissGameFeedback, message = "Missing actionParams" },
			data.appPage
		)
		return
	end

	local rootPlaceId = actionParams.rootPlaceId

	if rootPlaceId == nil or typeof(rootPlaceId) ~= "string" then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.DismissGameFeedback,
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
