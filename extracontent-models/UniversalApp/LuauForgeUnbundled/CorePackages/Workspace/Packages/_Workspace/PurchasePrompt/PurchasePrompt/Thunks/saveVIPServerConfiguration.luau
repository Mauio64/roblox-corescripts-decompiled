local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local VIPServerRenamed = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/VIPServerRenamed")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")
local updateVIPServerConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/updateVIPServerConfiguration")

local v5 = { Network }

local function saveVIPServerConfiguration(p2)
	return Thunk.new("saveVIPServerConfiguration", v5, function(object, p3)
		local vipServerId = object:getState().promptRequest.vipServerId
		return updateVIPServerConfiguration(p3[Network], vipServerId, p2):andThen(function(p4)
			if p4 ~= nil then
				object:dispatch(VIPServerRenamed(p4))
			end
		end)
	end)
end

return saveVIPServerConfiguration
