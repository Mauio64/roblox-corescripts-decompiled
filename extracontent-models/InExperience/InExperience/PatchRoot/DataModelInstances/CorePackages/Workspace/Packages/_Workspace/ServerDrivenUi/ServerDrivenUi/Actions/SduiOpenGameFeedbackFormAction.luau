local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local CentralOverlay = require(parent.CentralOverlay)
local DataHydration = require(parent.DataHydration)
local PlayerFeedback = require(parent.PlayerFeedback)
local RobloxAppEnums = require(parent.RobloxAppEnums)

local Game = DataHydration.Game
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local PlayerFeedbackEvents = PlayerFeedback.Analytics.Events.PlayerFeedbackEvents

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope

local v = { [true] = "Upvote", [false] = "Downvote" }

local function SduiOpenGameFeedbackFormAction(p, _, data, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenGameFeedbackForm, message = "Missing actionParams" },
			data.appPage
		)
		return
	end

	local universeId = actionParams.universeId

	if typeof(universeId) ~= "string" or universeId == "" then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenGameFeedbackForm,
				message = `Invalid or missing universeId: {tostring(universeId)}`,
				propName = "universeId"
			},
			data.appPage
		)
		return
	end

	local rootPlaceId = actionParams.rootPlaceId

	if typeof(rootPlaceId) ~= "string" or rootPlaceId == "" then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenGameFeedbackForm,
				message = `Invalid or missing rootPlaceId: {tostring(rootPlaceId)}`,
				propName = "rootPlaceId"
			},
			data.appPage
		)
		return
	end

	local data2 = Game.getUserVoteFeedbackMetadataStore(false).getUserVoteFeedbackMetadata(rootPlaceId).data(false)

	local data3 = Game.getVotesStore(false).getAndFetchUserVote(universeId).data(false)

	if not data2 or not data2.canSubmitReview or not data3 or data3.userVote ~= true and data3.userVote ~= false then
		data.dependencies.logger.reportError(SduiErrorType.FailedToExecuteAction, {
			name = SduiActionType.OpenGameFeedbackForm,
			message = `Missing or invalid feedback hydration: hasMetadata={tostring(data2 ~= nil)}, canSubmitReview={tostring(data2 and data2.canSubmitReview)}, hasUserVoteData={tostring(data3 ~= nil)}, userVote={tostring(data3 and data3.userVote)}`
		}, data.appPage)
		return
	end

	local categoryType = v[data3.userVote]
	local category2 = nil

	for _, category in data2.categories do
		if category.type == categoryType then
			category2 = category
			break
		end
	end

	if category2 == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.FailedToExecuteAction,
			{
				name = SduiActionType.OpenGameFeedbackForm,
				message = `No matching vote category found for type: {tostring(categoryType)}`
			},
			data.appPage
		)
		return
	end

	PlayerFeedbackEvents.ClickPlayerFeedbackPromptCta(data.dependencies.eventIngest, rootPlaceId)

	local playerFeedbackMetadata = {
		rootPlaceId = data2.rootPlaceId,
		canSubmitReview = data2.canSubmitReview,
		canSubmitComment = data2.canSubmitComment,
		categoryType = categoryType,
		category = category2,
		comment = data2.comment,
		metadata = data2.metadata
	}

	local configKey = data.configKey
	data.dependencies.dispatch(SetCentralOverlay(CentralOverlayType.GamePlayerFeedbackForm, {
		universeId = universeId,
		playerFeedbackMetadata = playerFeedbackMetadata,
		onSubmitted = function()
			Game.getUserVoteFeedbackMetadataStore(false).clearItem(rootPlaceId)

			if configKey then
				getSduiClientPageScope(configKey).set("showPlayerFeedback", false)
			end
		end
	}))
end

return SduiOpenGameFeedbackFormAction
