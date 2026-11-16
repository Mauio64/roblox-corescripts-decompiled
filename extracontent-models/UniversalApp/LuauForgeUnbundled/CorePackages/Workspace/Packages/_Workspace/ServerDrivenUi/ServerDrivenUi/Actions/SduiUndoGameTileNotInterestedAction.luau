local GameTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameTile")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")

local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getGameTileHiddenStore = GameTile.getGameTileHiddenStore
local undoGameNotInterested = GameTile.undoGameNotInterested

local function reportInvalidParam(p2, p3, p4)
	p2.dependencies.logger.reportError(
		sduiErrorType.InvalidActionParams,
		{ name = sduiActionType.UndoGameTileNotInterested, message = p3, propName = p4 },
		p2.appPage
	)
end

local function SduiUndoGameTileNotInterestedAction(p2, p3, p4)
	local actionParams = if p2 then p2.actionParams else nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.UndoGameTileNotInterested,
				message = "Missing actionParams",
				propName = nil
			},
			p4.appPage
		)

		return
	end

	local universeId = actionParams.universeId

	if typeof(universeId) ~= "string" or universeId == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.UndoGameTileNotInterested,
				message = "Missing or invalid actionParam: universeId",
				propName = "universeId"
			},
			p4.appPage
		)

		return
	end

	local collectionId = actionParams.collectionId

	if typeof(collectionId) == "string" and collectionId ~= "" then
		undoGameNotInterested({
			appPage = p4.appPage,
			collectionId = collectionId,
			dispatch = p4.dependencies.dispatch,
			networking = p4.dependencies.networking,
			setGameHidden = getGameTileHiddenStore(collectionId).setGameHidden,
			universeId = universeId
		})
	else
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.UndoGameTileNotInterested,
				message = "Missing or invalid actionParam: collectionId",
				propName = "collectionId"
			},
			p4.appPage
		)
	end
end

return SduiUndoGameTileNotInterestedAction
