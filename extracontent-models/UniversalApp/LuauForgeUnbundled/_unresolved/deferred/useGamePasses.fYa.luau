local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local module = require("@luauforge/bundled/dPI")
local dataStatus = module.DataStatus

local function useGamePasses(p2)
	local gamePassStore = module.Game.getGamePassStore(false)
	local v5 = React.useCallback(function(p3)
		local passesForUniverse = gamePassStore.getPassesForUniverse(p2)

		if passesForUniverse.status(p3) == dataStatus.NotReady then
			return nil
		end

		local data = passesForUniverse.data(p3)

		if data == nil then
			return nil
		end

		local result = {}

		for k, v6 in data do
			local data2 = gamePassStore.getGamePassInfo(v6).data(p3)

			if data2 then
				table.insert(result, data2)
			end
		end

		return result
	end, { gamePassStore, p2 })

	return SignalsReact.useSignalState(v5)
end

return useGamePasses
