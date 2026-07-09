local ParentParent = script.Parent.Parent.Parent

require(ParentParent.Signals)
require(ParentParent.LeaderboardStore)

local function getSortedPlayerInstances(t1: {[any]: any}) -- line: 43
	local t2 = {}

	for _, v6 in t1 do
		for _, v8 in v6.players do
			table.insert(t2, {
				teamId = v6.teamId,
				teamOrder = v6.order(false),
				playerOrder = v8.order(false),
				playerInstance = v8
			})
		end
	end

	table.sort(t2, function(p1, p2) -- line: 57
		if p1.teamOrder == p2.teamOrder then
			return p1.playerOrder < p2.playerOrder
		end

		return p1.teamOrder < p2.teamOrder
	end)

	return t2
end

return {
	getNextPlayerInstance = function(t3: {[any]: any}, t4: {[any]: any}, p3) -- line: 68
		-- upvalues: getSortedPlayerInstances (copy)
		local v12 = getSortedPlayerInstances(t3)
		local v13 = nil

		for v14, v15 in v12 do
			if v15.playerInstance.userId ~= t4.userId then
				continue
			end

			if v15.playerInstance.object ~= t4.object then
				return v15.playerInstance
			end

			local v16 = if not (v14 - 1 > 0) then nil else v12[v14 - 1]
			local v17 = if not (v14 + 1 <= #v12) then nil else v12[v14 + 1]

			if v17 then
				v13 = if p3 ~= v17.teamId and (not not v16 and p3 == v16.teamId) then v16.playerInstance else v17.playerInstance
			elseif v16 then
				v13 = v16.playerInstance
			end
		end

		return v13
	end,
	getFirstPlayerInstance = function(t5: {[any]: any}) -- line: 104
		local v19 = nil
		local n1 = 1e999

		for _, v22 in t5 do
			if next(v22.players) then
				local v23 = v22.order(false)

				if not v19 or not (n1 < v23) then
					for _, v25 in v22.players do
						if not v19 or v25.order(false) < v19.order(false) then
							v19 = v25
							n1 = v23
						end
					end
				end
			end
		end

		return v19
	end
}
