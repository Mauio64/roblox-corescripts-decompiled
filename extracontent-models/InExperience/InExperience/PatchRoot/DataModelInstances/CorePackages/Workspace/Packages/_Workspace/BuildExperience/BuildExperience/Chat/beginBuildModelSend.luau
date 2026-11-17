local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceAdvancedPreviewSpecs = SharedFlags.FFlagBuildExperienceAdvancedPreviewSpecs
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

local function beginBuildModelSend(data, p, p2, p3)
	if data == nil then
		return nil
	end

	local lock = data.acquireLock()

	if lock == nil then
		return nil
	end

	local v

	if p3 == nil then
		v = false
	else
		v = p3.isSelected
	end

	local v2 = FFlagBuildExperienceAdvancedPreviewSpecs
		and p3 ~= nil
		and p3.previewSpecName == "build-on-mobile-advanced"
		and "advanced"
		or "default"

	local captureSendConfiguration = CreatorAgentChat.captureSendConfiguration

	if not v then
		v2 = assert(data.getSelection(false)).intendedTier
	end

	local sendConfiguration = captureSendConfiguration(v2, p2)

	local v3 = false
	local v4 = false
	local v5 = nil
	local v6 = nil
	local function isCurrent() -- 4 equivalent calls inferred from this helper
		local v7 = not v3

		if v7 then
			if data.getSelection(false) == nil then
				return false
			end

			return v5 == nil or v5.getCasSessionId() == v6
		end

		return v7
	end

	local function release() -- 1 equivalent call inferred from this helper
		if not v3 then
			v3 = true
			data.releaseLock(lock)
		end
	end
	return {
		prepare = function(data2)
			assert(not v4, "A model send attempt can only prepare once")
			v4 = true

			if not isCurrent() then -- inferred equivalent call
				return nil, nil
			end

			local v7 = data2.getCasSessionId() == nil

			if v7 then
				data.restoreTier(sendConfiguration.tier)
			end

			local sessionId, setupError = data2.prepareSession({
				sendConfiguration = sendConfiguration,
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
				v5 = data2
				v6 = sessionId
				local models = data2.getModels(false)

				if not v7 and models ~= nil then
					data.restoreTier(models.current)
				end

				local tier

				if v7 or v == true then
					tier = sendConfiguration.tier
				else
					tier = assert(data.getSelection(false)).intendedTier
				end

				data.restoreTier(tier)

				if not isAvailable(models, tier) then -- inferred equivalent call
					return nil, { kind = "unavailable" }
				end

				local frozen = table.freeze({
					tier = tier,
					experiment = sendConfiguration.experiment,
					sessionId = sessionId,
					universeId = data2.universeId,
					placeId = data2.placeId
				})

				local v8 = awaitRefreshedQuota(p, frozen.tier, isCurrent)

				if not isCurrent() then -- inferred equivalent call
					return nil, nil
				end

				if v8 == nil or v8.allowed == nil then
					return nil, { kind = "quota" }
				end

				if not v8.allowed then
					return
						nil,
						{
							kind = "denied",
							errorCode = CreatorAgentChat.ErrorCodes.OutOfCredits,
							reason = v8.reason
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
