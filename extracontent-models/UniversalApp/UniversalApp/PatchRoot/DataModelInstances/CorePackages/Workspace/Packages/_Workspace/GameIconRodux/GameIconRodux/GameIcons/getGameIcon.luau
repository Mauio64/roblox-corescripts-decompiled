local GameIconRodux = script:FindFirstAncestor("GameIconRodux")
local GameIconReducer = require(GameIconRodux.GameIcons.GameIconReducer)

return function(p1, p2) -- line: 4
	-- upvalues: GameIconReducer (copy)
	local v5 = p1[GameIconReducer.key][p2]

	if v5 then
		return v5.url
	end

	return ""
end
