local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local EmojiList = require(parent.EmojiList)

require(script.Parent.Parent.AutocompleteTypes)
local internalProviders = require(ChatUIPrimitives.Components.ChatInputBar.Autocomplete.internalProviders)
local utf8Range = require(script.Parent.Parent.utf8Range)

local function isWordBoundary(charAt: string): boolean -- 1 equivalent call inferred from this helper
	return charAt == " " or charAt == "\n"
end

local function matchEmojiTrigger(p: string, p2: number)
	local v = utf8.len(p)

	if v == nil or p2 < 2 or v + 1 < p2 then
		return nil
	end

	local v2 = 1

	for i = p2 - 1, 1, -1 do
		local charAt = utf8Range.charAt(p, i)

		if charAt == nil then
			return nil
		end

		if isWordBoundary(charAt) then -- inferred equivalent call
			v2 = i + 1
			break
		end
	end

	local function matchFrom(replaceStart: number) -- 2 equivalent calls inferred from this helper
		if p2 - replaceStart < 3 then
			return nil
		end

		local slice = utf8Range.slice(p, replaceStart, p2 - 1)

		if slice == nil then
			return nil
		end

		return {
			query = slice,
			replaceStart = replaceStart,
			replaceFinish = p2 - 1
		}
	end

	local charAt = utf8Range.charAt(p, v2)

	if charAt == nil then
		return nil
	end

	if charAt == ":" then
		return matchFrom(v2) -- inferred equivalent call
	else
		local v3 = nil

		for i = p2 - 1, v2, -1 do
			if utf8Range.charAt(p, i) == ":" then
				v3 = i
				break
			end
		end

		if v3 == nil then
			return nil
		end

		return matchFrom(v3) -- inferred equivalent call
	end
end

local function matchEmojiCompletion(p: string, p2: number)
	local v = utf8.len(p)

	if v == nil or p2 - 1 < 3 or v < p2 - 1 or utf8Range.charAt(p, p2 - 1) ~= ":" then
		return nil
	end

	local slice = utf8Range.slice(p, 1, p2 - 1)

	if slice == nil then
		return nil
	end

	local v2, _, v3 = string.find(slice, ":([^:%s]+):$")

	if v3 == nil or v2 == nil then
		return nil
	end

	local emoji = EmojiList[string.lower(v3)]

	if emoji == nil then
		return nil
	end

	local v4 = utf8.len((string.sub(slice, 1, v2 - 1)))

	if v4 == nil then
		return nil
	end

	return {
		replacement = emoji.base,
		replaceStart = v4 + 1,
		replaceFinish = p2 - 1
	}
end

local function compareEmojiPopularity(value: string, value2: string): boolean
	local popularity = EmojiList[string.sub(value, 2)].popularity
	local popularity2 = EmojiList[string.sub(value2, 2)].popularity

	if popularity == popularity2 then
		return value < value2
	end

	return popularity < popularity2
end

local function searchEmojis(p: string)
	return internalProviders.searchSortedArray(internalProviders.getEmojiStructure(), p, compareEmojiPopularity)
end

local function selectEmoji(text: string)
	local emoji = EmojiList[string.sub(text, 2)]

	if emoji ~= nil then
		text = emoji.base
	end

	return { kind = "insert", text = text }
end

local function renderEmojiEntry(value: string, _: boolean)
	local text = string.sub(value, 2)
	local emoji = EmojiList[text]
	return React.createElement(Foundation.View, { tag = "row align-y-center gap-large size-full" }, {
		glyph = React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-medium content-emphasis",
			Text = not emoji and "" or emoji.base,
			LayoutOrder = 1
		}),
		name = React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-medium content-emphasis",
			Text = text,
			LayoutOrder = 2
		})
	})
end

local function emoji(p)
	local v = type(p.id) == "string" and p.id ~= ""
	assert(v, "AutocompleteSources.emoji requires an id")
	return {
		id = p.id,
		matchTrigger = matchEmojiTrigger,
		search = searchEmojis,
		select = selectEmoji,
		renderEntry = renderEmojiEntry,
		matchCompletion = matchEmojiCompletion
	}
end

return emoji
