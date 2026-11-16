local parent = script:FindFirstAncestor("ExpChat").Parent

local EmojiList = require(parent.EmojiList)

local defineFastString = game:DefineFastString("ExpChatLargerSingularEmojiBlacklist", "")

local v = utf8.char(65039)

local function stripPresentationSelectors(value: string) -- 2 equivalent calls inferred from this helper
	return (string.gsub(value, v, ""))
end

local function getBlacklistedEmojiNames() -- 1 equivalent call inferred from this helper
	local blacklistedEmojiNames = {}

	for k in string.gmatch(defineFastString, "[^,%s]+") do
		blacklistedEmojiNames[k] = true
	end

	return blacklistedEmojiNames
end

local supportedEmojis = nil

local function getSupportedEmojis()
	if supportedEmojis then
		return supportedEmojis
	end

	local blacklistedEmojiNames = getBlacklistedEmojiNames() -- inferred equivalent call
	local set = {}

	for k, emoji in EmojiList do
		if not blacklistedEmojiNames[k] then
			set[stripPresentationSelectors(emoji.base)] = true -- inferred equivalent call
		end
	end

	supportedEmojis = set

	return supportedEmojis
end

local function isSingleSupportedEmoji(value: string): boolean
	local v2 = string.match(value, "^%s*(.-)%s*$")
	return getSupportedEmojis()[stripPresentationSelectors(v2)] == true -- inferred equivalent call
end

return isSingleSupportedEmoji
