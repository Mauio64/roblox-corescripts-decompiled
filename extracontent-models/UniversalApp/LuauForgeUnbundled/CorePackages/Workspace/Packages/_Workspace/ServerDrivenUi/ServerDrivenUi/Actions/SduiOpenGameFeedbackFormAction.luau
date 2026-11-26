local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration")
local PlayerFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/PlayerFeedback")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums")

local Game = DataHydration.Game
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local centralOverlayType = RobloxAppEnums.CentralOverlayType
local playerFeedbackEvents = PlayerFeedback.Analytics.Events.PlayerFeedbackEvents

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope

local v5 = { [true] = "Upvote", [false] = "Downvote" }

local function SduiOpenGameFeedbackFormAction(p2, p3, data, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenGameFeedbackForm,
				message = "Missing actionParams"
			},
			data.appPage
		)
		return
	end

	local universeId = actionParams.universeId

	if typeof(universeId) ~= "string" or universeId == "" then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenGameFeedbackForm,
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
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenGameFeedbackForm,
				message = `Invalid or missing rootPlaceId: {tostring(rootPlaceId)}`,
				propName = "rootPlaceId"
			},
			data.appPage
		)
		return
	end

	local data2 = Game.getUserVoteFeedbackMetadataStore(false).getUserVoteFeedbackMetadata(rootPlaceId).data(false)

	local data3 = Game.getVotesStore(false).getAndFetchUserVote(universeId).data(false)

	if
		not data2
		or not data2.canSubmitReview
		or not data3
		or data3.userVote ~= true and data3.userVote ~= false
	then
		data.dependencies.logger.reportError(sduiErrorType.FailedToExecuteAction, {
			name = sduiActionType.OpenGameFeedbackForm,
			message = `Missing or invalid feedback hydration: hasMetadata={tostring(data2 ~= nil)}, canSubmitReview={tostring(data2 and data2.canSubmitReview)}, hasUserVoteData={tostring(data3 ~= nil)}, userVote={tostring(data3 and data3.userVote)}`
		}, data.appPage)
		return
	end

	local v6 = v5[data3.userVote]
	local v7 = nil

	for k, category in data2.categories do
		if category.type == v6 then
			v7 = category
			break
		end
	end

	if v7 == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.FailedToExecuteAction,
			{
				name = sduiActionType.OpenGameFeedbackForm,
				message = `No matching vote category found for type: {tostring(v6)}`
			},
			data.appPage
		)
		return
	end

	playerFeedbackEvents.ClickPlayerFeedbackPromptCta(data.dependencies.eventIngest, rootPlaceId)

	local v9 = {
		rootPlaceId = data2.rootPlaceId,
		canSubmitReview = data2.canSubmitReview,
		canSubmitComment = data2.canSubmitComment,
		categoryType = v6,
		category = v7,
		comment = data2.comment,
		metadata = data2.metadata
	}

	local configKey = data.configKey
	data.dependencies.dispatch(setCentralOverlay(centralOverlayType.GamePlayerFeedbackForm, {
		universeId = universeId,
		playerFeedbackMetadata = v9,
		onSubmitted = function()
			Game.getUserVoteFeedbackMetadataStore(false).clearItem(rootPlaceId)

			if configKey then
				getSduiClientPageScope(configKey).set("showPlayerFeedback", false)
			end
		end
	}))
end

return SduiOpenGameFeedbackFormAction
