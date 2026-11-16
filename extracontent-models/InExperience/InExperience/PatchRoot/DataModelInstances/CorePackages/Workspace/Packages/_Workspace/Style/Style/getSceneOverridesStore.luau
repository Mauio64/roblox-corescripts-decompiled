local sceneOverrides = nil
local v = {}

local sceneOverridesStore = {
	getSceneOverrides = function()
		return sceneOverrides
	end,
	setSceneOverrides = function(p)
		sceneOverrides = p

		for _, v2 in v do
			v2(p)
		end
	end,
	subscribe = function(p)
		table.insert(v, p)
		return function()
			local index = table.find(v, p)

			if index then
				table.remove(v, index)
			end
		end
	end
}

local function getSceneOverridesStore()
	return sceneOverridesStore
end

return getSceneOverridesStore
