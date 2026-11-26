local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Players = game:GetService("Players")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local useCreateAdCampaign = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useCreateAdCampaign")
local GetAdUpsellEventStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAdUpsellEventStore")
local GetAgentAdCampaignStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAgentAdCampaignStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAgentAdCampaignStore/createAgentAdCampaignStore")
local AdCampaignToolCallStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaignToolCallStatus")
local AdCampaigns = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaigns")
local AdCampaignEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/AdCampaignEligibility")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Storage/createAdCampaignCardStorage")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local adCampaignScheduleUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/adCampaignScheduleUtils")
local adCampaignEligibilityUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/adCampaignEligibilityUtils")

local FFlagBuildAgentAdCampaignRefreshEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignRefreshEligibility")

local FFlagBuildAgentAdCampaignToolCallStatusFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignToolCallStatusFallback")

local function persistenceFor(p2)
	return { get = p2.getAdCampaignCard, save = p2.recordAdCampaignAttempt }
end

local function hasFailedBackendAttempt(p2, p3): boolean
	local data = AdCampaignToolCallStatus.getAdCampaignToolCallStatusStore(false).getToolCallStatus(p2, p3).data(false)
	return data ~= nil and data.status == "failed"
end

local function useAgentAdCampaignChatViewModel(data, p2)
	local v5 = GetAdUpsellEventStore(false)
	local v6 = SignalsReact.useSignalState(v5.getAdCampaignRevision)
	local v7 = GetAgentAdCampaignStore(false)
	local v8 = SignalsReact.useSignalState(v7.getAttempts)
	local adCampaignsStore = AdCampaigns.getAdCampaignsStore(false)
	local v9 = SignalsReact.useSignalState(adCampaignsStore.getAdCampaigns().data)
	local localPlayer = Players.LocalPlayer

	if not p2 then
		if localPlayer == nil or not (localPlayer.UserId > 0) then
			p2 = nil
		else
			p2 = localPlayer.UserId
		end
	end

	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local v10 = if state ~= nil then v8[state.toolCallId] else nil
	local v11 = useCreateAdCampaign(data.universeId, data.sessionId)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(DateTime.now().UnixTimestampMillis)
	local ref2 = React.useRef(true)
	local v12 = {
		universeId = data.universeId,
		sessionId = data.sessionId,
		isPageVisible = data.isPageVisible,
		userId = p2
	}

	local ref3 = React.useRef(v12)
	ref3.current = v12
	local ref4 = React.useRef(data.isPageVisible)

	local ref5 = if FFlagBuildAgentAdCampaignRefreshEligibility then React.useRef(nil) else nil

	local ref6 = if FFlagBuildAgentAdCampaignRefreshEligibility then React.useRef(nil) else nil
	local state4, v13

	if FFlagBuildAgentAdCampaignRefreshEligibility then
		local setState4
		state4, setState4 = React.useState(nil)
		v13 = setState4

		React.useEffect(function()
			v13(nil)
			return function()
				local current = ref5.current
				ref5.current = nil

				if current ~= nil and current.timer ~= nil then
					task.cancel(current.timer)
				end
			end
		end, { data.universeId, data.sessionId, data.isPageVisible, p2, ref5, v13 })
	else
		state4 = nil
		v13 = nil
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
	end, { data.universeId, data.sessionId, p2 })
	React.useEffect(function()
		if data.isPageVisible then
			v5.retryAdCampaignCardWrites()
		end
	end, { data.isPageVisible, v5 })

	local v14 = React.useMemo(function()
		local recordsByToolCallId = {}

		if data.sessionId ~= nil then
			for k, record in v5.listAdCampaignCards(data.sessionId).records do
				if
					(record.userId == nil or record.userId == p2)
					and record.universeId == data.universeId
				then
					recordsByToolCallId[record.toolCallId] = record
				end
			end
		end

		return recordsByToolCallId
	end, { data.sessionId, data.universeId, v5, v6, p2 })
	local v15 = React.useMemo(function()
		local result = {}

		for k, v16 in v14 do
			if v16.campaignId ~= nil then
				result[k] = v16
			end
		end

		return result
	end, { v14 })
	React.useEffect(function()
		if data.isPageVisible and next(v15) ~= nil then
			adCampaignsStore.getAndFetchAdCampaigns()
		end
	end, { v15, data.isPageVisible, adCampaignsStore })
	local v16 = React.useMemo(function()
		local v17 = {}

		for k, v18 in v9 or {} do
			if v18.targetUniverseId == tostring(data.universeId) then
				v17[v18.id] = v18
			end
		end

		local result = {}

		for k, v18 in v15 do
			local v19 = v17[v18.campaignId]

			if v19 == nil then
				if (v18.userId == nil or v18.idempotencyKey ~= k) and v18.durationDays ~= nil then
					result[k] = {
						startMs = v18.createdAtMs,
						durationDays = v18.durationDays
					}
				end
			else
				local startMs = adCampaignScheduleUtils.toStartMs(v19.schedule.startTime)

				if startMs > 0 and v19.schedule.durationInDays > 0 then
					result[k] = {
						startMs = startMs,
						durationDays = v19.schedule.durationInDays
					}
				end
			end
		end

		return result
	end, { v15, v9, data.universeId })

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

		for k, v17 in v16 do
			local campaignEndExclusiveMs = adCampaignScheduleUtils.campaignEndExclusiveMs(v17.startMs, v17.durationDays)

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
	end, { v16, data.isPageVisible, state3 })

	local v17 = React.useCallback(function(p3)
		local v18 = v15[p3]

		if v18 == nil or v18.campaignId == nil then
			if FFlagBuildAgentAdCampaignRefreshEligibility and state4 ~= nil and state4.toolCallId == p3 then
				return { eligibilityStatus = state4.status }
			end

			return nil
		else
			local v19 = v16[p3]
			local v20 = {
				campaignId = v18.campaignId,
				variant = v19 ~= nil and (state3 >= adCampaignScheduleUtils.campaignEndExclusiveMs(
					v19.startMs,
					v19.durationDays
				) and "complete" or "active") or nil,
				campaignStartDate = 0,
				campaignEndDate = 0
			}

			local v21 = if v19 ~= nil then LocalizationStrings.formatAdCampaignSheetLocalDate(v19.startMs) else nil
			v20.campaignStartDate = v21

			local v22 = if v19 ~= nil then LocalizationStrings.formatAdCampaignSheetLocalDate(adCampaignScheduleUtils.campaignEndMs(v19.startMs, v19.durationDays)) else nil
			v20.campaignEndDate = v22
			return v20
		end
	end, { v15, v16, state3, state4 })

	local v18 = React.useCallback(function(p3)
		if FFlagBuildAgentAdCampaignRefreshEligibility and state4 ~= nil and state4.status == "loading" then
			return true
		end

		local v19 = v8[p3]
		local v20 = not data.isPageVisible

		if not v20 then
			v20 = not (v19 == nil) and v19.isPending
		end

		return v20
	end, { data.isPageVisible, v8, state4 })

	local v19 = React.useCallback(function(data2, campaignId, p3)
		if p3 ~= nil and p3 ~= data2.idempotencyKey then
			return false
		end

		local clone = table.clone(data2)
		clone.campaignId = campaignId
		clone.phase = "created"
		clone.updatedAtMs = math.max(data2.updatedAtMs, DateTime.now().UnixTimestampMillis)
		local recordAdCampaignCreatedReceipt, v20 = v5.recordAdCampaignCreatedReceipt(clone)

		if not (recordAdCampaignCreatedReceipt or v20) then
			return false
		end

		v7.completeDurable(data2)
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

		return v20
	end, { v7, v5 })

	React.useEffect(function()
		if not FFlagBuildAgentAdCampaignToolCallStatusFallback or p2 == nil then
			return
		end

		local v20 = {}

		for k, v21 in v14 do
			if not (v21.userId == p2 and v21.campaignId == nil) then
				continue
			end

			local v22 = v8[v21.toolCallId]

			if not (v22 == nil or not v22.isPending) then
				continue
			end

			local fetchToolCallStatus = AdCampaignToolCallStatus.getAdCampaignToolCallStatusStore(false).getAndFetchToolCallStatus(
				p2,
				v21.toolCallId
			)
			table.insert(v20, Signals.createEffect(function(p3)
				local data2 = fetchToolCallStatus.data(p3)

				if
					fetchToolCallStatus.status(p3) == "Ready"
					and data2 ~= nil
					and data2.campaignId ~= nil
					and v19(v21, data2.campaignId)
				then
					v11.refresh()
				end
			end))
		end

		return function()
			for k, v21 in v20 do
				v21()
			end
		end
	end, { v14, v8, p2, v19, v11.refresh })

	local v20 = React.useCallback(function(p3, p4): string
		if p2 == nil or ref3.current.userId ~= p2 then
			return "ignored"
		end

		if
			not data.isPageVisible
			or data.universeId == nil
			or data.universeId == 0
			or data.sessionId == nil
			or p3 == ""
			or v15[p3] ~= nil
			or ref3.current.universeId ~= data.universeId
			or ref3.current.sessionId ~= data.sessionId
			or not ref3.current.isPageVisible
			or ref.current ~= nil
			or p4.feedback == nil and p4.plays == nil
		then
			return "ignored"
		end

		local record = v5.getAdCampaignCard(data.sessionId, p3).record

		if record ~= nil and record.universeId == data.universeId and record.campaignId ~= nil then
			return "ignored"
		end

		local v22 = v5

		if not v7.restore({
			universeId = data.universeId,
			sessionId = data.sessionId,
			toolCallId = p3,
			offers = p4,
			runStartTimeMs = DateTime.now().UnixTimestampMillis
		}, p2, { get = v22.getAdCampaignCard, save = v22.recordAdCampaignAttempt }) then
			setState2(true)
			return "failed"
		end

		setState2(false)
		local v23 = v7.getAttempts(false)[p3]

		if FFlagBuildAgentAdCampaignRefreshEligibility and FFlagBuildAgentAdCampaignToolCallStatusFallback and v23 == nil then
			local data2 = AdCampaignToolCallStatus.getAdCampaignToolCallStatusStore(false).getToolCallStatus(p2, p3).data(false)
			local v25 = not (data2 == nil) and data2.status == "failed"

			if v25 then
				return "failed"
			end
		end

		if
			v23 ~= nil
			and (v23.isPending or v23.userId ~= p2 or v23.universeId ~= data.universeId or v23.sessionId ~= data.sessionId)
		then
			return "ignored"
		end

		local v24

		if v23 == nil then
			v24 = {
				universeId = data.universeId,
				sessionId = data.sessionId,
				toolCallId = p3,
				offers = 0,
				runStartTimeMs = 0
			}

			local v26 = if p4.feedback ~= nil then table.clone(p4.feedback) else nil
			local v27 = if p4.plays ~= nil then table.clone(p4.plays) else nil
			v24.offers = { feedback = v26, plays = v27 }

			v24.runStartTimeMs = DateTime.now().UnixTimestampMillis
		else
			v24 = v7.getRetrySelection(v23, DateTime.now().UnixTimestampMillis)
		end

		if FFlagBuildAgentAdCampaignRefreshEligibility and v23 ~= nil then
			local retryOffers = v7.getRetryOffers(v23, p4)

			if retryOffers == nil then
				return "failed"
			end

			v24 = table.clone(v24)
			v24.offers = retryOffers
		end

		if FFlagBuildAgentAdCampaignRefreshEligibility then
			local v25 = ref6

			if v23 == nil or not v7.canReplaceRejectedAttempt(v23) then
				v23 = nil
			end

			v25.current = v23
		end

		ref.current = v24
		setState(v24)
		v11.clearCreateError()
		return "opened"
	end, {
		data.isPageVisible,
		data.universeId,
		data.sessionId,
		v15,
		v5,
		v7,
		v11.clearCreateError,
		p2,
		setState2,
		ref6
	})

	local v21 = React.useCallback(function(p3, p4)
		if not FFlagBuildAgentAdCampaignRefreshEligibility then
			v20(p3, p4)
			return
		end

		local current = ref3.current

		if
			not ref2.current
			or not current.isPageVisible
			or current.universeId == nil
			or current.universeId == 0
			or current.sessionId == nil
			or p2 == nil
			or current.userId ~= p2
			or current.universeId ~= data.universeId
			or current.sessionId ~= data.sessionId
			or p3 == ""
			or ref.current ~= nil
			or ref5.current ~= nil
		then
			return
		end

		local record = v5.getAdCampaignCard(current.sessionId, p3).record
		local v22 = v7.getAttempts(false)[p3]

		if record ~= nil and record.campaignId ~= nil or v22 ~= nil and v22.isPending then
			return
		end

		local v23 = {}
		ref5.current = v23
		v13({ toolCallId = p3, status = "loading" })
		local function isCurrent()
			local current2 = ref3.current
			local v24 = ref2.current

			if not v24 then
				return v24
			end

			if ref5.current == v23 then
				v24 = current2.isPageVisible

				if v24 then
					if
						current2.universeId == current.universeId
						and current2.sessionId == current.sessionId
					then
						v24 = current2.userId == current.userId
					else
						v24 = false
					end
				end
			else
				v24 = false
			end

			return v24
		end

		v23.timer = task.delay(15, function()
			v23.timer = nil
			local current2 = ref3.current
			local v24 = ref2.current

			if v24 then
				if ref5.current == v23 then
					v24 = current2.isPageVisible

					if v24 then
						if
							current2.universeId == current.universeId
							and current2.sessionId == current.sessionId
						then
							v24 = current2.userId == current.userId
						else
							v24 = false
						end
					end
				else
					v24 = false
				end
			end

			if v24 then
				ref5.current = nil
				v13({ toolCallId = p3, status = "failed" })
			end
		end)
		AdCampaignEligibility.getAdCampaignEligibilityStore(false).fetchEligibility(current.universeId, function(p5)
			local current2 = ref3.current
			local v24 = ref2.current

			if v24 then
				if ref5.current == v23 then
					v24 = current2.isPageVisible

					if v24 then
						if
							current2.universeId == current.universeId
							and current2.sessionId == current.sessionId
						then
							v24 = current2.userId == current.userId
						else
							v24 = false
						end
					end
				else
					v24 = false
				end
			end

			if not v24 then
				return
			end

			if v23.timer ~= nil then
				task.cancel(v23.timer)
				v23.timer = nil
			end

			if p5 == nil then
				ref5.current = nil
				v13({ toolCallId = p3, status = "failed" })
			else
				local v25

				if not (p5.cardType == "none" or not adCampaignEligibilityUtils.canCreateCampaign(p5)) then
					v25 = adCampaignEligibilityUtils.getSelectableOffers(p5)
				end

				if v25 == nil then
					ref5.current = nil
					v13({ toolCallId = p3, status = "unavailable" })
				else
					local v26 = v20(p3, v25)
					ref5.current = nil
					v13(v26 == "failed" and { toolCallId = p3, status = "failed" } or nil)
				end
			end
		end)
	end, { v20, data.universeId, data.sessionId, p2, v5, v7, ref5, v13 })

	local v22 = React.useCallback(function()
		if not v11.isCreatePending and state ~= nil and ref.current == state then
			ref.current = nil
			setState(nil)
		end
	end, { v11.isCreatePending, state })
	local v23

	if state == nil or state.universeId ~= data.universeId or state.sessionId ~= data.sessionId then
		v23 = false
	else
		v23 = data.isPageVisible
	end

	local v24 = React.useCallback(function(p3)
		if p2 == nil or ref3.current.userId ~= p2 then
			return
		end

		if
			state == nil
			or ref.current ~= state
			or p3 == nil
			or not v23
			or not ref3.current.isPageVisible
			or ref3.current.universeId ~= state.universeId
			or ref3.current.sessionId ~= state.sessionId
			or v11.isCreatePending
			or v15[state.toolCallId] ~= nil
		then
			return
		end

		local v25 = if p3.campaignOption == "feedback" then state.offers.feedback else state.offers.plays

		if v25 == nil or v25.fundingType ~= p3.paymentType then
			return
		end

		local v26 = v7.getAttempts(false)[state.toolCallId]

		if v26 ~= nil and v26.isPending then
			return
		end

		local v27 = v5

		if not v7.restore(state, p2, {
			get = v27.getAdCampaignCard,
			save = v27.recordAdCampaignAttempt
		}) then
			setState2(true)
			return
		end

		local v28 = v7.getAttempts(false)[state.toolCallId]

		if FFlagBuildAgentAdCampaignRefreshEligibility and FFlagBuildAgentAdCampaignToolCallStatusFallback and v28 == nil then
			local toolCallId = state.toolCallId
			local data2 = AdCampaignToolCallStatus.getAdCampaignToolCallStatusStore(false).getToolCallStatus(p2, toolCallId).data(false)
			local v30 = not (data2 == nil) and data2.status == "failed"

			if v30 then
				ref.current = nil
				setState(nil)
				v13({ toolCallId = state.toolCallId, status = "failed" })
				return
			end
		end

		if v28 ~= nil then
			local retrySelection = v7.getRetrySelection(v28, state.runStartTimeMs)

			if FFlagBuildAgentAdCampaignRefreshEligibility then
				local retryOffers = v7.getRetryOffers(v28, state.offers)

				if retryOffers == nil then
					ref.current = nil
					setState(nil)
					v13({ toolCallId = state.toolCallId, status = "failed" })
					return
				end

				if retryOffers[p3.campaignOption] == nil then
					return
				end

				retrySelection = table.clone(retrySelection)
				retrySelection.offers = retryOffers
			end

			local v29

			if p3.campaignOption == "feedback" then
				v29 = retrySelection.offers.feedback
			else
				v29 = retrySelection.offers.plays
			end

			if
				state.runStartTimeMs ~= retrySelection.runStartTimeMs
				or v29 == nil
				or v25.fundingType ~= v29.fundingType
				or v25.durationDays ~= v29.durationDays
				or v25.priceRobux ~= v29.priceRobux
			then
				ref.current = retrySelection
				setState(retrySelection)
				setState2(false)
				return
			end
		end

		local v29 = v5
		local v30 = v7.startDurable(state, p3, p2, {
			get = v29.getAdCampaignCard,
			save = v29.recordAdCampaignAttempt
		})
		setState2(v30 == nil)

		if v30 == nil then
			return
		end

		sendBuildExperienceEvent(
			"AD_UPSELL_CREATE_CONFIRM_CLICK",
			{ universeId = state.universeId, conversationId = state.sessionId },
			{
				context = "agent_card",
				fundingType = p3.paymentType,
				campaignOption = p3.campaignOption
			}
		)

		local createCampaign = v11.createCampaign

		local function fn(p4, p5, p6)
			if p6 ~= nil then
				v19(v7.toRecord(v30), p4, p5)
			end
		end
		local v31 = if FFlagBuildAgentAdCampaignToolCallStatusFallback then state.toolCallId else nil
		createCampaign(p3, fn, v31, {
			idempotencyKey = v30.idempotencyKey,
			onFailed = function(p4)
				local v32 = v5

				if
					v7.finishDurable(v30, p4, {
						get = v32.getAdCampaignCard,
						save = v32.recordAdCampaignAttempt
					})
					and FFlagBuildAgentAdCampaignToolCallStatusFallback
					and p2 ~= nil
				then
					AdCampaignToolCallStatus.getAdCampaignToolCallStatusStore(false).fetchToolCallStatus(p2, v30.toolCallId)
				end
			end
		})
	end, {
		state,
		v7,
		v19,
		p2,
		v23,
		v15,
		v11.isCreatePending,
		v11.createCampaign,
		v5,
		setState2,
		v13
	})

	local v25 = if state ~= nil then state.offers else nil

	v25 = FFlagBuildAgentAdCampaignRefreshEligibility and v10 ~= nil and v25 ~= nil and not v10.isPending and v7.getRetryOffers(v10, v25)
		or v25

	local selectedOption = if v10 ~= nil then v10.selectedOption else nil

	local v26 = if not (FFlagBuildAgentAdCampaignRefreshEligibility and v10 == ref6.current) then v10 else nil

	if FFlagBuildAgentAdCampaignRefreshEligibility and selectedOption ~= nil and v25 ~= nil and v25[selectedOption.campaignOption] == nil then
		selectedOption = nil
	end

	local v27 = {
		isSheetOpen = v23,
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

	local v28 = v11.isCreatePending

	if not v28 then
		v28 = not (v10 == nil) and v10.isPending
	end

	v27.isCreatePending = v28
	state2 = v26 ~= nil and not v26.isPending or state2
	v27.hasCreateError = state2
	local v29 = if v26 == nil then v11.createErrorKind else v26.failureKind
	v27.createErrorKind = v29
	v27.campaignOffers = v25
	v27.attemptedOption = selectedOption
	local v30 = if state ~= nil then state.runStartTimeMs else nil
	v27.runStartTimeMs = v30
	v27.onOfferSelected = v21
	v27.isCreateDisabled = v18
	v27.getCardState = v17
	v27.onSheetClose = v22
	v27.onSheetCreate = v24
	return v27
end

return useAgentAdCampaignChatViewModel
