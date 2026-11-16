local HttpService = game:GetService("HttpService")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Storage/createAdCampaignCardStorage")
local FFlagBuildAgentAdCampaignRefreshEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignRefreshEligibility")

local function hasToolCallIdempotency(p2): boolean
	return p2.idempotencyKey == p2.toolCallId
end

local function isWithinReplayWindow(p2): boolean
	local v5 = DateTime.now().UnixTimestampMillis - (p2.attemptStartedAtMs or 0)
	return v5 >= 0 and v5 < 82800000
end

local function isDefinitiveFailure(data)
	local v5 = not data.isPending

	if v5 then
		if data.hasAmbiguousFailure == false and data.failureKind ~= nil then
			v5 = data.failureKind ~= "unknown"
		else
			v5 = false
		end
	end

	return v5
end

local function canReplaceRejectedAttempt(data)
	local v5 = not data.isPending

	if v5 then
		if data.hasAmbiguousFailure == false and data.failureKind ~= nil then
			v5 = data.failureKind ~= "unknown"
		else
			v5 = false
		end
	end

	return v5 and data.failureKind ~= "payment_required"
end

local function getRetrySelection(data, runStartTimeMs)
	if data.idempotencyKey == data.toolCallId then
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
		local v5 = DateTime.now().UnixTimestampMillis - (data.attemptStartedAtMs or 0)
		local v6 = v5 >= 0 and v5 < 82800000

		if v6 then
			return data
		end

		local v7 = not data.isPending

		if v7 then
			if data.hasAmbiguousFailure == false and data.failureKind ~= nil then
				v7 = data.failureKind ~= "unknown"
			else
				v7 = false
			end
		end

		if not v7 then
			return data
		end

		local clone = table.clone(data)
		local unixTimestampMillis = DateTime.now().UnixTimestampMillis
		local v8 = unixTimestampMillis - runStartTimeMs

		if v8 >= 0 then
			if not (v8 < 82800000) then
				runStartTimeMs = unixTimestampMillis
			end
		else
			runStartTimeMs = unixTimestampMillis
		end

		clone.runStartTimeMs = runStartTimeMs
		return clone
	end
end

local function getRetryOffers(data, p2)
	local v5 = not data.isPending

	if v5 then
		if data.hasAmbiguousFailure == false and data.failureKind ~= nil then
			v5 = data.failureKind ~= "unknown"
		else
			v5 = false
		end
	end

	if v5 and data.failureKind ~= "payment_required" then
		return p2
	end

	local campaignOption = data.selectedOption.campaignOption
	local offer = data.offers[campaignOption]
	local v6 = p2[campaignOption]

	if
		offer == nil
		or v6 == nil
		or v6.fundingType ~= data.selectedOption.paymentType
		or v6.durationDays ~= offer.durationDays
		or v6.priceRobux ~= offer.priceRobux
	then
		return nil
	end

	return { [campaignOption] = v6 }
end

local function toRecord(data)
	local selectedOption = data.selectedOption
	local v5

	if selectedOption.campaignOption == "feedback" then
		v5 = data.offers.feedback
	else
		v5 = data.offers.plays
	end

	assert(v5 ~= nil, "A submitted campaign must have an offer")
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
		durationDays = v5.durationDays,
		displayAmountRobux = v5.priceRobux,
		phase = data.isPending and "creating" or (data.hasAmbiguousFailure or data.failureKind == nil or data.failureKind == "unknown") and "outcome_unknown" or data.failureKind == "payment_required" and "payment_required" or "failed",
		lastErrorCode = data.failureKind,
		createdAtMs = data.runStartTimeMs,
		updatedAtMs = math.max(data.runStartTimeMs, DateTime.now().UnixTimestampMillis)
	}
end

local function createAgentAdCampaignStore()
	local sessionScopedSignal, v5 = SignalsUtils.createSessionScopedSignal({})

	local sessionScopedSignal2, v6 = SignalsUtils.createSessionScopedSignal({})

	local function start(data, p2, userId, p3)
		local v7 = sessionScopedSignal(false)
		local v8 = v7[data.toolCallId]
		local v9 = not p3

		if v9 then
			if v8 == nil or v8.selectedOption.campaignOption ~= p2.campaignOption then
				v9 = false
			else
				v9 = v8.selectedOption.paymentType == p2.paymentType
			end
		end

		if
			v8 ~= nil
			and (v8.isPending or v8.universeId ~= data.universeId or v8.sessionId ~= data.sessionId or v8.toolCallId ~= data.toolCallId or not v9 and (v8.failureKind == nil or v8.failureKind == "unknown"))
		then
			return nil
		end

		local v10 = if v8 == nil or not v9 then data else v8
		local v11 = {
			universeId = v10.universeId,
			sessionId = v10.sessionId,
			toolCallId = v10.toolCallId,
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

		local v13 = if v10.offers.feedback ~= nil then table.clone(v10.offers.feedback) else nil
		local v14 = if v10.offers.plays ~= nil then table.clone(v10.offers.plays) else nil
		v11.offers = { feedback = v13, plays = v14 }

		v11.runStartTimeMs = v10.runStartTimeMs
		v11.selectedOption = table.clone(p2)
		local v15

		if v8 == nil or not v9 and v8.idempotencyKey ~= v8.toolCallId then
			v15 = if v8 == nil and userId ~= nil then data.toolCallId else HttpService:GenerateGUID(false)
		else
			v15 = v8.idempotencyKey
		end

		v11.idempotencyKey = v15

		v11.userId = userId
		local v16

		if userId ~= nil then
			v16 = if v8 == nil or not v9 then DateTime.now().UnixTimestampMillis else v8.attemptStartedAtMs
		end

		v11.attemptStartedAtMs = v16

		local v17 = if userId ~= nil then not (v8 == nil) and (v9 and v8.hasAmbiguousFailure == true) else nil
		v11.hasAmbiguousFailure = v17

		local clone = table.clone(v7)
		clone[data.toolCallId] = v11
		v5(clone)
		return v11
	end

	local function restore(data, p2, p3): boolean
		local v7 = p3.get(data.sessionId, data.toolCallId)

		if not v7.isAvailable then
			return false
		end

		local v8 = sessionScopedSignal(false)[data.toolCallId]

		if
			v8 ~= nil
			and (v8.userId ~= p2 or v8.sessionId ~= data.sessionId or v8.universeId ~= data.universeId)
		then
			return false
		end

		local record = v7.record

		if record == nil then
			return true
		end

		if
			record.campaignId ~= nil
			or record.userId ~= p2
			or record.universeId ~= data.universeId
			or type(record.attemptStartedAtMs) ~= "number"
			or type(record.hasAmbiguousFailure) ~= "boolean"
			or record.campaignOption ~= "feedback" and record.campaignOption ~= "plays"
			or record.durationDays == nil
			or record.displayAmountRobux == nil
		then
			return false
		end

		if v8 ~= nil and v8.idempotencyKey == record.idempotencyKey then
			return true
		end

		if v8 ~= nil and v8.isPending then
			return false
		end

		local clone = table.clone(data.offers)
		clone[record.campaignOption] = {
			campaignOption = record.campaignOption,
			fundingType = record.fundingType,
			durationDays = record.durationDays,
			priceRobux = record.displayAmountRobux
		}

		local v9 = "unknown"

		if
			not record.hasAmbiguousFailure
			and (record.phase == "failed" or record.phase == "payment_required")
		then
			local lastErrorCode = record.lastErrorCode

			if
				lastErrorCode == "payment_required"
				or lastErrorCode == "ineligible"
				or lastErrorCode == "missing_thumbnail"
				or lastErrorCode == "invalid_offer"
			then
				v9 = lastErrorCode
			end
		end

		local v10 = {
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
			failureKind = v9,
			userId = p2,
			attemptStartedAtMs = record.attemptStartedAtMs,
			hasAmbiguousFailure = v9 == "unknown"
		}

		local clone2 = table.clone(sessionScopedSignal(false))
		clone2[data.toolCallId] = v10
		v5(clone2)
		return true
	end

	return {
		getAttempts = sessionScopedSignal,
		getRetrySelection = getRetrySelection,
		getRetryOffers = getRetryOffers,
		canReplaceRejectedAttempt = canReplaceRejectedAttempt,
		start = start,
		finish = function(p2, p3, failureKind, hasAmbiguousFailure): boolean
			local v7 = sessionScopedSignal(false)

			if v7[p2.toolCallId] ~= p2 then
				return false
			end

			local clone = table.clone(v7)

			if p3 then
				clone[p2.toolCallId] = nil
			else
				local clone2 = table.clone(p2)
				clone2.isPending = false
				clone2.failureKind = failureKind

				if hasAmbiguousFailure ~= nil then
					clone2.hasAmbiguousFailure = hasAmbiguousFailure
				end

				clone[p2.toolCallId] = clone2
			end

			v5(clone)
			return true
		end,
		restore = restore,
		startDurable = function(p2, p3, p4, p5)
			if not restore(p2, p4, p5) then
				return nil
			end

			local v7 = sessionScopedSignal(false)[p2.toolCallId]
			local v8 = false

			if v7 ~= nil then
				local v9 = v7.hasAmbiguousFailure
				local v10

				if FFlagBuildAgentAdCampaignRefreshEligibility then
					local v11 = not v7.isPending

					if v11 then
						v11 = v7.hasAmbiguousFailure == false
							and v7.failureKind ~= nil
							and v7.failureKind ~= "unknown"
					end

					v10 = v11 and v7.failureKind ~= "payment_required"
					v9 = not v10
				else
					v10 = false
				end

				if v7.idempotencyKey ~= v7.toolCallId then
					local v11 = DateTime.now().UnixTimestampMillis - (v7.attemptStartedAtMs or 0)
					local v12 = v11 >= 0 and v11 < 82800000

					if not v12 then
						local v13 = not v7.isPending

						if v13 then
							v13 = v7.hasAmbiguousFailure == false
								and v7.failureKind ~= nil
								and v7.failureKind ~= "unknown"
						end

						if not (v13 and p2.runStartTimeMs == getRetrySelection(v7, p2.runStartTimeMs).runStartTimeMs) then
							return nil
						end

						v8 = true
					end
				end

				if
					v9
					and (v7.selectedOption.campaignOption ~= p3.campaignOption or v7.selectedOption.paymentType ~= p3.paymentType)
				then
					return nil
				end

				v8 = v10 and true or v8
			end

			local v9 = start(p2, p3, p4, v8)

			if v9 == nil then
				return nil
			end

			local save = p5.save
			local v10 = toRecord(v9)
			local v11 = if v7 ~= nil then v7.idempotencyKey else nil

			if save(v10, v11) then
				if sessionScopedSignal(false)[v9.toolCallId] ~= v9 then
					return nil
				end

				if v9.idempotencyKey == v9.toolCallId then
					return v9
				end

				local v12 = DateTime.now().UnixTimestampMillis - (v9.attemptStartedAtMs or 0)
				local v13 = v12 >= 0 and v12 < 82800000

				if v13 then
					return v9
				end

				local v14 = sessionScopedSignal(false)

				if v14[v9.toolCallId] ~= v9 then
					return nil
				end

				local clone = table.clone(v14)

				local clone2 = table.clone(v9)
				clone2.isPending = false
				clone2.failureKind = "unknown"

				clone2.hasAmbiguousFailure = true

				clone[v9.toolCallId] = clone2

				v5(clone)

				return nil
			end

			if sessionScopedSignal(false)[v9.toolCallId] == v9 then
				local clone = table.clone(sessionScopedSignal(false))
				clone[v9.toolCallId] = v7
				v5(clone)
			end

			return nil
		end,
		finishDurable = function(data, failureKind, p2): boolean
			if sessionScopedSignal(false)[data.toolCallId] ~= data then
				return false
			end

			local clone = table.clone(data)
			clone.isPending = false
			clone.failureKind = failureKind
			clone.hasAmbiguousFailure = data.hasAmbiguousFailure == true
				or failureKind == nil
				or failureKind == "unknown"

			p2.save(toRecord(clone), data.idempotencyKey)
			local hasAmbiguousFailure = clone.hasAmbiguousFailure
			local v7 = sessionScopedSignal(false)

			if v7[data.toolCallId] ~= data then
				return false
			end

			local clone2 = table.clone(v7)

			local clone3 = table.clone(data)
			clone3.isPending = false
			clone3.failureKind = failureKind

			if hasAmbiguousFailure ~= nil then
				clone3.hasAmbiguousFailure = hasAmbiguousFailure
			end

			clone2[data.toolCallId] = clone3

			v5(clone2)
			return true
		end,
		completeDurable = function(data)
			local v7 = sessionScopedSignal(false)[data.toolCallId]

			if
				v7 ~= nil
				and v7.userId == data.userId
				and v7.sessionId == data.sessionId
				and v7.universeId == data.universeId
				and v7.idempotencyKey == data.idempotencyKey
			then
				local v8 = sessionScopedSignal(false)

				if v8[v7.toolCallId] ~= v7 then
					return
				end

				local clone = table.clone(v8)

				clone[v7.toolCallId] = nil

				v5(clone)
			end
		end,
		toRecord = toRecord,
		markImpressed = function(p2, p3): boolean
			local v7 = sessionScopedSignal2(false)

			if v7[p2] ~= nil and v7[p2][p3] then
				return false
			end

			local clone = table.clone(v7)
			clone[p2] = table.clone(v7[p2] or {})
			clone[p2][p3] = true
			v6(clone)
			return true
		end,
		reset = function()
			v5({})
			v6({})
		end
	}
end

return createAgentAdCampaignStore
