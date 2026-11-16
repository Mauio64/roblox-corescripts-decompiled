local parent = script.Parent.Parent.Parent

require(parent.Signals)

require(parent.LeaderboardStore)

local function getSortedPlayerInstances(items)
	local sortedPlayerInstances = {}

	for _, item in items do
		for _, player in item.players do
			table.insert(sortedPlayerInstances, {
				teamId = item.teamId,
				teamOrder = item.order(false),
				playerOrder = player.order(false),
				playerInstance = player
			})
		end
	end

	table.sort(sortedPlayerInstances, function(a, b): boolean
		if a.teamOrder == b.teamOrder then
			return a.playerOrder < b.playerOrder
		end

		return a.teamOrder < b.teamOrder
	end)

	return sortedPlayerInstances
end

local FocusNavHelper = {}

function FocusNavHelper.getNextPlayerInstance(p, p2, p3)
	local sortedPlayerInstances = getSortedPlayerInstances(p)
	local playerInstance = nil

	for k, sortedPlayerInstance in sortedPlayerInstances do
		if sortedPlayerInstance.playerInstance.userId ~= p2.userId then
			continue
		end

		if sortedPlayerInstance.playerInstance.object ~= p2.object then
			return sortedPlayerInstance.playerInstance
		end

		local v

		if k - 1 > 0 then
			v = sortedPlayerInstances[k - 1]
		end

		local v2

		if k + 1 <= #sortedPlayerInstances then
			v2 = sortedPlayerInstances[k + 1]
		end

		if v2 then
			if v2.teamId == p3 or not v or v.teamId ~= p3 then
				playerInstance = v2.playerInstance
			else
				playerInstance = v.playerInstance
			end
		elseif v then
			playerInstance = v.playerInstance
		end
	end

	return playerInstance
end

function FocusNavHelper.getFirstPlayerInstance(items)
	local firstPlayerInstance = nil
	local v = 1e999

	for _, item in items do
		if not next(item.players) then
			continue
		end

		local order = item.order(false)

		if firstPlayerInstance and v < order then
			continue
		end

		for _, player in item.players do
			if not (not firstPlayerInstance or player.order(false) < firstPlayerInstance.order(false)) then
				continue
			end

			v = order
			firstPlayerInstance = player
		end
	end

	return firstPlayerInstance
end

return FocusNavHelper
