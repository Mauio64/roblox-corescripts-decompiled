local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

local reactionType = MomentsCommon.Enums.ReactionType
local defineFastFlag = game:DefineFastFlag("MomentsUpdateReactionTrayOrder", false)

local set = {
	[reactionType.ThumbsUp] = true,
	[reactionType.Heart] = true,
	[reactionType.LaughJoy] = true,
	[reactionType.Wow] = true,
	[reactionType.Cry] = true,
	[reactionType.Fire] = true,
	[reactionType.Skull] = true
}

local v5 = {
	reactionType.ThumbsUp,
	reactionType.Heart,
	reactionType.LaughJoy,
	reactionType.Wow,
	reactionType.Cry,
	reactionType.Fire,
	reactionType.Skull
}

local function normalizeEmojiName(value)
	local v6 = string.gsub(string.lower(value), "%-", "")

	if v6 == "crying" then
		return "cry"
	end

	return v6
end

return {
	reactionTypesFromEmojis = function(items)
		local result = {}

		local set2 = {}

		for k, item in items do
			local name = item.name
			local v6 = string.gsub(string.lower(name), "%-", "")
			local v7 = v6 == "crying" and "cry" or v6

			if not set[v7] then
				continue
			end

			table.insert(result, v7)
			set2[v7] = true
		end

		if defineFastFlag then
			result = {}

			for k, v6 in v5 do
				if set2[v6] then
					table.insert(result, v6)
				end
			end
		end

		if #result == 0 then
			return v5
		end

		return result
	end,
	PICKER_REACTION_ORDER = v5
}
