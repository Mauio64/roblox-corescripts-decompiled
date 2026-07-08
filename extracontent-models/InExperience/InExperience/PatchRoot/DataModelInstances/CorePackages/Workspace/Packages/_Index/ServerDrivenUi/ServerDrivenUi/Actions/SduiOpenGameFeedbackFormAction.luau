local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local CentralOverlay = require(Parent.CentralOverlay)
local DataHydration = require(Parent.DataHydration)
local PlayerFeedback = require(Parent.PlayerFeedback)
local RobloxAppEnums = require(Parent.RobloxAppEnums)
local Game = DataHydration.Game
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local PlayerFeedbackEvents = PlayerFeedback.Analytics.Events.PlayerFeedbackEvents
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope
local t1 = {
	[true] = "Upvote",
	[false] = "Downvote"
}

local function SduiOpenGameFeedbackFormAction(p1, _, p3, _) -- line: 32
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), Game (copy), t1 (copy), PlayerFeedbackEvents (copy), SetCentralOverlay (copy), CentralOverlayType (copy), getSduiClientPageScope (copy)
	local v20 = p1 and p1.actionParams or nil

	if v20 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenGameFeedbackForm
		}, p3.appPage)

		return
	end

	local universeId = v20.universeId

	if typeof(universeId) ~= "string" or universeId == "" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "universeId",
			name = SduiActionType.OpenGameFeedbackForm,
			message = `Invalid or missing universeId: { tostring(universeId) }`
		}, p3.appPage)

		return
	end

	local rootPlaceId = v20.rootPlaceId

	if typeof(rootPlaceId) ~= "string" or rootPlaceId == "" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "rootPlaceId",
			name = SduiActionType.OpenGameFeedbackForm,
			message = `Invalid or missing rootPlaceId: { tostring(rootPlaceId) }`
		}, p3.appPage)

		return
	end

	local v23 = Game.getUserVoteFeedbackMetadataStore(false).getUserVoteFeedbackMetadata(rootPlaceId).data(false)
	local v24 = Game.getVotesStore(false).getAndFetchUserVote(universeId).data(false)

	if not v23 or not v23.canSubmitReview or not v24 or v24.userVote ~= true and v24.userVote ~= false then
		p3.dependencies.logger.reportError(SduiErrorType.FailedToExecuteAction, {
			name = SduiActionType.OpenGameFeedbackForm,
			message = `Missing or invalid feedback hydration: hasMetadata={ tostring(v23 ~= nil) }, canSubmitReview={ tostring(v23 and v23.canSubmitReview) }, hasUserVoteData={ tostring(v24 ~= nil) }, userVote={ tostring(v24 and v24.userVote) }`
		}, p3.appPage)

		return
	end

	local v25 = t1[v24.userVote]
	local v26 = nil

	for _, v28 in v23.categories do
		if v25 == v28.type then
			v26 = v28

			break
		end
	end

	if v26 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.FailedToExecuteAction, {
			name = SduiActionType.OpenGameFeedbackForm,
			message = `No matching vote category found for type: { tostring(v25) }`
		}, p3.appPage)

		return
	end

	PlayerFeedbackEvents.ClickPlayerFeedbackPromptCta(p3.dependencies.eventIngest, rootPlaceId)

	local t2 = {
		rootPlaceId = v23.rootPlaceId,
		canSubmitReview = v23.canSubmitReview,
		canSubmitComment = v23.canSubmitComment,
		categoryType = v25,
		category = v26,
		comment = v23.comment,
		metadata = v23.metadata
	}
	local configKey = p3.configKey

	p3.dependencies.dispatch(SetCentralOverlay(CentralOverlayType.GamePlayerFeedbackForm, {
		universeId = universeId,
		playerFeedbackMetadata = t2,
		onSubmitted = function() -- line: 123
			-- upvalues: Game (copy), rootPlaceId (copy), configKey (copy), getSduiClientPageScope (copy)
			Game.getUserVoteFeedbackMetadataStore(false).clearItem(rootPlaceId)

			if configKey then
				getSduiClientPageScope(configKey).set("showPlayerFeedback", false)
			end
		end
	}))
end

return SduiOpenGameFeedbackFormAction
