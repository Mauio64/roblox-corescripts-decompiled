local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local Game = require(Parent.DataHydration).Game
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope

local function SduiDismissGameFeedbackAction(p1, _, p3) -- line: 16
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), Game (copy), getSduiClientPageScope (copy)
	local v11 = p1 and p1.actionParams or nil

	if v11 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.DismissGameFeedback
		}, p3.appPage)

		return
	end

	local rootPlaceId = v11.rootPlaceId

	if rootPlaceId == nil or typeof(rootPlaceId) ~= "string" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing or invalid rootPlaceId",
			name = SduiActionType.DismissGameFeedback
		}, p3.appPage)

		return
	end

	Game.getUserVoteFeedbackMetadataStore(false).clearItem(rootPlaceId)

	if p3.configKey then
		getSduiClientPageScope(p3.configKey).set("showPlayerFeedback", false)
	end
end

return SduiDismissGameFeedbackAction
