local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorCredit")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildModelSelectionStore/createBuildModelSelectionStore")
local chatConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatConstants")

local function isAvailable(p2, p3): boolean
	if p2 == nil then
		return p3 == "default"
	end

	for k, v5 in p2.available do
		if v5.id == p3 then
			return true
		end
	end

	return false
end

local function awaitRefreshedQuota(p2, tier, isCurrent)
	local getTierQuotaSummarySignals = p2.getTierQuotaSummarySignals
	local refreshTierQuotaSummary = p2.refreshTierQuotaSummary

	if getTierQuotaSummarySignals == nil or refreshTierQuotaSummary == nil then
		return nil
	end

	local data = getTierQuotaSummarySignals("PRODUCT_BUILD", tier).data(false)
	local v5 = refreshTierQuotaSummary("PRODUCT_BUILD", tier)
	local v6 = os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS

	while isCurrent() and os.clock() < v6 do
		local status = v5.status(false)

		if status == "Failed" then
			return nil
		end

		local data2 = v5.data(false)

		if status == "Ready" and data2 ~= nil and data2 ~= data then
			return data2
		end

		task.wait()
	end

	return nil
end

local function beginBuildModelSend(data, p2, p3, p4)
	if data == nil then
		return nil
	end

	local lock = data.acquireLock()

	if lock == nil then
		return nil
	end

	local captureSendConfiguration = CreatorAgentChat.captureSendConfiguration(
		p4 and "default" or assert(data.getSelection(false)).intendedTier,
		p3
	)

	local v5 = false
	local v6 = false
	local v7 = nil
	local v8 = nil
	local function isCurrent()
		local v9 = not v5

		if v9 then
			v9 = not (data.getSelection(false) == nil) and (v7 == nil or v7.getCasSessionId() == v8)
		end

		return v9
	end

	return {
		prepare = function(data2)
			assert(not v6, "A model send attempt can only prepare once")
			v6 = true
			local v9 = not v5

			if v9 then
				v9 = not (data.getSelection(false) == nil) and (v7 == nil or v7.getCasSessionId() == v8)
			end

			if not v9 then
				return nil, nil
			end

			local v10 = data2.getCasSessionId() == nil

			if v10 then
				data.restoreTier(captureSendConfiguration.tier)
			end

			local v11, v12 = data2.prepareSession({
				sendConfiguration = captureSendConfiguration,
				isCancelled = function(): boolean
					local v13 = not v5

					if v13 then
						v13 = not (data.getSelection(false) == nil)
							and (v7 == nil or v7.getCasSessionId() == v8)
					end

					return not v13
				end
			})
			local v13 = not v5

			if v13 then
				v13 = not (data.getSelection(false) == nil) and (v7 == nil or v7.getCasSessionId() == v8)
			end

			if not v13 then
				return nil, nil
			end

			if v11 == nil and v12 == nil then
				if not v5 then
					v5 = true
					data.releaseLock(lock)
				end

				return nil, nil
			elseif v11 == nil or data2.getCasSessionId() ~= v11 then
				local v16 = if v12 ~= nil then v12.errorCode else nil
				local v17 = if v12 ~= nil then v12.fundingReason else nil
				return nil, {
					kind = "setup",
					errorCode = v16,
					reason = v17,
					setupError = v12
				}
			else
				v7 = data2
				v8 = v11
				local models = data2.getModels(false)

				if not v10 and models ~= nil then
					data.restoreTier(models.current)
				end

				local v14

				if v10 or p4 == true then
					v14 = captureSendConfiguration.tier
				else
					v14 = assert(data.getSelection(false)).intendedTier
				end

				data.restoreTier(v14)
				local v15

				if models == nil then
					v15 = v14 == "default"
				else
					local flag = true

					for k, v16 in models.available do
						if v16.id == v14 then
							v15 = true
							flag = false
							break
						end
					end

					if flag then
						v15 = false
					end
				end

				if not v15 then
					return nil, { kind = "unavailable" }
				end

				local frozen = table.freeze({
					tier = v14,
					experiment = captureSendConfiguration.experiment,
					sessionId = v11,
					universeId = data2.universeId,
					placeId = data2.placeId
				})

				local v16 = awaitRefreshedQuota(p2, frozen.tier, isCurrent)
				local v17 = not v5

				if v17 then
					v17 = not (data.getSelection(false) == nil)
						and (v7 == nil or v7.getCasSessionId() == v8)
				end

				if not v17 then
					return nil, nil
				end

				if v16 == nil or v16.allowed == nil then
					return nil, { kind = "quota" }
				end

				if not v16.allowed then
					return
						nil,
						{
							kind = "denied",
							errorCode = CreatorAgentChat.ErrorCodes.OutOfCredits,
							reason = v16.reason
						}
				end

				local models2 = data2.getModels(false)
				local tier = frozen.tier
				local v18

				if models2 == nil then
					v18 = tier == "default"
				else
					local flag = true

					for k, v19 in models2.available do
						if v19.id == tier then
							v18 = true
							flag = false
							break
						end
					end

					if flag then
						v18 = false
					end
				end

				if v18 then
					return frozen, nil
				end

				return nil, { kind = "unavailable" }
			end
		end,
		isCurrent = isCurrent,
		release = function()
			if not v5 then
				v5 = true
				data.releaseLock(lock)
			end
		end,
		unlockSelection = function()
			data.releaseLock(lock)
		end
	}
end

return beginBuildModelSend
