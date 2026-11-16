local MomentsTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local hardcodedMomentsEmojis = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/hardcodedMomentsEmojis")
local resolveEmoteId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/resolveEmoteId")
local resolveMomentsEmojiCatalog = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/resolveMomentsEmojiCatalog")
local FFlagMomentsEmojiSetsApi = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/FFlagMomentsEmojiSetsApi")

local set = {}

for k, v5 in MomentsTypes.Enums.ReactionType do
	set[v5] = true
end

local function isValidReactionType(p2): boolean
	return set[p2] == true or set[resolveEmoteId.normalizeName(p2)] == true
end

local function asReactionType(p2)
	local name = resolveEmoteId.normalizeName(p2)

	if set[name] then
		return name
	end

	return nil
end

local function convertReactionCountsArray(reaction_counts, p2)
	local counts = {}
	local v5 = nil
	local flag = false

	for k, item in reaction_counts do
		if type(item) ~= "table" then
			continue
		end

		local count = item.count

		if type(count) ~= "number" or count <= 0 then
			continue
		end

		local v6

		if type(item.name) == "string" then
			local name = item.name
			v6 = resolveEmoteId.normalizeName(name)

			if not set[v6] then
				v6 = nil
			end
		end

		if v6 == nil then
			local emote_id = item.emote_id or item.emoteId

			if type(emote_id) == "string" then
				local reactionTypeForEmoteId = resolveEmoteId.reactionTypeForEmoteId(p2, emote_id)

				if reactionTypeForEmoteId ~= nil then
					v6 = resolveEmoteId.normalizeName(reactionTypeForEmoteId)

					if not set[v6] then
						v6 = nil
					end
				end
			end
		end

		if v6 == nil then
			continue
		end

		counts[v6] = count
		flag = true

		local v7 = item.has_user_reacted

		if v7 == nil then
			v7 = item.hasUserReacted
		end

		if v7 == true then
			v5 = v6
		end
	end

	if v5 ~= nil then
		counts.userReaction = v5
		flag = true
	end

	if flag then
		return counts
	end

	return nil
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
				if set[k] == true or set[resolveEmoteId.normalizeName(k)] == true then
					local name = resolveEmoteId.normalizeName(k)

					if not set[name] then
						name = nil
					end

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
			local name = resolveEmoteId.normalizeName(userReaction)

			if not set[name] then
				name = nil
			end

			if name ~= nil then
				counts.userReaction = name
				flag = true
			end
		elseif set[userReaction] then
			counts.userReaction = userReaction
			flag = true
		end
	end

	if flag then
		return counts
	end

	return nil
end

local function convertApiReactions(p2, p3)
	if type(p2) ~= "table" then
		return nil
	end

	if FFlagMomentsEmojiSetsApi then
		local reaction_counts = p2.reaction_counts or p2.reactionCounts

		if type(reaction_counts) == "table" then
			local v5 = convertReactionCountsArray(reaction_counts, p3)

			if v5 ~= nil then
				return v5
			end
		end
	end

	return convertLegacyApiReactions(p2)
end

local function extractReactionsByMomentId(items)
	local reactionsByMomentId = {}

	local v5 = if FFlagMomentsEmojiSetsApi then resolveMomentsEmojiCatalog.resolveMomentsEmojiCatalog(nil).emojis else hardcodedMomentsEmojis

	if items == nil then
		return reactionsByMomentId
	end

	for k, item in items do
		local entityId = item.entityId or item.id

		if entityId == nil then
			continue
		end

		local reactions = item.reactions
		local v6

		if type(reactions) == "table" then
			if FFlagMomentsEmojiSetsApi then
				local reaction_counts = reactions.reaction_counts or reactions.reactionCounts

				if type(reaction_counts) == "table" then
					v6 = convertReactionCountsArray(reaction_counts, v5)

					if v6 == nil then
						v6 = convertLegacyApiReactions(reactions)
					end
				else
					v6 = convertLegacyApiReactions(reactions)
				end
			else
				v6 = convertLegacyApiReactions(reactions)
			end
		end

		if v6 ~= nil then
			reactionsByMomentId[entityId] = v6
		end
	end

	return reactionsByMomentId
end

return extractReactionsByMomentId
