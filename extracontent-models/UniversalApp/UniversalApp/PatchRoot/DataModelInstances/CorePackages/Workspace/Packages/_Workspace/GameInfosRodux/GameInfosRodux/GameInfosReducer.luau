local Parent = script:FindFirstAncestor("GameInfosRodux").Parent
local AddGames = require(script.Parent.AddGames)
local Cryo = require(Parent.Cryo)

require(Parent.DiscoveryTypes)

local function getMergedState(p1, p2) -- line: 12
	-- upvalues: Cryo (copy)
	local t1 = {}

	for k, _ in pairs(p2) do
		if p1[k] then
			t1[k] = Cryo.Dictionary.join(p1[k], p2[k])
		else
			t1[k] = p2[k]
		end
	end

	return (Cryo.Dictionary.join(p1, t1))
end

return {
	key = "GameInfosKey",
	reducer = function(t2: {[any]: any}?, p3) -- line: 26
		-- upvalues: AddGames (copy), getMergedState (copy)
		local v12 = t2 or {}

		assert(v12, "")

		if p3.type == AddGames.name then
			v12 = getMergedState(v12, p3.games)
		end

		return v12
	end
}
