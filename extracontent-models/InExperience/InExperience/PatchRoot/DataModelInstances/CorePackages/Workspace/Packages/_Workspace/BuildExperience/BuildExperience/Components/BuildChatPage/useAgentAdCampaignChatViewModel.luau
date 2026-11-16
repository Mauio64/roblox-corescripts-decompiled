local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Players = game:GetService("Players")
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
require(parent.DataHydration.CreatorAgentChat)
require(BuildExperience.Chat.chatTypes)
local useCreateAdCampaign = require(BuildExperience.Components.Ads.useCreateAdCampaign)
local GetAdUpsellEventStore = require(BuildExperience.Stores.GetAdUpsellEventStore)
local GetAgentAdCampaignStore = require(BuildExperience.Stores.GetAgentAdCampaignStore)
require(BuildExperience.Stores.GetAgentAdCampaignStore.createAgentAdCampaignStore)
local AdCampaignToolCallStatus = require(parent.DataHydration.AdCampaignToolCallStatus)
local AdCampaigns = require(parent.DataHydration.AdCampaigns)
local AdCampaignEligibility = require(parent.DataHydration.AdCampaignEligibility)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
require(BuildExperience.Storage.createAdCampaignCardStorage)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local adCampaignScheduleUtils = require(BuildExperience.Components.Ads.adCampaignScheduleUtils)
local adCampaignEligibilityUtils = require(BuildExperience.Components.Ads.adCampaignEligibilityUtils)

local FFlagBuildAgentAdCampaignRefreshEligibility = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignRefreshEligibility)

local FFlagBuildAgentAdCampaignToolCallStatusFallback = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignToolCallStatusFallback)

local function persistenceFor(p) -- 4 equivalent calls inferred from this helper
	return { get = p.getAdCampaignCard, save = p.recordAdCampaignAttempt }
end

local function hasFailedBackendAttempt(p: number, p2: string): boolean -- 2 equivalent calls inferred from this helper
	local data = AdCampaignToolCallStatus.getAdCampaignToolCallStatusStore(false).getToolCallStatus(p, p2).data(false)
	return data ~= nil and data.status == "failed"
end

local function useAgentAdCampaignChatViewModel(data, userId: number?)
	local adUpsellEventStore = GetAdUpsellEventStore(false)
	local v = SignalsReact.useSignalState(adUpsellEventStore.getAdCampaignRevision)
	local agentAdCampaignStore = GetAgentAdCampaignStore(false)
	local v2 = SignalsReact.useSignalState(agentAdCampaignStore.getAttempts)
	local adCampaignsStore = AdCampaigns.getAdCampaignsStore(false)
	local v3 = SignalsReact.useSignalState(adCampaignsStore.getAdCampaigns().data)
	local localPlayer = Players.LocalPlayer

	if not userId then
		if localPlayer == nil or not (localPlayer.UserId > 0) then
			userId = nil
		else
			userId = localPlayer.UserId
		end
	end

	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local v4

	if state ~= nil then
		v4 = v2[state.toolCallId]
	end

	local v5 = useCreateAdCampaign(data.universeId, data.sessionId)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(DateTime.now().UnixTimestampMillis)
	local ref2 = React.useRef(true)
	local current3 = {
		universeId = data.universeId,
		sessionId = data.sessionId,
		isPageVisible = data.isPageVisible,
		userId = userId
	}

	local ref3 = React.useRef(current3)
	ref3.current = current3
	local ref4 = React.useRef(data.isPageVisible)
	local ref5

	if FFlagBuildAgentAdCampaignRefreshEligibility then
		ref5 = React.useRef(nil)
	else
		ref5 = nil
	end

	local ref6

	if FFlagBuildAgentAdCampaignRefreshEligibility then
		ref6 = React.useRef(nil)
	else
		ref6 = nil
	end

	local state4, v6

	if FFlagBuildAgentAdCampaignRefreshEligibility then
		local setState4
		state4, setState4 = React.useState(nil)
		v6 = setState4

		React.useEffect(function()
			v6(nil)
			return function()
				local current = ref5.current
				ref5.current = nil

				if current ~= nil and current.timer ~= nil then
					task.cancel(current.timer)
				end
			end
		end, { data.universeId, data.sessionId, data.isPageVisible, userId, ref5, v6 })
	else
		state4 = nil
		v6 = nil
	end

	React.useEffect(function()
		ref2.current = true
		return function()
			ref2.current = false
		end
	end, {})
	React.useEffect(function()
		ref.current = nil
		setState(nil)
	end, { data.universeId, data.sessionId, userId })
	React.useEffect(function()
		if data.isPageVisible then
			adUpsellEventStore.retryAdCampaignCardWrites()
		end
	end, { data.isPageVisible, adUpsellEventStore })

	local v7 = React.useMemo(function()
		local recordsByToolCallId = {}

		if data.sessionId ~= nil then
			for _, record in adUpsellEventStore.listAdCampaignCards(data.sessionId).records do
				if (record.userId == nil or record.userId == userId) and record.universeId == data.universeId then
					recordsByToolCallId[record.toolCallId] = record
				end
			end
		end

		return recordsByToolCallId
	end, { data.sessionId, data.universeId, adUpsellEventStore, v, userId })
	local v8 = React.useMemo(function()
		local result = {}

		for k, v8 in v7 do
			if v8.campaignId ~= nil then
				result[k] = v8
			end
		end

		return result
	end, { v7 })
	React.useEffect(function()
		if data.isPageVisible and next(v8) ~= nil then
			adCampaignsStore.getAndFetchAdCampaigns()
		end
	end, { v8, data.isPageVisible, adCampaignsStore })
	local v9 = React.useMemo(function()
		local v9 = {}

		for _, v10 in v3 or {} do
			if v10.targetUniverseId == tostring(data.universeId) then
				v9[v10.id] = v10
			end
		end

		local result = {}

		for k, v10 in v8 do
			local v11 = v9[v10.campaignId]

			if v11 == nil then
				if (v10.userId == nil or v10.idempotencyKey ~= k) and v10.durationDays ~= nil then
					result[k] = { startMs = v10.createdAtMs, durationDays = v10.durationDays }
				end
			else
				local startMs = adCampaignScheduleUtils.toStartMs(v11.schedule.startTime)

				if startMs > 0 and v11.schedule.durationInDays > 0 then
					result[k] = { startMs = startMs, durationDays = v11.schedule.durationInDays }
				end
			end
		end

		return result
	end, { v8, v3, data.universeId })

	React.useEffect(function()
		local current = ref4.current
		ref4.current = data.isPageVisible

		if data.isPageVisible and not current then
			setState3(DateTime.now().UnixTimestampMillis)
		end
	end, { data.isPageVisible })
	React.useEffect(function()
		if not data.isPageVisible then
			return
		end

		local minValue = 1e999

		for _, v10 in v9 do
			local campaignEndExclusiveMs = adCampaignScheduleUtils.campaignEndExclusiveMs(v10.startMs, v10.durationDays)

			if state3 < campaignEndExclusiveMs then
				minValue = math.min(minValue, campaignEndExclusiveMs)
			end
		end

		if minValue == 1e999 then
			return
		end

		local thread = nil
		thread = task.delay(math.max(0, minValue - DateTime.now().UnixTimestampMillis) / 1000, function()
			thread = nil
			setState3(DateTime.now().UnixTimestampMillis)
		end)
		return function()
			if thread ~= nil then
				task.cancel(thread)
			end
		end
	end, { v9, data.isPageVisible, state3 })

	local getCardState = React.useCallback(function(p: string)
		local v10 = v8[p]

		if v10 == nil or v10.campaignId == nil then
			if FFlagBuildAgentAdCampaignRefreshEligibility and state4 ~= nil and state4.toolCallId == p then
				return { eligibilityStatus = state4.status }
			end

			return nil
		else
			local v11 = v9[p]
			local v12 = {
				campaignId = v10.campaignId,
				variant = v11 ~= nil and (state3 >= adCampaignScheduleUtils.campaignEndExclusiveMs(
					v11.startMs,
					v11.durationDays
				) and "complete" or "active") or nil,
				campaignStartDate = 0,
				campaignEndDate = 0
			}
			local campaignStartDate

			if v11 ~= nil then
				campaignStartDate = LocalizationStrings.formatAdCampaignSheetLocalDate(v11.startMs)
			end

			v12.campaignStartDate = campaignStartDate
			local campaignEndDate

			if v11 ~= nil then
				campaignEndDate = LocalizationStrings.formatAdCampaignSheetLocalDate(adCampaignScheduleUtils.campaignEndMs(
					v11.startMs,
					v11.durationDays
				))
			end

			v12.campaignEndDate = campaignEndDate
			return v12
		end
	end, { v8, v9, state3, state4 })

	local isCreateDisabled = React.useCallback(function(p: string)
		if FFlagBuildAgentAdCampaignRefreshEligibility and state4 ~= nil and state4.status == "loading" then
			return true
		end

		local v10 = v2[p]
		local v11 = not data.isPageVisible

		if not v11 then
			return not (v10 == nil) and v10.isPending
		end

		return v11
	end, { data.isPageVisible, v2, state4 })

	local v10 = React.useCallback(function(data2, campaignId: string, p: string?)
		if p ~= nil and p ~= data2.idempotencyKey then
			return false
		end

		local clone = table.clone(data2)
		clone.campaignId = campaignId
		clone.phase = "created"
		clone.updatedAtMs = math.max(data2.updatedAtMs, DateTime.now().UnixTimestampMillis)
		local recordAdCampaignCreatedReceipt, v10 = adUpsellEventStore.recordAdCampaignCreatedReceipt(clone)

		if not (recordAdCampaignCreatedReceipt or v10) then
			return false
		end

		agentAdCampaignStore.completeDurable(data2)
		local current = ref.current
		local current2 = ref3.current

		if
			ref2.current
			and current ~= nil
			and current.toolCallId == data2.toolCallId
			and current.universeId == data2.universeId
			and current.sessionId == data2.sessionId
			and current2.universeId == data2.universeId
			and current2.sessionId == data2.sessionId
			and current2.userId == data2.userId
		then
			ref.current = nil
			setState(nil)
		end

		return v10
	end, { agentAdCampaignStore, adUpsellEventStore })

	React.useEffect(function()
		if not FFlagBuildAgentAdCampaignToolCallStatusFallback or userId == nil then
			return
		end

		local v11 = {}

		for _, v12 in v7 do
			if not (v12.userId == userId and v12.campaignId == nil) then
				continue
			end

			local v13 = v2[v12.toolCallId]

			if not (v13 == nil or not v13.isPending) then
				continue
			end

			local fetchToolCallStatus = AdCampaignToolCallStatus.getAdCampaignToolCallStatusStore(false).getAndFetchToolCallStatus(
				userId,
				v12.toolCallId
			)
			table.insert(v11, Signals.createEffect(function(p)
				local data2 = fetchToolCallStatus.data(p)

				if
					fetchToolCallStatus.status(p) == "Ready"
					and data2 ~= nil
					and data2.campaignId ~= nil
					and v10(v12, data2.campaignId)
				then
					v5.refresh()
				end
			end))
		end

		return function()
			for _, v12 in v11 do
				v12()
			end
		end
	end, { v7, v2, userId, v10, v5.refresh })

	local v11 = React.useCallback(function(toolCallId: string, offers): string
		if userId == nil or ref3.current.userId ~= userId then
			return "ignored"
		end

		if
			not data.isPageVisible
			or data.universeId == nil
			or data.universeId == 0
			or data.sessionId == nil
			or toolCallId == ""
			or v8[toolCallId] ~= nil
			or ref3.current.universeId ~= data.universeId
			or ref3.current.sessionId ~= data.sessionId
			or not ref3.current.isPageVisible
			or ref.current ~= nil
			or offers.feedback == nil and offers.plays == nil
		then
			return "ignored"
		end

		local record = adUpsellEventStore.getAdCampaignCard(data.sessionId, toolCallId).record

		if record ~= nil and record.universeId == data.universeId and record.campaignId ~= nil then
			return "ignored"
		end

		if not agentAdCampaignStore.restore({
			universeId = data.universeId,
			sessionId = data.sessionId,
			toolCallId = toolCallId,
			offers = offers,
			runStartTimeMs = DateTime.now().UnixTimestampMillis
		}, userId, persistenceFor(adUpsellEventStore)) then -- inferred equivalent call
			setState2(true)
			return "failed"
		end

		setState2(false)
		local current = agentAdCampaignStore.getAttempts(false)[toolCallId]

		if
			FFlagBuildAgentAdCampaignRefreshEligibility
			and FFlagBuildAgentAdCampaignToolCallStatusFallback
			and current == nil
			and hasFailedBackendAttempt(userId, toolCallId) -- inferred equivalent call
		then
			return "failed"
		end

		if
			current ~= nil
			and (current.isPending or current.userId ~= userId or current.universeId ~= data.universeId or current.sessionId ~= data.sessionId)
		then
			return "ignored"
		end

		local current2

		if current == nil then
			current2 = {
				universeId = data.universeId,
				sessionId = data.sessionId,
				toolCallId = toolCallId,
				offers = 0,
				runStartTimeMs = 0
			}
			local feedback

			if offers.feedback ~= nil then
				feedback = table.clone(offers.feedback)
			end

			local plays

			if offers.plays ~= nil then
				plays = table.clone(offers.plays)
			end

			current2.offers = { feedback = feedback, plays = plays }

			current2.runStartTimeMs = DateTime.now().UnixTimestampMillis
		else
			current2 = agentAdCampaignStore.getRetrySelection(current, DateTime.now().UnixTimestampMillis)
		end

		if FFlagBuildAgentAdCampaignRefreshEligibility and current ~= nil then
			local retryOffers = agentAdCampaignStore.getRetryOffers(current, offers)

			if retryOffers == nil then
				return "failed"
			end

			current2 = table.clone(current2)
			current2.offers = retryOffers
		end

		if FFlagBuildAgentAdCampaignRefreshEligibility then
			local v11 = ref6

			if current == nil or not agentAdCampaignStore.canReplaceRejectedAttempt(current) then
				current = nil
			end

			v11.current = current
		end

		ref.current = current2
		setState(current2)
		v5.clearCreateError()
		return "opened"
	end, {
		data.isPageVisible,
		data.universeId,
		data.sessionId,
		v8,
		adUpsellEventStore,
		agentAdCampaignStore,
		v5.clearCreateError,
		userId,
		setState2,
		ref6
	})

	local onOfferSelected = React.useCallback(function(toolCallId: string, p)
		if not FFlagBuildAgentAdCampaignRefreshEligibility then
			v11(toolCallId, p)
			return
		end

		local current = ref3.current

		if
			not ref2.current
			or not current.isPageVisible
			or current.universeId == nil
			or current.universeId == 0
			or current.sessionId == nil
			or userId == nil
			or current.userId ~= userId
			or current.universeId ~= data.universeId
			or current.sessionId ~= data.sessionId
			or toolCallId == ""
			or ref.current ~= nil
			or ref5.current ~= nil
		then
			return
		end

		local record = adUpsellEventStore.getAdCampaignCard(current.sessionId, toolCallId).record
		local v12 = agentAdCampaignStore.getAttempts(false)[toolCallId]

		if record ~= nil and record.campaignId ~= nil or v12 ~= nil and v12.isPending then
			return
		end

		local current4 = {}
		ref5.current = current4
		v6({ toolCallId = toolCallId, status = "loading" })
		local function isCurrent() -- 2 equivalent calls inferred from this helper
			local current2 = ref3.current
			local v13 = ref2.current

			if not v13 then
				return v13
			end

			if ref5.current == current4 then
				v13 = current2.isPageVisible

				if v13 then
					if current2.universeId == current.universeId and current2.sessionId == current.sessionId then
						return current2.userId == current.userId
					end

					return false
				end
			else
				return false
			end

			return v13
		end

		current4.timer = task.delay(15, function()
			current4.timer = nil

			if isCurrent() then -- inferred equivalent call
				ref5.current = nil
				v6({ toolCallId = toolCallId, status = "failed" })
			end
		end)
		AdCampaignEligibility.getAdCampaignEligibilityStore(false).fetchEligibility(current.universeId, function(p2)
			if not isCurrent() then -- inferred equivalent call
				return
			end

			if current4.timer ~= nil then
				task.cancel(current4.timer)
				current4.timer = nil
			end

			if p2 == nil then
				ref5.current = nil
				v6({ toolCallId = toolCallId, status = "failed" })
			else
				local v13

				if not (p2.cardType == "none" or not adCampaignEligibilityUtils.canCreateCampaign(p2)) then
					v13 = adCampaignEligibilityUtils.getSelectableOffers(p2)
				end

				if v13 == nil then
					ref5.current = nil
					v6({ toolCallId = toolCallId, status = "unavailable" })
				else
					local v14 = v11(toolCallId, v13)
					ref5.current = nil
					v6(v14 == "failed" and { toolCallId = toolCallId, status = "failed" } or nil)
				end
			end
		end)
	end, {
		v11,
		data.universeId,
		data.sessionId,
		userId,
		adUpsellEventStore,
		agentAdCampaignStore,
		ref5,
		v6
	})

	local onSheetClose = React.useCallback(function()
		if not v5.isCreatePending and state ~= nil and ref.current == state then
			ref.current = nil
			setState(nil)
		end
	end, { v5.isCreatePending, state })
	local isSheetOpen

	if state == nil or state.universeId ~= data.universeId or state.sessionId ~= data.sessionId then
		isSheetOpen = false
	else
		isSheetOpen = data.isPageVisible
	end

	local onSheetCreate = React.useCallback(function(p)
		if userId == nil or ref3.current.userId ~= userId then
			return
		end

		if
			state == nil
			or ref.current ~= state
			or p == nil
			or not isSheetOpen
			or not ref3.current.isPageVisible
			or ref3.current.universeId ~= state.universeId
			or ref3.current.sessionId ~= state.sessionId
			or v5.isCreatePending
			or v8[state.toolCallId] ~= nil
		then
			return
		end

		local v12

		if p.campaignOption == "feedback" then
			v12 = state.offers.feedback
		else
			v12 = state.offers.plays
		end

		if v12 == nil or v12.fundingType ~= p.paymentType then
			return
		end

		local v13 = agentAdCampaignStore.getAttempts(false)[state.toolCallId]

		if v13 ~= nil and v13.isPending then
			return
		end

		if not agentAdCampaignStore.restore(state, userId, persistenceFor(adUpsellEventStore)) then -- inferred equivalent call
			setState2(true)
			return
		end

		local v14 = agentAdCampaignStore.getAttempts(false)[state.toolCallId]

		if
			FFlagBuildAgentAdCampaignRefreshEligibility
			and FFlagBuildAgentAdCampaignToolCallStatusFallback
			and v14 == nil
			and hasFailedBackendAttempt(userId, state.toolCallId) -- inferred equivalent call
		then
			ref.current = nil
			setState(nil)
			v6({ toolCallId = state.toolCallId, status = "failed" })
			return
		end

		if v14 ~= nil then
			local retrySelection = agentAdCampaignStore.getRetrySelection(v14, state.runStartTimeMs)

			if FFlagBuildAgentAdCampaignRefreshEligibility then
				local retryOffers = agentAdCampaignStore.getRetryOffers(v14, state.offers)

				if retryOffers == nil then
					ref.current = nil
					setState(nil)
					v6({ toolCallId = state.toolCallId, status = "failed" })
					return
				end

				if retryOffers[p.campaignOption] == nil then
					return
				end

				retrySelection = table.clone(retrySelection)
				retrySelection.offers = retryOffers
			end

			local v15

			if p.campaignOption == "feedback" then
				v15 = retrySelection.offers.feedback
			else
				v15 = retrySelection.offers.plays
			end

			if
				state.runStartTimeMs ~= retrySelection.runStartTimeMs
				or v15 == nil
				or v12.fundingType ~= v15.fundingType
				or v12.durationDays ~= v15.durationDays
				or v12.priceRobux ~= v15.priceRobux
			then
				ref.current = retrySelection
				setState(retrySelection)
				setState2(false)
				return
			end
		end

		local v15 = agentAdCampaignStore.startDurable(state, p, userId, persistenceFor(adUpsellEventStore)) -- inferred equivalent call
		setState2(v15 == nil)

		if v15 == nil then
			return
		end

		sendBuildExperienceEvent(
			"AD_UPSELL_CREATE_CONFIRM_CLICK",
			{ universeId = state.universeId, conversationId = state.sessionId },
			{
				context = "agent_card",
				fundingType = p.paymentType,
				campaignOption = p.campaignOption
			}
		)

		local createCampaign = v5.createCampaign

		local function fn(p2, p3, p4)
			if p4 ~= nil then
				v10(agentAdCampaignStore.toRecord(v15), p2, p3)
			end
		end

		local v16

		if FFlagBuildAgentAdCampaignToolCallStatusFallback then
			v16 = state.toolCallId
		end

		createCampaign(p, fn, v16, {
			idempotencyKey = v15.idempotencyKey,
			onFailed = function(p2)
				if
					agentAdCampaignStore.finishDurable(v15, p2, persistenceFor(adUpsellEventStore)) -- inferred equivalent call
					and FFlagBuildAgentAdCampaignToolCallStatusFallback
					and userId ~= nil
				then
					AdCampaignToolCallStatus.getAdCampaignToolCallStatusStore(false).fetchToolCallStatus(
						userId,
						v15.toolCallId
					)
				end
			end
		})
	end, {
		state,
		agentAdCampaignStore,
		v10,
		userId,
		isSheetOpen,
		v8,
		v5.isCreatePending,
		v5.createCampaign,
		adUpsellEventStore,
		setState2,
		v6
	})
	local campaignOffers

	if state ~= nil then
		campaignOffers = state.offers
	end

	campaignOffers = FFlagBuildAgentAdCampaignRefreshEligibility
		and v4 ~= nil
		and campaignOffers ~= nil
		and not v4.isPending
		and agentAdCampaignStore.getRetryOffers(v4, campaignOffers)
		or campaignOffers
	local selectedOption

	if v4 ~= nil then
		selectedOption = v4.selectedOption
	end

	local v12

	if not (FFlagBuildAgentAdCampaignRefreshEligibility and v4 == ref6.current) then
		v12 = v4
	end

	if
		FFlagBuildAgentAdCampaignRefreshEligibility
		and selectedOption ~= nil
		and campaignOffers ~= nil
		and campaignOffers[selectedOption.campaignOption] == nil
	then
		selectedOption = nil
	end

	local v13 = {
		isSheetOpen = isSheetOpen,
		isCreatePending = 0,
		hasCreateError = 0,
		createErrorKind = 0,
		campaignOffers = 0,
		attemptedOption = 0,
		runStartTimeMs = 0,
		onOfferSelected = 0,
		isCreateDisabled = 0,
		getCardState = 0,
		onSheetClose = 0,
		onSheetCreate = 0
	}

	local isCreatePending = v5.isCreatePending

	if not isCreatePending then
		isCreatePending = not (v4 == nil) and v4.isPending
	end

	v13.isCreatePending = isCreatePending
	state2 = v12 ~= nil and not v12.isPending or state2
	v13.hasCreateError = state2
	local createErrorKind

	if v12 == nil then
		createErrorKind = v5.createErrorKind
	else
		createErrorKind = v12.failureKind
	end

	v13.createErrorKind = createErrorKind
	v13.campaignOffers = campaignOffers
	v13.attemptedOption = selectedOption
	local runStartTimeMs

	if state ~= nil then
		runStartTimeMs = state.runStartTimeMs
	end

	v13.runStartTimeMs = runStartTimeMs
	v13.onOfferSelected = onOfferSelected
	v13.isCreateDisabled = isCreateDisabled
	v13.getCardState = getCardState
	v13.onSheetClose = onSheetClose
	v13.onSheetCreate = onSheetCreate
	return v13
end

return useAgentAdCampaignChatViewModel
