local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/generateVIPServerLink")

local v5 = { Network }

local function generateVIPServerLink()
	return Thunk.new("generateVIPServerLink", v5, function(object, p2)
		return module3(p2[Network], object:getState().promptRequest.vipServerId)
	end)
end

return generateVIPServerLink
