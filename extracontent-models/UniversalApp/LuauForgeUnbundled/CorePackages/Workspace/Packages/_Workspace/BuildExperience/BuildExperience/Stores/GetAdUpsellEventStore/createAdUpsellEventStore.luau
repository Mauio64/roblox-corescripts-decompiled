local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local UniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")

local chatTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignCard")
local FFlagBuildAdUpsellPinned = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdUpsellPinned")
local getAdUpsellEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/getAdUpsellEligibility")
local observeAdUpsellEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/observeAdUpsellEligibility")
local GameConfigurationLabels = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameConfigurationLabels")

local engineFeature = game:GetEngineFeature("BuildAppStorageKey")
local v5 = if engineFeature then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Storage/BuildAppStorage") else nil
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Storage/createAdCampaignCardStorage")

local function defaultDependencies()
	if not engineFeature then
		return nil
	end

	local v7 = if FFlagBuildAgentAdCampaignCard then v5.getAdCampaignCardStorage else nil
	return {
		getAdCampaignCardStorage = v7,
		recordCompletedTurn = v5.recordAdUpsellCompletedTurn,
		recordPublish = v5.recordAdUpsellPublish,
		attachPendingMilestones = v5.attachPendingAdUpsellMilestones,
		pruneAnchors = v5.pruneAdUpsellAnchors,
		markAnchorImpressed = v5.markAdUpsellAnchorImpressed,
		dismissPermanently = v5.markAdUpsellDismissedPermanently,
		isDismissedPermanently = function(p2)
			local adUpsellState = v5.getAdUpsellState(p2, nil)
			return adUpsellState.isAvailable and adUpsellState.dismissedPermanently
		end,
		retryStorageRead = v5.retryAdUpsellRead,
		refreshSummary = function(p2)
			return UniverseConfiguration.getUniverseConfigurationStore().refreshSummary(p2)
		end,
		getAudience = function(p2)
			return GameConfigurationLabels.getAudience(p2)
		end,
		publicAudience = UniverseConfiguration.PrivacyType.Public,
		getEligibility = getAdUpsellEligibility,
		observeEligibility = observeAdUpsellEligibility,
		scheduleRetry = function(duration, callback)
			return task.delay(duration, callback)
		end,
		cancelRetry = function(p2)
			task.cancel(p2)
		end
	}
end

local function hasSuccessfulPublish(p2): boolean
	return CreatorAgentChat.PublishToolUtils.getLatestSuccessfulResult(p2, {
		parseDirectText = true
	}) ~= nil
end

local function createAdUpsellEventStore(p2)
	local v6 = p2 or defaultDependencies()
	local signal, v7 = Signals.createSignal(0)
	local signal2, v8 = Signals.createSignal(0)
	local v9 = {}
	local ids = {}
	local afterMessageKeysById = {}
	local v10 = nil
	local v11 = {}
	local count = 0

	local fn

	local function bumpRevision()
		v7(function(p3)
			return p3 + 1
		end)
	end

	local function getCardStorage()
		if v6 == nil then
			return nil
		end

		return (v6.getAdCampaignCardStorage())
	end

	local function bumpAdCampaignRevision()
		v8(function(p3)
			return p3 + 1
		end)
		v7(function(p3)
			return p3 + 1
		end)
	end

	local function recordCardMutation(confirm, p3, pendingWrites)
		if p3 or confirm and pendingWrites then
			v8(function(p4)
				return p4 + 1
			end)
			v7(function(p4)
				return p4 + 1
			end)
		end

		return confirm, p3
	end

	local function disposeEligibilitySubscription(p3)
		local v12 = v11[p3]

		if v12 == nil then
			return
		end

		v11[p3] = nil
		v12()
	end

	local function removePending(p3)
		if v9[p3] == nil then
			return
		end

		local v12 = v11[p3]

		if v12 ~= nil then
			v11[p3] = nil
			v12()
		end

		v9[p3] = nil
		local index = table.find(ids, p3)

		if index ~= nil then
			table.remove(ids, index)
		end
	end

	local function retainPending(p3)
		local v12 = v9[p3.id]

		if v12 ~= nil then
			return v12
		end

		v9[p3.id] = p3
		table.insert(ids, p3.id)

		while #ids > 50 do
			local v13 = table.remove(ids, 1)

			if v13 == nil then
				continue
			end

			local v14 = v11[v13]

			if v14 ~= nil then
				v11[v13] = nil
				v14()
			end

			v9[v13] = nil
		end

		return p3
	end

	local function canRetryAutomatically(data): boolean
		if data.isAwaitingEligibility then
			return false
		end

		if data.requiresAudienceVerification and data.isEligiblePublish == nil then
			return not data.isVerifyingAudience and data.audienceVerificationAttempts < 3
		end

		return data.storagePersistenceAttempts < 3
	end

	local function hasAutomaticallyRetryableEvent(): boolean
		for k, v12 in ids do
			local v13 = v9[v12]

			if v13 == nil then
				continue
			end

			local v14

			if v13.isAwaitingEligibility then
				v14 = false
			elseif v13.requiresAudienceVerification and v13.isEligiblePublish == nil then
				v14 = not v13.isVerifyingAudience and v13.audienceVerificationAttempts < 3
			else
				v14 = v13.storagePersistenceAttempts < 3
			end

			if v14 then
				return true
			end
		end

		return false
	end

	local function fn2()
		if v6 ~= nil and v10 == nil then
			local flag = true
			local flag2

			for k, v12 in ids do
				local v13 = v9[v12]

				if v13 == nil then
					continue
				end

				local v14

				if v13.isAwaitingEligibility then
					v14 = false
				elseif v13.requiresAudienceVerification and v13.isEligiblePublish == nil then
					v14 = not v13.isVerifyingAudience and v13.audienceVerificationAttempts < 3
				else
					v14 = v13.storagePersistenceAttempts < 3
				end

				if v14 then
					flag2 = true
					flag = false
					break
				end
			end

			if flag then
				flag2 = false
			end

			if flag2 then
				local v12 = count
				v10 = v6.scheduleRetry(1, function()
					v10 = nil

					if count ~= v12 then
						return
					end

					local clone = table.clone(ids)

					for k, v13 in clone do
						local v14 = v9[v13]

						if v14 == nil then
							continue
						end

						local v15

						if v14.isAwaitingEligibility then
							v15 = false
						elseif v14.requiresAudienceVerification and v14.isEligiblePublish == nil then
							v15 = not v14.isVerifyingAudience and v14.audienceVerificationAttempts < 3
						else
							v15 = v14.storagePersistenceAttempts < 3
						end

						if v15 then
							fn(v14)
						end
					end

					local flag3 = true
					local flag4

					for k, v13 in ids do
						local v14 = v9[v13]

						if v14 == nil then
							continue
						end

						local v15

						if v14.isAwaitingEligibility then
							v15 = false
						elseif v14.requiresAudienceVerification and v14.isEligiblePublish == nil then
							v15 = not v14.isVerifyingAudience and v14.audienceVerificationAttempts < 3
						else
							v15 = v14.storagePersistenceAttempts < 3
						end

						if v15 then
							flag4 = true
							flag3 = false
							break
						end
					end

					if flag3 then
						flag4 = false
					end

					if flag4 then
						fn2()
					end
				end)
			end
		end
	end

	local function persistEvent(state)
		if v6 == nil then
			return
		end

		local v12 = {
			universeId = state.universeId,
			sessionId = state.sessionId,
			eventId = state.id,
			afterMessageKey = state.afterMessageKey,
			isEligiblePublish = state.isEligiblePublish == true
		}
		local v13, v14

		if state.isCompletedTurn then
			v13, v14 = v6.recordCompletedTurn(v12)
		else
			v13, v14 = v6.recordPublish(v12)
		end

		if v14 then
			if FFlagBuildAdUpsellPinned and state.afterMessageKey ~= nil then
				afterMessageKeysById[state.id] = state.afterMessageKey
			end

			v7(function(p3)
				return p3 + 1
			end)
		end

		if v13 or v14 then
			local id = state.id

			if v9[id] == nil then
				return
			end

			local v15 = v11[id]

			if v15 ~= nil then
				v11[id] = nil
				v15()
			end

			v9[id] = nil
			local index = table.find(ids, id)

			if index ~= nil then
				table.remove(ids, index)
			end
		else
			state.storagePersistenceAttempts += 1

			if state.storagePersistenceAttempts < 3 then
				fn2()
			end
		end
	end

	local function handleAudienceVerificationFailure(p3)
		p3.isVerifyingAudience = false
		p3.audienceVerificationAttempts += 1

		if p3.audienceVerificationAttempts < 3 then
			fn2()
		end
	end

	local function awaitEligibility(state, p3)
		if v6 == nil then
			return
		end

		state.isVerifyingAudience = false

		if state.isAwaitingEligibility then
			return
		end

		state.isAwaitingEligibility = true

		local v12 = count
		local v13 = nil
		local flag = false
		local function onEligibilityChanged()
			if count ~= v12 or v9[state.id] ~= state then
				return
			end

			local eligibility = v6.getEligibility(state.universeId)

			if not eligibility.isResolved then
				return
			end

			state.isAwaitingEligibility = false

			if v13 == nil then
				flag = true
			else
				local id = state.id
				local v14 = v11[id]

				if v14 ~= nil then
					v11[id] = nil
					v14()
				end
			end

			state.isEligiblePublish = v6.getAudience(p3) == v6.publicAudience
				and eligibility.isEligible
				and eligibility.freePromotionsRemaining > 0
			persistEvent(state)
		end

		local v14 = v6.observeEligibility(state.universeId, onEligibilityChanged)
		v13 = v14

		if flag then
			v14()
		else
			v11[state.id] = v14
		end
	end

	fn = function(state)
		if v6 == nil or v9[state.id] ~= state then
			return
		end

		if not state.requiresAudienceVerification or state.isEligiblePublish ~= nil then
			persistEvent(state)
			return
		end

		if state.isVerifyingAudience or state.isAwaitingEligibility then
			return
		end

		state.isVerifyingAudience = true
		local success, result = pcall(v6.refreshSummary, state.universeId)

		if success and result ~= nil then
			local v12 = count
			result:andThen(function(p3)
				if count ~= v12 or v9[state.id] ~= state then
					return
				end

				local eligibility = v6.getEligibility(state.universeId)

				if not eligibility.isResolved then
					awaitEligibility(state, p3)
					return
				end

				state.isVerifyingAudience = false
				state.isEligiblePublish = v6.getAudience(p3) == v6.publicAudience
					and eligibility.isEligible
					and eligibility.freePromotionsRemaining > 0
				persistEvent(state)
			end, function()
				if count ~= v12 or v9[state.id] ~= state then
					return
				end

				local v13 = state
				v13.isVerifyingAudience = false
				v13.audienceVerificationAttempts += 1

				if v13.audienceVerificationAttempts < 3 then
					fn2()
				end
			end)
		else
			state.isVerifyingAudience = false
			state.audienceVerificationAttempts += 1

			if state.audienceVerificationAttempts < 3 then
				fn2()
			end
		end
	end

	local function disposeAllEligibilitySubscriptions()
		local v12 = {}

		for k in v11 do
			table.insert(v12, k)
		end

		for k, v13 in v12 do
			local v14 = v11[v13]

			if v14 == nil then
				continue
			end

			v11[v13] = nil
			v14()
		end
	end

	return {
		recordAdCampaignAttempt = FFlagBuildAgentAdCampaignCard and function(p3, p4): boolean
			local v12 = if v6 ~= nil then v6.getAdCampaignCardStorage() else nil

			if v12 == nil or not v12.saveAttempt(p3, p4) then
				return false
			end

			v8(function(p5)
				return p5 + 1
			end)
			v7(function(p5)
				return p5 + 1
			end)

			return true
		end or nil,
		getAdCampaignCard = FFlagBuildAgentAdCampaignCard and function(p3, p4)
			local v12 = if v6 ~= nil then v6.getAdCampaignCardStorage() else nil

			if v12 == nil then
				return { isAvailable = false, isPersisted = false }
			end

			return v12.get(p3, p4)
		end or nil,
		listAdCampaignCards = FFlagBuildAgentAdCampaignCard and function(p3)
			local v12 = if v6 ~= nil then v6.getAdCampaignCardStorage() else nil

			if v12 == nil then
				return { isAvailable = false, records = {} }
			end

			return v12.list(p3)
		end or nil,
		recordAdCampaignCreatedReceipt = FFlagBuildAgentAdCampaignCard and function(p3)
			local v12 = if v6 ~= nil then v6.getAdCampaignCardStorage() else nil

			if v12 == nil then
				return false, false
			end

			local pendingWrites = v12.hasPendingWrites()
			local confirm, v13 = v12.confirm(p3)
			return recordCardMutation(confirm, v13, pendingWrites)
		end or nil,
		retryAdCampaignCardWrites = FFlagBuildAgentAdCampaignCard and function(): boolean
			local v12 = if v6 ~= nil then v6.getAdCampaignCardStorage() else nil

			if v12 == nil then
				return false
			end

			local pendingWrites = v12.hasPendingWrites()

			if not v12.retryWrites() then
				return false
			end

			if pendingWrites then
				v8(function(p3)
					return p3 + 1
				end)
				v7(function(p3)
					return p3 + 1
				end)
			end

			return true
		end or nil,
		pruneAdCampaignCards = FFlagBuildAgentAdCampaignCard and function(p3)
			local v12 = if v6 ~= nil then v6.getAdCampaignCardStorage() else nil

			if v12 == nil then
				return false, false
			end

			local prune, v13 = v12.prune(p3)

			if v13 then
				v8(function(p4)
					return p4 + 1
				end)
				v7(function(p4)
					return p4 + 1
				end)
			end

			return prune, v13
		end or nil,
		getRevision = signal,
		getAdCampaignRevision = signal2,
		reportAssistantTurnCompleted = function(data)
			if v6 == nil or data.universeId == 0 or v6.isDismissedPermanently(data.universeId) then
				return
			end

			local assistantTurnAnchorKey = chatTypes.makeAssistantTurnAnchorKey(
				data.sessionId,
				data.latestSequenceId
			)

			if assistantTurnAnchorKey == nil then
				return
			end

			local formatted = `chat:{data.universeId}:{assistantTurnAnchorKey}`
			local turnState = data.turnState
			local v12 = CreatorAgentChat.PublishToolUtils.getLatestSuccessfulResult(turnState, {
				parseDirectText = true
			}) ~= nil

			local v14 = {
				id = formatted,
				universeId = data.universeId,
				sessionId = 0,
				afterMessageKey = 0,
				isCompletedTurn = true,
				isEligiblePublish = 0,
				requiresAudienceVerification = 0,
				isVerifyingAudience = false,
				isAwaitingEligibility = false,
				audienceVerificationAttempts = 0,
				storagePersistenceAttempts = 0
			}
			local v15 = if data.sessionId ~= "" then data.sessionId else nil
			v14.sessionId = v15
			v14.afterMessageKey = assistantTurnAnchorKey

			v14.isEligiblePublish = if not v12 then false else nil
			v14.requiresAudienceVerification = v12
			local v17 = retainPending(v14)

			fn(v17)
		end,
		reportMenuPublish = function(p3, sessionId, p4, p5)
			if v6 == nil or p3 == 0 or p4 == "" or v6.isDismissedPermanently(p3) then
				return
			end

			local eligibility = v6.getEligibility(p3)

			local v12 = p5 and not eligibility.isResolved
			local v14 = {
				id = `menu:{p3}:{p4}`,
				universeId = p3,
				sessionId = 0,
				afterMessageKey = nil,
				isCompletedTurn = false,
				isEligiblePublish = 0,
				requiresAudienceVerification = 0,
				isVerifyingAudience = false,
				isAwaitingEligibility = false,
				audienceVerificationAttempts = 0,
				storagePersistenceAttempts = 0
			}

			if sessionId == "" then
				sessionId = nil
			end

			v14.sessionId = sessionId

			local v15 = if not v12 then p5 and eligibility.isEligible and eligibility.freePromotionsRemaining > 0 else nil
			v14.isEligiblePublish = v15

			v14.requiresAudienceVerification = v12
			local v16 = retainPending(v14)

			fn(v16)
		end,
		retryStorageRead = function()
			local function fn3(p3)
				return p3 + 1
			end

			local function fn4(p3)
				return p3 + 1
			end

			if FFlagBuildAgentAdCampaignCard then
				local v12 = if v6 ~= nil then v6.getAdCampaignCardStorage() else nil

				if v12 ~= nil and v12.hasPendingWrites() and v12.retryWrites() then
					v8(fn4)
					v7(fn3)
				end
			end

			if v6 ~= nil and v6.retryStorageRead() then
				if FFlagBuildAgentAdCampaignCard then
					v8(fn4)
					v7(fn3)
				else
					v7(fn3)
				end

				local clone = table.clone(ids)

				for k, v12 in clone do
					local v13 = v9[v12]

					if v13 == nil then
						continue
					end

					v13.storagePersistenceAttempts = 0
					fn(v13)
				end
			end
		end,
		attachPendingMilestones = function(p3, p4, p5)
			if v6 ~= nil then
				v6.attachPendingMilestones(p3, p4, p5)
				v7(function(p6)
					return p6 + 1
				end)
			end
		end,
		pruneAnchors = function(p3, p4, p5)
			if FFlagBuildAdUpsellPinned or v6 == nil then
				return false
			end

			local pruneAnchors2, v12 = v6.pruneAnchors(p3, p4, p5)

			if v12 then
				v7(function(p6)
					return p6 + 1
				end)
			end

			return pruneAnchors2
		end,
		getTransientCongratsMessageKey = function(p3)
			if FFlagBuildAdUpsellPinned then
				return afterMessageKeysById[p3]
			end

			return nil
		end,
		markAnchorImpressed = function(p3, p4, p5)
			if v6 == nil then
				return false
			end

			local v12 = v6.markAnchorImpressed(p3, p4, p5)

			if v12 then
				v7(function(p6)
					return p6 + 1
				end)
			end

			return v12
		end,
		dismissPermanently = function(p3)
			if v6 ~= nil then
				local clone = table.clone(ids)

				for k, v12 in clone do
					local v13 = v9[v12]

					if not (v13 ~= nil and v13.universeId == p3 and v9[v12] ~= nil) then
						continue
					end

					local v14 = v11[v12]

					if v14 ~= nil then
						v11[v12] = nil
						v14()
					end

					v9[v12] = nil
					local index = table.find(ids, v12)

					if index ~= nil then
						table.remove(ids, index)
					end
				end

				v6.dismissPermanently(p3)
				v7(function(p4)
					return p4 + 1
				end)
			end
		end,
		reset = function()
			count += 1

			if v6 ~= nil and v10 ~= nil then
				v6.cancelRetry(v10)
			end

			v10 = nil
			disposeAllEligibilitySubscriptions()
			table.clear(v9)
			table.clear(ids)

			if FFlagBuildAdUpsellPinned then
				table.clear(afterMessageKeysById)
			end

			v7(0)
			v8(0)
		end
	}
end

return createAdUpsellEventStore
