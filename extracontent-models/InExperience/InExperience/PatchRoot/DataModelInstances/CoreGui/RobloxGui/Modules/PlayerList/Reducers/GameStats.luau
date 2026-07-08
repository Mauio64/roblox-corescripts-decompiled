local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local ParentParent = script.Parent.Parent
local Actions = ParentParent.Actions
local AddGameStat = require(Actions.AddGameStat)
local RemoveGameStat = require(Actions.RemoveGameStat)
local SetGameStatText = require(Actions.SetGameStatText)
local SetGameStatAddId = require(Actions.SetGameStatAddId)
local FFlagLeaderstatsWithASideOfClient = require(ParentParent.Flags.FFlagLeaderstatsWithASideOfClient)
local FormatStatString = require(ParentParent.FormatStatString)

local function gameStatsComp(p1, p2) -- line: 17
	-- upvalues: FFlagLeaderstatsWithASideOfClient (copy)
	if p1.isPrimary ~= p2.isPrimary then
		return p1.isPrimary
	end

	if p1.priority == p2.priority then
		if FFlagLeaderstatsWithASideOfClient then
			local serverAddId = p1.serverAddId
			local serverAddId2 = p2.serverAddId

			if serverAddId and serverAddId2 then
				return serverAddId < serverAddId2
			end
		end

		return p1.addId < p2.addId
	end

	return p1.priority > p2.priority
end

local n1 = 0

local function GameStats(p3, p4) -- line: 35
	-- upvalues: AddGameStat (copy), FormatStatString (copy), FFlagLeaderstatsWithASideOfClient (copy), n1 (ref), Cryo (copy), gameStatsComp (copy), RemoveGameStat (copy), SetGameStatText (copy), SetGameStatAddId (copy)
	local v20 = p3 or {}

	if p4.type == AddGameStat.name then
		local addId = nil
		local serverAddId = nil
		local v23 = FormatStatString(nil)
		local t1 = {}

		for _, v in ipairs(v20) do
			if v.name == p4.statName then
				addId = v.addId
				v23 = v.text

				if FFlagLeaderstatsWithASideOfClient then
					serverAddId = v.serverAddId
				end
			else
				table.insert(t1, v)
			end
		end

		n1 += 1

		local v27 = Cryo.List.join(t1, {{
			name = p4.statName,
			text = v23,
			addId = addId or n1,
			isPrimary = p4.isPrimary,
			priority = p4.priority,
			serverAddId = serverAddId
		}})

		table.sort(v27, gameStatsComp)

		return v27
	end

	if p4.type == RemoveGameStat.name then
		return Cryo.List.filter(v20, function(p5) -- line: 68
			-- upvalues: p4 (copy)
			return p5.name ~= p4.statName
		end)
	end

	if p4.type == SetGameStatText.name then
		return Cryo.List.map(v20, function(p6) -- line: 72
			-- upvalues: p4 (copy), Cryo (copy)
			return p6.name == p4.statName and Cryo.Dictionary.join(p6, {
				text = p4.text
			}) or p6
		end)
	end

	if FFlagLeaderstatsWithASideOfClient and p4.type == SetGameStatAddId.name then
		local v28 = Cryo.List.map(v20, function(p7) -- line: 76
			-- upvalues: p4 (copy), Cryo (copy)
			return p7.name == p4.statName and Cryo.Dictionary.join(p7, {
				serverAddId = p4.serverAddId
			}) or p7
		end)

		table.sort(v28, gameStatsComp)

		return v28
	end

	return v20
end

return GameStats
