local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Cryo = require(parent.Cryo)
local EmojiList = require(parent.EmojiList)

local Trie = require(script.Parent.Trie)

local function buildUnifiedTrie(items, flag: boolean?)
	local unifiedTrie = Trie.new()

	if items then
		for _, item in items do
			unifiedTrie:insert(item:lower())
		end
	end

	if flag then
		for _, v in Cryo.Dictionary.keys(EmojiList) do
			unifiedTrie:insert(":" .. v)
		end
	end

	return unifiedTrie
end

local function buildEmojiArray()
	local emojiArray = {}

	for _, v in Cryo.Dictionary.keys(EmojiList) do
		table.insert(emojiArray, ":" .. v)
	end

	table.sort(emojiArray)
	return emojiArray
end

local emojiStructure = nil

local function searchSortedArray(emoji, value: string, compareEmojiPopularity)
	local lower = value:lower()
	local v = #lower

	local v2 = #emoji + 1
	local v3 = 1

	while v3 < v2 do
		local v4 = (v3 + v2) // 2

		if emoji[v4] < lower then
			v3 = v4 + 1
		else
			v2 = v4
		end
	end

	local sortedArray = {}

	for i = v3, #emoji do
		local item = emoji[i]

		if string.sub(item, 1, v) ~= lower then
			break
		end

		table.insert(sortedArray, item)
	end

	if compareEmojiPopularity then
		table.sort(sortedArray, compareEmojiPopularity)
	end

	return sortedArray
end

local function compareEmojiPopularity(value: string, value2: string): boolean
	local popularity = EmojiList[string.sub(value, 2)].popularity
	local popularity2 = EmojiList[string.sub(value2, 2)].popularity

	if popularity == popularity2 then
		return value < value2
	end

	return popularity < popularity2
end

local InternalProviders = {}
InternalProviders.buildTrie = buildUnifiedTrie
InternalProviders.buildEmojiArray = buildEmojiArray

function InternalProviders.buildCommandTrie(items)
	local commandTrie = Trie.new()

	for _, item in items do
		commandTrie:insert(item:lower())
	end

	return commandTrie
end

function InternalProviders.getEmojiStructure()
	if not emojiStructure then
		emojiStructure = buildEmojiArray()
	end

	return emojiStructure
end

function InternalProviders.matchTrigger(value: string, p: number)
	if p < 2 then
		return nil
	end

	local replaceStart = 1

	for i = p - 1, 1, -1 do
		local v = string.sub(value, i, i)

		if v == " " or v == "\n" then
			replaceStart = i + 1
			break
		end
	end

	local v = string.sub(value, replaceStart, replaceStart)

	if v == "/" then
		if replaceStart == 1 then
			return {
				query = string.sub(value, 1, p - 1),
				replaceStart = 1,
				replaceFinish = p - 1
			}
		end

		return nil
	elseif v == ":" then
		if p - replaceStart < 3 then
			return nil
		end

		return {
			query = string.sub(value, replaceStart, p - 1),
			replaceStart = replaceStart,
			replaceFinish = p - 1
		}
	else
		local v2 = nil

		for i = p - 1, replaceStart, -1 do
			if string.sub(value, i, i) == ":" then
				v2 = i
				break
			end
		end

		if not v2 or p - v2 < 3 then
			return nil
		end

		replaceStart = v2
		return {
			query = string.sub(value, replaceStart, p - 1),
			replaceStart = replaceStart,
			replaceFinish = p - 1
		}
	end
end

function InternalProviders.matchColonCompletion(value: string, p: number)
	if p - 1 < 3 or string.sub(value, p - 1, p - 1) ~= ":" then
		return nil
	end

	local v = string.sub(value, 1, p - 1)
	local replaceStart, _, v2 = string.find(v, ":([^:%s]+):$")

	if not v2 then
		return nil
	end

	local emoji = EmojiList[string.lower(v2)]

	if emoji then
		return {
			replacement = emoji.base,
			replaceStart = replaceStart,
			replaceFinish = p - 1
		}
	end

	return nil
end

function InternalProviders.search(object, value: string)
	local autocomplete = object:autocomplete(value:lower())
	table.sort(autocomplete, function(a: string, b: string): boolean
		local v = string.sub(a, 1, 1) == ":"
		local v2 = string.sub(b, 1, 1) == ":"

		if not (v and v2) then
			return a < b
		end

		local popularity = EmojiList[string.sub(a, 2)].popularity
		local popularity2 = EmojiList[string.sub(b, 2)].popularity

		if popularity == popularity2 then
			return a < b
		end

		return popularity < popularity2
	end)

	return autocomplete
end

InternalProviders.searchSortedArray = searchSortedArray

function InternalProviders.searchStructures(p, value: string)
	if string.sub(value, 1, 1) == ":" then
		if p.emoji then
			return searchSortedArray(p.emoji, value, compareEmojiPopularity)
		end

		return {}
	else
		if not p.command then
			return {}
		end

		local autocomplete = p.command:autocomplete(value:lower())
		table.sort(autocomplete, function(a: string, b: string): boolean
			local v = string.sub(a, 1, 1) == ":"
			local v2 = string.sub(b, 1, 1) == ":"

			if not (v and v2) then
				return a < b
			end

			local popularity = EmojiList[string.sub(a, 2)].popularity
			local popularity2 = EmojiList[string.sub(b, 2)].popularity

			if popularity == popularity2 then
				return a < b
			end

			return popularity < popularity2
		end)

		return autocomplete
	end
end

function InternalProviders.formatReplacement(value: string)
	if string.sub(value, 1, 1) == ":" then
		return EmojiList[string.sub(value, 2)].base
	end

	return value
end

function InternalProviders.renderEntry(text: string, _: boolean)
	if string.sub(text, 1, 1) ~= ":" then
		return React.createElement(Foundation.Text, {
			tag = "text-body-medium text-align-x-left content-emphasis",
			Text = text,
			Size = UDim2.fromScale(1, 1)
		})
	end

	local text2 = string.sub(text, 2)
	local emoji = EmojiList[text2]
	return React.createElement(
		Foundation.View,
		{ tag = "row align-y-center gap-large", Size = UDim2.fromScale(1, 1) },
		{
			glyph = React.createElement(Foundation.Text, {
				tag = "auto-xy text-body-medium content-emphasis",
				Text = not emoji and "" or emoji.base,
				LayoutOrder = 1
			}),
			name = React.createElement(Foundation.Text, {
				tag = "auto-xy text-body-medium content-emphasis",
				Text = text2,
				LayoutOrder = 2
			})
		}
	)
end

return InternalProviders
