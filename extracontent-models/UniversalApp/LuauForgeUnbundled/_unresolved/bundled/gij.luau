local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dAH")
local module2 = require("@luauforge/bundled/gik")

local fFlagUseSignalsForIsLocalUserSoothsayer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForIsLocalUserSoothsayer
local getIsLocalUserSoothsayerStore

if fFlagUseSignalsForIsLocalUserSoothsayer then
	getIsLocalUserSoothsayerStore = require("@luauforge/bundled/gil").GetIsLocalUserSoothsayerStore
else
	getIsLocalUserSoothsayerStore = nil
end

return function(p2)
	return function(object)
		return module2(p2):andThen(function(p3)
			local roles = p3.responseBody.roles or {}
			local v5 = Cryo.List.find(roles, "Soothsayer") ~= nil

			if fFlagUseSignalsForIsLocalUserSoothsayer then
				getIsLocalUserSoothsayerStore(false).setIsLocalUserSoothsayer(v5)
			else
				object:dispatch(module(v5))
			end
		end)
	end
end
