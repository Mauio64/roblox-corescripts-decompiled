require(script.ReactInternalTypes)
require(script.ReactRootTags)

require(script.ReactFiberHostConfig)

require(script["ReactFiberHotReloading.new"])

local function initialize(items)
	local ReactFiberHostConfig = require(script.ReactFiberHostConfig)

	for k, item in items do
		ReactFiberHostConfig[k] = item
	end

	return require(script.ReactFiberReconciler)
end

return initialize
