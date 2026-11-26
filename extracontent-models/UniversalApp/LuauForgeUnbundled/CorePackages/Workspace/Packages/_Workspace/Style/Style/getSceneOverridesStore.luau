local sceneOverrides = nil
local v5 = {}

local sceneOverridesStore = {
	getSceneOverrides = function()
		return sceneOverrides
	end,
	setSceneOverrides = function(p2)
		sceneOverrides = p2

		for k, v6 in v5 do
			v6(p2)
		end
	end,
	subscribe = function(p2)
		table.insert(v5, p2)
		return function()
			local index = table.find(v5, p2)

			if index then
				table.remove(v5, index)
			end
		end
	end
}

local function getSceneOverridesStore()
	return sceneOverridesStore
end

return getSceneOverridesStore
