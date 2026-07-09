local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Cryo = require(DiscoveryMonolithParent.Cryo)
local Modules = DiscoveryMonolith.Modules
local AddOmniRecommendations = require(Modules.LuaApp.Actions.Games.AddOmniRecommendations)

return function(p1, p2) -- line: 8
	-- upvalues: AddOmniRecommendations (copy), Cryo (copy)
	local v8 = p1 or {}

	if p2.type == AddOmniRecommendations.name then
		if p2.isAppend then
			for k, v in pairs(p2.recommendations) do
				local v11 = v8[k]

				if v11 then
					local v12 = Cryo.List.join(v11.sorts, v.sorts)
					local v13 = Cryo.Dictionary.join(v11, v)

					v13.sorts = v12
					v13.metadata = nil
					v8 = Cryo.Dictionary.join(v8, {
						[k] = v13
					})
				end
			end

			return v8
		end

		local v14 = table.clone(p2.recommendations)

		for v15, v16 in v14 do
			v14[v15] = Cryo.Dictionary.join(v16, {
				metadata = Cryo.None
			})
		end

		v8 = Cryo.Dictionary.join(v8, v14)
	end

	return v8
end
