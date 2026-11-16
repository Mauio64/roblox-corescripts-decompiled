local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local HttpService = game:GetService("HttpService")
require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
require(parent.DataHydration.CreatorAgentChat)
require(BuildExperience.Storage.createAdCampaignCardStorage)
local FFlagBuildAgentAdCampaignRefreshEligibility = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignRefreshEligibility)

local function hasToolCallIdempotency(data): boolean -- 4 equivalent calls inferred from this helper
	return data.idempotencyKey == data.toolCallId
end

local function isWithinReplayWindow(p): boolean -- 3 equivalent calls inferred from this helper
	local v = DateTime.now().UnixTimestampMillis - (p.attemptStartedAtMs or 0)
	return v >= 0 and v < 82800000
end

local function isDefinitiveFailure(data) -- 3 equivalent calls inferred from this helper
	local v = not data.isPending

	if v then
		if data.hasAmbiguousFailure == false and data.failureKind ~= nil then
			return data.failureKind ~= "unknown"
		end

		return false
	end

	return v
end

local function canReplaceRejectedAttempt(data) -- 2 equivalent calls inferred from this helper
	return isDefinitiveFailure(data) and data.failureKind ~= "payment_required" -- inferred equivalent call
end

local function getRetrySelection(data, runStartTimeMs: number)
	if hasToolCallIdempotency(data) then -- inferred equivalent call
		local now = DateTime.now()
		local localTime = now:ToLocalTime()
		local localTime2 = DateTime.fromUnixTimestampMillis(data.runStartTimeMs):ToLocalTime()

		if
			localTime2.Year == localTime.Year
			and localTime2.Month == localTime.Month
			and localTime2.Day == localTime.Day
		then
			return data
		end

		local localTime3 = DateTime.fromUnixTimestampMillis(runStartTimeMs):ToLocalTime()
		local clone = table.clone(data)

		if
			localTime3.Year ~= localTime.Year
			or localTime3.Month ~= localTime.Month
			or localTime3.Day ~= localTime.Day
		then
			runStartTimeMs = now.UnixTimestampMillis
		end

		clone.runStartTimeMs = runStartTimeMs

		return clone
	else
		if isWithinReplayWindow(data) then -- inferred equivalent call
			return data
		end

		if not isDefinitiveFailure(data) then -- inferred equivalent call
			return data
		end

		local clone = table.clone(data)
		local unixTimestampMillis = DateTime.now().UnixTimestampMillis
		local v = unixTimestampMillis - runStartTimeMs

		if v >= 0 then
			if not (v < 82800000) then
				runStartTimeMs = unixTimestampMillis
			end
		else
			runStartTimeMs = unixTimestampMillis
		end

		clone.runStartTimeMs = runStartTimeMs
		return clone
	end
end

local function getRetryOffers(p, p2)
	if canReplaceRejectedAttempt(p) then -- inferred equivalent call
		return p2
	end

	local campaignOption = p.selectedOption.campaignOption
	local offer = p.offers[campaignOption]
	local v = p2[campaignOption]

	if
		offer == nil
		or v == nil
		or v.fundingType ~= p.selectedOption.paymentType
		or v.durationDays ~= offer.durationDays
		or v.priceRobux ~= offer.priceRobux
	then
		return nil
	end

	return { [campaignOption] = v }
end

local function toRecord(data)
	local selectedOption = data.selectedOption
	local v

	if selectedOption.campaignOption == "feedback" then
		v = data.offers.feedback
	else
		v = data.offers.plays
	end

	assert(v ~= nil, "A submitted campaign must have an offer")
	return {
		sessionId = data.sessionId,
		universeId = data.universeId,
		toolCallId = data.toolCallId,
		idempotencyKey = data.idempotencyKey,
		userId = data.userId,
		attemptStartedAtMs = data.attemptStartedAtMs,
		hasAmbiguousFailure = data.hasAmbiguousFailure,
		campaignOption = selectedOption.campaignOption,
		fundingType = selectedOption.paymentType,
		durationDays = v.durationDays,
		displayAmountRobux = v.priceRobux,
		phase = data.isPending and "creating" or (data.hasAmbiguousFailure or data.failureKind == nil or data.failureKind == "unknown") and "outcome_unknown" or data.failureKind == "payment_required" and "payment_required" or "failed",
		lastErrorCode = data.failureKind,
		createdAtMs = data.runStartTimeMs,
		updatedAtMs = math.max(data.runStartTimeMs, DateTime.now().UnixTimestampMillis)
	}
end

local function createAgentAdCampaignStore()
	local sessionScopedSignal, v = SignalsUtils.createSessionScopedSignal({})

	local sessionScopedSignal2, v2 = SignalsUtils.createSessionScopedSignal({})

	local function start(data, p, userId: number?, flag: boolean?)
		local v3 = sessionScopedSignal(false)
		local v4 = v3[data.toolCallId]
		local v5 = not flag

		if v5 then
			if v4 == nil or v4.selectedOption.campaignOption ~= p.campaignOption then
				v5 = false
			else
				v5 = v4.selectedOption.paymentType == p.paymentType
			end
		end

		if
			v4 ~= nil
			and (v4.isPending or v4.universeId ~= data.universeId or v4.sessionId ~= data.sessionId or v4.toolCallId ~= data.toolCallId or not v5 and (v4.failureKind == nil or v4.failureKind == "unknown"))
		then
			return nil
		end

		local v6 = if v4 == nil or not v5 then data else v4
		local v7 = {
			universeId = v6.universeId,
			sessionId = v6.sessionId,
			toolCallId = v6.toolCallId,
			offers = 0,
			runStartTimeMs = 0,
			selectedOption = 0,
			idempotencyKey = 0,
			isPending = true,
			failureKind = nil,
			userId = 0,
			attemptStartedAtMs = 0,
			hasAmbiguousFailure = 0
		}
		local feedback

		if v6.offers.feedback ~= nil then
			feedback = table.clone(v6.offers.feedback)
		end

		local plays

		if v6.offers.plays ~= nil then
			plays = table.clone(v6.offers.plays)
		end

		v7.offers = { feedback = feedback, plays = plays }

		v7.runStartTimeMs = v6.runStartTimeMs
		v7.selectedOption = table.clone(p)
		local idempotencyKey

		if v4 == nil or not (v5 or hasToolCallIdempotency(v4)) then -- inferred equivalent call
			if v4 == nil and userId ~= nil then
				idempotencyKey = data.toolCallId
			else
				idempotencyKey = HttpService:GenerateGUID(false)
			end
		else
			idempotencyKey = v4.idempotencyKey
		end

		v7.idempotencyKey = idempotencyKey

		v7.userId = userId
		local attemptStartedAtMs

		if userId ~= nil then
			if v4 == nil or not v5 then
				attemptStartedAtMs = DateTime.now().UnixTimestampMillis
			else
				attemptStartedAtMs = v4.attemptStartedAtMs
			end
		end

		v7.attemptStartedAtMs = attemptStartedAtMs
		local hasAmbiguousFailure

		if userId ~= nil then
			if v4 == nil then
				hasAmbiguousFailure = false
			else
				hasAmbiguousFailure = v5 and v4.hasAmbiguousFailure == true
			end
		end

		v7.hasAmbiguousFailure = hasAmbiguousFailure

		local clone = table.clone(v3)
		clone[data.toolCallId] = v7
		v(clone)
		return v7
	end

	local function finish(data, flag: boolean, failureKind, hasAmbiguousFailure: boolean?): boolean -- 1 equivalent call inferred from this helper
		local v3 = sessionScopedSignal(false)

		if v3[data.toolCallId] ~= data then
			return false
		end

		local clone = table.clone(v3)

		if flag then
			clone[data.toolCallId] = nil
		else
			local clone2 = table.clone(data)
			clone2.isPending = false
			clone2.failureKind = failureKind

			if hasAmbiguousFailure ~= nil then
				clone2.hasAmbiguousFailure = hasAmbiguousFailure
			end

			clone[data.toolCallId] = clone2
		end

		v(clone)
		return true
	end

	local function restore(data, userId: number, p): boolean
		local v3 = p.get(data.sessionId, data.toolCallId)

		if not v3.isAvailable then
			return false
		end

		local v4 = sessionScopedSignal(false)[data.toolCallId]

		if
			v4 ~= nil
			and (v4.userId ~= userId or v4.sessionId ~= data.sessionId or v4.universeId ~= data.universeId)
		then
			return false
		end

		local record = v3.record

		if record == nil then
			return true
		end

		if
			record.campaignId ~= nil
			or record.userId ~= userId
			or record.universeId ~= data.universeId
			or type(record.attemptStartedAtMs) ~= "number"
			or type(record.hasAmbiguousFailure) ~= "boolean"
			or record.campaignOption ~= "feedback" and record.campaignOption ~= "plays"
			or record.durationDays == nil
			or record.displayAmountRobux == nil
		then
			return false
		end

		if v4 ~= nil and v4.idempotencyKey == record.idempotencyKey then
			return true
		end

		if v4 ~= nil and v4.isPending then
			return false
		end

		local clone = table.clone(data.offers)
		clone[record.campaignOption] = {
			campaignOption = record.campaignOption,
			fundingType = record.fundingType,
			durationDays = record.durationDays,
			priceRobux = record.displayAmountRobux
		}

		local failureKind = "unknown"

		if not record.hasAmbiguousFailure and (record.phase == "failed" or record.phase == "payment_required") then
			local lastErrorCode = record.lastErrorCode

			if
				lastErrorCode == "payment_required"
				or lastErrorCode == "ineligible"
				or lastErrorCode == "missing_thumbnail"
				or lastErrorCode == "invalid_offer"
			then
				failureKind = lastErrorCode
			end
		end

		local v5 = {
			universeId = record.universeId,
			sessionId = record.sessionId,
			toolCallId = record.toolCallId,
			offers = clone,
			runStartTimeMs = record.createdAtMs,
			selectedOption = {
				campaignOption = record.campaignOption,
				paymentType = record.fundingType
			},
			idempotencyKey = record.idempotencyKey,
			isPending = false,
			failureKind = failureKind,
			userId = userId,
			attemptStartedAtMs = record.attemptStartedAtMs,
			hasAmbiguousFailure = failureKind == "unknown"
		}

		local clone2 = table.clone(sessionScopedSignal(false))
		clone2[data.toolCallId] = v5
		v(clone2)
		return true
	end

	return {
		getAttempts = sessionScopedSignal,
		getRetrySelection = getRetrySelection,
		getRetryOffers = getRetryOffers,
		canReplaceRejectedAttempt = canReplaceRejectedAttempt,
		start = start,
		finish = finish,
		restore = restore,
		startDurable = function(p, p2, userId: number, p3)
			if not restore(p, userId, p3) then
				return nil
			end

			local v3 = sessionScopedSignal(false)[p.toolCallId]
			local v4 = false

			if v3 ~= nil then
				local v5 = v3.hasAmbiguousFailure
				local v6

				if FFlagBuildAgentAdCampaignRefreshEligibility then
					v6 = canReplaceRejectedAttempt(v3) -- inferred equivalent call
					v5 = not v6
				else
					v6 = false
				end

				if not hasToolCallIdempotency(v3) and not isWithinReplayWindow(v3) then -- inferred equivalent call
					if not (isDefinitiveFailure(v3) and p.runStartTimeMs == getRetrySelection(v3, p.runStartTimeMs).runStartTimeMs) then -- inferred equivalent call
						return nil
					end

					v4 = true
				end

				if
					v5
					and (v3.selectedOption.campaignOption ~= p2.campaignOption or v3.selectedOption.paymentType ~= p2.paymentType)
				then
					return nil
				end

				v4 = v6 and true or v4
			end

			local v5 = start(p, p2, userId, v4)

			if v5 == nil then
				return nil
			end

			local save = p3.save
			local v6 = toRecord(v5)
			local v7

			if v3 ~= nil then
				v7 = v3.idempotencyKey
			end

			if save(v6, v7) then
				if sessionScopedSignal(false)[v5.toolCallId] ~= v5 then
					return nil
				end

				if hasToolCallIdempotency(v5) then -- inferred equivalent call
					return v5
				end

				if isWithinReplayWindow(v5) then -- inferred equivalent call
					return v5
				end

				local v8 = sessionScopedSignal(false)

				if v8[v5.toolCallId] ~= v5 then
					return nil
				end

				local clone = table.clone(v8)

				local clone2 = table.clone(v5)
				clone2.isPending = false
				clone2.failureKind = "unknown"

				clone2.hasAmbiguousFailure = true

				clone[v5.toolCallId] = clone2

				v(clone)

				return nil
			end

			if sessionScopedSignal(false)[v5.toolCallId] == v5 then
				local clone = table.clone(sessionScopedSignal(false))
				clone[v5.toolCallId] = v3
				v(clone)
			end

			return nil
		end,
		finishDurable = function(data, failureKind, p)
			if sessionScopedSignal(false)[data.toolCallId] ~= data then
				return false
			end

			local clone = table.clone(data)
			clone.isPending = false
			clone.failureKind = failureKind
			clone.hasAmbiguousFailure = data.hasAmbiguousFailure == true
				or failureKind == nil
				or failureKind == "unknown"

			p.save(toRecord(clone), data.idempotencyKey)
			return finish(data, false, failureKind, clone.hasAmbiguousFailure) -- inferred equivalent call
		end,
		completeDurable = function(data)
			local v3 = sessionScopedSignal(false)[data.toolCallId]

			if
				v3 ~= nil
				and v3.userId == data.userId
				and v3.sessionId == data.sessionId
				and v3.universeId == data.universeId
				and v3.idempotencyKey == data.idempotencyKey
			then
				local v4 = sessionScopedSignal(false)

				if v4[v3.toolCallId] ~= v3 then
					return
				end

				local clone = table.clone(v4)

				clone[v3.toolCallId] = nil

				v(clone)
			end
		end,
		toRecord = toRecord,
		markImpressed = function(p: string, p2: string): boolean
			local v3 = sessionScopedSignal2(false)

			if v3[p] ~= nil and v3[p][p2] then
				return false
			end

			local clone = table.clone(v3)
			clone[p] = table.clone(v3[p] or {})
			clone[p][p2] = true
			v2(clone)
			return true
		end,
		reset = function()
			v({})
			v2({})
		end
	}
end

return createAgentAdCampaignStore
