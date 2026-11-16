local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

local Network = require(PurchasePrompt.Services.Network)
local VIPServerRenamed = require(PurchasePrompt.Actions.VIPServerRenamed)
local Thunk = require(PurchasePrompt.Thunk)
require(PurchasePrompt.types)
local updateVIPServerConfiguration = require(PurchasePrompt.Network.updateVIPServerConfiguration)

local v = { Network }

local function saveVIPServerConfiguration(p)
	return Thunk.new(script.Name, v, function(object, p2)
		local vipServerId = object:getState().promptRequest.vipServerId
		return updateVIPServerConfiguration(p2[Network], vipServerId, p):andThen(function(p3: string?)
			if p3 ~= nil then
				object:dispatch(VIPServerRenamed(p3))
			end
		end)
	end)
end

return saveVIPServerConfiguration
