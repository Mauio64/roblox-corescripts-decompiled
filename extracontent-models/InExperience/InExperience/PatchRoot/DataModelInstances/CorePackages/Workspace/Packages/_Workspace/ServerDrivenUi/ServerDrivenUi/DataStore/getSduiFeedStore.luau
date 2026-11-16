local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
require(parent.RobloxAppEnums)
require(ServerDrivenUi.DataStore.SduiFeedStoreTypes)
local createSduiFeedStore = require(ServerDrivenUi.DataStore.createSduiFeedStore)

local v = {}

return function(p: string)
	local v2 = v[p]

	if v2 == nil then
		v[p] = createSduiFeedStore()
		return v[p]
	end

	return v2
end
