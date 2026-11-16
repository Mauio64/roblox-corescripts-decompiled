local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

local Network = require(PurchasePrompt.Services.Network)
local Thunk = require(PurchasePrompt.Thunk)
local searchUsers = require(PurchasePrompt.Network.searchUsers)

local v = { Network }

local function searchUsers2(p: string)
	return Thunk.new(script.Name, v, function(_, p2)
		return searchUsers(p2[Network], p)
	end)
end

return searchUsers2
