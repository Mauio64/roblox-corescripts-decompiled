local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

local function selectedEmoteId(p2)
	if p2 == nil or p2.userReaction == nil then
		return nil
	end

	return p2.userReaction.emoteId
end

local function selectionsAgree(p2, p3): boolean
	return (if p2 ~= nil and p2.userReaction ~= nil then p2.userReaction.emoteId else nil) == p3
end

local function restrictionFromState(data, p2, p3)
	local commentRestriction = data.commentRestrictionsByCommentId[p3]
	local globalRestriction = data.globalRestriction or data.feedRestrictionsByFeedItemId[p2]

	if globalRestriction then
		return globalRestriction
	end

	if commentRestriction ~= nil and commentRestriction.feedItemId == p2 then
		return commentRestriction.errorCode
	end

	globalRestriction = nil
	return globalRestriction
end

local function transitionDeltas(p2, p3)
	local v5 = {}

	if p2 ~= nil and p2 ~= p3 then
		v5[p2] = -1
	end

	if p3 ~= nil and p3 ~= p2 then
		v5[p3] = (v5[p3] or 0) + 1
	end

	return v5
end

local function combineDeltas(p2, items)
	local clone = table.clone(p2)

	for k, item in items do
		local v5 = (clone[k] or 0) + item

		if v5 == 0 then
			clone[k] = nil
		else
			clone[k] = v5
		end
	end

	return clone
end

local function projectReactions(reactions, intent)
	local v5 = table.create(#reactions.counts)
	local emoteIdSet = {}

	for k, count in reactions.counts do
		local v6 = intent.countDeltas[count.emoteId] or 0
		table.insert(v5, {
			emoteId = count.emoteId,
			count = math.max(0, count.count + v6)
		})

		emoteIdSet[count.emoteId] = true
	end

	for k, countDelta in intent.countDeltas do
		if emoteIdSet[k] or not (countDelta > 0) then
			continue
		end

		table.insert(v5, { emoteId = k, count = countDelta })
	end

	return {
		counts = v5,
		userReaction = intent.desiredEmoteId ~= nil and {
			emoteId = intent.desiredEmoteId
		} or nil
	}
end

local function createCommentReactionsStore()
	local signal, v5 = Signals.createSignal({
		intentsByCommentId = {},
		globalRestriction = nil,
		feedRestrictionsByFeedItemId = {},
		commentRestrictionsByCommentId = {},
		cooldownUntilMs = 0
	})

	local signal2, v6 = Signals.createSignal(0)
	local flag = false

	local function updateState(callback)
		if not flag then
			v5(callback(signal(false)))
		end
	end

	local function updateIntentStatus(p2, p3, status): boolean
		local intent = signal(false).intentsByCommentId[p2]

		if flag or intent == nil or intent.generation ~= p3 then
			return false
		end

		local function fn(data)
			local clone = table.clone(data.intentsByCommentId)
			local clone2 = table.clone(intent)
			clone2.status = status

			if status == "LocallyConfirmed" then
				clone2.rollbackState = nil
			end

			clone[p2] = clone2
			return {
				intentsByCommentId = clone,
				globalRestriction = data.globalRestriction,
				feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
				commentRestrictionsByCommentId = data.commentRestrictionsByCommentId,
				cooldownUntilMs = data.cooldownUntilMs
			}
		end

		if not flag then
			v5(fn(signal(false)))
		end

		return true
	end

	local function removeIntent(p2, p3, p4): boolean
		local intent = signal(false).intentsByCommentId[p2]

		if flag or intent == nil or intent.generation ~= p3 then
			return false
		end

		local function fn(data)
			local clone = table.clone(data.intentsByCommentId)

			if intent.rollbackState == nil then
				clone[p2] = nil
			else
				clone[p2] = {
					feedItemId = intent.feedItemId,
					desiredEmoteId = intent.rollbackState.desiredEmoteId,
					countDeltas = table.clone(intent.rollbackState.countDeltas),
					generation = intent.generation,
					rollbackState = nil,
					status = "LocallyConfirmed"
				}
			end

			local clone2 = table.clone(data.commentRestrictionsByCommentId)

			if p4 == nil then
				clone2[p2] = nil
			else
				clone2[p2] = {
					feedItemId = intent.feedItemId,
					errorCode = p4,
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
			v5(fn(signal(false)))
		end

		return true
	end

	local function clear()
		if flag then
			return
		end

		v6(signal2(false) + 1)
		v5({
			intentsByCommentId = {},
			globalRestriction = nil,
			feedRestrictionsByFeedItemId = {},
			commentRestrictionsByCommentId = {},
			cooldownUntilMs = 0
		})
	end

	return {
		getGeneration = signal2,
		getCooldownUntilMs = function(p2)
			return signal(p2 or false).cooldownUntilMs
		end,
		getIntent = function(p2, p3)
			return signal(p3 or false).intentsByCommentId[p2]
		end,
		getRestriction = function(p2, p3, p4)
			local v7 = signal(p4 or false)
			local commentRestriction = v7.commentRestrictionsByCommentId[p3]
			local globalRestriction = v7.globalRestriction or v7.feedRestrictionsByFeedItemId[p2]

			if globalRestriction then
				return globalRestriction
			end

			if commentRestriction ~= nil and commentRestriction.feedItemId == p2 then
				return commentRestriction.errorCode
			end

			globalRestriction = nil
			return globalRestriction
		end,
		getProjection = function(p2, p3, reactions, p4)
			local v7 = signal(p4 or false)
			local intent = v7.intentsByCommentId[p3]

			if reactions ~= nil and intent ~= nil then
				reactions = projectReactions(reactions, intent)
			end

			local v8 = if intent ~= nil then intent.status else nil
			local commentRestriction = v7.commentRestrictionsByCommentId[p3]
			local v9 = v7.globalRestriction or v7.feedRestrictionsByFeedItemId[p2]

			if not v9 then
				if commentRestriction == nil or commentRestriction.feedItemId ~= p2 then
					v9 = nil
				else
					v9 = commentRestriction.errorCode
				end
			end

			local v10 = if intent ~= nil then intent.generation else nil
			return {
				reactions = reactions,
				status = v8,
				restriction = v9,
				generation = v10
			}
		end,
		beginIntent = function(p2, p3, p4, p5)
			if flag then
				return signal2(false)
			end

			local v7 = signal2(false) + 1
			v6(v7)
			local function fn(data)
				local clone = table.clone(data.intentsByCommentId)
				local v8 = clone[p3]
				local v9 = p4
				local v10 = if not (v9 == nil or v9.userReaction == nil) then v9.userReaction.emoteId else nil

				local v11 = nil
				local v12

				if v8 == nil then
					v12 = {}
				else
					v10 = v8.desiredEmoteId
					v12 = v8.countDeltas

					if v8.rollbackState == nil then
						if v8.status == "LocallyConfirmed" then
							v11 = {
								desiredEmoteId = v8.desiredEmoteId,
								countDeltas = table.clone(v8.countDeltas)
							}
						end
					else
						v11 = {
							desiredEmoteId = v8.rollbackState.desiredEmoteId,
							countDeltas = table.clone(v8.rollbackState.countDeltas)
						}
					end
				end

				local v14 = {
					feedItemId = p2,
					desiredEmoteId = p5,
					countDeltas = 0,
					generation = 0,
					rollbackState = 0,
					status = "Pending"
				}

				local v16 = p5
				local v17 = {}

				if v10 ~= nil and v10 ~= v16 then
					v17[v10] = -1
				end

				if v16 ~= nil and v16 ~= v10 then
					v17[v16] = (v17[v16] or 0) + 1
				end

				v14.countDeltas = combineDeltas(v12, v17)
				v14.generation = v7
				v14.rollbackState = v11
				clone[p3] = v14

				return {
					intentsByCommentId = clone,
					globalRestriction = data.globalRestriction,
					feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
					commentRestrictionsByCommentId = data.commentRestrictionsByCommentId,
					cooldownUntilMs = data.cooldownUntilMs
				}
			end

			if not flag then
				v5(fn(signal(false)))
			end

			return v7
		end,
		markPending = function(p2, p3): boolean
			local intent = signal(false).intentsByCommentId[p2]

			if flag or intent == nil or intent.generation ~= p3 then
				return false
			end

			local v7 = "Pending"
			local function fn(data)
				local clone = table.clone(data.intentsByCommentId)
				local clone2 = table.clone(intent)
				clone2.status = v7

				if v7 == "LocallyConfirmed" then
					clone2.rollbackState = nil
				end

				clone[p2] = clone2
				return {
					intentsByCommentId = clone,
					globalRestriction = data.globalRestriction,
					feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
					commentRestrictionsByCommentId = data.commentRestrictionsByCommentId,
					cooldownUntilMs = data.cooldownUntilMs
				}
			end

			if not flag then
				v5(fn(signal(false)))
			end

			return true
		end,
		markUncertain = function(p2, p3): boolean
			local intent = signal(false).intentsByCommentId[p2]

			if flag or intent == nil or intent.generation ~= p3 then
				return false
			end

			local v7 = "Uncertain"
			local function fn(data)
				local clone = table.clone(data.intentsByCommentId)
				local clone2 = table.clone(intent)
				clone2.status = v7

				if v7 == "LocallyConfirmed" then
					clone2.rollbackState = nil
				end

				clone[p2] = clone2
				return {
					intentsByCommentId = clone,
					globalRestriction = data.globalRestriction,
					feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
					commentRestrictionsByCommentId = data.commentRestrictionsByCommentId,
					cooldownUntilMs = data.cooldownUntilMs
				}
			end

			if not flag then
				v5(fn(signal(false)))
			end

			return true
		end,
		markLocallyConfirmed = function(p2, p3): boolean
			local intent = signal(false).intentsByCommentId[p2]

			if flag or intent == nil or intent.generation ~= p3 then
				return false
			end

			local v7 = "LocallyConfirmed"
			local function fn(data)
				local clone = table.clone(data.intentsByCommentId)
				local clone2 = table.clone(intent)
				clone2.status = v7

				if v7 == "LocallyConfirmed" then
					clone2.rollbackState = nil
				end

				clone[p2] = clone2
				return {
					intentsByCommentId = clone,
					globalRestriction = data.globalRestriction,
					feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
					commentRestrictionsByCommentId = data.commentRestrictionsByCommentId,
					cooldownUntilMs = data.cooldownUntilMs
				}
			end

			if not flag then
				v5(fn(signal(false)))
			end

			return true
		end,
		confirmAndRebase = function(p2, p3, p4): boolean
			local intent = signal(false).intentsByCommentId[p2]

			if flag or intent == nil or intent.generation ~= p3 then
				return false
			end

			local function fn(data)
				local clone = table.clone(data.intentsByCommentId)
				local clone2 = table.clone(intent)

				local v7 = p4
				local emoteId = if not (v7 == nil or v7.userReaction == nil) then v7.userReaction.emoteId else nil

				local desiredEmoteId = intent.desiredEmoteId
				local v8 = {}

				if emoteId ~= nil and emoteId ~= desiredEmoteId then
					v8[emoteId] = -1
				end

				if desiredEmoteId ~= nil and desiredEmoteId ~= emoteId then
					v8[desiredEmoteId] = (v8[desiredEmoteId] or 0) + 1
				end

				clone2.countDeltas = v8

				clone2.rollbackState = nil
				clone2.status = "LocallyConfirmed"
				clone[p2] = clone2
				return {
					intentsByCommentId = clone,
					globalRestriction = data.globalRestriction,
					feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
					commentRestrictionsByCommentId = data.commentRestrictionsByCommentId,
					cooldownUntilMs = data.cooldownUntilMs
				}
			end

			if not flag then
				v5(fn(signal(false)))
			end

			return true
		end,
		rollback = removeIntent,
		expireIntent = function(p2, p3): boolean
			local intent = signal(false).intentsByCommentId[p2]

			if flag or intent == nil or intent.generation ~= p3 then
				return false
			end

			if flag then
				return true
			end

			local v8 = signal(false)

			local clone = table.clone(v8.intentsByCommentId)
			clone[p2] = nil
			v5({
				intentsByCommentId = clone,
				globalRestriction = v8.globalRestriction,
				feedRestrictionsByFeedItemId = v8.feedRestrictionsByFeedItemId,
				commentRestrictionsByCommentId = v8.commentRestrictionsByCommentId,
				cooldownUntilMs = v8.cooldownUntilMs
			})

			return true
		end,
		reconcile = function(p2, p3, p4, p5)
			if p4 == nil then
				return false
			end

			local v7 = false
			local function fn(data)
				local clone = table.clone(data.commentRestrictionsByCommentId)
				local v8 = clone[p3]

				if v8 ~= nil and v8.feedItemId == p2 and p5 >= v8.generation then
					clone[p3] = nil
				end

				local intent = data.intentsByCommentId[p3]
				local clone2 = table.clone(data.intentsByCommentId)

				if intent ~= nil then
					local v9 = p4
					local desiredEmoteId = intent.desiredEmoteId
					local v10 = if not (v9 == nil or v9.userReaction == nil) then v9.userReaction.emoteId else nil

					if v10 == desiredEmoteId then
						clone2[p3] = nil
						v7 = true
					elseif p5 >= intent.generation then
						local clone3 = table.clone(intent)

						local v11 = p4
						local emoteId = if not (v11 == nil or v11.userReaction == nil) then v11.userReaction.emoteId else nil

						local desiredEmoteId2 = intent.desiredEmoteId
						local v12 = {}

						if emoteId ~= nil and emoteId ~= desiredEmoteId2 then
							v12[emoteId] = -1
						end

						if desiredEmoteId2 ~= nil and desiredEmoteId2 ~= emoteId then
							v12[desiredEmoteId2] = (v12[desiredEmoteId2] or 0) + 1
						end

						clone3.countDeltas = v12

						if intent.rollbackState ~= nil then
							local v13 = {
								desiredEmoteId = intent.rollbackState.desiredEmoteId,
								countDeltas = 0
							}

							local v14 = p4
							local emoteId2 = if not (v14 == nil or v14.userReaction == nil) then v14.userReaction.emoteId else nil

							local desiredEmoteId3 = intent.rollbackState.desiredEmoteId
							local v15 = {}

							if emoteId2 ~= nil and emoteId2 ~= desiredEmoteId3 then
								v15[emoteId2] = -1
							end

							if desiredEmoteId3 ~= nil and desiredEmoteId3 ~= emoteId2 then
								v15[desiredEmoteId3] = (v15[desiredEmoteId3] or 0) + 1
							end

							v13.countDeltas = v15
							clone3.rollbackState = v13
						end

						clone2[p3] = clone3
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
				v5(fn(signal(false)))
			end

			return v7
		end,
		setGlobalRestriction = function(p2)
			if not flag then
				local v8 = signal(false)
				v5({
					intentsByCommentId = v8.intentsByCommentId,
					globalRestriction = p2,
					feedRestrictionsByFeedItemId = v8.feedRestrictionsByFeedItemId,
					commentRestrictionsByCommentId = v8.commentRestrictionsByCommentId,
					cooldownUntilMs = v8.cooldownUntilMs
				})
			end
		end,
		setFeedRestriction = function(p2, p3)
			local function fn(data)
				local clone = table.clone(data.feedRestrictionsByFeedItemId)

				if p3 == nil then
					clone[p2] = nil
				else
					clone[p2] = p3
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
				v5(fn(signal(false)))
			end
		end,
		setCommentRestriction = function(p2, p3, p4, p5)
			local function fn(data)
				local clone = table.clone(data.commentRestrictionsByCommentId)

				if p4 == nil then
					clone[p3] = nil
				else
					clone[p3] = { feedItemId = p2, errorCode = p4, generation = p5 }
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
				v5(fn(signal(false)))
			end
		end,
		setCooldownUntilMs = function(p2)
			if not flag then
				local v8 = signal(false)
				v5({
					intentsByCommentId = v8.intentsByCommentId,
					globalRestriction = v8.globalRestriction,
					feedRestrictionsByFeedItemId = v8.feedRestrictionsByFeedItemId,
					commentRestrictionsByCommentId = v8.commentRestrictionsByCommentId,
					cooldownUntilMs = math.max(0, p2)
				})
			end
		end,
		clearComment = function(p2)
			local function fn(data)
				local clone = table.clone(data.intentsByCommentId)
				clone[p2] = nil
				local clone2 = table.clone(data.commentRestrictionsByCommentId)
				clone2[p2] = nil
				return {
					intentsByCommentId = clone,
					globalRestriction = data.globalRestriction,
					feedRestrictionsByFeedItemId = data.feedRestrictionsByFeedItemId,
					commentRestrictionsByCommentId = clone2,
					cooldownUntilMs = data.cooldownUntilMs
				}
			end

			if not flag then
				v5(fn(signal(false)))
			end
		end,
		clearFeed = function(p2)
			local function fn(data)
				local clone = table.clone(data.intentsByCommentId)

				for k, v7 in clone do
					if v7.feedItemId == p2 then
						clone[k] = nil
					end
				end

				local clone2 = table.clone(data.feedRestrictionsByFeedItemId)
				clone2[p2] = nil
				local clone3 = table.clone(data.commentRestrictionsByCommentId)

				for k, v7 in clone3 do
					if v7.feedItemId == p2 then
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
				v5(fn(signal(false)))
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
