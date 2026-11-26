local GameTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameTile")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Localization")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")

local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local activateGameNotInterested = GameTile.activateGameNotInterested
local getGameTileHiddenStore = GameTile.getGameTileHiddenStore
local localizeStrings = Localization.localizeStrings

local function reportInvalidParam(p2, p3, p4)
	p2.dependencies.logger.reportError(
		sduiErrorType.InvalidActionParams,
		{ name = sduiActionType.SetGameTileNotInterested, message = p3, propName = p4 },
		p2.appPage
	)
end

local function SduiSetGameTileNotInterestedAction(p2, p3, p4)
	local actionParams = if p2 then p2.actionParams else nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.SetGameTileNotInterested,
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
				name = sduiActionType.SetGameTileNotInterested,
				message = "Missing or invalid actionParam: universeId",
				propName = "universeId"
			},
			p4.appPage
		)

		return
	end

	local collectionId = actionParams.collectionId

	if typeof(collectionId) ~= "string" or collectionId == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.SetGameTileNotInterested,
				message = "Missing or invalid actionParam: collectionId",
				propName = "collectionId"
			},
			p4.appPage
		)

		return
	end

	local v5 = localizeStrings(p4.dependencies.localization, {
		checkboxListTitle = "Feature.GameDetails.Message.HidingExperienceQuestion",
		dialogText = "Feature.GameDetails.Message.HelpImproveExperience",
		dialogTitle = "Feature.GameDetails.Label.ProvideFeedbackTitle",
		dontLikeGame = "Feature.GameDetails.Label.DontLikeGame",
		dontLikeImage = "Feature.GameDetails.Label.DontLikeImage",
		inappropriateContent = "Feature.GameDetails.Label.InappropriateContent",
		somethingElse = "Feature.GameDetails.Label.SomethingElse",
		tooRepetitive = "Feature.GameDetails.Label.TooRepetitive"
	})

	local v6 = if typeof(actionParams.isSponsored) == "boolean" then actionParams.isSponsored else nil

	activateGameNotInterested({
		appPage = p4.appPage,
		collectionId = collectionId,
		dispatch = p4.dependencies.dispatch,
		isSponsored = v6,
		localizedStrings = v5,
		networking = p4.dependencies.networking,
		placeId = actionParams.placeId,
		setGameHidden = getGameTileHiddenStore(collectionId).setGameHidden,
		universeId = universeId
	})
end

return SduiSetGameTileNotInterestedAction
