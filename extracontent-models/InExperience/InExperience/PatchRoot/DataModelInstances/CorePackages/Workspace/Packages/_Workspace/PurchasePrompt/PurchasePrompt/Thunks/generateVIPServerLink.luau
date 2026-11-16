local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

local Network = require(PurchasePrompt.Services.Network)
local Thunk = require(PurchasePrompt.Thunk)
local generateVIPServerLink = require(PurchasePrompt.Network.generateVIPServerLink)

local v = { Network }

local function generateVIPServerLink2()
	return Thunk.new(script.Name, v, function(object, p)
		return generateVIPServerLink(p[Network], object:getState().promptRequest.vipServerId)
	end)
end

return generateVIPServerLink2
