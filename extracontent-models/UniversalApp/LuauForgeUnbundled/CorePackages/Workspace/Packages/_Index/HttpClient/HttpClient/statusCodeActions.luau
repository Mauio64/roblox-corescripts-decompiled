require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/types")

local v5 = {}

return {
	add = function(p2, p3)
		local v6 = v5[p2]

		if v6 == nil then
			v6 = {}
			v5[p2] = v6
		end

		table.insert(v6, p3)
	end,
	remove = function(p2, p3)
		local v6 = v5[p2]

		if v6 == nil then
			return
		end

		for k, v7 in v6 do
			if v7 == p3 then
				table.remove(v6, k)
				break
			end
		end

		if #v6 == 0 then
			v5[p2] = nil
		end
	end,
	clear = function()
		v5 = {}
	end,
	snapshot = function()
		if next(v5) == nil then
			return nil
		end

		local result = {}

		for k, v6 in v5 do
			local v7 = {}

			for i = #v6, 1, -1 do
				table.insert(v7, v6[i])
			end

			result[k] = v7
		end

		return result
	end
}
