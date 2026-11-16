local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")

local function generateVIPServerLink(p2, p3)
	return p2.updateVIPServer(p3, { newJoinCode = true }):andThen(function(p4)
		if type(p4) == "table" and type(p4.link) == "string" then
			return p4.link
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return generateVIPServerLink
