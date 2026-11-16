local parent = script:FindFirstAncestor("GameTile").Parent
local React = require(parent.React)

local function useInGameUserIds(p: string, items)
	return React.useMemo(function()
		if not (p and items) then
			return {}
		end

		local result = {}

		for k, _ in items do
			if k ~= p then
				table.insert(result, k)
			end
		end

		return result
	end, { p, items })
end

return useInGameUserIds
