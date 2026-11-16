local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local GameTile = require(parent.GameTile)
local Localization = require(parent.Localization)
local SduiCoreSystem = require(parent.SduiCoreSystem)

local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local activateGameNotInterested = GameTile.activateGameNotInterested
local getGameTileHiddenStore = GameTile.getGameTileHiddenStore
local localizeStrings = Localization.localizeStrings

local function reportInvalidParam(p, message: string, propName: string?) -- 3 equivalent calls inferred from this helper
	p.dependencies.logger.reportError(
		SduiErrorType.InvalidActionParams,
		{ name = SduiActionType.SetGameTileNotInterested, message = message, propName = propName },
		p.appPage
	)
end

local function SduiSetGameTileNotInterestedAction(p, _, p2)
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

	if typeof(collectionId) ~= "string" or collectionId == "" then
		reportInvalidParam(p2, "Missing or invalid actionParam: collectionId", "collectionId") -- inferred equivalent call
		return
	end

	local localizedStrings = localizeStrings(p2.dependencies.localization, {
		checkboxListTitle = "Feature.GameDetails.Message.HidingExperienceQuestion",
		dialogText = "Feature.GameDetails.Message.HelpImproveExperience",
		dialogTitle = "Feature.GameDetails.Label.ProvideFeedbackTitle",
		dontLikeGame = "Feature.GameDetails.Label.DontLikeGame",
		dontLikeImage = "Feature.GameDetails.Label.DontLikeImage",
		inappropriateContent = "Feature.GameDetails.Label.InappropriateContent",
		somethingElse = "Feature.GameDetails.Label.SomethingElse",
		tooRepetitive = "Feature.GameDetails.Label.TooRepetitive"
	})
	local isSponsored

	if typeof(actionParams.isSponsored) == "boolean" then
		isSponsored = actionParams.isSponsored
	end

	activateGameNotInterested({
		appPage = p2.appPage,
		collectionId = collectionId,
		dispatch = p2.dependencies.dispatch,
		isSponsored = isSponsored,
		localizedStrings = localizedStrings,
		networking = p2.dependencies.networking,
		placeId = actionParams.placeId,
		setGameHidden = getGameTileHiddenStore(collectionId).setGameHidden,
		universeId = universeId
	})
end

return SduiSetGameTileNotInterestedAction
