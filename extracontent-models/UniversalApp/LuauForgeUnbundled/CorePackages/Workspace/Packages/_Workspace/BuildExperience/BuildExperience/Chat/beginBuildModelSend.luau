local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local fFlagBuildExperienceAdvancedPreviewSpecs = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceAdvancedPreviewSpecs
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

	local v5 = not (p4 == nil) and p4.isSelected

	local v6 = fFlagBuildExperienceAdvancedPreviewSpecs
		and p4 ~= nil
		and p4.previewSpecName == "build-on-mobile-advanced"
		and "advanced"
		or "default"

	local captureSendConfiguration = CreatorAgentChat.captureSendConfiguration

	if not v5 then
		v6 = assert(data.getSelection(false)).intendedTier
	end

	local v7 = captureSendConfiguration(v6, p3)

	local v8 = false
	local v9 = false
	local v10 = nil
	local v11 = nil
	local function isCurrent()
		local v12 = not v8

		if v12 then
			v12 = not (data.getSelection(false) == nil) and (v10 == nil or v10.getCasSessionId() == v11)
		end

		return v12
	end

	return {
		prepare = function(data2)
			assert(not v9, "A model send attempt can only prepare once")
			v9 = true
			local v12 = not v8

			if v12 then
				v12 = not (data.getSelection(false) == nil) and (v10 == nil or v10.getCasSessionId() == v11)
			end

			if not v12 then
				return nil, nil
			end

			local v13 = data2.getCasSessionId() == nil

			if v13 then
				data.restoreTier(v7.tier)
			end

			local v14, v15 = data2.prepareSession({
				sendConfiguration = v7,
				isCancelled = function(): boolean
					local v16 = not v8

					if v16 then
						v16 = not (data.getSelection(false) == nil)
							and (v10 == nil or v10.getCasSessionId() == v11)
					end

					return not v16
				end
			})
			local v16 = not v8

			if v16 then
				v16 = not (data.getSelection(false) == nil) and (v10 == nil or v10.getCasSessionId() == v11)
			end

			if not v16 then
				return nil, nil
			end

			if v14 == nil and v15 == nil then
				if not v8 then
					v8 = true
					data.releaseLock(lock)
				end

				return nil, nil
			elseif v14 == nil or data2.getCasSessionId() ~= v14 then
				local v19 = if v15 ~= nil then v15.errorCode else nil
				local v20 = if v15 ~= nil then v15.fundingReason else nil
				return nil, {
					kind = "setup",
					errorCode = v19,
					reason = v20,
					setupError = v15
				}
			else
				v10 = data2
				v11 = v14
				local models = data2.getModels(false)

				if not v13 and models ~= nil then
					data.restoreTier(models.current)
				end

				local v17 = if v13 or v5 == true then v7.tier else assert(data.getSelection(false)).intendedTier
				data.restoreTier(v17)
				local v18

				if models == nil then
					v18 = v17 == "default"
				else
					local flag = true

					for k, v19 in models.available do
						if v19.id == v17 then
							v18 = true
							flag = false
							break
						end
					end

					if flag then
						v18 = false
					end
				end

				if not v18 then
					return nil, { kind = "unavailable" }
				end

				local frozen = table.freeze({
					tier = v17,
					experiment = v7.experiment,
					sessionId = v14,
					universeId = data2.universeId,
					placeId = data2.placeId
				})

				local v19 = awaitRefreshedQuota(p2, frozen.tier, isCurrent)
				local v20 = not v8

				if v20 then
					v20 = not (data.getSelection(false) == nil)
						and (v10 == nil or v10.getCasSessionId() == v11)
				end

				if not v20 then
					return nil, nil
				end

				if v19 == nil or v19.allowed == nil then
					return nil, { kind = "quota" }
				end

				if not v19.allowed then
					return
						nil,
						{
							kind = "denied",
							errorCode = CreatorAgentChat.ErrorCodes.OutOfCredits,
							reason = v19.reason
						}
				end

				local models2 = data2.getModels(false)
				local tier = frozen.tier
				local v21

				if models2 == nil then
					v21 = tier == "default"
				else
					local flag = true

					for k, v22 in models2.available do
						if v22.id == tier then
							v21 = true
							flag = false
							break
						end
					end

					if flag then
						v21 = false
					end
				end

				if v21 then
					return frozen, nil
				end

				return nil, { kind = "unavailable" }
			end
		end,
		isCurrent = isCurrent,
		release = function()
			if not v8 then
				v8 = true
				data.releaseLock(lock)
			end
		end,
		unlockSelection = function()
			data.releaseLock(lock)
		end
	}
end

return beginBuildModelSend
