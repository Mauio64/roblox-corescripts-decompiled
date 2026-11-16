local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local MomentsTypes = require(parent.MomentsTypes)
require(DataHydration.Moments.MomentsStoreTypes)
local hardcodedMomentsEmojis = require(DataHydration.Moments.Util.hardcodedMomentsEmojis)
local resolveEmoteId = require(DataHydration.Moments.Util.resolveEmoteId)
local resolveMomentsEmojiCatalog = require(DataHydration.Moments.Util.resolveMomentsEmojiCatalog)
local FFlagMomentsEmojiSetsApi = require(DataHydration.Moments.FFlagMomentsEmojiSetsApi)

local set = {}

for _, v in MomentsTypes.Enums.ReactionType do
	set[v] = true
end

local function isValidReactionType(k: string): boolean -- 1 equivalent call inferred from this helper
	return set[k] == true or set[resolveEmoteId.normalizeName(k)] == true
end

local function asReactionType(p: string) -- 2 equivalent calls inferred from this helper
	local name = resolveEmoteId.normalizeName(p)
	return if set[name] then name else nil
end

local function convertReactionCountsArray(reaction_counts, p)
	local counts = {}
	local userReaction = nil
	local flag = false

	for _, item in reaction_counts do
		if type(item) ~= "table" then
			continue
		end

		local count = item.count

		if type(count) ~= "number" or count <= 0 then
			continue
		end

		local v

		if type(item.name) == "string" then
			local name = item.name
			v = resolveEmoteId.normalizeName(name)

			if not set[v] then
				v = nil
			end
		end

		if v == nil then
			local emote_id = item.emote_id or item.emoteId

			if type(emote_id) == "string" then
				local reactionTypeForEmoteId = resolveEmoteId.reactionTypeForEmoteId(p, emote_id)

				if reactionTypeForEmoteId ~= nil then
					v = resolveEmoteId.normalizeName(reactionTypeForEmoteId)

					if not set[v] then
						v = nil
					end
				end
			end
		end

		if v == nil then
			continue
		end

		counts[v] = count
		flag = true

		local v2 = item.has_user_reacted

		if v2 == nil then
			v2 = item.hasUserReacted
		end

		if v2 == true then
			userReaction = v
		end
	end

	if userReaction ~= nil then
		counts.userReaction = userReaction
		flag = true
	end

	return if flag then counts else nil
end

local function convertLegacyApiReactions(data)
	local counts = {}
	local flag = false

	local counts2 = data.counts

	if type(counts2) == "table" then
		for k, count in counts2 do
			if not (type(k) == "string" and type(count) == "number" and count > 0) then
				continue
			end

			if FFlagMomentsEmojiSetsApi then
				if isValidReactionType(k) then -- inferred equivalent call
					local name = asReactionType(k) -- inferred equivalent call

					if name ~= nil then
						counts[name] = count
						flag = true
					end
				end
			elseif set[k] then
				counts[k] = count
				flag = true
			end
		end
	end

	local userReaction = data.userReaction or data.viewerReaction

	if type(userReaction) == "string" then
		if FFlagMomentsEmojiSetsApi then
			local userReaction2 = asReactionType(userReaction) -- inferred equivalent call

			if userReaction2 ~= nil then
				counts.userReaction = userReaction2
				flag = true
			end
		elseif set[userReaction] then
			counts.userReaction = userReaction
			flag = true
		end
	end

	return if flag then counts else nil
end

local function convertApiReactions(reactions, p) -- 1 equivalent call inferred from this helper
	if type(reactions) ~= "table" then
		return nil
	end

	if FFlagMomentsEmojiSetsApi then
		local reaction_counts = reactions.reaction_counts or reactions.reactionCounts

		if type(reaction_counts) == "table" then
			local v = convertReactionCountsArray(reaction_counts, p)

			if v ~= nil then
				return v
			end
		end
	end

	return convertLegacyApiReactions(reactions)
end

local function extractReactionsByMomentId(items)
	local reactionsByMomentId = {}
	local v

	if FFlagMomentsEmojiSetsApi then
		v = resolveMomentsEmojiCatalog.resolveMomentsEmojiCatalog(nil).emojis
	else
		v = hardcodedMomentsEmojis
	end

	if items == nil then
		return reactionsByMomentId
	end

	for _, item in items do
		local entityId = item.entityId or item.id

		if entityId == nil then
			continue
		end

		local v2 = convertApiReactions(item.reactions, v) -- inferred equivalent call

		if v2 ~= nil then
			reactionsByMomentId[entityId] = v2
		end
	end

	return reactionsByMomentId
end

return extractReactionsByMomentId
