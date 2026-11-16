local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local Signals = require(parent.Signals)
local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)

local chatTypes = require(BuildExperience.Chat.chatTypes)
local FFlagBuildAgentAdCampaignCard = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignCard)
local FFlagBuildAdUpsellPinned = require(BuildExperience.Flags.FFlagBuildAdUpsellPinned)
local getAdUpsellEligibility = require(BuildExperience.Components.Ads.getAdUpsellEligibility)
local observeAdUpsellEligibility = require(BuildExperience.Components.Ads.observeAdUpsellEligibility)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)

local engineFeature = game:GetEngineFeature("BuildAppStorageKey")
local BuildAppStorage

if engineFeature then
	BuildAppStorage = require(BuildExperience.Storage.BuildAppStorage)
else
	BuildAppStorage = nil
end

require(BuildExperience.Storage.createAdCampaignCardStorage)

local function defaultDependencies()
	if not engineFeature then
		return nil
	end

	local getAdCampaignCardStorage

	if FFlagBuildAgentAdCampaignCard then
		getAdCampaignCardStorage = BuildAppStorage.getAdCampaignCardStorage
	end

	return {
		getAdCampaignCardStorage = getAdCampaignCardStorage,
		recordCompletedTurn = BuildAppStorage.recordAdUpsellCompletedTurn,
		recordPublish = BuildAppStorage.recordAdUpsellPublish,
		attachPendingMilestones = BuildAppStorage.attachPendingAdUpsellMilestones,
		pruneAnchors = BuildAppStorage.pruneAdUpsellAnchors,
		markAnchorImpressed = BuildAppStorage.markAdUpsellAnchorImpressed,
		dismissPermanently = BuildAppStorage.markAdUpsellDismissedPermanently,
		isDismissedPermanently = function(p: number)
			local adUpsellState = BuildAppStorage.getAdUpsellState(p, nil)
			return adUpsellState.isAvailable and adUpsellState.dismissedPermanently
		end,
		retryStorageRead = BuildAppStorage.retryAdUpsellRead,
		refreshSummary = function(p: number)
			return UniverseConfiguration.getUniverseConfigurationStore().refreshSummary(p)
		end,
		getAudience = function(p)
			return GameConfigurationLabels.getAudience(p)
		end,
		publicAudience = UniverseConfiguration.PrivacyType.Public,
		getEligibility = getAdUpsellEligibility,
		observeEligibility = observeAdUpsellEligibility,
		scheduleRetry = function(duration: number, callback)
			return task.delay(duration, callback)
		end,
		cancelRetry = function(thread: thread)
			task.cancel(thread)
		end
	}
end

local function hasSuccessfulPublish(turnState): boolean -- 1 equivalent call inferred from this helper
	return CreatorAgentChat.PublishToolUtils.getLatestSuccessfulResult(turnState, {
		parseDirectText = true
	}) ~= nil
end

local function createAdUpsellEventStore(p)
	local v = p or defaultDependencies()
	local signal, v2 = Signals.createSignal(0)
	local signal2, v3 = Signals.createSignal(0)
	local v4 = {}
	local ids = {}
	local afterMessageKeysById = {}
	local v5 = nil
	local v6 = {}
	local count = 0

	local fn

	local function bumpRevision()
		v2(function(p2)
			return p2 + 1
		end)
	end

	local function getCardStorage() -- 7 equivalent calls inferred from this helper
		if v == nil then
			return nil
		end

		return (v.getAdCampaignCardStorage())
	end

	local function bumpAdCampaignRevision()
		v3(function(p2)
			return p2 + 1
		end)
		v2(function(p2)
			return p2 + 1
		end)
	end

	local function recordCardMutation(confirm: boolean, flag: boolean, pendingWrites: boolean)
		if flag or confirm and pendingWrites then
			v3(function(p2)
				return p2 + 1
			end)
			v2(function(p2)
				return p2 + 1
			end)
		end

		return confirm, flag
	end

	local function disposeEligibilitySubscription(p2: string) -- 4 equivalent calls inferred from this helper
		local v7 = v6[p2]

		if v7 == nil then
			return
		end

		v6[p2] = nil
		v7()
	end

	local function removePending(p2: string) -- 2 equivalent calls inferred from this helper
		if v4[p2] == nil then
			return
		end

		disposeEligibilitySubscription(p2) -- inferred equivalent call
		v4[p2] = nil
		local index = table.find(ids, p2)

		if index ~= nil then
			table.remove(ids, index)
		end
	end

	local function retainPending(p2)
		local v7 = v4[p2.id]

		if v7 ~= nil then
			return v7
		end

		v4[p2.id] = p2
		table.insert(ids, p2.id)

		while #ids > 50 do
			local v8 = table.remove(ids, 1)

			if v8 == nil then
				continue
			end

			disposeEligibilitySubscription(v8) -- inferred equivalent call
			v4[v8] = nil
		end

		return p2
	end

	local function canRetryAutomatically(data): boolean -- 2 equivalent calls inferred from this helper
		if data.isAwaitingEligibility then
			return false
		end

		if data.requiresAudienceVerification and data.isEligiblePublish == nil then
			return not data.isVerifyingAudience and data.audienceVerificationAttempts < 3
		end

		return data.storagePersistenceAttempts < 3
	end

	local function hasAutomaticallyRetryableEvent(): boolean -- 2 equivalent calls inferred from this helper
		for _, v7 in ids do
			local v8 = v4[v7]

			if v8 ~= nil and canRetryAutomatically(v8) then -- inferred equivalent call
				return true
			end
		end

		return false
	end

	local function fn2()
		if v ~= nil and v5 == nil and hasAutomaticallyRetryableEvent() then -- inferred equivalent call
			local v7 = count
			v5 = v.scheduleRetry(1, function()
				v5 = nil

				if count ~= v7 then
					return
				end

				local clone = table.clone(ids)

				for _, v8 in clone do
					local v9 = v4[v8]

					if v9 ~= nil and canRetryAutomatically(v9) then -- inferred equivalent call
						fn(v9)
					end
				end

				if hasAutomaticallyRetryableEvent() then -- inferred equivalent call
					fn2()
				end
			end)
		end
	end

	local function persistEvent(state)
		if v == nil then
			return
		end

		local v7 = {
			universeId = state.universeId,
			sessionId = state.sessionId,
			eventId = state.id,
			afterMessageKey = state.afterMessageKey,
			isEligiblePublish = state.isEligiblePublish == true
		}
		local v8, v9

		if state.isCompletedTurn then
			v8, v9 = v.recordCompletedTurn(v7)
		else
			v8, v9 = v.recordPublish(v7)
		end

		if v9 then
			if FFlagBuildAdUpsellPinned and state.afterMessageKey ~= nil then
				afterMessageKeysById[state.id] = state.afterMessageKey
			end

			v2(function(p2)
				return p2 + 1
			end)
		end

		if v8 or v9 then
			removePending(state.id) -- inferred equivalent call
		else
			state.storagePersistenceAttempts += 1

			if state.storagePersistenceAttempts < 3 then
				fn2()
			end
		end
	end

	local function handleAudienceVerificationFailure(state) -- 2 equivalent calls inferred from this helper
		state.isVerifyingAudience = false
		state.audienceVerificationAttempts += 1

		if state.audienceVerificationAttempts < 3 then
			fn2()
		end
	end

	local function awaitEligibility(state, p2)
		if v == nil then
			return
		end

		state.isVerifyingAudience = false

		if state.isAwaitingEligibility then
			return
		end

		state.isAwaitingEligibility = true

		local v7 = count
		local v8 = nil
		local flag = false
		local function onEligibilityChanged()
			if count ~= v7 or v4[state.id] ~= state then
				return
			end

			local eligibility = v.getEligibility(state.universeId)

			if not eligibility.isResolved then
				return
			end

			state.isAwaitingEligibility = false

			if v8 == nil then
				flag = true
			else
				disposeEligibilitySubscription(state.id) -- inferred equivalent call
			end

			state.isEligiblePublish = v.getAudience(p2) == v.publicAudience
				and eligibility.isEligible
				and eligibility.freePromotionsRemaining > 0
			persistEvent(state)
		end

		local v9 = v.observeEligibility(state.universeId, onEligibilityChanged)
		v8 = v9

		if flag then
			v9()
		else
			v6[state.id] = v9
		end
	end

	fn = function(state)
		if v == nil or v4[state.id] ~= state then
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
		local success, result = pcall(v.refreshSummary, state.universeId)

		if success and result ~= nil then
			local v7 = count
			result:andThen(function(p2)
				if count ~= v7 or v4[state.id] ~= state then
					return
				end

				local eligibility = v.getEligibility(state.universeId)

				if not eligibility.isResolved then
					awaitEligibility(state, p2)
					return
				end

				state.isVerifyingAudience = false
				state.isEligiblePublish = v.getAudience(p2) == v.publicAudience
					and eligibility.isEligible
					and eligibility.freePromotionsRemaining > 0
				persistEvent(state)
			end, function()
				if count ~= v7 or v4[state.id] ~= state then
					return
				end

				handleAudienceVerificationFailure(state) -- inferred equivalent call
			end)
		else
			handleAudienceVerificationFailure(state) -- inferred equivalent call
		end
	end

	local function disposeAllEligibilitySubscriptions()
		local v7 = {}

		for k in v6 do
			table.insert(v7, k)
		end

		for _, v8 in v7 do
			disposeEligibilitySubscription(v8) -- inferred equivalent call
		end
	end

	return {
		recordAdCampaignAttempt = FFlagBuildAgentAdCampaignCard and function(p2, p3): boolean
			local cardStorage = getCardStorage() -- inferred equivalent call

			if cardStorage == nil or not cardStorage.saveAttempt(p2, p3) then
				return false
			end

			v3(function(p4)
				return p4 + 1
			end)
			v2(function(p4)
				return p4 + 1
			end)

			return true
		end or nil,
		getAdCampaignCard = FFlagBuildAgentAdCampaignCard and function(p2, p3)
			local cardStorage = getCardStorage() -- inferred equivalent call

			if cardStorage == nil then
				return { isAvailable = false, isPersisted = false }
			end

			return cardStorage.get(p2, p3)
		end or nil,
		listAdCampaignCards = FFlagBuildAgentAdCampaignCard and function(p2)
			local cardStorage = getCardStorage() -- inferred equivalent call

			if cardStorage == nil then
				return { isAvailable = false, records = {} }
			end

			return cardStorage.list(p2)
		end or nil,
		recordAdCampaignCreatedReceipt = FFlagBuildAgentAdCampaignCard and function(p2)
			local cardStorage = getCardStorage() -- inferred equivalent call

			if cardStorage == nil then
				return false, false
			end

			local pendingWrites = cardStorage.hasPendingWrites()
			local confirm, v7 = cardStorage.confirm(p2)
			return recordCardMutation(confirm, v7, pendingWrites)
		end or nil,
		retryAdCampaignCardWrites = FFlagBuildAgentAdCampaignCard and function(): boolean
			local cardStorage = getCardStorage() -- inferred equivalent call

			if cardStorage == nil then
				return false
			end

			local pendingWrites = cardStorage.hasPendingWrites()

			if not cardStorage.retryWrites() then
				return false
			end

			if pendingWrites then
				v3(function(p2)
					return p2 + 1
				end)
				v2(function(p2)
					return p2 + 1
				end)
			end

			return true
		end or nil,
		pruneAdCampaignCards = FFlagBuildAgentAdCampaignCard and function(p2)
			local cardStorage = getCardStorage() -- inferred equivalent call

			if cardStorage == nil then
				return false, false
			end

			local prune, v7 = cardStorage.prune(p2)

			if v7 then
				v3(function(p3)
					return p3 + 1
				end)
				v2(function(p3)
					return p3 + 1
				end)
			end

			return prune, v7
		end or nil,
		getRevision = signal,
		getAdCampaignRevision = signal2,
		reportAssistantTurnCompleted = function(data)
			if v == nil or data.universeId == 0 or v.isDismissedPermanently(data.universeId) then
				return
			end

			local assistantTurnAnchorKey = chatTypes.makeAssistantTurnAnchorKey(data.sessionId, data.latestSequenceId)

			if assistantTurnAnchorKey == nil then
				return
			end

			local formatted = `chat:{data.universeId}:{assistantTurnAnchorKey}`
			local successfulPublish = hasSuccessfulPublish(data.turnState) -- inferred equivalent call

			local v7 = {
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
			local sessionId

			if data.sessionId ~= "" then
				sessionId = data.sessionId
			end

			v7.sessionId = sessionId
			v7.afterMessageKey = assistantTurnAnchorKey
			local isEligiblePublish

			if not successfulPublish then
				isEligiblePublish = false
			end

			v7.isEligiblePublish = isEligiblePublish
			v7.requiresAudienceVerification = successfulPublish
			local v8 = retainPending(v7)

			fn(v8)
		end,
		reportMenuPublish = function(universeId: number, sessionId: string?, p2: string, flag: boolean)
			if v == nil or universeId == 0 or p2 == "" or v.isDismissedPermanently(universeId) then
				return
			end

			local eligibility = v.getEligibility(universeId)

			local requiresAudienceVerification = flag and not eligibility.isResolved
			local v7 = {
				id = `menu:{universeId}:{p2}`,
				universeId = universeId,
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

			v7.sessionId = sessionId
			local isEligiblePublish

			if not requiresAudienceVerification then
				isEligiblePublish = flag and eligibility.isEligible and eligibility.freePromotionsRemaining > 0
			end

			v7.isEligiblePublish = isEligiblePublish

			v7.requiresAudienceVerification = requiresAudienceVerification
			local v8 = retainPending(v7)

			fn(v8)
		end,
		retryStorageRead = function()
			local function fn3(p2)
				return p2 + 1
			end

			local function fn4(p2)
				return p2 + 1
			end

			if FFlagBuildAgentAdCampaignCard then
				local cardStorage = getCardStorage() -- inferred equivalent call

				if cardStorage ~= nil and cardStorage.hasPendingWrites() and cardStorage.retryWrites() then
					v3(fn4)
					v2(fn3)
				end
			end

			if v ~= nil and v.retryStorageRead() then
				if FFlagBuildAgentAdCampaignCard then
					v3(fn4)
					v2(fn3)
				else
					v2(fn3)
				end

				local clone = table.clone(ids)

				for _, v7 in clone do
					local v8 = v4[v7]

					if v8 == nil then
						continue
					end

					v8.storagePersistenceAttempts = 0
					fn(v8)
				end
			end
		end,
		attachPendingMilestones = function(p2: number, p3: string, p4: string?)
			if v ~= nil then
				v.attachPendingMilestones(p2, p3, p4)
				v2(function(p5)
					return p5 + 1
				end)
			end
		end,
		pruneAnchors = function(p2: number, p3: string, p4)
			if FFlagBuildAdUpsellPinned or v == nil then
				return false
			end

			local pruneAnchors, v7 = v.pruneAnchors(p2, p3, p4)

			if v7 then
				v2(function(p5)
					return p5 + 1
				end)
			end

			return pruneAnchors
		end,
		getTransientCongratsMessageKey = function(p2: string)
			if FFlagBuildAdUpsellPinned then
				return afterMessageKeysById[p2]
			end

			return nil
		end,
		markAnchorImpressed = function(p2: number, p3: string, p4: string)
			if v == nil then
				return false
			end

			local v7 = v.markAnchorImpressed(p2, p3, p4)

			if v7 then
				v2(function(p5)
					return p5 + 1
				end)
			end

			return v7
		end,
		dismissPermanently = function(p2: number)
			if v ~= nil then
				local clone = table.clone(ids)

				for _, v7 in clone do
					local v8 = v4[v7]

					if v8 ~= nil and v8.universeId == p2 then
						removePending(v7) -- inferred equivalent call
					end
				end

				v.dismissPermanently(p2)
				v2(function(p3)
					return p3 + 1
				end)
			end
		end,
		reset = function()
			count += 1

			if v ~= nil and v5 ~= nil then
				v.cancelRetry(v5)
			end

			v5 = nil
			disposeAllEligibilitySubscriptions()
			table.clear(v4)
			table.clear(ids)

			if FFlagBuildAdUpsellPinned then
				table.clear(afterMessageKeysById)
			end

			v2(0)
			v3(0)
		end
	}
end

return createAdUpsellEventStore
