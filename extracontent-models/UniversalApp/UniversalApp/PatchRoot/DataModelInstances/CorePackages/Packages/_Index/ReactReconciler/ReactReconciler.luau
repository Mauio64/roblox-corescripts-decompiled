require(script.ReactInternalTypes)
require(script.ReactRootTags)
require(script.ReactFiberHostConfig)
require(script["ReactFiberHotReloading.new"])

local function initialize(p1) -- line: 39
	local ReactFiberHostConfig = require(script.ReactFiberHostConfig)

	for v4, v5 in p1 do
		ReactFiberHostConfig[v4] = v5
	end

	return require(script.ReactFiberReconciler)
end

return initialize
