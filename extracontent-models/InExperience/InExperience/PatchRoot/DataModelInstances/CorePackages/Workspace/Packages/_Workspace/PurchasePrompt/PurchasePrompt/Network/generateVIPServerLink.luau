local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local Promise = require(PurchasePrompt.Promise)

local function generateVIPServerLink(p, p2: number)
	return p.updateVIPServer(p2, { newJoinCode = true }):andThen(function(p3)
		if type(p3) == "table" and type(p3.link) == "string" then
			return p3.link
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return generateVIPServerLink
