local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Signals = require(parent.Signals)

require(script.Parent.Parent.AutocompleteTypes)
local utf8Range = require(script.Parent.Parent.utf8Range)

local function isWordBoundary(charAt: string): boolean -- 1 equivalent call inferred from this helper
	return charAt == " " or charAt == "\n"
end

local function matchCommandTrigger(p: string, p2: number)
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

	if v2 ~= 1 or utf8Range.charAt(p, 1) ~= "/" then
		return nil
	end

	local slice = utf8Range.slice(p, 1, p2 - 1)

	if slice == nil or slice == "" then
		return nil
	end

	return {
		query = slice,
		replaceStart = 1,
		replaceFinish = p2 - 1
	}
end

local function buildSortedAliases(getCommandSets, p)
	local set = {}
	local sortedAliases = {}

	for _, item in getCommandSets do
		for _, v in item(p) do
			if v.autocompleteVisible == false then
				continue
			end

			for _, alias in v.aliases do
				local v2 = string.lower(alias)

				if set[v2] then
					continue
				end

				set[v2] = true
				table.insert(sortedAliases, v2)
			end
		end
	end

	table.sort(sortedAliases)
	return sortedAliases
end

local function searchSortedAliases(list, value: string)
	local v = string.lower(value)
	local v2 = #v

	local v3 = #list + 1
	local v4 = 1

	while v4 < v3 do
		local v5 = (v4 + v3) // 2

		if list[v5] < v then
			v4 = v5 + 1
		else
			v3 = v5
		end
	end

	local sortedAliases = {}

	for i = v4, #list do
		local item = list[i]

		if string.sub(item, 1, v2) ~= v then
			break
		end

		table.insert(sortedAliases, item)
	end

	return sortedAliases
end

local function selectCommand(text: string)
	return { kind = "insert", text = text }
end

local function renderCommandEntry(text: string, _: boolean)
	return React.createElement(Foundation.View, { tag = "row align-y-center size-full" }, {
		alias = React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-medium content-emphasis",
			Text = text,
			LayoutOrder = 1
		})
	})
end

local function commands(data)
	local v = type(data.id) == "string" and data.id ~= ""
	assert(v, "AutocompleteSources.commands requires an id")
	assert(type(data.getCommandSets) == "table", "AutocompleteSources.commands requires getCommandSets")

	local getCommandSets = data.getCommandSets
	local v2 = {}

	local function search(p: string)
		return searchSortedAliases(v2, p)
	end

	local function subscribe(callback)
		local v3 = false
		local v4 = false
		local effect = Signals.createEffect(function(p)
			v2 = buildSortedAliases(getCommandSets, p)

			if v3 or not v4 then
				v4 = true
			else
				callback()
			end
		end)
		return function()
			v3 = true
			effect()
		end
	end

	return {
		id = data.id,
		matchTrigger = matchCommandTrigger,
		search = search,
		select = selectCommand,
		renderEntry = renderCommandEntry,
		maxResults = data.maxResults,
		subscribe = subscribe
	}
end

return commands
