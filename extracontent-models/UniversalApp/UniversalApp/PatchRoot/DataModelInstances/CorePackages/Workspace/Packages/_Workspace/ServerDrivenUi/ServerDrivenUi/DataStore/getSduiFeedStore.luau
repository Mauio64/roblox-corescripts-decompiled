local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent

require(ServerDrivenUiParent.RobloxAppEnums)
require(ServerDrivenUi.DataStore.SduiFeedStoreTypes)

local createSduiFeedStore = require(ServerDrivenUi.DataStore.createSduiFeedStore)
local t1 = {}

return function(s1: string) -- line: 19
	-- upvalues: t1 (copy), createSduiFeedStore (copy)
	local v6 = t1[s1]

	if v6 == nil then
		t1[s1] = createSduiFeedStore()
		v6 = t1[s1]
	end

	return v6
end
