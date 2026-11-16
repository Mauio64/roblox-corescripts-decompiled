local function getEventManager(p)
	local v = {}

	local function removeListener(p2, p3) -- 1 equivalent call inferred from this helper
		local v2 = v[p2]
		local v3

		if v2 then
			v3 = v2[p]
		end

		if not v3 then
			return
		end

		local index = table.find(v3, p3)
		table.remove(v3, index)
	end

	return {
		addListener = function(p2, p3)
			v[p2] = v[p2] or {}
			v[p2][p] = v[p2][p] or {}

			table.insert(v[p2][p], p3)

			return {
				remove = function()
					removeListener(p2, p3) -- inferred equivalent call
				end
			}
		end,
		emit = function(p2, p3)
			local v2 = v[p2] or {}
			local clone

			if v2[p] then
				clone = table.clone(v2[p])
			end

			if clone then
				for _, v3 in clone do
					v3(p3)
				end
			end
		end
	}
end

return getEventManager
