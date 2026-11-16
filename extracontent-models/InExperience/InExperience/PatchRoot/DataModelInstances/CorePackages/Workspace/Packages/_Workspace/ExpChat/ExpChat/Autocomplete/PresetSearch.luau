local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local SharedFlags = require(parent.SharedFlags)
local EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint = SharedFlags.EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint

require(ExpChat.Stores.GetPresetChatStore.createPresetChatStore)
local Constants = require(ExpChat.PresetChat.Constants)

local searchMode = { Substring = 0, WordStart = 1 }

local v = nil
local v2 = nil

local function flatten(categoryGroups)
	local presetIds = {}
	local values = {}
	local lowerValues = {}

	for _, item in categoryGroups do
		for _, category in item.categories do
			local v3

			if EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint then
				v3 = category.contents
			else
				v3 = category.messages
			end

			for _, v4 in v3 do
				if not (not EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint or v4.kind ~= "Emoji") then
					continue
				end

				local v5

				if EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint then
					v5 = v4.text
				else
					v5 = v4.value
				end

				if presetIds[v5] ~= nil then
					continue
				end

				presetIds[v5] = v4.presetId
				table.insert(values, v5)
				table.insert(lowerValues, string.lower(v5))
			end
		end
	end

	return { values = values, lowerValues = lowerValues, presetIdByValue = presetIds }
end

local function getCatalog(data)
	if not data.getIsEnabled(false) or data.getAccessLevel(false) ~= Constants.AccessLevel.Enabled then
		return nil
	end

	local categoryGroups = data.getCategoryGroups(false)

	if v2 == nil or v ~= categoryGroups then
		v = categoryGroups
		v2 = flatten(categoryGroups)
	end

	return v2
end

local function getRank(value: string, p: string): nil | number
	local v3 = string.find(value, p, 1, true)

	if v3 == nil then
		return nil
	elseif v3 == 1 then
		return 1
	end

	if string.match(string.sub(value, v3 - 1, v3 - 1), "%w") == nil then
		return 2
	end

	return 3
end

local function getWordStartRank(value: string, p: string): nil | number
	local v3 = string.find(value, p, 1, true)

	while v3 ~= nil do
		if v3 == 1 then
			return 1
		end

		if string.match(string.sub(value, v3 - 1, v3 - 1), "%w") == nil then
			return 2
		end

		v3 = string.find(value, p, v3 + 1, true)
	end

	return nil
end

local PresetSearch = {}
PresetSearch.MIN_QUERY_LENGTH = 2
PresetSearch.SearchMode = searchMode

function PresetSearch.findMatchingPresets(p, value: string, p2)
	if (not (p2 and p2.minQueryLength) and 2 or p2.minQueryLength) > (utf8.len(value) or #value) then
		return {}
	end

	local presetCooldownEndsAt = p.getPresetCooldownEndsAt(false)

	if presetCooldownEndsAt ~= nil and os.clock() < presetCooldownEndsAt then
		return {}
	end

	local catalog = getCatalog(p)

	if catalog == nil then
		return {}
	end

	local v3 = string.lower(value)
	local v4

	if p2 and p2.mode == searchMode.WordStart then
		v4 = getWordStartRank
	else
		v4 = getRank
	end

	local v5 = {}

	for k, lowerValue in catalog.lowerValues do
		local rank = v4(lowerValue, v3)

		if rank ~= nil then
			table.insert(v5, { rank = rank, index = k })
		end
	end

	table.sort(v5, function(a, b): boolean
		if a.rank == b.rank then
			return a.index < b.index
		end

		return a.rank < b.rank
	end)

	local result = table.create(#v5)

	for _, v6 in v5 do
		table.insert(result, catalog.values[v6.index])
	end

	return result
end

function PresetSearch.getPresetIdForValue(p, p2: string)
	local catalog = getCatalog(p)

	if catalog == nil then
		return nil
	end

	return catalog.presetIdByValue[p2]
end

return PresetSearch
