local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)
require(parent.MomentsTypes)

local function selectedEmoteId(p) -- 6 equivalent calls inferred from this helper
	if p == nil or p.userReaction == nil then
		return nil
	end

	return p.userReaction.emoteId
end

local function selectionsAgree(p, p2: string?): boolean
	return selectedEmoteId(p) == p2 -- inferred equivalent call
end

local function restrictionFromState(data, p: string, p2: string) -- 2 equivalent calls inferred from this helper
	local commentRestriction = data.commentRestrictionsByCommentId[p2]
	local globalRestriction = data.globalRestriction or data.feedRestrictionsByFeedItemId[p]

	if globalRestriction then
		return globalRestriction
	end

	if commentRestriction ~= nil and commentRestriction.feedItemId == p then
		return commentRestriction.errorCode
	end

	globalRestriction = nil
	return globalRestriction
end

local function transitionDeltas(p: string?, p2: string?) -- 4 equivalent calls inferred from this helper
	local v = {}

	if p ~= nil and p ~= p2 then
		v[p] = -1
	end

	if p2 ~= nil and p2 ~= p then
		v[p2] = (v[p2] or 0) + 1
	end

	return v
end

local function combineDeltas(p, items)
	local clone = table.clone(p)

	for k, item in items do
		local v = (clone[k] or 0) + item

		if v == 0 then
			clone[k] = nil
		else
			clone[k] = v
		end
	end

	return clone
end

local function projectReactions(reactions, intent)
	local counts = table.create(#reactions.counts)
	local emoteIdSet = {}

	for _, count in reactions.counts do
		local v = intent.countDeltas[count.emoteId] or 0
		table.insert(counts, {
			emoteId = count.emoteId,
			count = math.max(0, count.count + v)
		})

		emoteIdSet[count.emoteId] = true
	end

	for k, countDelta in intent.countDeltas do
		if emoteIdSet[k] or not (countDelta > 0) then
			continue
		end

		table.insert(counts, { emoteId = k, count = countDelta })
	end

	return {
		counts = counts,
		userReaction = intent.desiredEmoteId ~= nil and { emoteId = intent.desiredEmoteId } or nil
	}
end

local function createCommentReactionsStore()
	local signal, v = Signals.createSignal({
		intentsByCommentId = {},
		globalRestriction = nil,
		feedRestrictionsByFeedItemId = {},
		commentRestrictionsByCommentId = {},
		cooldownUntilMs = 0
	})

	local signal2, v2 = Signals.createSignal(0)
	local flag = false

	local function updateState(fn) -- 3 equivalent calls inferred from this helper
		if not flag then
			v(fn(signal(false)))
		end
	end

	local function getIntent(p: string, p2) -- 4 equivalent calls inferred from this helper
		return signal(p2 or false).intentsByCommentId[p]
	end

	local function updateIntentStatus(p: string, p2: number, status: string): boolean -- 3 equivalent calls inferred from this helper
		local intent = getIntent(p) -- inferred equivalent call

		if flag or intent == nil or intent.generation ~= p2 then
			return false
		end

		local function fn(data)
			local clone = table.clone(data.intentsByCommentId)
			local clone2 = table.clone(intent)
			clone2.status = status

			if status == "LocallyConfirmed" then
				clone2.rollbackState = nil
			end

			clone[p] = clone2
			return {
				intentsByCommentId = clone,
				globalRestriction = data.globalRestriction,
				feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
				commentRestrictionsByCommentId = data.commentRestrictionsByCommentId,
				cooldownUntilMs = data.cooldownUntilMs
			}
		end

		if not flag then
			v(fn(signal(false)))
		end

		return true
	end

	local function removeIntent(p: string, p2: number, errorCode: string?): boolean
		local intent = getIntent(p) -- inferred equivalent call

		if flag or intent == nil or intent.generation ~= p2 then
			return false
		end

		local function fn(data)
			local clone = table.clone(data.intentsByCommentId)

			if intent.rollbackState == nil then
				clone[p] = nil
			else
				clone[p] = {
					feedItemId = intent.feedItemId,
					desiredEmoteId = intent.rollbackState.desiredEmoteId,
					countDeltas = table.clone(intent.rollbackState.countDeltas),
					generation = intent.generation,
					rollbackState = nil,
					status = "LocallyConfirmed"
				}
			end

			local clone2 = table.clone(data.commentRestrictionsByCommentId)

			if errorCode == nil then
				clone2[p] = nil
			else
				clone2[p] = {
					feedItemId = intent.feedItemId,
					errorCode = errorCode,
					generation = intent.generation
				}
			end

			return {
				intentsByCommentId = clone,
				globalRestriction = data.globalRestriction,
				feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
				commentRestrictionsByCommentId = clone2,
				cooldownUntilMs = data.cooldownUntilMs
			}
		end

		if not flag then
			v(fn(signal(false)))
		end

		return true
	end

	local function clear()
		if flag then
			return
		end

		v2(signal2(false) + 1)
		v({
			intentsByCommentId = {},
			globalRestriction = nil,
			feedRestrictionsByFeedItemId = {},
			commentRestrictionsByCommentId = {},
			cooldownUntilMs = 0
		})
	end

	return {
		getGeneration = signal2,
		getCooldownUntilMs = function(p)
			return signal(p or false).cooldownUntilMs
		end,
		getIntent = getIntent,
		getRestriction = function(p: string, p2: string, p3)
			return restrictionFromState(signal(p3 or false), p, p2) -- inferred equivalent call
		end,
		getProjection = function(p: string, p2: string, reactions, p3)
			local v3 = signal(p3 or false)
			local intent = v3.intentsByCommentId[p2]

			if reactions ~= nil and intent ~= nil then
				reactions = projectReactions(reactions, intent)
			end

			local status

			if intent ~= nil then
				status = intent.status
			end

			local projection = {
				reactions = reactions,
				status = status,
				restriction = restrictionFromState(v3, p, p2), -- inferred equivalent call
				generation = 0
			}
			local generation

			if intent ~= nil then
				generation = intent.generation
			end

			projection.generation = generation
			return projection
		end,
		beginIntent = function(feedItemId: string, p: string, p2, desiredEmoteId: string?)
			if flag then
				return signal2(false)
			end

			local generation = signal2(false) + 1
			v2(generation)
			local function fn(data)
				local clone = table.clone(data.intentsByCommentId)
				local v3 = clone[p]
				local v4 = selectedEmoteId(p2) -- inferred equivalent call
				local rollbackState = nil
				local v5

				if v3 == nil then
					v5 = {}
				else
					v4 = v3.desiredEmoteId
					v5 = v3.countDeltas

					if v3.rollbackState == nil then
						if v3.status == "LocallyConfirmed" then
							rollbackState = {
								desiredEmoteId = v3.desiredEmoteId,
								countDeltas = table.clone(v3.countDeltas)
							}
						end
					else
						rollbackState = {
							desiredEmoteId = v3.rollbackState.desiredEmoteId,
							countDeltas = table.clone(v3.rollbackState.countDeltas)
						}
					end
				end

				clone[p] = {
					feedItemId = feedItemId,
					desiredEmoteId = desiredEmoteId,
					countDeltas = combineDeltas(v5, transitionDeltas(v4, desiredEmoteId)), -- inferred equivalent call
					generation = generation,
					rollbackState = rollbackState,
					status = "Pending"
				}

				return {
					intentsByCommentId = clone,
					globalRestriction = data.globalRestriction,
					feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
					commentRestrictionsByCommentId = data.commentRestrictionsByCommentId,
					cooldownUntilMs = data.cooldownUntilMs
				}
			end

			if not flag then
				v(fn(signal(false)))
			end

			return generation
		end,
		markPending = function(p: string, p2: number)
			return updateIntentStatus(p, p2, "Pending") -- inferred equivalent call
		end,
		markUncertain = function(p: string, p2: number)
			return updateIntentStatus(p, p2, "Uncertain") -- inferred equivalent call
		end,
		markLocallyConfirmed = function(p: string, p2: number)
			return updateIntentStatus(p, p2, "LocallyConfirmed") -- inferred equivalent call
		end,
		confirmAndRebase = function(p: string, p2: number, p3): boolean
			local intent = getIntent(p) -- inferred equivalent call

			if flag or intent == nil or intent.generation ~= p2 then
				return false
			end

			local function fn(data)
				local clone = table.clone(data.intentsByCommentId)
				local clone2 = table.clone(intent)
				clone2.countDeltas = transitionDeltas(selectedEmoteId(p3), intent.desiredEmoteId) -- inferred equivalent call
				clone2.rollbackState = nil
				clone2.status = "LocallyConfirmed"
				clone[p] = clone2
				return {
					intentsByCommentId = clone,
					globalRestriction = data.globalRestriction,
					feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
					commentRestrictionsByCommentId = data.commentRestrictionsByCommentId,
					cooldownUntilMs = data.cooldownUntilMs
				}
			end

			if not flag then
				v(fn(signal(false)))
			end

			return true
		end,
		rollback = removeIntent,
		expireIntent = function(p: string, p2: number): boolean
			local intent = getIntent(p) -- inferred equivalent call

			if flag or intent == nil or intent.generation ~= p2 then
				return false
			end

			local function fn(data)
				local clone = table.clone(data.intentsByCommentId)
				clone[p] = nil
				return {
					intentsByCommentId = clone,
					globalRestriction = data.globalRestriction,
					feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
					commentRestrictionsByCommentId = data.commentRestrictionsByCommentId,
					cooldownUntilMs = data.cooldownUntilMs
				}
			end

			updateState(fn) -- inferred equivalent call
			return true
		end,
		reconcile = function(p: string, p2: string, p3, p4: number)
			if p3 == nil then
				return false
			end

			local v3 = false
			local function fn(data)
				local clone = table.clone(data.commentRestrictionsByCommentId)
				local v4 = clone[p2]

				if v4 ~= nil and v4.feedItemId == p and p4 >= v4.generation then
					clone[p2] = nil
				end

				local intent = data.intentsByCommentId[p2]
				local clone2 = table.clone(data.intentsByCommentId)

				if intent ~= nil then
					local desiredEmoteId = intent.desiredEmoteId

					if selectedEmoteId(p3) == desiredEmoteId then -- inferred equivalent call
						clone2[p2] = nil
						v3 = true
					elseif p4 >= intent.generation then
						local clone3 = table.clone(intent)
						clone3.countDeltas = transitionDeltas(selectedEmoteId(p3), intent.desiredEmoteId) -- inferred equivalent call

						if intent.rollbackState ~= nil then
							clone3.rollbackState = {
								desiredEmoteId = intent.rollbackState.desiredEmoteId,
								countDeltas = transitionDeltas(selectedEmoteId(p3), intent.rollbackState.desiredEmoteId) -- inferred equivalent call
							}
						end

						clone2[p2] = clone3
					end
				end

				return {
					intentsByCommentId = clone2,
					globalRestriction = data.globalRestriction,
					feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
					commentRestrictionsByCommentId = clone,
					cooldownUntilMs = data.cooldownUntilMs
				}
			end

			if not flag then
				v(fn(signal(false)))
			end

			return v3
		end,
		setGlobalRestriction = function(globalRestriction: string?)
			local function fn(data)
				return {
					intentsByCommentId = data.intentsByCommentId,
					globalRestriction = globalRestriction,
					feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
					commentRestrictionsByCommentId = data.commentRestrictionsByCommentId,
					cooldownUntilMs = data.cooldownUntilMs
				}
			end

			updateState(fn) -- inferred equivalent call
		end,
		setFeedRestriction = function(p: string, p2: string?)
			local function fn(data)
				local clone = table.clone(data.feedRestrictionsByFeedItemId)

				if p2 == nil then
					clone[p] = nil
				else
					clone[p] = p2
				end

				return {
					intentsByCommentId = data.intentsByCommentId,
					globalRestriction = data.globalRestriction,
					feedRestrictionsByFeedItemId = clone,
					commentRestrictionsByCommentId = data.commentRestrictionsByCommentId,
					cooldownUntilMs = data.cooldownUntilMs
				}
			end

			if not flag then
				v(fn(signal(false)))
			end
		end,
		setCommentRestriction = function(feedItemId: string, p: string, errorCode: string?, generation: number)
			local function fn(data)
				local clone = table.clone(data.commentRestrictionsByCommentId)

				if errorCode == nil then
					clone[p] = nil
				else
					clone[p] = {
						feedItemId = feedItemId,
						errorCode = errorCode,
						generation = generation
					}
				end

				return {
					intentsByCommentId = data.intentsByCommentId,
					globalRestriction = data.globalRestriction,
					feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
					commentRestrictionsByCommentId = clone,
					cooldownUntilMs = data.cooldownUntilMs
				}
			end

			if not flag then
				v(fn(signal(false)))
			end
		end,
		setCooldownUntilMs = function(p: number)
			local function fn(data)
				return {
					intentsByCommentId = data.intentsByCommentId,
					globalRestriction = data.globalRestriction,
					feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
					commentRestrictionsByCommentId = data.commentRestrictionsByCommentId,
					cooldownUntilMs = math.max(0, p)
				}
			end

			updateState(fn) -- inferred equivalent call
		end,
		clearComment = function(p: string)
			local function fn(data)
				local clone = table.clone(data.intentsByCommentId)
				clone[p] = nil
				local clone2 = table.clone(data.commentRestrictionsByCommentId)
				clone2[p] = nil
				return {
					intentsByCommentId = clone,
					globalRestriction = data.globalRestriction,
					feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
					commentRestrictionsByCommentId = clone2,
					cooldownUntilMs = data.cooldownUntilMs
				}
			end

			if not flag then
				v(fn(signal(false)))
			end
		end,
		clearFeed = function(p: string)
			local function fn(data)
				local clone = table.clone(data.intentsByCommentId)

				for k, v3 in clone do
					if v3.feedItemId == p then
						clone[k] = nil
					end
				end

				local clone2 = table.clone(data.feedRestrictionsByFeedItemId)
				clone2[p] = nil
				local clone3 = table.clone(data.commentRestrictionsByCommentId)

				for k, v3 in clone3 do
					if v3.feedItemId == p then
						clone3[k] = nil
					end
				end

				return {
					intentsByCommentId = clone,
					globalRestriction = data.globalRestriction,
					feedRestrictionsByFeedItemId = clone2,
					commentRestrictionsByCommentId = clone3,
					cooldownUntilMs = data.cooldownUntilMs
				}
			end

			if not flag then
				v(fn(signal(false)))
			end
		end,
		clear = clear,
		dispose = function()
			if flag then
				return
			end

			clear()
			flag = true
		end
	}
end

return createCommentReactionsStore
