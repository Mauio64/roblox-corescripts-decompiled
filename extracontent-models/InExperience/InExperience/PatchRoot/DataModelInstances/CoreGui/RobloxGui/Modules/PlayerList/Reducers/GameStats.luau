local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local parent = script.Parent.Parent
local actions = parent.Actions
local AddGameStat = require(actions.AddGameStat)
local RemoveGameStat = require(actions.RemoveGameStat)
local SetGameStatText = require(actions.SetGameStatText)
local SetGameStatAddId = require(actions.SetGameStatAddId)

local FFlagLeaderstatsWithASideOfClient = require(parent.Flags.FFlagLeaderstatsWithASideOfClient)

local FormatStatString = require(parent.FormatStatString)

local function gameStatsComp(data, data2)
	if data.isPrimary ~= data2.isPrimary then
		return data.isPrimary
	end

	if data.priority ~= data2.priority then
		return data.priority > data2.priority
	end

	if not FFlagLeaderstatsWithASideOfClient then
		return data.addId < data2.addId
	end

	local serverAddId = data.serverAddId
	local serverAddId2 = data2.serverAddId

	if serverAddId and serverAddId2 then
		return serverAddId < serverAddId2
	end

	return data.addId < data2.addId
end

local count = 0

local function GameStats(options, data)
	local selected = options or {}

	if data.type == AddGameStat.name then
		local text = FormatStatString(nil)
		local v = {}
		local addId = nil
		local serverAddId = nil

		for _, v2 in ipairs(selected) do
			if v2.name == data.statName then
				addId = v2.addId
				text = v2.text

				if FFlagLeaderstatsWithASideOfClient then
					serverAddId = v2.serverAddId
				end
			else
				table.insert(v, v2)
			end
		end

		count += 1
		local joined = Cryo.List.join(v, {
			{
				name = data.statName,
				text = text,
				addId = addId or count,
				isPrimary = data.isPrimary,
				priority = data.priority,
				serverAddId = serverAddId
			}
		})

		table.sort(joined, gameStatsComp)
		return joined
	else
		if data.type == RemoveGameStat.name then
			return Cryo.List.filter(selected, function(p): boolean
				return p.name ~= data.statName
			end)
		end

		if data.type == SetGameStatText.name then
			return Cryo.List.map(selected, function(p)
				return p.name == data.statName and Cryo.Dictionary.join(p, { text = data.text }) or p
			end)
		end

		if not FFlagLeaderstatsWithASideOfClient or data.type ~= SetGameStatAddId.name then
			return selected
		end

		local mapped = Cryo.List.map(selected, function(p)
			return p.name == data.statName and Cryo.Dictionary.join(p, {
				serverAddId = data.serverAddId
			}) or p
		end)

		table.sort(mapped, gameStatsComp)
		return mapped
	end
end

return GameStats
