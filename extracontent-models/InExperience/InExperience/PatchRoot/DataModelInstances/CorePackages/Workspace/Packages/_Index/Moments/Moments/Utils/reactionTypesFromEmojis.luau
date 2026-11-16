local parent = script:FindFirstAncestor("Moments").Parent

local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)

local ReactionType = MomentsCommon.Enums.ReactionType
local defineFastFlag = game:DefineFastFlag("MomentsUpdateReactionTrayOrder", false)

local set = {
	[ReactionType.ThumbsUp] = true,
	[ReactionType.Heart] = true,
	[ReactionType.LaughJoy] = true,
	[ReactionType.Wow] = true,
	[ReactionType.Cry] = true,
	[ReactionType.Fire] = true,
	[ReactionType.Skull] = true
}

local v = {
	ReactionType.ThumbsUp,
	ReactionType.Heart,
	ReactionType.LaughJoy,
	ReactionType.Wow,
	ReactionType.Cry,
	ReactionType.Fire,
	ReactionType.Skull
}

local function normalizeEmojiName(name: string) -- 1 equivalent call inferred from this helper
	local v2 = string.gsub(string.lower(name), "%-", "")
	return if v2 == "crying" then "cry" else v2
end

return {
	reactionTypesFromEmojis = function(items)
		local result = {}

		local emojiNameSet = {}

		for _, item in items do
			local emojiName = normalizeEmojiName(item.name) -- inferred equivalent call

			if not set[emojiName] then
				continue
			end

			table.insert(result, emojiName)
			emojiNameSet[emojiName] = true
		end

		if defineFastFlag then
			result = {}

			for _, v2 in v do
				if emojiNameSet[v2] then
					table.insert(result, v2)
				end
			end
		end

		return if #result == 0 then v else result
	end,
	PICKER_REACTION_ORDER = v
}
