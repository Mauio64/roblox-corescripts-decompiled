local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Signals = require(parent.Signals)

require(script.Parent.Parent.AutocompleteTypes)
require(ChatUIPrimitives.UniversalMessage.Types)
require(ChatUIPrimitives.createExpressionCatalogResource)
local escapeRichText = require(ChatUIPrimitives.Utils.escapeRichText)
local getPresetIconRichText = require(ChatUIPrimitives.universal.ContentKinds.Preset.getPresetIconRichText)
local messageDraftFromExpressionContent = require(ChatUIPrimitives.universal.messageDraftFromExpressionContent)

local function resolveMinQueryLength(searchVariant) -- 1 equivalent call inferred from this helper
	local minQueryLength

	if searchVariant ~= nil then
		minQueryLength = searchVariant.minQueryLength
	end

	if type(minQueryLength) == "number" and minQueryLength > 0 then
		return minQueryLength
	end

	return 2
end

local function getWordStartRank(lowerText: string, p: string): nil | number
	local v = string.find(lowerText, p, 1, true)

	while v ~= nil do
		if v == 1 then
			return 1
		end

		if string.match(string.sub(lowerText, v - 1, v - 1), "%w") == nil then
			return 2
		end

		v = string.find(lowerText, p, v + 1, true)
	end

	return nil
end

local function presetText(p) -- 2 equivalent calls inferred from this helper
	local content = p.content
	return if content.kind == "preset" then content.text else nil
end

local function buildIndex(p)
	if p == nil or p.status ~= "enabled" then
		return {}
	end

	local count = 0
	local set = {}
	local result = {}

	for _, categoryGroup in p.categoryGroups do
		for _, category in categoryGroup.categories do
			for _, item in category.items do
				count += 1
				local v = presetText(item) -- inferred equivalent call

				if not (v ~= nil and v ~= "" and set[v] ~= true) then
					continue
				end

				set[v] = true
				table.insert(result, {
					expressionItem = item,
					catalogIndex = count,
					lowerText = string.lower(v)
				})
			end
		end
	end

	return result
end

local function presetDisplayText(p) -- 1 equivalent call inferred from this helper
	local selected = presetText(p.expressionItem) -- inferred equivalent call
	return if selected == nil then "" else selected
end

local function selectPreset(p)
	local draft = messageDraftFromExpressionContent(p.expressionItem.content)

	if draft == nil then
		return nil
	end

	return { kind = "sendDraft", draft = draft }
end

local function PresetAutocompleteEntry(p)
	local presetIconRichText = getPresetIconRichText(Foundation.Hooks.useTokens().Typography.BodyMedium.FontSize)
	return React.createElement(Foundation.View, { tag = "row align-y-center size-full" }, {
		label = React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-medium content-emphasis",
			Text = `{escapeRichText(p.text)} {presetIconRichText}`,
			RichText = true,
			LayoutOrder = 1
		})
	})
end

local function renderPresetEntry(p, _: boolean)
	return React.createElement(PresetAutocompleteEntry, { text = presetDisplayText(p) }) -- inferred equivalent call
end

local function presetChat(data)
	local v = type(data.id) == "string" and data.id ~= ""
	assert(v, "AutocompleteSources.presetChat requires an id")
	assert(type(data.catalogResource) == "table", "AutocompleteSources.presetChat requires a catalogResource")
	assert(type(data.getIsAvailable) == "function", "AutocompleteSources.presetChat requires getIsAvailable")

	local catalogResource = data.catalogResource
	local getIsAvailable = data.getIsAvailable
	local minQueryLength = resolveMinQueryLength(data.searchVariant) -- inferred equivalent call

	local v2 = false
	local v3 = false
	local v4 = nil
	local v5 = {}

	local function updateIndex(p) -- 1 equivalent call inferred from this helper
		if v3 and v4 == p then
			return
		end

		v3 = true
		v4 = p
		v5 = buildIndex(p)
	end

	local function search(value: string)
		if not v2 then
			return {}
		end

		local v6 = string.lower(value)
		local v7 = {}

		for _, entry in v5 do
			local wordStartRank = getWordStartRank(entry.lowerText, v6)

			if wordStartRank ~= nil then
				table.insert(v7, { rank = wordStartRank, entry = entry })
			end
		end

		table.sort(v7, function(a, b): boolean
			if a.rank == b.rank then
				return a.entry.catalogIndex < b.entry.catalogIndex
			end

			return a.rank < b.rank
		end)

		local result = table.create(#v7)

		for _, v8 in v7 do
			table.insert(result, {
				expressionItem = v8.entry.expressionItem,
				catalogIndex = v8.entry.catalogIndex
			})
		end

		return result
	end

	local function subscribe(callback)
		catalogResource.acquire()
		local v6 = false
		local v7 = false
		local effect = Signals.createEffect(function(p)
			v2 = getIsAvailable(p) == true
			updateIndex(catalogResource.getCatalog(p)) -- inferred equivalent call

			if v6 or not v7 then
				v7 = true
			else
				callback()
			end
		end)
		return function()
			v6 = true
			effect()
			catalogResource.release()
		end
	end

	return {
		id = data.id,
		matchTrigger = function(query: string, p: number)
			local replaceFinish = utf8.len(query)

			if replaceFinish == nil or p ~= replaceFinish + 1 or replaceFinish < minQueryLength then
				return nil
			end

			return { query = query, replaceStart = 1, replaceFinish = replaceFinish }
		end,
		search = search,
		select = selectPreset,
		renderEntry = renderPresetEntry,
		maxResults = data.maxResults,
		subscribe = subscribe
	}
end

return presetChat
