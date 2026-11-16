local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/InternalHttpStore/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/InternalHttpStore/HttpSignals")

require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/HttpStoreTypes")

local function createParsedResponse(callback, p2)
	return Signals.createComputed(function(p3)
		local v5 = callback(p3)

		if v5.status == "success" then
			return { status = "Success", config = p2, response = v5.data }
		end

		if v5.status ~= "error" then
			return { status = "Fetching", config = p2 }
		end

		return { status = "Failed", config = p2, response = v5.error }
	end)
end

return createParsedResponse
