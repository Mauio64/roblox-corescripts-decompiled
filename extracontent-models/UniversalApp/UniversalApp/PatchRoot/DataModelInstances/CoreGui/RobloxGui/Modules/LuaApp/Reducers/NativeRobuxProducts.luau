local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetNativeRobuxProducts = require(Modules.LuaApp.Actions.SetNativeRobuxProducts)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)

return function(t1: {[any]: any}?, p1) -- line: 12
	-- upvalues: RetrievalStatus (copy), SetNativeRobuxProducts (copy)
	local v6 = t1 or {
		Products = nil,
		FetchingStatus = RetrievalStatus.NotStarted
	}

	assert(v6, "")

	if p1.type == SetNativeRobuxProducts.name then
		return {
			Products = p1.nativeRobuxProducts,
			FetchingStatus = RetrievalStatus.Done
		}
	end

	return v6
end
