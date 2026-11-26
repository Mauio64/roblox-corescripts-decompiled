local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/searchUsers")

local v5 = { Network }

local function searchUsers(p2)
	return Thunk.new("searchUsers", v5, function(p3, p4)
		return module3(p4[Network], p2)
	end)
end

return searchUsers
