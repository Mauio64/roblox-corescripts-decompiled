local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
require(parent.DataHydration.CreatorCredit)
require(BuildExperience.Stores.GetBuildModelSelectionStore.createBuildModelSelectionStore)
local chatConstants = require(script.Parent.chatConstants)

local function isAvailable(p, p2): boolean -- 2 equivalent calls inferred from this helper
	if p == nil then
		return p2 == "default"
	end

	for _, v in p.available do
		if v.id == p2 then
			return true
		end
	end

	return false
end

local function awaitRefreshedQuota(p, tier, isCurrent)
	local getTierQuotaSummarySignals = p.getTierQuotaSummarySignals
	local refreshTierQuotaSummary = p.refreshTierQuotaSummary

	if getTierQuotaSummarySignals == nil or refreshTierQuotaSummary == nil then
		return nil
	end

	local data = getTierQuotaSummarySignals("PRODUCT_BUILD", tier).data(false)
	local v = refreshTierQuotaSummary("PRODUCT_BUILD", tier)
	local v2 = os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS

	while isCurrent() and os.clock() < v2 do
		local status = v.status(false)

		if status == "Failed" then
			return nil
		end

		local data2 = v.data(false)

		if status == "Ready" and data2 ~= nil and data2 ~= data then
			return data2
		end

		task.wait()
	end

	return nil
end

local function beginBuildModelSend(data, p, p2, flag: boolean?)
	if data == nil then
		return nil
	end

	local lock = data.acquireLock()

	if lock == nil then
		return nil
	end

	local captureSendConfiguration = CreatorAgentChat.captureSendConfiguration(
		flag and "default" or assert(data.getSelection(false)).intendedTier,
		p2
	)

	local v = false
	local v2 = false
	local v3 = nil
	local v4 = nil
	local function isCurrent() -- 4 equivalent calls inferred from this helper
		local v5 = not v

		if v5 then
			if data.getSelection(false) == nil then
				return false
			end

			return v3 == nil or v3.getCasSessionId() == v4
		end

		return v5
	end

	local function release() -- 1 equivalent call inferred from this helper
		if not v then
			v = true
			data.releaseLock(lock)
		end
	end
	return {
		prepare = function(data2)
			assert(not v2, "A model send attempt can only prepare once")
			v2 = true

			if not isCurrent() then -- inferred equivalent call
				return nil, nil
			end

			local v5 = data2.getCasSessionId() == nil

			if v5 then
				data.restoreTier(captureSendConfiguration.tier)
			end

			local sessionId, setupError = data2.prepareSession({
				sendConfiguration = captureSendConfiguration,
				isCancelled = function(): boolean
					return not isCurrent() -- inferred equivalent call
				end
			})

			if not isCurrent() then -- inferred equivalent call
				return nil, nil
			end

			if sessionId == nil and setupError == nil then
				release() -- inferred equivalent call
				return nil, nil
			elseif sessionId == nil or data2.getCasSessionId() ~= sessionId then
				local errorCode

				if setupError ~= nil then
					errorCode = setupError.errorCode
				end

				local reason

				if setupError ~= nil then
					reason = setupError.fundingReason
				end

				return nil, {
					kind = "setup",
					errorCode = errorCode,
					reason = reason,
					setupError = setupError
				}
			else
				v3 = data2
				v4 = sessionId
				local models = data2.getModels(false)

				if not v5 and models ~= nil then
					data.restoreTier(models.current)
				end

				local tier

				if v5 or flag == true then
					tier = captureSendConfiguration.tier
				else
					tier = assert(data.getSelection(false)).intendedTier
				end

				data.restoreTier(tier)

				if not isAvailable(models, tier) then -- inferred equivalent call
					return nil, { kind = "unavailable" }
				end

				local frozen = table.freeze({
					tier = tier,
					experiment = captureSendConfiguration.experiment,
					sessionId = sessionId,
					universeId = data2.universeId,
					placeId = data2.placeId
				})

				local v6 = awaitRefreshedQuota(p, frozen.tier, isCurrent)

				if not isCurrent() then -- inferred equivalent call
					return nil, nil
				end

				if v6 == nil or v6.allowed == nil then
					return nil, { kind = "quota" }
				end

				if not v6.allowed then
					return
						nil,
						{
							kind = "denied",
							errorCode = CreatorAgentChat.ErrorCodes.OutOfCredits,
							reason = v6.reason
						}
				end

				if isAvailable(data2.getModels(false), frozen.tier) then -- inferred equivalent call
					return frozen, nil
				end

				return nil, { kind = "unavailable" }
			end
		end,
		isCurrent = isCurrent,
		release = release,
		unlockSelection = function()
			data.releaseLock(lock)
		end
	}
end

return beginBuildModelSend
