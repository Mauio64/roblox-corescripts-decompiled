local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local GameTile = require(parent.GameTile)
local SduiCoreSystem = require(parent.SduiCoreSystem)

local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getGameTileHiddenStore = GameTile.getGameTileHiddenStore
local undoGameNotInterested = GameTile.undoGameNotInterested

local function reportInvalidParam(p, message: string, propName: string?) -- 3 equivalent calls inferred from this helper
	p.dependencies.logger.reportError(
		SduiErrorType.InvalidActionParams,
		{ name = SduiActionType.UndoGameTileNotInterested, message = message, propName = propName },
		p.appPage
	)
end

local function SduiUndoGameTileNotInterestedAction(p, _, p2)
	local actionParams

	if p then
		actionParams = p.actionParams
	end

	if actionParams == nil then
		reportInvalidParam(p2, "Missing actionParams") -- inferred equivalent call
		return
	end

	local universeId = actionParams.universeId

	if typeof(universeId) ~= "string" or universeId == "" then
		reportInvalidParam(p2, "Missing or invalid actionParam: universeId", "universeId") -- inferred equivalent call
		return
	end

	local collectionId = actionParams.collectionId

	if typeof(collectionId) == "string" and collectionId ~= "" then
		undoGameNotInterested({
			appPage = p2.appPage,
			collectionId = collectionId,
			dispatch = p2.dependencies.dispatch,
			networking = p2.dependencies.networking,
			setGameHidden = getGameTileHiddenStore(collectionId).setGameHidden,
			universeId = universeId
		})
	else
		reportInvalidParam(p2, "Missing or invalid actionParam: collectionId", "collectionId") -- inferred equivalent call
	end
end

return SduiUndoGameTileNotInterestedAction
